SetTitleMatchMode, 2
SetTitleMatchMode, slow

#Include, C:\Apps\streamdeck\_nighthold_\const_env\const_env.ahk

if (WinExist("Nighthold - Obsidian")){
    WinActivate, Nighthold - Obsidian
}
else {
    Run, %lappdata% %obsd% 
}