<#
.SYNOPSIS
  Step 2a helper: Run Morphe pre-patch on a raw APK (unsigned) so Android Duo + Liquid Glass patches can be applied next.
.EXAMPLE
  .\step2-morphe-prepatch.ps1 -App zalo -InputApk ".\merged.apk" -OutApk ".\zalo-ehvn.apk"
  .\step2-morphe-prepatch.ps1 -App tiktok -InputApk ".\tiktok-raw.apk" -OutApk ".\tiktok-morphe.apk"
#>
param(
    [Parameter(Mandatory)] [string]$App,
    [Parameter(Mandatory)] [string]$InputApk,
    [Parameter(Mandatory)] [string]$OutApk,
    [string]$PatchesFile,
    [string[]]$EnablePatches,
    [string[]]$DisablePatches,
    [switch]$PreRelease,
    [switch]$Force
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "common.ps1")
$ctx   = Get-PipelineContext
$entry = Get-AppEntry -Context $ctx -AppId $App

if (-not $ctx.Java21)    { throw "Java 21+ is required to run Morphe Desktop JAR." }
if (-not $ctx.MorpheJar) { throw "morphe-desktop-*.jar not found." }
if (-not (Test-Path $InputApk)) { throw "Input APK not found: $InputApk" }

$patchArg = $PatchesFile
if (-not $patchArg -and $entry.morphe.local_mpp_glob) {
    $resolved = Get-Item (Join-Path $ctx.RepoDir $entry.morphe.local_mpp_glob) -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($resolved) { $patchArg = $resolved.FullName }
}
if (-not $patchArg) {
    $patchArg = $entry.morphe.patches_repo
}
if (-not $patchArg) {
    throw "No Morphe patch source configured for '$App'. Pass -PatchesFile explicitly."
}

$outDir = Split-Path -Parent (Resolve-Path -LiteralPath (Split-Path -Parent $OutApk) -ErrorAction SilentlyContinue)
$resultJson = [System.IO.Path]::ChangeExtension($OutApk, ".morphe-result.json")

$argsList = @(
    "-jar", $ctx.MorpheJar,
    "patch",
    "--unsigned",
    "-p", $patchArg,
    "-o", $OutApk,
    "-r", $resultJson
)
if ($PreRelease -or ($entry.morphe.prerelease -and $patchArg -match "^https?://")) {
    $argsList += "--prerelease"
}
if ($Force) { $argsList += "--force" }
foreach ($e in $EnablePatches)  { $argsList += @("-e", $e) }
foreach ($d in $DisablePatches) { $argsList += @("-d", $d) }
$argsList += (Resolve-Path $InputApk).Path

Write-Host "Running Morphe pre-patch for $($entry.display_name)..."
Write-Host "  Patch source: $patchArg"
Write-Host "  Input APK:    $InputApk"
Write-Host "  Output APK:   $OutApk"
& $ctx.Java21 @argsList
if ($LASTEXITCODE -ne 0) { throw "Morphe pre-patch failed (exit $LASTEXITCODE)" }

Write-Host "Morphe pre-patch succeeded: $OutApk ($((Get-Item $OutApk).Length) bytes)"
Write-Host "Report saved to: $resultJson"
