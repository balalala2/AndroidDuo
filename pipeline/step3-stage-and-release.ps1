<#
.SYNOPSIS
  Step 3: Verify built APKs (signature SHA-256, manifest version, baseline.prof), stage with standard naming,
  and create a DRAFT GitHub Release on balalala2/AndroidDuo.
.EXAMPLE
  .\step3-stage-and-release.ps1 -ReleaseVersion "2.1" -Apks @{ zalo="...\Zalo.apk"; facebook="...\FB.apk" } -DryRun
  .\step3-stage-and-release.ps1 -ReleaseVersion "2.1" -Apks @{ zalo="...\Zalo.apk" } -NotesFile ".\release-notes.md"
#>
param(
    [Parameter(Mandatory)] [string]$ReleaseVersion,
    [Parameter(Mandatory)] [hashtable]$Apks,
    [string]$StagingDir,
    [string]$NotesFile,
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "common.ps1")
$ctx = Get-PipelineContext

if (-not $StagingDir) {
    $StagingDir = Join-Path $ctx.WorkspaceRoot "Antigravity-ZSplit\release-$ReleaseVersion"
}
New-Item -ItemType Directory -Force $StagingDir | Out-Null

$verifyPy = Join-Path $ctx.PipelineDir "verify-apk.py"
$stagedFiles = @()
$tableRows   = @()
$tag         = "v$ReleaseVersion"

Write-Host "=== Verifying & Staging Android Duo $ReleaseVersion ==="
foreach ($appId in $Apks.Keys) {
    $entry  = Get-AppEntry -Context $ctx -AppId $appId
    $srcApk = $Apks[$appId]
    if (-not (Test-Path $srcApk)) { throw "APK not found for '$appId': $srcApk" }

    # 1. Inspect manifest & file metadata
    $meta = (& $ctx.Python $verifyPy $srcApk) | ConvertFrom-Json
    $expectedPkg = if ($entry.patched_package) { $entry.patched_package } else { $entry.package }
    if ($meta.package -ne $expectedPkg) {
        throw "Package mismatch for '$appId': expected '$expectedPkg', got '$($meta.package)'"
    }
    if ($meta.has_baseline_prof) {
        Write-Warning "[$appId] APK still contains assets/dexopt/baseline.prof* (should be stripped to avoid ART verify issues)."
    }

    # 2. Verify signing certificate matches zsplit.jks
    $certSha = Get-ApkCertSha256 -Context $ctx -ApkPath $srcApk
    if ($certSha -ne $ctx.ExpectedCertSha256) {
        throw "CERT MISMATCH for '$appId'! Expected $($ctx.ExpectedCertSha256), got $certSha"
    }

    # 3. Copy to staging with canonical v2.2+ release filename: <App>Duo-<ReleaseVer>_<AppVer>.apk
    $fileName = "$($entry.display_name)Duo-${ReleaseVersion}_$($meta.version_name).apk"
    $destApk  = Join-Path $StagingDir $fileName
    Copy-Item -Force $srcApk $destApk

    $stagedFiles += $destApk
    $dlUrl = "https://github.com/$($ctx.Config.repo)/releases/download/$tag/$fileName"
    $tableRows += "| **$($entry.display_name)** | ``$($meta.version_name)`` (vc ``$($meta.version_code)``) | [$fileName]($dlUrl) | $($meta.size_mb) MB |"

    Write-Host ("  [OK] {0,-10} v{1} (vc={2}, {3} MB, cert=OK) -> {4}" -f $entry.display_name, $meta.version_name, $meta.version_code, $meta.size_mb, $fileName)
}

# 4. Generate default release notes if none provided
if (-not $NotesFile) {
    $NotesFile = Join-Path $StagingDir "release-notes.md"
    $notes = @(
        "# Android Duo $ReleaseVersion"
        ""
        "| Ứng dụng | Phiên bản gốc | Tải về ($tag) | Dung lượng |"
        "|---|---|---|---|"
    ) + $tableRows + @(
        ""
        "## Lưu ý cài đặt"
        "- Tất cả APK được ký chung khóa dự án (cert SHA-256 ``$($ctx.ExpectedCertSha256)``) — cài đè trực tiếp lên bản Android Duo cũ **không mất dữ liệu**."
        "- Nếu đang dùng bản chính thức từ CH Play, vui lòng gỡ bản gốc trước khi cài (sao lưu tin nhắn Zalo trước khi gỡ)."
    )
    [System.IO.File]::WriteAllText($NotesFile, ($notes -join "`n"), (New-Object System.Text.UTF8Encoding $false))
}

Write-Host ""
Write-Host "Staged $($stagedFiles.Count) APK(s) in: $StagingDir"
Write-Host "Release notes: $NotesFile"

if ($DryRun) {
    Write-Host "[DryRun] Skipping 'gh release create $tag --draft'."
    exit 0
}

if (-not $ctx.Gh) { throw "GitHub CLI (gh) not found." }

Write-Host "Creating DRAFT GitHub Release $tag on $($ctx.Config.repo)..."
$ghArgs = @(
    "release", "create", $tag,
    "--repo", $ctx.Config.repo,
    "--draft",
    "--title", "Android Duo $ReleaseVersion",
    "--notes-file", $NotesFile
) + $stagedFiles

& $ctx.Gh @ghArgs
if ($LASTEXITCODE -ne 0) { throw "gh release create failed" }
Write-Host "Draft release $tag created! Review and click 'Publish release' on GitHub when ready."
