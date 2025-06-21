; SellPollinated.ahk - Macro for Roblox: Fill inventory bar from backpack, then sell each item

#SingleInstance, Force
#NoEnv
SetWorkingDir %A_ScriptDir%
#WinActivateForce
SetMouseDelay, -1
SetWinDelay, -1
SetControlDelay, -1
SetBatchLines, -1

; --- CONFIGURABLE KEYS ---
backpackKey := "Tab"   ; Key to open/close backpack (change if needed)
moveToHotbarKey := "LeftClick" ; Action to move item to hotbar (simulate mouse click)
hotbarKeys := ["1","2","3","4","5","6","7","8","9","0"] ; Hotbar slots 1-0
sellKey := "e"         ; Key to sell item
keyword := "Pollinated Coconut"

; --- PARAMETERS ---
global autofill := 1 ; Default to enabled
settingsFile := A_ScriptDir "\settings.ini"

; --- LOAD SETTINGS ---
IniRead, autofill, %settingsFile%, SellPollinated, Autofill, 1
checkedOpt := autofill ? "Checked" : ""
Gui, Add, Checkbox, x20 y20 vautofill gUpdateAutofill %checkedOpt%, Autofill (Fill Inventory Before Selling)
Gui, Add, Button, x20 y60 w120 h30 gStartMacro, Start
Gui, Show, w200 h120, Sell Pollinated Macro
Return

UpdateAutofill:
    Gui, Submit, NoHide
    IniWrite, %autofill%, %settingsFile%, SellPollinated, Autofill
Return

StartMacro:
    Gui, Submit, NoHide
    ; Save autofill setting
    IniWrite, %autofill%, %settingsFile%, SellPollinated, Autofill
    ; Activate Roblox window
    If WinExist("ahk_exe RobloxPlayerBeta.exe") {
        WinActivate
        WinWaitActive, , , 2
        Sleep, 300
    }
    ; Main loop: run once per button press
    if (autofill) {
        FillInventoryBar()
    }
    SellInventory()
    MsgBox, Done! All inventory slots processed.
Return

GuiClose:
    ExitApp

; --- FILL INVENTORY BAR ---
FillInventoryBar() {
    global keyword
    ; Press $ to enable UI navigation
    Send, {$}
    Sleep, 200
    ; Right arrow key
    Send, {Right}
    Sleep, 200
    ; Enter
    Send, {Enter}
    Sleep, 200
    ; Right arrow key x2
    Send, {Right}
    Sleep, 200
    Send, {Right}
    Sleep, 200
    ; Down arrow key
    Send, {Down}
    Sleep, 200
    ; Left arrow key x2
    Send, {Left}
    Sleep, 200
    Send, {Left}
    Sleep, 200
    ; Enter
    Send, {Enter}
    Sleep, 200
    ; Right arrow key x3
    Send, {Right}
    Sleep, 200
    Send, {Right}
    Sleep, 200
    Send, {Right}
    Sleep, 200
    ; Down arrow key
    Send, {Down}
    Sleep, 200
    ; Left arrow key
    Send, {Left}
    Sleep, 200
    ; Enter
    Send, {Enter}
    Sleep, 200
    ; Send sequence of letters from 'keyword'
    Loop, Parse, keyword
    {
        Send, {%A_LoopField%}
        Sleep, 120
    }
    Sleep, 200
    ; Enter
    Send, {Enter}
}

; --- SELL INVENTORY ---
SellInventory() {
    global hotbarKeys, sellKey
    Loop, 10 {
        slotKey := hotbarKeys[A_Index]
        ; Select hotbar slot
        Send, {%slotKey%}
        Sleep, 200
        ; Press E to sell
        Send, {%sellKey%}
        Sleep, 100
        ; Wait 31 seconds
        Sleep, 31000
        ; Press E again to confirm/finish
        Send, {%sellKey%}
        Sleep, 300
    }
}

; --- HOTKEYS ---
F5::
    Gosub, StartMacro
Return

F7::
    Gosub, ResetScript
Return

ResetScript:
    ; Reset state and GUI as if script was restarted
    Reload
Return
