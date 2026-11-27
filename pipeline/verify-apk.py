#!/usr/bin/env python3
"""Inspect an APK: package, versionName, versionCode, dex count, baseline.prof check, file SHA-256."""
import hashlib
import json
import os
import struct
import sys
import zipfile

RES_STRING_POOL = 0x0001
RES_XML_START_ELEM = 0x0102
TYPE_STRING = 0x03
TYPE_INT_DEC = 0x10
TYPE_INT_HEX = 0x11


def read_axml_manifest_attrs(data: bytes) -> dict:
    """Extract package, versionName, versionCode from binary AndroidManifest.xml."""
    pos = 8
    strings = []
    attrs_out = {}

    while pos + 8 <= len(data):
        ctype, hdr_size, chunk_size = struct.unpack_from("<HHI", data, pos)
        if chunk_size <= 0:
            break

        if ctype == RES_STRING_POOL:
            str_count, _, flags, strings_start, _ = struct.unpack_from("<IIIII", data, pos + 8)
            is_utf8 = bool(flags & (1 << 8))
            offsets = struct.unpack_from(f"<{str_count}I", data, pos + hdr_size)
            pool_base = pos + strings_start
            for off in offsets:
                p = pool_base + off
                if is_utf8:
                    # Skip char length (1-2 bytes)
                    b = data[p]
                    p += 2 if (b & 0x80) else 1
                    # Read byte length (1-2 bytes)
                    b = data[p]
                    if b & 0x80:
                        blen = ((b & 0x7F) << 8) | data[p + 1]
                        p += 2
                    else:
                        blen = b
                        p += 1
                    strings.append(data[p:p + blen].decode("utf-8", errors="replace"))
                else:
                    u16len = struct.unpack_from("<H", data, p)[0]
                    p += 2
                    if u16len & 0x8000:
                        u16len = ((u16len & 0x7FFF) << 16) | struct.unpack_from("<H", data, p)[0]
                        p += 2
                    strings.append(data[p:p + u16len * 2].decode("utf-16le", errors="replace"))

        elif ctype == RES_XML_START_ELEM:
            name_idx = struct.unpack_from("<I", data, pos + 20)[0]
            tag = strings[name_idx] if name_idx < len(strings) else ""
            if tag == "manifest":
                attr_start, attr_size, attr_count = struct.unpack_from("<HHH", data, pos + 24)
                base = pos + hdr_size + attr_start - 16
                # Actually attr_start is offset from start of extension (pos + 16)
                base = pos + 16 + attr_start
                for i in range(attr_count):
                    ap = base + i * attr_size
                    _, aname_idx, raw_val_idx, _, _, vtype, vdata_i = struct.unpack_from("<IIIHBBI", data, ap)
                    aname = strings[aname_idx] if aname_idx < len(strings) else ""
                    if aname in ("package", "versionName", "versionCode"):
                        if vtype == TYPE_STRING and vdata_i < len(strings):
                            attrs_out[aname] = strings[vdata_i]
                        elif raw_val_idx != 0xFFFFFFFF and raw_val_idx < len(strings):
                            attrs_out[aname] = strings[raw_val_idx]
                        elif vtype in (TYPE_INT_DEC, TYPE_INT_HEX):
                            attrs_out[aname] = vdata_i
                break

        pos += chunk_size

    return attrs_out


def inspect_apk(path: str) -> dict:
    if not os.path.isfile(path):
        raise FileNotFoundError(path)
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)

    with zipfile.ZipFile(path, "r") as z:
        names = z.namelist()
        manifest = read_axml_manifest_attrs(z.read("AndroidManifest.xml"))
        dex_files = sorted([n for n in names if n.startswith("classes") and n.endswith(".dex")])
        has_baseline_prof = any(n.startswith("assets/dexopt/baseline.prof") for n in names)

    return {
        "file": os.path.basename(path),
        "path": os.path.abspath(path),
        "size_bytes": os.path.getsize(path),
        "size_mb": round(os.path.getsize(path) / (1024 * 1024), 2),
        "file_sha256": h.hexdigest(),
        "package": manifest.get("package", ""),
        "version_name": str(manifest.get("versionName", "")),
        "version_code": manifest.get("versionCode", 0),
        "dex_count": len(dex_files),
        "has_baseline_prof": has_baseline_prof,
    }


def main():
    if len(sys.argv) < 2:
        print("Usage: verify-apk.py <apk1> [apk2 ...]", file=sys.stderr)
        sys.exit(2)
    results = [inspect_apk(p) for p in sys.argv[1:]]
    print(json.dumps(results if len(results) > 1 else results[0], indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
