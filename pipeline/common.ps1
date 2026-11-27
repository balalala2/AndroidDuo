$ErrorActionPreference = "Stop"

function Get-PipelineContext {
    $pipelineDir = $PSScriptRoot
    $repoDir     = Split-Path -Parent $pipelineDir
    $wsRoot      = Split-Path -Parent $repoDir

    $cfgPath = Join-Path $pipelineDir "apps.json"
    $cfg     = Get-Content $cfgPath -Raw -Encoding UTF8 | ConvertFrom-Json

    # Locate JDK 17 (javac + java) and JRE/JDK 21+ (required by Morphe Desktop 2.3+)
    $javacCmd = Get-Command javac -ErrorAction SilentlyContinue
    $java17   = if ($javacCmd) { Join-Path (Split-Path $javacCmd.Source) "java.exe" } else { "java" }

    $java21 = $null
    $j21Candidates = @(
        "C:\Program Files\Eclipse Adoptium\jre-21*\bin\java.exe",
        "C:\Program Files\Eclipse Adoptium\jdk-21*\bin\java.exe",
        "C:\Program Files\Java\jdk-21*\bin\java.exe",
        "C:\Program Files\Microsoft\jdk-21*\bin\java.exe"
    )
    foreach ($pat in $j21Candidates) {
        $found = Get-Item $pat -ErrorAction SilentlyContinue | Sort-Object FullName -Descending | Select-Object -First 1
        if ($found) { $java21 = $found.FullName; break }
    }

    # Locate Morphe Desktop JAR
    $morpheJar = Get-ChildItem (Join-Path $wsRoot "Antigravity-ZSplit") -Recurse -Filter "morphe-desktop-*.jar" -ErrorAction SilentlyContinue |
        Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName
    if (-not $morpheJar) {
        $morpheJar = Get-ChildItem (Join-Path $wsRoot "work\bin") -Filter "morphe-*.jar" -ErrorAction SilentlyContinue |
            Select-Object -First 1 -ExpandProperty FullName
    }

    $keystore = Join-Path $repoDir $cfg.signing.keystore_relative
    if (Test-Path $keystore) { $keystore = (Resolve-Path $keystore).Path }

    return [PSCustomObject]@{
        PipelineDir        = $pipelineDir
        RepoDir            = $repoDir
        WorkspaceRoot      = $wsRoot
        Config             = $cfg
        SdkDir             = Join-Path $wsRoot "work\sdk"
        BinDir             = Join-Path $wsRoot "work\bin"
        Java17             = $java17
        Javac              = if ($javacCmd) { $javacCmd.Source } else { "javac" }
        Java21             = $java21
        Python             = (Get-Command python -ErrorAction SilentlyContinue).Source
        Gh                 = (Get-Command gh -ErrorAction SilentlyContinue).Source
        MorpheJar          = $morpheJar
        Keystore           = $keystore
        ExpectedCertSha256 = $cfg.signing.expected_cert_sha256.ToLowerInvariant()
    }
}

function Get-AppEntry {
    param(
        [Parameter(Mandatory)] $Context,
        [Parameter(Mandatory)] [string]$AppId
    )
    $key = $AppId.ToLowerInvariant()
    $entry = $Context.Config.apps.$key
    if (-not $entry) {
        $valid = ($Context.Config.apps.PSObject.Properties.Name) -join ", "
        throw "Unknown app '$AppId'. Valid apps in apps.json: $valid"
    }
    return $entry
}

function Get-ApkCertSha256 {
    param(
        [Parameter(Mandatory)] $Context,
        [Parameter(Mandatory)] [string]$ApkPath
    )
    $verifyJava = Join-Path $Context.PipelineDir "VerifyCert.java"
    $apksigJar  = Join-Path $Context.SdkDir "apksig.jar"
    if (-not (Test-Path $apksigJar)) {
        throw "apksig.jar not found at $apksigJar"
    }
    $out = & $Context.Java17 -cp $apksigJar $verifyJava $ApkPath 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw "Signature verification failed for ${ApkPath}: $($out -join "`n")"
    }
    $line = $out | Where-Object { $_ -match "^CERT_SHA256=" } | Select-Object -First 1
    if (-not $line) {
        throw "Could not parse CERT_SHA256 from output: $($out -join "`n")"
    }
    return ($line -replace "^CERT_SHA256=", "").Trim().ToLowerInvariant()
}
