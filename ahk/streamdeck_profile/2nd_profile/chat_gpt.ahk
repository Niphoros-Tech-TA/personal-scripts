SetTitleMatchMode, 2
SetTitleMatchMode, slow

#Include, C:\Apps\github\personal-scripts\ahk\streamdeck_profile\vars\env.ahk
#Include, C:\Apps\github\personal-scripts\ahk\streamdeck_profile\vars\homelab.ahk

Run, % prgmfiles86 edge " " chatgpt " " (WinExist("Microsoft Edge") ? "--profile-directory="profile : " --new-window --profile-directory="profile)
