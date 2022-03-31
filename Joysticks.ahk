#SingleInstance Force
#NoEnv
;#Warn
#Persistent
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
;#KeyHistory 0 ; Comment this line to see the key history
#UseHook, On
#InstallMouseHook

ListLines, On
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, 0, 0
SetMouseDelay, 0
SetDefaultMouseSpeed, 0
SetWinDelay, 0
SetControlDelay, 0
SendMode Input
SetControlDelay, 0
;Thread, Interrupt, -1
	;OPTIMIZATIONS

JoystickNumber = 0
GetKeyState, JoyR, JoyR
if(JoyR = "")
	SetTimer, checkController, 300

joystickSwitch := 1
sameKeys := 0
SetTimer, WatchPOVandStick, 20
ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 4, "1")
resChange := 0

; Joystic as mouse
JoyMultiplier = 0.50 
JoyThreshold = 0
InvertYAxis := false
WheelDelay = 250
JoystickNumber = 1

JoystickPrefix = %JoystickNumber%Joy

; Calculate the axis displacements that are needed to start moving the cursor:
JoyThresholdUpper := 50 + JoyThreshold
JoyThresholdLower := 50 - JoyThreshold
if InvertYAxis
	YAxisMultiplier = -1
else
	YAxisMultiplier = 1

SetTimer, WatchPOV, 50
ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 1, "1")
SetTimer, WatchJoystick, 5  ; Monitor the movement of the joystick.
ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 2, "1")
SetTimer, joyButtons, 20
ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 3, "1")

GetKeyState, JoyInfo, %JoystickNumber%JoyInfo

joystickAsMouseSwitch := 1

;SetTimer, sharedVariablesJoysticks, 50

I_Icon = D:\Users\Bruno\Pictures\Icons\gamepad.ico
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%

#Include D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\Functions.ahk
Return

sharedVariablesJoysticks:
; First line is for WatchPOV
	FileReadLine, WatchPOVVar, D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt, 1
	if(WatchPOVVar = 1){
		SetTimer, WatchPOV, On
	}else{
		SetTimer, WatchPOV, Off
	}

; Second line is for WatchJoystick
	FileReadLine, WatchJoystickVar, D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt, 2
	if(WatchJoystickVar = 1){
		SetTimer, WatchJoystick, On
	}else{
		SetTimer, WatchJoystick, Off
	}

;Third line is for joyButtons
	FileReadLine, joyButtonsVar, D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt, 3
	if(joyButtonsVar = 1){
		SetTimer, joyButtons, On
	}else{
		SetTimer, joyButtons, Off
	}

;Forth line is for WatchPOVandStick
	FileReadLine, WatchPOVandStickVar, D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt, 4
	if(WatchPOVandStickVar = 1){
		SetTimer, WatchPOVandStick, On
	}else{
		SetTimer, WatchPOVandStick, Off
	}

;Fifth line is for Reloading
	FileReadLine, WatchPOVandStickVar, D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt, 5
	if(reloadingVar = 1){
		ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 5, "0")
		Reload
	}
Return




checkController:
	GetKeyState, JoyR, JoyR
	if(JoyR != "")
		Reload
Return

JoystickAsMouseEnable:
	if(flipJoystickSwitch){
		if(joystickAsMouseSwitch){
			SetTimer, WatchPOV, On
			ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 1, "1")
			SetTimer, WatchJoystick, On  ; Monitor the movement of the joystick
			ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 2, "1")
			SetTimer, joyButtons, On
			ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 3, "1")
			ToolTip, Joystick as Mouse enabled
			Goto, smoothTooltip
		}else{
			SetTimer, WatchPOV, Off
			ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 1, "0")
			SetTimer, WatchJoystick, Off
			ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 2, "0")
			SetTimer, joyButtons, Off
			ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 3, "0")
			ToolTip, Joystick as Mouse disabled
			Goto, smoothTooltip
		}
	}
	joystickAsMouseSwitch := !joystickAsMouseSwitch
Return

povDirection:
	POV := GetKeyState("JoyPOV")  ; Get position of the POV control.
	KeyToHoldDownPrevPOV := KeyToHoldDownPOV  ; Prev now holds the key that was down before (if any).
	if (POV < 0)   ; No angle to report
		KeyToHoldDownPOV := ""
    else if (POV > 31500)               ; 315 to 360 degrees: Forward
		KeyToHoldDownPOV := "Up"
	else if POV between 0 and 4500      ; 0 to 45 degrees: Forward
		KeyToHoldDownPOV := "Up"
	else if POV between 4501 and 13500  ; 45 to 135 degrees: Right
		KeyToHoldDownPOV := "Right"
	else if POV between 13501 and 22500 ; 135 to 225 degrees: Down
		KeyToHoldDownPOV := "Down"
	else                                ; 225 to 315 degrees: Left
		KeyToHoldDownPOV := "Left"
Return
povPressandDelay:
	while((KeyToHoldDownPOV = KeyToHoldDownPrevPOV) && !(KeyToHoldDownPOV = "" && KeyToHoldDownPrevPOV = "")){
		Gosub, povDirection
		
		SetKeyDelay -1  ; Avoid delays between keystrokes.
		if KeyToHoldDownPOV   ; There is a key to press down.
		    Send, {%KeyToHoldDownPOV%}  ; Press it down.

		if(sameKeys = 0){
			startTime := A_TickCount
			runTime := 0
			while((runTime <= 500) && (KeyToHoldDownPOV = KeyToHoldDownPrevPOV) && !(KeyToHoldDownPOV = "" && KeyToHoldDownPrevPOV = "")){
				Gosub, povDirection
				runTime := A_TickCount - startTime
			}
			sameKeys++
		}else if(sameKeys > 0){
			startTime := A_TickCount
			runTime := 0
			while((runTime <= 30) && (KeyToHoldDownPOV = KeyToHoldDownPrevPOV) && !(KeyToHoldDownPOV = "" && KeyToHoldDownPrevPOV = "")){
				Gosub, povDirection
				runTime := A_TickCount - startTime
			}
			sameKeys++
		}
	}
	sameKeys := 0
Return
WatchPOVandStick:
	SetTimer, WatchPOVandStick, Off
	ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 4, "0")

	if(WinActive("ahk_exe AutoHotkey.exe") && (WinActive("Games") || WinActive("Resolution")
		|| WinActive("Yes || No") || WinActive("Emulators"))){
		
		joystickSwitch := !joystickSwitch

		if(joystickSwitch){	
		    Gosub, povDirection

		    Gosub, povPressandDelay
		}else{
			JoyX := GetKeyState("JoyX")  ; Get position of X axis.
			JoyY := GetKeyState("JoyY")  ; Get position of Y axis.
			KeyToHoldDownPrevStick := KeyToHoldDownStick  ; Prev now holds the key that was down before (if any).

			if (JoyX > 70)
			    KeyToHoldDownStick := "Right"
			else if (JoyX < 30)
			    KeyToHoldDownStick := "Left"
			else if (JoyY > 70)
			    KeyToHoldDownStick := "Down"
			else if (JoyY < 30)
			    KeyToHoldDownStick := "Up"
			else
			    KeyToHoldDownStick := ""

			if (KeyToHoldDownStick = KeyToHoldDownPrevStick)  ; The correct key is already down (or no key is needed).
			    return  ; Do nothing.

			; Otherwise, release the previous key and press down the new key:
			SetKeyDelay -1  ; Avoid delays between keystrokes.
			if KeyToHoldDownPrevStick   ; There is a previous key to release.
			    Send, {%KeyToHoldDownPrevStick% up}  ; Release it.
			if KeyToHoldDownStick   ; There is a key to press down.
			    Send, {%KeyToHoldDownStick% down}  ; Press it down.
		}
	}

	SetTimer, WatchPOVandStick, On
	ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 4, "1")
return

WatchPOV:
	SetTimer, WatchPOV, Off
	ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 1, "0")

	Gosub, povDirection

	Gosub, povPressandDelay
	
	SetTimer, WatchPOV, On
	ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 1, "1")
Return
joystickAsMouse:
	MouseNeedsToBeMoved := false  ; Set default.
	SetFormat, float, 03
	GetKeyState, JoyX, %JoystickNumber%JoyX
	GetKeyState, JoyY, %JoystickNumber%JoyY
	if JoyX > %JoyThresholdUpper%
	{
		MouseNeedsToBeMoved := true
		DeltaX := JoyX - JoyThresholdUpper
	}
	else if JoyX < %JoyThresholdLower%
	{
		MouseNeedsToBeMoved := true
		DeltaX := JoyX - JoyThresholdLower
	}
	else
		DeltaX = 0
	if JoyY > %JoyThresholdUpper%
	{
		MouseNeedsToBeMoved := true
		DeltaY := JoyY - JoyThresholdUpper
	}
	else if JoyY < %JoyThresholdLower%
	{
		MouseNeedsToBeMoved := true
		DeltaY := JoyY - JoyThresholdLower
	}
	else
		DeltaY = 0
	if MouseNeedsToBeMoved
	{
		SetMouseDelay, -1  ; Makes movement smoother.
		MouseMove, DeltaX * JoyMultiplier, DeltaY * JoyMultiplier * YAxisMultiplier, 0, R
	}
	MouseNeedsToBeMoved := false  ; Set default.
	SetFormat, float, 03
	GetKeyState, JoyU, %JoystickNumber%JoyU
	GetKeyState, JoyR, %JoystickNumber%JoyR
	if JoyU > %JoyThresholdUpper%
	{
		MouseNeedsToBeMoved := true
		DeltaX := JoyU - JoyThresholdUpper
	}
	else if JoyU < %JoyThresholdLower%
	{
		MouseNeedsToBeMoved := true
		DeltaX := JoyU - JoyThresholdLower
	}
	else
		DeltaX = 0
	if JoyR > %JoyThresholdUpper%
	{
		MouseNeedsToBeMoved := true
		DeltaY := JoyR - JoyThresholdUpper
	}
	else if JoyR < %JoyThresholdLower%
	{
		MouseNeedsToBeMoved := true
		DeltaY := JoyR - JoyThresholdLower
	}
	else
		DeltaY = 0
	if MouseNeedsToBeMoved
	{
		SetMouseDelay, -1  ; Makes movement smoother.
		MouseMove, DeltaX * JoyMultiplier, DeltaY * JoyMultiplier * YAxisMultiplier, 0, R
	}
Return
WatchJoystick:
	JoyZ := GetKeyState("JoyZ")
	if(JoyZ < 45){
		JoyMultiplier := 0.10
		Gosub, joystickAsMouse
	}else if (JoyZ >= 45 && JoyZ <= 55){
		JoyMultiplier := 0.50
		Gosub, joystickAsMouse
	}else if(JoyZ > 55){
		JoyR := GetKeyState("JoyR")

		if(JoyR <= 45)
			Send {WheelUp}
		else if(JoyR >= 55)
			Send {WheelDown}

		JoyY := GetKeyState("JoyY")

		if(JoyY <= 45)
			Send {WheelUp}
		else if(JoyY >= 55)
			Send {WheelDown}

		Sleep, 50
	}
return
joyButtons:
	SetTimer, joyButtons, Off
	ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 3, "0")
	; A
	if(GetKeyState("Joy1") && !(GetKeyState("Joy3")) && !(GetKeyState("Joy7")) 
		&& !(WinActive("Delete File") || WinActive("Delete Folder") || WinActive("Delete Multiple Items"))){

		Send, {LButton Down}
		KeyWait, Joy1
		Send, {LButton Up}
		Gosub, lbActions
	}

	; B
	if(GetKeyState("Joy2") && !(GetKeyState("Joy7")) && !(GetKeyState("Joy8"))){
		Send, {RButton Down}
		KeyWait, Joy2
		Send, {RButton Up}
	}

	; X
	if(GetKeyState("Joy3") && !(GetKeyState("Joy7")) && !(GetKeyState("Joy8"))){
		Send, {LControl Down}
		while(GetKeyState("Joy3")){
	; X+A
			if(GetKeyState("Joy1")){
				Send, {LButton Down}
				KeyWait, Joy1
				Send, {LButton Up}
			}
		}
		Send, {LControl Up}
	}

	; Y
	if(GetKeyState("Joy4") && !(GetKeyState("Joy7")) && !(GetKeyState("Joy8"))){
		if(WinActive("ahk_exe vivaldi.exe")){
			Send, ^{w}
		}else if(WinActive("ahk_exe explorer.exe")){
			Send, +{Delete}
		}else if(WinActive("ahk_exe MusicBee.exe")){
			Send, +{Delete}
		}else if(WinActive("ahk_exe mpc-hc64.exe") || WinActive("ahk_exe PotPlayerMini64.exe")){
			Send, !{F4}
		}
		KeyWait, Joy4
	}

	; Select
	if(GetKeyState("Joy7")){
		while(GetKeyState("Joy7")){
	; Select+A
			if(GetKeyState("Joy1")){
				Send, ^!{m}
				KeyWait, Joy1
			}
	; Select+B
			if(GetKeyState("Joy2")){
				Send, {Media_Next}
				KeyWait, Joy2
			}
	; Select+X
			if(GetKeyState("Joy3")){
				Send, {Media_Prev}
				KeyWait, Joy3
			}
	; Select+Y
			if(GetKeyState("Joy4")){
				Send, !{Media_Play_Pause}
				KeyWait, Joy4
			}

	; Select+LB
			if(GetKeyState("Joy5")){
				Send, {LAlt Down}
				Send, +{Tab}
				KeyWait, Joy5
			}
	; Select+RB
			if(GetKeyState("Joy6")){
				Send, {LAlt Down}
				Send, {Tab}
				KeyWait, Joy6
			}
		}
		Send, {LAlt Up}
	}

	; Pause
	if(GetKeyState("Joy8")){
		while(GetKeyState("Joy8")){
	; Pause+LB
			if(GetKeyState("Joy5")){
				Gosub, turnOnOffLights
				KeyWait, Joy5
			}
	; Pause+RB
			if(GetKeyState("Joy6")){
				Gosub, fxSoundChangeOutput
				KeyWait, Joy6
			}
	; Pause+A
			if(GetKeyState("Joy1")){
				reviewAndLesson := 1
				Gosub, waniKaniAuto
				KeyWait, Joy1
			}
	; Pause+B
			if(GetKeyState("Joy2")){
				reviewAndLesson := 0
				Gosub, waniKaniAuto
				KeyWait, Joy2
			}
	; Pause+Y
			if(GetKeyState("Joy4")){
				Send, !{F4}
				KeyWait, Joy4
			}
	; Pause+RT	
			JoyZ := GetKeyState("JoyZ")
			if(JoyZ < 45)
				Reload
		}
	}

	; LSB
	if(GetKeyState("Joy9") && !(GetKeyState("Joy7"))){
		if(!WinActive("ahk_exe PotPlayerMini64.exe")){
			JoyZ := GetKeyState("JoyZ")
			if(JoyZ > 55)
				Send, ^{r}
			else
				Send, {F5}
		}
		KeyWait, Joy9
	}

	; RSB
	if(GetKeyState("Joy10") && !(GetKeyState("Joy7"))){
		if(!WinActive("ahk_exe PotPlayerMini64.exe")){
			Send, {LShift Down}
			while(GetKeyState("Joy10")){
		; RSB+A
				if(GetKeyState("Joy1")){
					Send, {LButton Down}
					KeyWait, Joy1
					Send, {LButton Up}
				}
			}
			Send, {LShift Up}
		}
	}

	SetTimer, joyButtons, On
	ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 3, "1")
Return

; Game mode
Joy7::
	flipJoystickSwitch := 0
	While(GetKeyState("Joy8", "P")){
		if(!(GetKeyState("Joy7", "P")))
			flipJoystickSwitch := 1
	}

	Goto, JoystickAsMouseEnable
Return
Joy8::
	flipJoystickSwitch := 0
	While(GetKeyState("Joy7", "P")){
		if(!(GetKeyState("Joy8", "P")))
			flipJoystickSwitch := 1
	}

	Goto, JoystickAsMouseEnable
Return
VK07::	
$>!g::
$<^>!g::
	SetTimer, programRoutine, On
	Suspend, Off
	Gui, Destroy
	Gui +AlwaysOnTop -0x30000
	Gui, Add, DropDownList, vGameChoice Choose1, General|Emulation|Close
	Gui, Add, Button, gGameChoose, Choose
	Gui, Show, , Games
Return
#IfWinActive, Games
	$Joy1::
	$Enter::
		Gosub, GameChoose
	Return
	$vk07::
	$Joy2::
	$Esc::
		if(ProcessExist("AoTClock.exe")){
			SetTimer, programRoutine, On
			WatchPOV := 1
			WatchJoystick := 1  ; Monitor the movement of the joystick
			joyButtons := 1
		}else{
			SetTimer, programRoutine, Off
		}
		Gui, Destroy
	Return
#IfWinActive, Emulators
	$Joy1::
	$Enter::
		Gosub, EmuChoose
	Return
	$Joy2::
	$Esc::
		Gui, Destroy
	Return
#IfWinActive, Stores
	$Joy1::
		Send, {Enter}
	Return
	$Joy2::
	$Esc::
		Gui, Destroy
	Return
Return