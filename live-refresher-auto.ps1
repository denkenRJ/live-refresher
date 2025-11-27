param(
    [string]$ResultFile,
    [string]$OutputDir = "./dashboard",
    [int]$RefreshIntervalSec = 5
)

# Try to auto-detect JMeter bin
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$possibleJMeter = @(
    "$scriptDir\..\apache-jmeter-5.6.3\bin",
    "C:\Tools\JMeter\apache-jmeter-5.6.3\bin",
    "C:\apache-jmeter-5.6.3\bin"
)

$JMeterBin = $possibleJMeter | Where-Object { Test-Path $_ } | Select-Object -First 1

# Fallback: try PATH
if (-not $JMeterBin) {
    $bin = Get-Command jmeter.bat -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source -ErrorAction SilentlyContinue
    if ($bin) { $JMeterBin = Split-Path -Parent $bin }
}

# Auto-detect latest JTL if none specified
if (-not $ResultFile) {
    $folders = @("$scriptDir", "$scriptDir\Results", "$scriptDir\..\Results")
    $found = $null
    foreach ($f in $folders) {
        if (Test-Path $f) {
            $found = Get-ChildItem -Path $f -Filter *.jtl -Recurse -File -ErrorAction SilentlyContinue |
                Sort-Object LastWriteTime -Descending |
                Select-Object -First 1
            if ($found) { break }
        }
    }
    if ($found) { $ResultFile = $found.FullName }
}

if (-not $ResultFile) {
    Write-Host "ERROR: No JTL file found or provided." -ForegroundColor Red
    exit
}

# Normalize output folder
$OutputDir = (Resolve-Path -LiteralPath $OutputDir -ErrorAction SilentlyContinue)?.ProviderPath
if (-not $OutputDir) {
    New-Item -ItemType Directory -Path $OutputDir | Out-Null
    $OutputDir = (Resolve-Path -LiteralPath $OutputDir).ProviderPath
}

$TempOut = Join-Path $OutputDir '_tmp'
$SnapshotJtl = "$ResultFile`_snapshot.jtl"
$FallbackExpectedCols = 17

Set-Location $JMeterBin

function Get-ExpectedColumns {
    param([string]$file)
    $lines = Get-Content $file -ErrorAction SilentlyContinue
    if ($lines.Count -eq 0) { return $FallbackExpectedCols }
    ($lines[0] -split ",").Count
}

function Create-Snapshot {
    param([string]$src, [string]$dst)

    $expectedCols = Get-ExpectedColumns $src
    $lines = Get-Content $src -ErrorAction SilentlyContinue
    $valid = $lines | Where-Object { ($_.Split(',').Count) -eq $expectedCols }

    if ($valid.Count -gt 0) {
        Set-Content -Path $dst -Value $valid
        return $true
    }

    return $false
}

if (Test-Path $TempOut) { Remove-Item $TempOut -Recurse -Force }
New-Item -ItemType Directory -Path $TempOut | Out-Null

Write-Host "-----------------------------------------"
Write-Host "Live Refresher (AUTO MODE) Started" -ForegroundColor Cyan
Write-Host "Result File: $ResultFile"
Write-Host "Output Directory: $OutputDir"
Write-Host "Refresh Interval: $RefreshIntervalSec sec"
Write-Host "-----------------------------------------"

while ($true) {

    if (Create-Snapshot -src $ResultFile -dst $SnapshotJtl) {

        & jmeter.bat -g $SnapshotJtl -o $TempOut | Out-Null

        if (Test-Path $TempOut) {
            Copy-Item "$TempOut\*" $OutputDir -Recurse -Force
            Write-Host "Updated Dashboard at $(Get-Date)" -ForegroundColor Green
        }
    }

    Start-Sleep -Seconds $RefreshIntervalSec
}
