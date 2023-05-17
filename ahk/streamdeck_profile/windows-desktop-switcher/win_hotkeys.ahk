; Snap to the left
#+<::Send #{Left}
Return
; =================
; Snap to the right
#+>::Send #{Right}
Return
; =================

; =================
; Switch Screens
#+?::Send #+{Right}
Return
; =================

; =================
; New Asana task
Send ^+{+}
Sleep 250
Return
; =================

; =================
; Maximize window
#+m::WinMaximize, A ; Alt+C
Return
; =================

; =================
; Close window
#+q::WinClose, A ; Alt+C
; =================