# 🚀 Blackout

A lightweight AutoHotkey v2 tool that automatically blacks out your display when brightness reaches **0**, restoring it instantly when brightness increases. Designed for OLED laptops and external monitors, with fast detection and low CPU usage.

---

## 📋 Table of Contents
- [About the Project](#-about-the-project)
- [Key Features](#-key-features)
- [Getting Started](#%EF%B8%8F-getting-started)
  - [Installation](#installation)
  - [Automatic Startup](#automatic-startup)
- [Usage](#-usage)
- [License](#-license)

---

## 🔍 About the Project

Blackout is a background utility that monitors your system brightness and covers the entire screen with a black overlay when brightness reaches **0**. This simulates a true “screen off” state without actually powering down the display — useful for OLED laptops that do not fully turn off the panel at minimum brightness.

The script uses a hybrid detection system:

- **Dxva2 physical brightness**
- **WMI ACPI brightness**

It automatically determines which method your system supports and switches accordingly.

---

## ✨ Key Features

- **Automatic blackout at brightness 0**
- **Instant restore when brightness increases**
- **Hybrid brightness detection**
  - Dxva2 (DDC/CI) 
  - WMI ACPI
- **One-time Dxva2 capability detection**
- **Fullscreen blackout overlay across all monitors**
- **Safe cursor hiding / restoring**
- **FAST/SLOW polling intervals for responsiveness + efficiency**
- **Silent background operation**
- **Low memory footprint**

---

## 🛠️ Getting Started

Follow these steps to install and run the Blackout utility.

---

## Installation

You can install Blackout in **two ways**:


### **Option A — Use the Compiled `.exe` (Recommended, No AutoHotkey Required)**

1. Download the precompiled `Blackout.exe` from the [**Releases**](https://github.com/Link2999/Blackout/releases) section of this repository.
2. Place it anywhere on your system, for example:
   ```
   C:\Programs\Blackout\blackout.exe
   ```
3. Double‑click `Blackout.exe` to run it.

4. Lower your brightness to **0** to test blackout behavior.

**Why choose the `.exe` version?**

- No AutoHotkey installation required  
- Fully standalone  
- Ideal for startup automation  
- Easy to distribute across systems  
- Same performance and behavior as the `.ahk` script
  
### **OR**
 
### **Option B — Run the `.ahk` Script (Requires [AutoHotkey v2](https://www.autohotkey.com/v2/))**

1. Download and install [AutoHotkey v2](https://www.autohotkey.com/v2/)

2. Download `Blackout.ahk` from the [**Releases**](https://github.com/Link2999/Blackout/releases) section of this repository.

3. Double‑click `Blackout.ahk` to run it.

4. Lower your brightness to **0** to test blackout behavior.

---

### Automatic Startup

1. Press **Win + R**
2. Type:
   ```
   shell:startup
   ```
3. Place a shortcut to `blackout.exe` (or `blackout.ahk`) inside the startup folder.

Windows will now launch Blackout automatically at login.

---

## 💡 Usage

- Lower brightness to **0** → screen blacks out  
- Raise brightness → screen restores  
- Script runs silently in the background  
- No interaction required  

---

## 📄 License

Distributed under the **AGPL-3.0 License**.  
See [`LICENSE`](https://github.com/Link2999/Blackout/blob/main/LICENSE) for details.
