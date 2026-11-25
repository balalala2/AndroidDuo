import struct, sys, zipfile, zlib
src, out = sys.argv[1], sys.argv[2]
repl = dict(a.split('=',1) for a in sys.argv[3:])
zf = zipfile.ZipFile(src); raw = open(src,'rb')
o = open(out,'wb'); cd=[]
def rawdata(i):
    raw.seek(i.header_offset); h=raw.read(30); n,e=struct.unpack('<HH',h[26:30])
    raw.seek(i.header_offset+30+n+e); return raw.read(i.compress_size)
for i in zf.infolist():
    name=i.filename
    if name.startswith('META-INF/') and (name.endswith('.SF') or name.endswith('.RSA') or name.endswith('.EC') or name=='META-INF/MANIFEST.MF'): continue
    if repl.get(name)=='-': continue
    if name in repl:
        data=open(repl[name],'rb').read(); crc=zlib.crc32(data)&0xffffffff; usize=len(data)
        if i.compress_type==0: method,cdata=0,data
        else:
            c=zlib.compressobj(9,zlib.DEFLATED,-15); cdata=c.compress(data)+c.flush(); method=8
    else:
        cdata=rawdata(i); method=i.compress_type; crc=i.CRC; usize=i.file_size
    off=o.tell(); nb=name.encode(); extra=b''
    if method==0:
        al=16384 if name.endswith('.so') else 4
        extra=b'\0'*((-(off+30+len(nb)))%al)
    dt=i.date_time; dosd=((dt[0]-1980)<<9)|(dt[1]<<5)|dt[2]; dost=(dt[3]<<11)|(dt[4]<<5)|(dt[5]//2)
    o.write(struct.pack('<IHHHHHIIIHH',0x04034b50,20,0x800,method,dost,dosd,crc,len(cdata),usize,len(nb),len(extra))+nb+extra); o.write(cdata)
    cd.append((nb,method,dost,dosd,crc,len(cdata),usize,off))
cs=o.tell()
for nb,method,dost,dosd,crc,cl,ul,off in cd:
    o.write(struct.pack('<IHHHHHHIIIHHHHHII',0x02014b50,20,20,0x800,method,dost,dosd,crc,cl,ul,len(nb),0,0,0,0,0,off)+nb)
ce=o.tell(); o.write(struct.pack('<IHHHHIIH',0x06054b50,0,0,len(cd),len(cd),ce-cs,cs,0)); o.close(); print('entries',len(cd))
