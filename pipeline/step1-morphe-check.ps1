<#
.SYNOPSIS
  Step 1 helper: Check Morphe compatible versions / patches for an app, or merge split APKs (.apkm/.xapk/.apks/dir).
.EXAMPLE
  .\step1-morphe-check.ps1 -App zalo
  .\step1-morphe-check.ps1 -App tiktok -ListPatches
  .\step1-morphe-check.ps1 -MergeSplits "C:\path\to\Zalo.apkm" -OutApk "C:\path\to\merged.apk"
#>
param(
    [string]$App,
    [string]$PatchesFile,
    [switch]$ListPatches,
    [switch]$PreRelease,
    [string]$MergeSplits,
    [string]$OutApk
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "common.ps1")
$ctx = Get-PipelineContext

if ($MergeSplits) {
    if (-not $OutApk) {
        $OutApk = [System.IO.Path]::ChangeExtension($MergeSplits, ".merged.apk")
    }
    $apkEditor = Join-Path $ctx.BinDir "APKEditor.jar"
    if (-not (Test-Path $apkEditor)) { throw "APKEditor.jar not found at $apkEditor" }
    Write-Host "Merging split bundle '$MergeSplits' -> '$OutApk'..."
    & $ctx.Java17 -jar $apkEditor m -i $MergeSplits -o $OutApk
    if ($LASTEXITCODE -ne 0) { throw "APKEditor merge failed" }
    Write-Host "Merged: $OutApk ($((Get-Item $OutApk).Length) bytes)"
    exit 0
}

if (-not $App) {
    Write-Host "Configured apps in AndroidDuo/pipeline/apps.json:"
    foreach ($p in $ctx.Config.apps.PSObject.Properties) {
        $a = $p.Value
        $m = if ($a.morphe.enabled) { "Morphe:YES ($($a.morphe.patches_repo))" } else { "Morphe:NO" }
        Write-Host ("  {0,-10} {1,-28} [{2,-7}] {3}" -f $p.Name, $a.package, $a.status, $m)
    }
    exit 0
}

$entry = Get-AppEntry -Context $ctx -AppId $App
if (-not $entry.morphe.enabled -and -not $PatchesFile) {
    Write-Host "$($entry.display_name) ($($entry.package)) does not require Morphe pre-patch."
    Write-Host "Fetch latest $($entry.arch) APK from: $($entry.apk_sources -join ', ')"
    exit 0
}

if (-not $ctx.Java21) { throw "Java 21+ is required to run Morphe Desktop JAR." }
if (-not $ctx.MorpheJar) { throw "morphe-desktop-*.jar not found." }

$patchArg = $PatchesFile
if (-not $patchArg -and $entry.morphe.local_mpp_glob) {
    $resolved = Get-Item (Join-Path $ctx.RepoDir $entry.morphe.local_mpp_glob) -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($resolved) {
        Write-Host "Found local MPP: $($resolved.FullName)"
        $patchArg = $resolved.FullName
    }
}
if (-not $patchArg) {
    $patchArg = $entry.morphe.patches_repo
}

$cmd = if ($ListPatches) { "list-patches" } else { "list-versions" }
$argsList = @("-jar", $ctx.MorpheJar, $cmd, "--patches", $patchArg, "-f", $entry.package)
if ($PreRelease -or ($entry.morphe.prerelease -and $patchArg -match "^https?://")) {
    $argsList += "--prerelease"
}

Write-Host "Running: morphe-desktop $cmd --patches $patchArg -f $($entry.package)"
& $ctx.Java21 @argsList
exit $LASTEXITCODE
