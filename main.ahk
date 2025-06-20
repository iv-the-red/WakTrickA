#Requires AutoHotkey v2.0
#SingleInstance Force
; ========================================
; WakaTime Activity Simulator v1.0
; By Ivthered
; ========================================

; --- Configuration ---

global MinSleepSeconds := 18
global MaxSleepSeconds := 25
global MinGibberishLength := 10
global MaxGibberishLength := 25
global CycleCount := 0
global IsPaused := false
global StartTime := A_Now
global currentVariable := ""
global hasVariable := false

; --- Hotkeys ---
F9::TogglePause()
F10::ExitScript()
F11::ShowStatus()

; --- GUI Setup ---
CreateStatusGUI()

; --- Startup ---
ShowWelcomeMessage()
SetTimer(UpdateGUI, 1000)

; --- Main Loop ---
Loop {
    if (IsPaused) {
        Sleep(100)
        continue
    }

    if !ActivateVSCode()
        continue

    CycleCount++
    UpdateStatus("Starting cycle " . CycleCount)
    
    
    EnsureVSCodeFocus()
    
    
    rememberedText := GenerateGibberish()
    
    UpdateStatus("Finding empty line...")
    
    
    Loop {
        testLine := Random(20, 500)
        
        Send "^g"
        Sleep 700
        SendInput "{Text}" testLine
        Sleep 700
        SendEvent "{Enter}"
        Sleep 1000
        
        
        Send "{Home}+{End}^c"
        Sleep 500
        currentContent := Trim(A_Clipboard)
        
        if (StrLen(currentContent) == 0) {
            rememberedLine := testLine
            Send "{Home}"
            SendInput "{Text}" rememberedText
            UpdateStatus("Added gibberish at line " . testLine)
            break
        }
        
        
        Send "{Down}{Home}+{End}^c"
        Sleep 500
        belowContent := Trim(A_Clipboard)
        
        if (StrLen(belowContent) == 0) {
            rememberedLine := testLine + 1
            Send "{Home}"
            SendInput "{Text}" rememberedText
            UpdateStatus("Added gibberish at line " . (testLine + 1))
            break
        }
    }
    
    
    CountdownWait(20, "Waiting after gibberish")
    
    
    UpdateStatus("Adding comment...")
    Send "{End}{Enter}{Enter}"
    Sleep 500
    timestamp := FormatTime(, "yyMMdd_HHmmss")
    emoji := ["🎉", "🚀", "💻", "💡", "✨"][Random(1,5)]
    commentText := "// WakePoke " . emoji . " " . timestamp . " #" . CycleCount
    SendInput "{Text}" commentText
    
    
    CountdownWait(20, "Waiting after comment")
    
    
    UpdateStatus("Managing variables...")
    Send "^{Home}{Home}{Enter}{Up}"
    Sleep 500
    
    if (!hasVariable) {
        currentVariable := "wakavar" . Random(100, 999)
        varText := "let " . currentVariable . " = " . Random(1, 100) . ";"
        SendInput "{Text}" varText
        hasVariable := true
        UpdateStatus("Added variable: " . currentVariable)
    } else {
        ChangeVariableValue(currentVariable)
        UpdateStatus("Updated variable: " . currentVariable)
    }
    
    Sleep 2000
    
    
    UpdateStatus("Cleaning up gibberish...")
    Send "^h"
    Sleep 1200
    SendInput "{Text}" rememberedText
    Sleep 800
    Send "{Tab}"
    Sleep 600
    SendInput "{Text}"  
    Sleep 600
    Send "^!{Enter}"
    Sleep 1500
    Send "{Escape}"
    Sleep 800
    
    
    UpdateStatus("Verifying cleanup...")
    Send "^f"
    Sleep 500
    SendInput "{Text}" rememberedText
    Sleep 500
    Send "{Enter}"
    Sleep 500
    
    
    Send "^c"
    Sleep 300
    foundText := A_Clipboard
    
    if (InStr(foundText, rememberedText)) {
        UpdateStatus("WARNING: Gibberish deletion failed! Retrying...")
        
        Send "{Escape}"
        Sleep 300
        Send "^h"
        Sleep 800
        SendInput "{Text}" rememberedText
        Sleep 500
        Send "{Tab}"
        Sleep 300
        SendInput "{Text}"
        Sleep 300
        Send "^!{Enter}"
        Sleep 1000
        Send "{Escape}"
        UpdateStatus("Retry cleanup completed")
    } else {
        UpdateStatus("Gibberish successfully deleted")
    }
    
    Send "{Escape}"
    Sleep 300
    
    
    ChangeVariableValue(currentVariable)
    
    
    UpdateStatus("Saving file...")
    Send "^s"
    Sleep 1000
    
    UpdateStatus("Cycle " . CycleCount . " completed successfully")
    
    
    waitTime := Random(MinSleepSeconds * 1000, MaxSleepSeconds * 1000)
    CountdownWait(waitTime/1000, "Next cycle")
}

; ========================================
; FUNCTIONS
; ========================================

ShowWelcomeMessage() {
    MsgBox("WakaTime Activity Simulator v1.0`n`n" .
           "Controls:`n" .
           "F9  = Pause/Resume`n" .
           "F10 = Exit`n" .
           "F11 = Show Status`n`n" .
           "Make sure VS Code is open and ready!`n`n" .
           "Starting in 3 seconds...", 
           "WakaTime Simulator", "4096 T3")
}

CreateStatusGUI() {
    global StatusGUI := Gui("+AlwaysOnTop +ToolWindow", "WakaTime Simulator")
    StatusGUI.SetFont("s10", "Consolas")
    
    global StatusText := StatusGUI.Add("Text", "w400 h100 +Border", 
        "Status: Starting...`nCycles: 0`nRuntime: 00:00:00`nState: Running")
    
    StatusGUI.Add("Text", "w400", "F9=Pause/Resume | F10=Exit | F11=Show/Hide")
    
    StatusGUI.Show("x10 y10")
}

UpdateGUI() {
    if (!IsObject(StatusText))
        return
        
    runtime := DateDiff(A_Now, StartTime, "Seconds")
    hours := Format("{:02d}", runtime // 3600)
    minutes := Format("{:02d}", (runtime // 60) - (hours * 60))
    seconds := Format("{:02d}", Mod(runtime, 60))
    
    state := IsPaused ? "PAUSED" : "RUNNING"
    
    StatusText.Text := "Status: " . (IsPaused ? "Paused" : "Active") . "`n" .
                       "Cycles: " . CycleCount . "`n" .
                       "Runtime: " . hours . ":" . minutes . ":" . seconds . "`n" .
                       "State: " . state
}

UpdateStatus(message) {
    
}

TogglePause() {
    global IsPaused
    IsPaused := !IsPaused
    
    if (IsPaused) {
        TrayTip("PAUSED - Press F9 to resume", "WakaTime Simulator")
    } else {
        TrayTip("RESUMED", "WakaTime Simulator")
    }
}

ShowStatus() {
    if (StatusGUI.Visible) {
        StatusGUI.Hide()
    } else {
        StatusGUI.Show()
    }
}

CountdownWait(seconds, message) {
    Loop seconds {
        if (IsPaused) {
            Loop {
                Sleep(100)
                if (!IsPaused)
                    break
            }
        }
        
        remaining := seconds - A_Index + 1
        ToolTip(message . ": " . remaining . "s remaining...")
        Sleep(1000)
    }
    ToolTip()
}

ActivateVSCode() {
    if WinExist("ahk_exe Code.exe") {
        WinActivate("ahk_exe Code.exe")
        Sleep(800)
        return WinActive("ahk_exe Code.exe")
    }
    
    TrayTip("VS Code not found! Please open VS Code.", "WakaTime Simulator")
    IsPaused := true
    return false
}

EnsureVSCodeFocus() {
    Loop 3 {
        if WinActive("ahk_exe Code.exe")
            return true
            
        WinActivate("ahk_exe Code.exe")
        Sleep(500)
    }
    return false
}

ChangeVariableValue(varName) {
    Send "^f"
    Sleep 800
    SendInput "{Text}" varName . " = "
    Sleep 800
    SendEvent "{Enter}"
    Sleep 800
    Send "{Escape}{End}{Left 2}^+{Left}"
    Sleep 500
    SendInput "{Text}" Random(1, 999)
    Sleep 500
}

GenerateGibberish() {
    chars := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJ0123456789"
    length := Random(MinGibberishLength, MaxGibberishLength)
    result := ""
    Loop length {
        result .= SubStr(chars, Random(1, StrLen(chars)), 1)
    }
    return result
}

ExitScript() {
    if (MsgBox("Are you sure you want to exit?", "WakaTime Simulator", "YesNo") = "Yes") {
        ExitApp
    }
}