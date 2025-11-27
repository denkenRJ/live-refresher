# ============================
# Live JMeter Dashboard Refresher (ORIGINAL STYLE)
# Update only the folder paths below before running
# ============================

# 👉 Update these paths before running
$JMeterBin   = "C:\Tools\JMeter\apache-jmeter-5.6.3\bin"        # JMeter bin folder
$ResultsJtl  = "C:\PerfTests\Results\sample_test.jtl"           # Your .jtl file
$LiveOut     = "C:\PerfTests\Dashboard\LiveReport"              # Dashboard output folder
$TempOut     = "C:\PerfTests\Dashboard\LiveReport_tmp"          # Temporary generation folder
$SnapshotJtl = "C:\PerfTests\Results\sample_test_snapshot.jtl"  # Internal snapshot file

# Refresh interval (seconds)
$IntervalSec = 5

# Expected column fallback
$FallbackExpectedCols = 17
# ============================

Set-Location $JMeterBin

function Get-ExpectedColumns {
    param([string]$file)

    $lines = Get-Content $file -ErrorAction SilentlyContinue
    if ($lines.Count -eq 0) { return $FallbackExpectedCols }

    $header = $lines[0]
    $headerCols = ($header -split ",").Count

    return $headerCols
}

function Create-Snapshot {
    $expectedCols = Get-ExpectedColumns $ResultsJtl
    $lines = Get-Content $ResultsJtl

    $validLines = @()

    foreach ($line in $lines) {
        $cols = ($line -split ",").Count
        if ($cols -eq $expectedCols) {
            $validLines += $line
        }
    }

    if ($validLines.Count -gt 0) {
        Set-Content -Path $SnapshotJtl -Value $validLines
        return $true
    }

    Write-Host "Waiting for valid JTL rows…" -ForegroundColor Yellow
    return $false
}

# Ensure output folders exist
if (!(Test-Path $LiveOut)) { New-Item -ItemType Directory -Path $LiveOut | Out-Null }
if (Test-Path $TempOut) { Remove-Item $TempOut -Recurse -Force }
New-Item -ItemType Directory -Path $TempOut | Out-Null

Write-Host "-----------------------------------------"
Write-Host "Live JMeter Dashboard Refresher Started" -ForegroundColor Cyan
Write-Host "JTL File: $ResultsJtl"
Write-Host "Dashboard Output: $LiveOut"
Write-Host "Refresh Interval: $IntervalSec sec"
Write-Host "-----------------------------------------"

while ($true) {

    if (Create-Snapshot) {

        & jmeter.bat `
            -g $SnapshotJtl `
            -o $TempOut `
            | Out-Null

        if (Test-Path $TempOut) {
            Copy-Item "$TempOut\*" $LiveOut -Recurse -Force
            Write-Host "Dashboard updated at $(Get-Date)" -ForegroundColor Green
        }
    }

    Start-Sleep -Seconds $IntervalSec
}
