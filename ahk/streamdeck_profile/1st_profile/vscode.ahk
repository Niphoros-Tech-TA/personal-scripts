SetTitleMatchMode, 2
SetTitleMatchMode, slow
#NoEnv

#Include, C:\Apps\github\personal-scripts\ahk\streamdeck_profile\vars\env.ahk
#Include, C:\Apps\github\personal-scripts\ahk\streamdeck_profile\vars\homelab.ahk

; Check if Visual Studio Code is running
if WinExist("ahk_exe Code.exe")
{
    ; If it's running, activate the window
    WinActivate, ahk_exe Code.exe
}
else
{
    ; If it's not running, launch it with the specified user data directory
    Run, % lappdata vscode 
}