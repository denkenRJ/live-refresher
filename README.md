# Live JMeter HTML Dashboard (PowerShell)


Lightweight PowerShell tool to regenerate the JMeter HTML dashboard from a .jtl file repeatedly so you can inspect near-live results without Grafana/InfluxDB/Datadog.


## Features


- Original `live-refresher.ps1` (edit folder paths inside the script)
- `live-refresher-auto.ps1` — improved version with parameter support and automatic path detection (can run with parameters or defaults)
- `live-refresher-gui.ps1` — simple PowerShell WinForm GUI wrapper for starting/stopping and editing paths
- `docs/video-script.md` — optional script you can use to record a tutorial


## Quickstart (Original script)
1. Edit `live-refresher.ps1` and update the hardcoded folder paths:
- `$JMeterBin` — JMeter bin folder (where `jmeter.bat` lives)
- `$ResultsJtl` — absolute path to your `.jtl` results file
- `$LiveOut` — folder where HTML report will be written
- `$TempOut` — temporary folder used during generation
2. Run your JMeter test in non-GUI mode:
