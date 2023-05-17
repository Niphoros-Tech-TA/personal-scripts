#NoEnv
SetTitleMatchMode, 2

; File Explorer
prgmfiles := A_ProgramFiles
prgmfiles86 := A_ProgramFiles " (x86)"
rappdata := A_AppData
c_tools := "C:\Apps"
EnvGet, lappdata, LocalAppData

; Apps
edge :="\Microsoft\Edge\Application\msedge.exe"
obsd := "\Obsidian\Obsidian.exe"
vscode :="\Programs\Microsoft VS Code\Code.exe"
one_comm :="\OneCommander\OneCommander.exe"