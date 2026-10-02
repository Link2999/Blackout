#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================
; Configuration
; ============================
FAST_INTERVAL := 300
SLOW_INTERVAL := 600

; ============================
; Global State
; ============================
ScreenIsOff := false
Dxva2Supported := true   ; Auto-detected once

; ============================
; GUI Overlay
; ============================
BlankScreen := Gui("+AlwaysOnTop -Caption -Border +ToolWindow")
BlankScreen.BackColor := "Black"

; ============================
; Start Timers
; ============================
SetTimer(CheckBrightness, SLOW_INTERVAL)
SetTimer(TrimMemory, 30000)

; ============================
; Main Brightness Logic
; ============================
CheckBrightness() {
    global Dxva2Supported

    brightness := -1

    ; Try Dxva2 only once
    if (Dxva2Supported) {
        brightness := GetPhysicalBrightness()
        if (brightness == -1)
            Dxva2Supported := false   ; Permanently disable Dxva2
    }

    ; WMI fallback (Legion uses this path)
    if (brightness == -1)
        brightness := GetWMIBrightness()

    if (brightness = 0)
        TurnOff()
    else
        TurnOn()
}

; ============================
; Memory Trimming
; ============================
TrimMemory() {
    DllCall("psapi\EmptyWorkingSet", "Ptr", -1)
}

; ============================
; Dxva2 Physical Brightness
; ============================
GetPhysicalBrightness() {
    hMonitor := DllCall("user32\MonitorFromWindow", "Ptr", 0, "UInt", 1, "Ptr")
    if (!hMonitor)
        return -1

    numMonitors := 0
    if (!DllCall("dxva2\GetNumberOfPhysicalMonitorsFromHMONITOR", "Ptr", hMonitor, "UInt*", &numMonitors)
        || numMonitors == 0)
        return -1

    ; Correct PHYSICAL_MONITOR struct size:
    ; Ptr (8 bytes) + WCHAR[128] (256 * 2 bytes) = 520 bytes
    structSize := 8 + (256 * 2)
    PHYSICAL_MONITOR := Buffer(structSize * numMonitors, 0)

    if (!DllCall("dxva2\GetPhysicalMonitorsFromHMONITOR", "Ptr", hMonitor, "UInt", numMonitors, "Ptr", PHYSICAL_MONITOR))
        return -1

    hPhysicalMonitor := NumGet(PHYSICAL_MONITOR, 0, "Ptr")

    minB := 0, curB := 0, maxB := 0
    success := DllCall("dxva2\GetMonitorBrightness", "Ptr", hPhysicalMonitor,
                       "UInt*", &minB, "UInt*", &curB, "UInt*", &maxB)

    ; Proper cleanup for multiple monitors
    DllCall("dxva2\DestroyPhysicalMonitors", "UInt", numMonitors, "Ptr", PHYSICAL_MONITOR)

    return success ? curB : -1
}

; ============================
; WMI Brightness
; ============================
GetWMIBrightness() {
    try {
        for item in ComObjGet("winmgmts:\\.\root\WMI").ExecQuery("SELECT CurrentBrightness FROM WmiMonitorBrightness")
            return item.CurrentBrightness
    }
    return -1
}

; ============================
; Cursor Handling
; ============================
HideCursor() {
    while (DllCall("ShowCursor", "Int", 0) >= 0)
        continue
}

ShowCursor() {
    while (DllCall("ShowCursor", "Int", 1) < 0)
        continue
}

; ============================
; Screen Control
; ============================
TurnOff() {
    global ScreenIsOff, FAST_INTERVAL

    if (!ScreenIsOff) {
        BlankScreen.Show("x" SysGet(76) " y" SysGet(77) " w" SysGet(78) " h" SysGet(79))
        HideCursor()
        ScreenIsOff := true
        SetTimer(CheckBrightness, FAST_INTERVAL)
    }
}

TurnOn() {
    global ScreenIsOff, SLOW_INTERVAL

    if (ScreenIsOff) {
        BlankScreen.Hide()
        ShowCursor()
        ScreenIsOff := false
        SetTimer(CheckBrightness, SLOW_INTERVAL)
    }
}

