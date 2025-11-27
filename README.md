<!-- GitHub repo badges -->
[![Release](https://img.shields.io/github/v/release/denkenRJ/live-refresher?label=release&style=flat-square)](https://github.com/denkenRJ/live-refresher/releases)
[![License: MIT](https://img.shields.io/github/license/denkenRJ/live-refresher?style=flat-square)](https://github.com/denkenRJ/live-refresher/blob/main/LICENSE)
[![Stars](https://img.shields.io/github/stars/denkenRJ/live-refresher?style=social)](https://github.com/denkenRJ/live-refresher/stargazers)
[![Issues](https://img.shields.io/github/issues/denkenRJ/live-refresher?style=flat-square)](https://github.com/denkenRJ/live-refresher/issues)
[![PowerShell Version](https://img.shields.io/badge/PowerShell-%3E%3D5.1-blue?style=flat-square)](https://github.com/denkenRJ/live-refresher)


# ⚡ Live JMeter HTML Dashboard Refresher  
**Lightweight, zero-dependency live dashboard for JMeter**  
_No Grafana. No Datadog. No InfluxDB. Just PowerShell + JMeter._

---

## 📌 Why This Tool Exists

When running JMeter tests in **Non-GUI mode**, you can’t see live test metrics unless you set up heavy systems like:

- Grafana  
- Datadog  
- InfluxDB / Prometheus  
- Custom monitoring servers  

These are great, but…  
❌ Overkill for quick debugging  
❌ Often not allowed on secure machines  
❌ Require installation + setup  
❌ Slow for local performance iterations  

So this tool provides a **simple, fast, standalone** workaround.

---

# ✅ What This Tool Does

This script:

✔ Continuously regenerates the **JMeter HTML Dashboard**  
✔ Shows **near-live results** while your test runs  
✔ Requires **no external monitoring tools**  
✔ Works with any `.jtl` results file  
✔ Supports:
   - **Hardcoded path mode** (original)
   - **Auto-detect mode**
   - **GUI mode**

To simulate live monitoring, simply refresh your browser or set it to auto-refresh every **10–15 seconds**.

---

# 📂 Project Structure

```
live-refresher/
├── live-refresher.ps1           # Original version (edit paths manually)
├── live-refresher-auto.ps1      # Auto-detect + parameters
├── live-refresher-gui.ps1       # Simple PowerShell GUI wrapper
└── README.md                    # You are here
```

---

# 📘 Table of Contents
- [Why This Tool Exists](#-why-this-tool-exists)
- [What This Tool Does](#-what-this-tool-does)
- [Project Structure](#-project-structure)
- [Screenshots](#-screenshots)
- [Usage](#-usage)
  - [1. Original Script (edit paths manually)](#1-original-script-edit-paths-manually)
  - [2. Auto-Mode Script (recommended)](#2-auto-mode-script-recommended)
  - [3. GUI Mode](#3-gui-mode)
- [Prerequisites](#-prerequisites)
- [Browser Auto-Refresh Hack](#-browser-auto-refresh-hack)
- [Recommended Folder Setup](#-recommended-folder-setup)
- [Contributing](#-contributing)
- [License](#-license)

---

# 🖼 Screenshots  
_(Add your screenshots here later)_  

For now, placeholders:

### 🔵 Terminal Output
```
Live JMeter Dashboard Refresher Started
JTL File: sample_test.jtl
Dashboard updated at 2025-11-27 12:30:15
```

### 🟢 Browser Dashboard (index.html)
```
[ Your HTML dashboard screenshot goes here ]
```

---

# 🚀 Usage

## 1️⃣ Original Script (edit paths manually)
This version is good for fixed environments where paths don’t change.

1. Open `live-refresher.ps1`
2. Update:

```
$JMeterBin
$ResultsJtl
$LiveOut
$TempOut
$SnapshotJtl
```

3. Run JMeter test:

```
jmeter -n -t TestPlan.jmx -l C:\Results\test.jtl
```

4. Run script:

```
.\live-refresher.ps1
```

5. Open the dashboard:

```
C:\PerfTests\Dashboard\LiveReport\index.html
```

Refresh browser every 10–15 seconds to see updates.

---

## 2️⃣ Auto-Mode Script (recommended)
This version supports parameters + auto-detection.

### Run with parameters:

```
.\live-refresher-auto.ps1 -ResultFile "C:\Results\test.jtl" -OutputDir "C:\Results\dashboard" -RefreshIntervalSec 5
```

### Or run without specifying a file:
The script will try to find the **latest .jtl** automatically.

---

## 3️⃣ GUI Mode  
A simple GUI allowing:

✔ File picker for `.jtl`  
✔ Output folder selector  
✔ Start/Stop buttons  
✔ Real-time log window  

Run:

```
.\live-refresher-gui.ps1
```

---

# 📦 Prerequisites

✔ Windows (PowerShell)  
✔ Apache JMeter installed  
✔ A JTL result file (in CSV format)  
✔ Browser (Chrome/Edge/Firefox)  
✔ PowerShell execution policy:  

```
Set-ExecutionPolicy Bypass -Scope Process -Force
```

---

# 🔁 Browser Auto-Refresh Hack (Optional but Awesome)

To simulate "live" monitoring:

### Chrome / Edge Extensions:
- **Easy Auto Refresh**
- **Super Auto Refresh Plus**

Set refresh interval to **10–15 seconds**.  
This creates a near-real-time experience.

---

# 📁 Recommended Folder Setup

```
C:\PerfTests\
├── Scripts\
│   ├── TestPlan.jmx
│   ├── run-test.ps1
│   └── live-refresher*.ps1
├── Results\
│   └── test.jtl
└── Dashboard\
    └── LiveReport\
```

---

# 🤝 Contributing

Contributions are welcome!

Ideas you can help with:

- Adding logging
- Adding auto-open browser support
- Adding real-time WebSocket-based dashboard
- Improving GUI
- Packaging into an EXE

---

# 📜 License

MIT License — free to use, modify, share.

