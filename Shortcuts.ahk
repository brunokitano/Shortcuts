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

ntimes := 0
;#Include D:\Users\Bruno\Documents\Scripts\Shortcuts\Scripts\Tooltip.ahk
;ToolTipColor("Black", "White")
CoordMode, ToolTip, Screen

I_Icon = D:\Users\Bruno\Documents\Scripts\Shortcuts\Icon\Shortcut.ico
IfExist, %I_Icon%
Menu, Tray, Icon, %I_Icon%
	;SETTINGS

expCounter := 0

lowVol := 20
highVol := 80
SoundGet, volume, MASTER
Start_LidWatcher()

headphonesPath := "SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render\{b9736be9-28d7-44b1-b72a-97935ba3e37a}\FxProperties"
headphonesValue := "{3BA0CD54-830F-4551-A6EB-F3EAB68E3700},6"
RegRead, headphones, HKEY_LOCAL_MACHINE, %headphonesPath%, %headphonesValue%
prevValue := headphones
;SetTimer, checkHeadphones, 500

JoystickNumber = 0
GetKeyState, JoyR, JoyR
if(JoyR = "")
	SetTimer, checkController, 300

gotActivated := 0
SetTimer, programRoutine, 10

joystickSwitch := 0
sameKeys := 0
SetTimer, WatchPOVandStick, 20
resChange := 0

; Sound output
outputChange := 0 

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

SetTimer, WatchPOV, 10
SetTimer, WatchJoystick, 10  ; Monitor the movement of the joystick.
SetTimer, joyButtons, 10

GetKeyState, JoyInfo, %JoystickNumber%JoyInfo

joystickAsMouseSwitch := 1
	;VARIABLES AND FUNCTIONS


Send, {<# up} 
Send, {># up} 
Send, {# up} 
Send, {+ up} 
Send, {<+ up} 
Send, {! up} 
Send, {<! up} 
Send, {>! up} 
Send, {^<^^>! up} 
Send, {^<^>! up} 
Send, {^ up}
Send, {Ctrl up}
Send, {§ up}         
Send, {Shift Up}
Send, {LShift Up}
Send, {RShift Up}
Send, {Alt Up}
Send, {LAlt Up}
Send, {RAlt Up}
Send, {Control Up}
Send, {LControl Up}  
Send, {RControl Up}
Send, {<^ Up} 
Send, {>^ Up}
Send, {LWin Up}
Send, {RWin Up}
	;RELEASE KEYS

ToolTip, Shortcuts reloaded.
Goto, smoothTooltip

return

checkHeadphones:
	SetTimer, checkHeadphones, Off

	if(lidState = "opened"){
		RegRead, headphones, HKEY_LOCAL_MACHINE, %headphonesPath%, %headphonesValue%
		if(headphones != 0 && prevValue != headphones){
			SoundSet, %highVol%, MASTER
			RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SOFTWARE\Dolby\DAX, DolbyEnable, 00000001
			Send, {Volume_Mute}
			Send, {Volume_Mute}
			Sleep, 200

			MouseGetPos, mouseX, mouseY
			resFix(62, 75, 696, 280)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}

			resFix(62, 75, 142, 280)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsMute%A_ScreenHeight%.png
			if(!ErrorLevel){
				Send, {Volume_Mute}		
			}
		}else if(headphones != 1 && prevValue != headphones){
			SoundSet, %lowVol%, MASTER
			RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SOFTWARE\Dolby\DAX, DolbyEnable, 00000000
			Send, {Volume_Mute}
			Send, {Volume_Mute}
			Sleep, 200

			MouseGetPos, mouseX, mouseY
			resFix(62, 75, 696, 280)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}

			resFix(62, 75, 142, 280)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsMute%A_ScreenHeight%.png
			if(!ErrorLevel){
				Send, {Volume_Mute}		
			}
		}

		prevValue := headphones
	}

	SetTimer, checkHeadphones, On
Return

checkController:
	GetKeyState, joy_name, 1JoyName
	if(joy_name != "")
		Reload
Return

reopenKDE:
	SetTimer, reopenKDE, Off

	Process, Close, kdeconnect-indicator.exe
	Process, WaitClose, kdeconnect-indicator.exe

	while(ProcessExist("kdeconnectd.exe")){
		Process, Close, kdeconnectd.exe
		Process, WaitClose, kdeconnectd.exe
	}
	Run, "C:\Users\Bruno\AppData\Local\KDE Connect\bin\kdeconnect-indicator.exe"

	SetTimer, reopenKDE, On
Return

vivaldiZoom:
	BlockInput, On
	SetControlDelay, 10
	ControlClick, x1265 y735, ahk_exe vivaldi.exe, , Left, 1
	ControlSend, , %zoomValue%, ahk_exe vivaldi.exe
	ControlSend, , {Enter}{Esc}, ahk_exe vivaldi.exe
	SetControlDelay, 0
	BlockInput, Off
Return
programRoutine:
	SetTimer, programRoutine, Off

	WinGetTitle, winTitle, A

	if(WinActive("ahk_exe AutoHotkey.exe") && (WinExist("Games") || WinExist("Resolution") || WinExist("Yes || No")
		|| WinExist("Emulators") || WinExist("Stores"))){

		SetTimer, WatchPOV, Off
		SetTimer, WatchJoystick, Off
		SetTimer, joyButtons, Off
		joystickAsMouseSwitch := 0

		Gosub, WatchPOV

		WinActivate, Games
		WinActivate, Resolution
		WinActivate, Yes || No
		WinActivate, Emulators
	}else if InStr(winTitle, "Stories", CaseSensitive := false) and InStr(winTitle, "Instagram", CaseSensitive := false){
		ImageSearch, , , 1100, 150, 1200, 250, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\InstaMuted.png
		if(!ErrorLevel){
			ControlClick, x1150 y195, ahk_exe vivaldi.exe, , Left, 1
		}
		Sleep, 300 ; Make it scan less 
	}else if(WinActive("WaniKani / Lessons - Vivaldi") || WinActive("WaniKani / Reviews - Vivaldi") || WinActive("WaniKani / Dashboard - Vivaldi")){
		if(WinActive("WaniKani / Lessons - Vivaldi")){
			if(prevWani != "lessons"){
				Gosub, loadingPage

				ImageSearch, , , 1230, 710, 1280, 740, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\vivaldi140.png
				incorrectZoom := ErrorLevel
				while(incorrectZoom && WinActive("WaniKani / Lessons - Vivaldi")){
					zoomValue := 140
					Gosub, vivaldiZoom

					Sleep, 150
					ImageSearch, , , 1230, 710, 1280, 740, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\vivaldi140.png
					incorrectZoom := ErrorLevel
				}
			}
			prevWani := "lessons"
		}else if(WinActive("WaniKani / Reviews - Vivaldi") || WinActive("WaniKani / Dashboard - Vivaldi")){
			if(prevWani != "reviewsOrDashboard"){
				Gosub, loadingPage

				ImageSearch, , , 1230, 710, 1280, 740, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\vivaldi110.png
				incorrectZoom := ErrorLevel
				while((incorrectZoom && WinActive("WaniKani / Reviews - Vivaldi")) || (incorrectZoom && WinActive("WaniKani / Dashboard - Vivaldi"))){
					zoomValue := 110
					Gosub, vivaldiZoom

					Sleep, 150
					ImageSearch, , , 1230, 710, 1280, 740, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\vivaldi110.png
					incorrectZoom := ErrorLevel
				}
			}
			prevWani := "reviewsOrDashboard"
		}
	}

	SetTimer, programRoutine, On
Return

Start_LidWatcher()
{	
	global
	VarSetCapacity(guid, 16)
	;GUID_LIDSWITCH_STATE_CHANGE
	Numput(0xBA3E0F4D, guid, 0, "uint"), Numput(0x4094B817, guid, 4, "uint")
	Numput(0x63D5D1A2, guid, 8, "uint"), Numput(0xF3A0E679, guid, 12, "uint")

	r := DllCall("RegisterPowerSettingNotification", "ptr", A_ScriptHwnd, "ptr", &guid, "uint", 0)
	if (!r || ErrorLevel)
	{
		;MSDN says check GetLastError if the return value was NULL.
		Msgbox % "RegisterPowerSettingNotification failed with error: " (ErrorLevel ? ErrorLevel : A_LastError)
		return 0
	}
	OnMessage(0x218, "WM_POWERBROADCAST")
	return r
}
Stop_LidWatcher(r)
{
	global
	DllCall("UnregisterPowerSettingNotification", "ptr", r)
	OnMessage(0x218, "")
}
WM_POWERBROADCAST(wparam, lparam)
{
	global
	static fx := "LidStateChange"
	if (wparam = 0x8013 && isFunc(fx))
	{
		;data = 0 = closed
		;data = 1 = opened
		%fx%(Numget(lparam+20, 0, "uchar") ? "opened" : "closed")
	}
	return 1
}
LidStateChange(newstate)
{
	global
	if(newstate = "closed"){
		SoundGet, volume, MASTER
	 	SoundSet, Mute, MASTER
;	 	SetTimer, reopenKDE, Off
	}
	if(newstate = "opened"){
	 	SoundSet, %volume%, MASTER
;	 	SetTimer, reopenKDE, On
	}
	lidState := newstate 
}

; Checks if Process exists
ProcessExist(Name){
	Process,Exist,%Name%
return Errorlevel
}

sleepTime(msTime){
	runTime := ""
	startTime := A_TickCount
	while(runTime <= msTime){
		runTime := A_TickCount - startTime
		Sleep, 10
	}
}

; MsgBox buttons
yesNo: 
	IfWinNotExist, Yes || No
		return  ; Keep waiting.
	SetTimer, yesNo, Off 
	WinActivate 
	ControlSetText, Button1, &Yes
	ControlSetText, Button2, &No
return
resolution: 
	IfWinNotExist, Resolution
		return  ; Keep waiting.
	SetTimer, resolution, Off 
	WinActivate 
	ControlSetText, Button1, &768p
	ControlSetText, Button2, &900p
	ControlSetText, Button3, &1080p
return
stores: 
	IfWinNotExist, Stores
		return  ; Keep waiting.
	SetTimer, stores, Off 
	WinActivate 
	ControlSetText, Button1, &GOG
	ControlSetText, Button2, &Steam
return
closeClass:
	IfWinNotExist, Close Class
		return  ; Keep waiting.
	SetTimer, closeClass, Off 
	WinActivate 
	ControlSetText, Button1, &Yes
	ControlSetText, Button2, &No	
Return

showMessage:
	if(message = "cClass"){
		MsgBox, 0x1000, Hotkey Pressed, Class mode closed., 1
		message := ""
	}
	if(message = "fClass"){
		MsgBox, 0x1000, Hotkey Pressed, Fatec class mode, 1
		message := ""
	}
	if(message = "eClass"){
		MsgBox, 0x1000, Hotkey Pressed, English class mode, 1
		message := ""
	}
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
return

WatchPOV:
	if(!WinActive("ahk_exe PotPlayerMini64.exe")){
		SetTimer, WatchPOV, Off

		Gosub, povDirection

		Gosub, povPressandDelay
		
		SetTimer, WatchPOV, On
	}
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
	if(GetKeyState("Joy1") && !(GetKeyState("Joy3")) && !(GetKeyState("Joy7")) 
		&& !(WinActive("Delete File") || WinActive("Delete Folder") || WinActive("Delete Multiple Items"))){

		Send, {LButton Down}
		KeyWait, Joy1
		Send, {LButton Up}
		Gosub, lbActions
	}
	if(GetKeyState("Joy2") && !(GetKeyState("Joy7")) && !(GetKeyState("Joy8"))){
		Send, {RButton Down}
		KeyWait, Joy2
		Send, {RButton Up}
	}
	if(GetKeyState("Joy3") && !(GetKeyState("Joy7")) && !(GetKeyState("Joy8"))){
		Send, {LControl Down}
		while(GetKeyState("Joy3")){
			if(GetKeyState("Joy1")){
				Send, {LButton Down}
				KeyWait, Joy1
				Send, {LButton Up}
			}
		}
		Send, {LControl Up}
	}
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

	if(GetKeyState("Joy7")){
		while(GetKeyState("Joy7")){
			if(GetKeyState("Joy1")){
				Send, ^!{m}
				KeyWait, Joy1
			}
			if(GetKeyState("Joy2")){
				Send, {Media_Next}
				KeyWait, Joy2
			}
			if(GetKeyState("Joy3")){
				Send, {Media_Prev}
				KeyWait, Joy3
			}
			if(GetKeyState("Joy4")){
				Send, !{Media_Play_Pause}
				KeyWait, Joy4
			}

			if(GetKeyState("Joy5")){
				Send, {LAlt Down}
				Send, +{Tab}
				KeyWait, Joy5
			}
			if(GetKeyState("Joy6")){
				Send, {LAlt Down}
				Send, {Tab}
				KeyWait, Joy6
			}
		}
		Send, {LAlt Up}
	}
	if(GetKeyState("Joy8")){
		while(GetKeyState("Joy8")){
			if(GetKeyState("Joy5")){
				Gosub, turnOnOffLights
				KeyWait, Joy5
			}
			if(GetKeyState("Joy6")){
				Gosub, fxSoundChangeOutput
				KeyWait, Joy6
			}
			if(GetKeyState("Joy4")){
				Gosub, wanikaniAuto
				KeyWait, Joy4
			}
		}
	}
	if(GetKeyState("Joy9") && !(GetKeyState("Joy7"))){
		if(!WinActive("ahk_exe PotPlayerMini64.exe")){
			Send, {F5}
		}
		KeyWait, Joy9
	}
	if(GetKeyState("Joy10") && !(GetKeyState("Joy7"))){
		if(!WinActive("ahk_exe PotPlayerMini64.exe")){
			Send, !{r}
		}
		KeyWait, Joy10
	}

	SetTimer, joyButtons, On
Return

MouseIsOver(WinTitle){
    MouseGetPos,,, Win
	return WinExist(WinTitle . " ahk_id " . Win)
}

resFix(x0 := 0, y0 := 0, x1 := 0, y1 := 0){
	global
	xValue0 := x0 * (A_ScreenWidth / 1920)
	xValue0 := Round(xValue0)
	yValue0 := y0 * (A_ScreenHeight / 1080)
	yValue0 := Round(yValue0)

	xValue1 := x1 * (A_ScreenWidth / 1920)
	xValue1 := Round(xValue1)
	yValue1 := y1 * (A_ScreenHeight / 1080)
	yValue1 := Round(yValue1)
Return
}

smoothTooltip:
	startTime := A_TickCount
	runTime := 0
	Process, Exist 
	hwnd := WinExist("ahk_class tooltips_class32 ahk_pid " ErrorLevel) 
	WinGetPos,,,w,h,ahk_id %hwnd%
	While (DllCall("MoveWindow","Uptr",hwnd,"Int",x+20,"Int",y-10,"Int",w,"Int",h,"Int",0) && runTime <= 1000){
		MouseGetPos, x, y
		runTime := A_TickCount - startTime
	}
	ToolTip, 
Return




; Close class mode
$>!c::
$<^>!c::
	Suspend, Off
	SetTimer, closeClass, 10
	MsgBox, 0x1001, Close Class, Do you want to close Class mode?
	IfMsgBox, OK
	{
		cClassOK:
		message := "cClass"
		SetTimer, showMessage, -10

		if(ProcessExist("NVIDIA RTX Voice.exe")){
			Process, Close, NVIDIA RTX Voice.exe
		}
		while(ProcessExist("Teams.exe")){
			WinClose, ahk_exe Teams.exe
		}
		if(ProcessExist("obs64.exe")){
			Send, #{b}
			Sleep, 50
			resFix(1121, 1050, 1900, 1079)
			PixelSearch, obsX, obsY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xFF0000, 0, Fast RGB
			if(!(ErrorLevel)){ ; Stops recording and closes
				Send, {F22 Down}
				Sleep, 50
				Send, {F22 Up}
				Sleep, 50
				Send, !{Tab}
				Process, Close, obs64.exe			
			}Else{
				Process, Close, obs64.exe
			}
		}
		if(!ProcessExist("wallpaper64.exe")){
			Run, "D:\Program Files (x86)\Steam\steamapps\common\wallpaper_engine\wallpaper64.exe"
		}Else{
			Send, ^{F23}
		}
		if(!ProcessExist("MusicBee.exe")){
			Run, "D:\Program Files (x86)\MusicBee\MusicBee.exe"
		}
	}
	Else
	{
		cClassCancel:
		MsgBox, 0x1000, Button pressed, Cancelled., 1
	}
Return

; English class mode
$>!e::
$<^>!e::
	Suspend, Off
	MsgBox, 0x1001, English Class, Do you want to start English class mode?
	IfMsgBox, OK
	{
		if(!ProcessExist("NVIDIA RTX Voice.exe")){
			Run, "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe", C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice, Hide
		}
		message := "eClass"
		SetTimer, showMessage, -10
		Run, "D:\Users\Bruno\Google Drive\Cursos\Supreme Educators\Life\1 - Beginner"
		Run, "D:\Users\Bruno\Google Drive\Cursos\Supreme Educators\Life\1 - Beginner\Life Beginner Student's book.pdf", , Max
		if(!ProcessExist("Teams.exe")){
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Teams.bat"
		}
		if(ProcessExist("MusicBee.exe")){
			Process, close, MusicBee.exe
		}
		if(ProcessExist("wallpaper64.exe")){
			Send, ^{F23}
		}else{
			Run, "D:\Program Files (x86)\Steam\steamapps\common\wallpaper_engine\wallpaper64.exe"
		}
		Run, https://docs.google.com/spreadsheets/d/1_K11pBdyy8-2Yl_V1QYJ5UXpPc88xxJt6B5SQAU5a-8/edit#gid=0
		Run, https://calendar.google.com/calendar/r
		WinWait, ahk_class RTXVoiceWindowClass
		Sleep, 200
		WinActivate, ahk_class RTXVoiceWindowClass
		WinWaitActive, ahk_class RTXVoiceWindowClass, , 1.5
		Send, !{F4}
	}
	Else
	{
		MsgBox, 0x1000, Button pressed, Cancelled., 1
	}
Return

; Fatec class mode
$>!f::
$<^>!f::
	Suspend, Off
	MsgBox, 0x1001, Fatec Mode, Do you want to start Fatec mode?
	IfMsgBox, OK
	{		
;		if(!ProcessExist("NVIDIA RTX Voice.exe")){
;			Run, "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe", C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice, Hide
;		}
		message := "fClass"
		SetTimer, showMessage, -10
		if(!ProcessExist("Teams.exe")){
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Teams.bat"
		}
		if(!ProcessExist("obs64.exe")){
			Run, "D:\Program Files\obs-studio\bin\64bit\obs64.exe", D:\Program Files\obs-studio\bin\64bit
		}
		if(ProcessExist("wallpaper64.exe")){
			Send, ^{F23}
		}else{
			Run, "D:\Program Files (x86)\Steam\steamapps\common\wallpaper_engine\wallpaper64.exe"
		}
		if(ProcessExist("MusicBee.exe")){
			Process, close, MusicBee.exe
		}
/*		WinWait, ahk_class RTXVoiceWindowClass
		Sleep, 2000
		WinActivate, ahk_class RTXVoiceWindowClass
		WinWaitActive, ahk_class RTXVoiceWindowClass, , 1.5
		Send, !{F4}
*/
	}
	Else
	{
		MsgBox, 0x1000, Button pressed, Cancelled., 1
	}
Return

; Game mode
JoystickAsMouseEnable:
	if(flipJoystickSwitch){
		if(joystickAsMouseSwitch){
			SetTimer, WatchPOV, On
			SetTimer, WatchJoystick, On  ; Monitor the movement of the joystick
			SetTimer, joyButtons, On
			ToolTip, Joystick as Mouse enabled
			Goto, smoothTooltip
		}else{
			SetTimer, WatchPOV, Off
			SetTimer, WatchJoystick, Off
			SetTimer, joyButtons, Off
			ToolTip, Joystick as Mouse disabled
			Goto, smoothTooltip
		}
	}
	joystickAsMouseSwitch := !joystickAsMouseSwitch
Return
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
GameChoose:
	Gui, Submit

	if(GameChoice = "General"){
		Send, ^{F23}
		Sleep, 50
		Gui, Destroy

		SetTimer, stores, 50
		MsgBox, 0x1003, Stores, Which Store?
		IfMsgBox, Yes
		{
			Run, steam://rungameid/14209988591219638272 ; GOG 2.0
		}
		IfMsgBox, No
		{
			Run, "C:\Users\Bruno\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Steam\Big Picture.lnk"
		}

		SetTimer, resolution, 50
		MsgBox, 0x1003, Resolution, Which resolution?
		IfMsgBox, Yes
		{
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\768p.bat"
			resChange := 1 ; correct this
		}
		IfMsgBox, No
		{
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"
			resChange := 1 ; correct this
		}

;		Process, Exist, vivaldi.exe
;		vivaldiPID=%Errorlevel%
;		if(vivaldiPID){
;			WinActivate ahk_pid %vivaldiPID%
;			WinWaitActive, ahk_exe vivaldi.exe, , 1.5
;			Send, !{F4}
;		}
;		Process, Close, WhatsApp.exe
		Process, Close, AoTClock.exe

		if(!ProcessExist("Steam.exe")){
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Shortcuts\Steam Ryuiti"
			WinWait, Steam
			Sleep, 500
			WinActivate, ahk_class vguiPopupWindow, , Steam Login
			WinWaitActive, ahk_class vguiPopupWindow, , 1.5, Steam Login
			Sleep, 1000
			WinActivate, ahk_class vguiPopupWindow, , Steam Login
			WinWaitActive, ahk_class vguiPopupWindow, , 1.5, Steam Login
			Send, !{F4}			
		}

		SetTimer, yesNo, 50
		MsgBox, 0x1101, Yes || No, Do you want to open Discord and RTX Voice?
		IfMsgBox, OK
		{
			Run, "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe", C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice, Hide
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Discord.bat"
			WinWait, ahk_class RTXVoiceWindowClass
			Sleep, 200
			WinActivate, ahk_class RTXVoiceWindowClass
			WinWaitActive, ahk_class RTXVoiceWindowClass, , 1.5
			Send, !{F4}	
		}
		SetTimer, programRoutine, Off
		SetTimer, WatchPOVandStick, Off

	Gui, Destroy
	}

	if(GameChoice = "Close"){
		Send, ^{F23}
		Sleep, 50

		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\1080p.bat"
		if(!ProcessExist("vivaldi.exe")){
			Run, "D:\Program Files\Vivaldi\Application\vivaldi.exe"
		}
;		if(!ProcessExist("WhatsApp.exe")){
;			Run, C:\Users\Bruno\AppData\Local\WhatsApp\WhatsApp.exe
;		}
;		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Restart explorer.bat"

		Process, Close, NVIDIA RTX Voice.exe
		Process, Close, GalaxyClient.exe
		Process, Close, EpicGamesLauncher.exe
		Process, Close, Discord.exe
		Process, Close, retroarch.exe
		Process, Close, citra-qt.exe
		Process, Close, Cemu.exe
		Process, Close, JoyToKey.exe

		Run, "D:\Users\Bruno\Documents\Scripts\Always on top clock\AoTClock.exe"

		if(fallGuys){
			Process, Close, steam.exe
			Sleep, 200
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Shortcuts\Steam Ryuiti"
			WinWait, Steam
			Sleep, 500
			WinActivate, ahk_class vguiPopupWindow, , Steam Login
			WinWaitActive, ahk_class vguiPopupWindow, , 1.5, Steam Login
			Sleep, 1000
			WinActivate, ahk_class vguiPopupWindow, , Steam Login
			WinWaitActive, ahk_class vguiPopupWindow, , 1.5, Steam Login
			Send, !{F4}
			fallGuys := 0
		}

		if(WinExist("ahk_class CUIEngineWin32")){
			WinActivate, ahk_class CUIEngineWin32
			WinWaitActive, ahk_class CUIEngineWin32, , 2
			Send, !{Enter}
		}

		Reload
	Gui, Destroy
	}

	if(GameChoice = "Emulation"){
		Send, ^{F23}
		Sleep, 50
		
;		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"
;		Process, Exist, vivaldi.exe
;		vivaldiPID=%Errorlevel%
;		if(vivaldiPID){
;			WinActivate ahk_pid %vivaldiPID%
;			WinWaitActive, ahk_exe vivaldi.exe, , 1.5
;			Send, !{F4}
;		}
	;	Process, Close, WhatsApp.exe
		Process, Close, AoTClock.exe

		Gui, Destroy
		Gui +AlwaysOnTop -0x30000
		Gui, Add, DropDownList, vEmuChoice Choose1, RetroArch|Citra|Cemu|Close
		Gui, Add, Button, gEmuChoose, Choose
		Gui, Show, , Emulators

		SetTimer, programRoutine, Off
		SetTimer, WatchPOVandStick, Off
	}
Return
EmuChoose:
	Gui, Submit
	if(EmuChoice = "RetroArch"){
		Run, steam://rungameid/1118310 ; retroarch
	}
	if(EmuChoice = "Citra"){
		Run, "C:\Users\Bruno\AppData\Local\Citra\canary-mingw\citra-qt.exe"
		Run, "D:\Program Files (x86)\JoyToKey\JoyToKey.exe"
	}
	if(EmuChoice = "Cemu"){
		Run, "D:\Users\Bruno\Documents\Emulators\Wii U\Cemu\Cemu.exe"
	}
	Gui, Destroy
Return

; Win+H = Hibernate computer
$>!h::
$<^>!h::
	Suspend, Off
	Run, D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Hibernate.bat
	MsgBox, 0x1000, Hotkey Pressed, Hibernating., 1
Return

; Show all the shortcuts
$>!i::
$<^>!i::
	Suspend, Off
	MsgBox, , List of shortcuts,
	(
F1 || F2 || F3: Suspend for Vivaldi search
AltGr+c: Close Class mode
AltGr+e: English Class Mode
AltGr+f: Fatec Mode
AltGr+g: Game mode
AltGr+h: Hibernate Computer
AltGr+j: Study Japanese
AltGr+l: Turn on || off the light
AltGr+r: Start recording with OBS
AltGr+,: Show time temporarily
Alt+w: Stop Wallpaper Engine
	)
Return

; Turn the lights On || Off
lightButtons: 
	IfWinNotExist, Lights
		return  ; Keep waiting.
	SetTimer, lightButtons, Off 
	WinActivate 
	ControlSetText, Button1, &Ligar
	ControlSetText, Button2, &Desligar
return
turnOnOffLights:
	Suspend, Off
	SetTimer, lightButtons, 50
	MsgBox, 0x1003, Lights, What do you want to do with the lights?
	IfMsgBox, Yes
	{
		Run, D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Lights\On.vbs
		MsgBox, 0x1000, Button pressed, Turning the light on., 1
	}
	IfMsgBox, No
	{
		Run, D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Lights\Off.vbs
		MsgBox, 0x1000, Button pressed, Turning the light off., 1
	}
Return
$>!l::
$<^>!l::
	Goto, turnOnOffLights
Return

; MusicBee
musicBee:
	if(!ProcessExist("MusicBee.exe")){
		Run, "D:\Program Files (x86)\MusicBee\MusicBee.exe"
		WinWait, ahk_exe MusicBee.exe
	}
	Sleep, 100
	Send, #{b}
	Sleep, 50
	CoordMode, Pixel, Screen
	
	MouseGetPos, mouseX, mouseY
	resFix(1450, 1042, 1700, 1080)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	ImageSearch, musicBeeX, musicBeeY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBLogo%A_ScreenHeight%.png
	if(!ErrorLevel){
		MouseClick, Left, %musicBeeX%, %musicBeeY%, 2, 0
		MouseMove, %mouseX%, %mouseY%, 0

		WinActivate, ahk_exe MusicBee.exe
		WinWaitActive, ahk_exe MusicBee.exe
		Send, #{Up}
		WinActivate, ahk_exe MusicBee.exe
		WinWaitActive, ahk_exe MusicBee.exe
		Send, #{Up}
	}
	
	CoordMode, Pixel, Relative
Return
$>!b::
$<^>!b::
	Gosub, musicBee

	Sleep, 200
	ImageSearch, , , 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBPlaylists%A_ScreenHeight%.png
	if(ErrorLevel){
		resFix(410, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
	}else{
		resFix(280, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
		resFix(410, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
	}

	MouseGetPos, mouseX, mouseY
	resFix(220, 120)
	MouseClick, Left, %xValue0%, %yValue0%, 2, 0 ; Classical
	MouseMove, %mouseX%, %mouseY%, 0
Return
$>!n::
$<^>!n::
	Gosub, musicBee

	Sleep, 200
	ImageSearch, , , 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBPlaylists%A_ScreenHeight%.png
	if(ErrorLevel){
		resFix(410, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
	}else{
		resFix(280, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
		resFix(410, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
	}


	MouseGetPos, mouseX, mouseY
	ImageSearch, MBnotClassicalX, MBnotClassicalY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNotClassical%A_ScreenHeight%.png
	MouseClick, Left, %MBnotClassicalX%, %MBnotClassicalY%, 2, 0 ; Not Classical
	MouseMove, %mouseX%, %mouseY%, 0
Return

; Start || stop recording
$>!r::
$<^>!r::
	Suspend, Off
	if(ProcessExist("obs64.exe")){
		Send, #{b}
		Sleep, 50
		resFix(1121, 1050, 1900, 1079)
		PixelSearch, obsX, obsY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xFF0000, 6, Fast RGB
		if(!(ErrorLevel)){
			Send, {F22 Down}
			Sleep, 50
			Send, {F22 Up}
			Send, !{Tab}
			MsgBox, 0x1000, Hotkey Pressed, Stopped recording., 1				
		}Else{
			Send, {F22 Down}
			Sleep, 50
			Send, {F22 Up}
			Send, !{Tab}
			MsgBox, 0x1000, Hotkey Pressed, Started recording., 1
		}
	}Else{
		MsgBox, 0x1000, Hotkey Pressed, OBS is not running., 1
	}
Return

$>!s::
$<^>!s::
	if(WinExist("ahk_exe sublime_text.exe")){
		WinActivate, ahk_exe sublime_text.exe
	}else{
		Run, "D:\Program Files\Sublime Text 3\sublime_text.exe"
	}
Return

$<!w::
	Send, ^{F23}
	Suspend, Off
Return

$>!LButton::
$<^>!LButton::
	Send, ^{LButton}
Return

$PrintScreen::
	Send, ^{F24}
	prtscCounter := 0
	while(1){
		if(GetKeyState("Enter", "P"))
			Break

		if(GetKeyState("LButton", "P")){
			KeyWait, LButton
			Break
		}
	}
Return

$>!,::
$<^>!,::
	if(WinActive("ahk_exe mpc-hc64.exe")){
		MouseGetPos, mouseX, mouseY
		resFix(50, 50)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(50, 50)
		ImageSearch, , , 0, 0, %xValue0%, %yValue0%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\mpcLogo%A_ScreenHeight%.png
		if(ErrorLevel){
			Send, {f}
			mpcWindow := 1
		}

		MouseMove, %mouseX%, %mouseY%, 0
	}else if(WinActive("ahk_exe vivaldi.exe")){
		MouseGetPos, mouseX, mouseY

		resFix(9, 85, 50, 140)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(9, 85, 50, 140)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg%A_ScreenHeight%.png
		if(ErrorLevel){
			Send, {f}
			vivaldiWindow := 1
		}
		MouseMove, %mouseX%, %mouseY%, 0
	}

	;if(!ProcessExist("WhatsappTray.exe")){
	if(!ProcessExist("Whatsapp.exe")){
		while(ProcessExist("WhatsApp.exe")){
			Process, Close, WhatsApp.exe
		}
		;Run, "D:\Program Files (x86)\WhatsappTray\WhatsappTray.exe"
		Run, C:\Users\Bruno\AppData\Local\WhatsApp\WhatsApp.exe
	}
	
	Run, C:\Users\Bruno\AppData\Local\WhatsApp\WhatsApp.exe
	WinWait, ahk_exe WhatsApp.exe
	WinActivate, ahk_exe WhatsApp.exe
	WinSet, Top, , ahk_exe WhatsApp.exe

	WinGet, window, MinMax
	if(window != 1){
		Send, #{Up}
	}
Return

; WaniKani
wanikaniAuto:
	if(!WinActive("ahk_exe vivaldi.exe")){	
		Process, Exist, vivaldi.exe
		vivaldiPID=%Errorlevel%
		if(vivaldiPID){
			WinActivate ahk_pid %vivaldiPID%
			WinWaitActive, ahk_exe vivaldi.exe, , 1.5
			Send, #{Up}
		}
		Sleep, 200
	}else{
		WinMaximize, ahk_exe vivaldi.exe
		Sleep, 200
	}

	MouseGetPos, mouseX, mouseY

	resFix(1600, 110, 1910, 210) ; (mouseX > 1600 && mouseY > 110 && mouseX < 1910 && mouseY < 210)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(1600, 110, 1910, 210) ; (mouseX > 1600 && mouseY > 110 && mouseX < 1910 && mouseY < 210)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniSession%A_ScreenHeight%.png ; Detects if it's already on the page
	if(ErrorLevel){
		MouseGetPos, mouseX, mouseY

		resFix(1350, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(1350, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniExtension%A_ScreenHeight%.png ; Detects if the extension is open
		waniKaniError := ErrorLevel
		if(waniKaniError){
			resFix(1820, 70)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1
			Sleep, 10

			varTime := 1000
			Sleep, %varTime%

			resFix(1350, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniExtension%A_ScreenHeight%.png ; Detects if the extension is open
			waniKaniError := ErrorLevel
		}
		while(waniKaniError){
			resFix(1820, 70)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1
			varTime := varTime + 100
			Sleep, %varTime%

			MouseGetPos, mouseX, mouseY
			resFix(1350, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}
			
			resFix(1350, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniExtension%A_ScreenHeight%.png ; Detects if the extension is open
			waniKaniError := ErrorLevel
		}

		resFix(1452, 228, 1824, 313)
		PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xF100A1, 50, Fast RGB  ; Lesson
		waniKaniLesson := ErrorLevel
		if(!waniKaniLesson){
			Send, {Esc}
			Sleep, 10
			Run, https://www.wanikani.com/lesson/session

			waniKaniReview := 1
		}else{
			resFix(1452, 228, 1824, 313)
			PixelSearch, waniX, waniY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x00AAFF, 50, Fast RGB ; Review
			waniKaniReview := ErrorLevel
		}

		if(!waniKaniReview){
			Send, {Esc}
			Sleep, 10
			Run, https://www.wanikani.com/review/session
		}
		if(waniKaniLesson){
			Send, {Esc}
			Sleep, 10
		}
	}else{
		resFix(1740, 160)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 ; If it's already on review/lesson page
	}
Return
$>+/::
$>+;::
	Gosub, wanikaniAuto
Return

$F1::
	if(ProcessExist("AoTClock.exe")){
		if(!ProcessExist("vivaldi.exe")){
			Run, D:\Program Files\Vivaldi\Application\vivaldi.exe
			WinWait, ahk_exe vivaldi.exe
		}

		Process, Exist, vivaldi.exe
		vivaldiPID=%Errorlevel%
		if(vivaldiPID){
			WinActivate ahk_pid %vivaldiPID%
			WinWaitActive, ahk_exe vivaldi.exe, , 1.5
			Sleep, 10
		}

		resFix(1270, 340)
		PixelGetColor, searchBar, %xValue0%, %yValue0%, Fast RGB
		if(searchBar != "0x2B2B2B" || searchBar != "0x2B2C34"){
			Send, {Esc}
			Send, {F1}
		}else{
			Send, {F1}
		}
	}else{
		Send, {F1}
	}
Return
$F2::
$F3::
	if(!ProcessExist("vivaldi.exe")){
		Run, D:\Program Files\Vivaldi\Application\vivaldi.exe
		WinWait, ahk_exe vivaldi.exe
	}

	Process, Exist, vivaldi.exe
	vivaldiPID=%Errorlevel%
	if(vivaldiPID){
		WinActivate ahk_pid %vivaldiPID%
		WinWaitActive, ahk_exe vivaldi.exe, , 1.5
		Sleep, 10
	}

	resFix(1270, 340)
	PixelGetColor, searchBar, %xValue0%, %yValue0%, Fast RGB
	if(searchBar != "0x2B2B2B" || searchBar != "0x2B2C34"){
		Send, {Esc}
		Send, {F1}
	}else{
		Send, {F1}
	}
Return

FxSoundTrayTip:
	TrayTip, FxSound, Changing Output to %futureOutput%, 2.5
Return
fxSoundChangeOutput:
	WinGetActiveTitle, currentActive
	Process, Close, FxSound.exe
	
	MySearchTerm := "philco"
	 
	currentOutput := "" ; clears the var variable if it has contents
	TheFile := "" ; clears the TheFile variable if it has contents
	Loop, Read, C:\Users\Bruno\AppData\Roaming\FxSound\FxSound.settings
	{
		If(nextline)
		{	
			currentOutput.=A_LoopReadLine
			nextline:=false
		}
		else IfInString, A_LoopReadLine, %MySearchTerm%
		{
			currentOutput.=A_LoopReadLine
			nextline:=true
		}
	}
	
	FileRead, textContents, C:\Users\Bruno\AppData\Roaming\FxSound\FxSound.settings
	if(currentOutput = ""){ ; Realtek is the current output, change it to philco
		textContents := StrReplace(textContents, "Speakers (Realtek High Definition Audio)", "TV-PHILCO (Intel(R) Display Audio)")
		textContents := StrReplace(textContents, "{0.0.0.00000000}.{577cb51f-f82d-456f-8878-44ea83a018d7}", "{0.0.0.00000000}.{f80174d9-5f21-4599-8957-2852f2495fb5}")
		futureOutput := "TV"
	}else{
		textContents := StrReplace(textContents, "TV-PHILCO (Intel(R) Display Audio)", "Speakers (Realtek High Definition Audio)")
		textContents := StrReplace(textContents, "{0.0.0.00000000}.{f80174d9-5f21-4599-8957-2852f2495fb5}", "{0.0.0.00000000}.{577cb51f-f82d-456f-8878-44ea83a018d7}")
		futureOutput := "Headphone Jack"
	}
	FileDelete, C:\Users\Bruno\AppData\Roaming\FxSound\FxSound.settings
	FileAppend, %textContents%, C:\Users\Bruno\AppData\Roaming\FxSound\FxSound.settings

	SetTimer, FxSoundTrayTip, -1
	Run, C:\ProgramData\Microsoft\Windows\Start Menu\Programs\FxSound\FxSound.lnk
Return
F12::
	Goto, fxSoundChangeOutput
Return

$<!Tab::
	if(WinActive("ahk_exe vivaldi.exe")){
		MouseGetPos, mouseX, mouseY
		resFix(9, 85, 50, 140)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(9, 85, 50, 140)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg%A_ScreenHeight%.png
		if(ErrorLevel){
			Send, {f}
			Sleep, 50
			vivaldiFull := 1
			vivaldiCounter := 1
		}
	}
	Send, {LAlt Down}{Tab}
	KeyWait, Tab, T0.5
	if(vivaldiFull = 1){
		if(vivaldiCounter >= 2){
			if(WinActive("ahk_exe vivaldi.exe")){	
				Send, {f}
				Sleep, 50
			}else{
				vivaldiFull := 0
				vivaldiCounter := 0
			}
		}
	}
	while(GetKeyState("LAlt", "P")){
		if(GetKeyState("Tab", "P")){
			Send, {LAlt Down}{Tab}
			KeyWait, Tab, T0.5
		}
	}
	Send, {LAlt Up}
	if(vivaldiCounter){
		vivaldiCounter++
	}
Return

; Reload
^Esc::
$<^>!Esc::
	Reload
Return

~$#Space::
	KeyWait, #
	Sleep, 500
	CoordMode, Pixel, Screen

	MouseGetPos, mouseX, mouseY
	resFix(1600, 1042, 1716, 1079)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(1600, 1042, 1716, 1079)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\JapaneseIME%A_ScreenHeight%.png
	if(!ErrorLevel){
		Send, +{CapsLock}
	}

	MouseMove, %mouseX%, %mouseY%, 0

	CoordMode, Pixel, Relative
Return

ExtractAppTitle(FullTitle)
{	
	AppTitle := SubStr(FullTitle, InStr(FullTitle, " ", false, -1) + 1)
	Return AppTitle
}
$^Tab::
	WinGet, ActiveProcess, ProcessName, A
	WinGet, OpenWindowsAmount, Count, ahk_exe %ActiveProcess%

	If OpenWindowsAmount = 1  ; If only one Window exist, do nothing
	    Return			
	Else{
		WinGetTitle, FullTitle, A
		AppTitle := ExtractAppTitle(FullTitle)

		SetTitleMatchMode, 2		
		WinGet, WindowsWithSameTitleList, List, %AppTitle%
		
		If WindowsWithSameTitleList > 1 ; If several Window of same type (title checking) exist
		{
			WinActivate, % "ahk_id " WindowsWithSameTitleList%WindowsWithSameTitleList%	; Activate next Window	
		}
	}
Return

$^\::
	SoundGet, volume
	if(volume != "20.000000"){
		SoundSet, %lowVol%, MASTER
		RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SOFTWARE\Dolby\DAX, DolbyEnable, 00000000
	}else{
		SoundSet, %highVol%, MASTER
		RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SOFTWARE\Dolby\DAX, DolbyEnable, 00000001
	}

	Send, {Volume_Mute}
	Send, {Volume_Mute}


	CoordMode, Mouse, Screen

	MouseGetPos, mouseX, mouseY
	resFix(62, 75, 696, 280)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	Sleep, 100
	resFix(62, 75, 142, 280)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsMute%A_ScreenHeight%.png
	if(!ErrorLevel){
		Send, {Volume_Mute}		
	}

	CoordMode, Mouse, Relative
Return

$^F3::
$Volume_Up::
	SoundGet, volume
	Send, {Volume_Up}
	SoundSet, volume + 1
	
	SoundGet, volume
	if(volume >= 30){
		RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SOFTWARE\Dolby\DAX, DolbyEnable, 00000001
	}else{
		RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SOFTWARE\Dolby\DAX, DolbyEnable, 00000000
	}
Return
$^F2::
$Volume_Down::
	SoundGet, volume
	Send, {Volume_Down}
	SoundSet, volume - 1

	SoundGet, volume
	if(volume >= 30){
		RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SOFTWARE\Dolby\DAX, DolbyEnable, 00000001
	}else{
		RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SOFTWARE\Dolby\DAX, DolbyEnable, 00000000
	}
Return

$^F1::Volume_Mute

$^#Down:: 
	WinGetActiveTitle, winTitle
	WinMinimize, %winTitle%
Return

$#a::
	CoordMode, Mouse, Screen
	CoordMode, Pixel, Screen

	MouseGetPos, mouseX, mouseY
	resFix(1700, 850, 1910, 930)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(1700, 850, 1910, 930)
	ImageSearch, WinNotif1X, WinNotif1Y, %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsNotifications1%A_ScreenHeight%.png
	windowsNotifications1 := ErrorLevel
	resFix(1700, 850, 1910, 930)
	ImageSearch, WinNotif2X, WinNotif2Y, %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsNotifications2%A_ScreenHeight%.png
	windowsNotifications2 := ErrorLevel
	if(!windowsNotifications1){
		MouseGetPos, mouseX, mouseY
		MouseClick, , %WinNotif1X%, %WinNotif1Y%, 1, 0
		Send, #{a}
		Sleep, 150
		WinActivate, %winTitle%
	}else if(!windowsNotifications2){
		MouseGetPos, mouseX, mouseY
		MouseClick, , %WinNotif2X%, %WinNotif2Y%, 1, 0
		Send, #{a}
		Sleep, 150
		WinActivate, %winTitle%
	}else{
		WinGetActiveTitle, winTitle
		Send, #{a}
	}

	MouseMove, %mouseX%, %mouseY%, 0

	CoordMode, Mouse, Relative
	CoordMode, Pixel, Relative
Return

+Media_Play_Pause::F21




#IfWinExist, Resolution
	$7::
		WinClose, Resolution
;		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\768p.bat"
	Return
	$9::
		WinClose, Resolution
		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"
	Return
	$1::
		WinClose, Resolution
		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\1080p.bat"
	Return

	$Joy1::
		Send, {Enter}
	Return
	$Joy2::
	Esc::
		WinClose, Resolution
	Return
	Left::
		WinActivate, Resolution 
		WinWaitActive, Resolution
		Send, {Left}
	Return
	Right::
		WinActivate, Resolution 
		WinWaitActive, Resolution
		Send, {Right}
	Return
#IfWinExist, Yes || No
	$y::
		WinClose, Yes || No
		Run, "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe", C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice, Hide
		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Discord.bat"
		
		WinWait, ahk_class RTXVoiceWindowClass
		Sleep, 200
		WinActivate, ahk_class RTXVoiceWindowClass
		WinWaitActive, ahk_class RTXVoiceWindowClass, , 1.5
		Send, !{F4}
	Return

	$Joy1:: Send, {Enter}
	
	$Joy2::
	Esc::
	$n::
		WinClose, Yes || No
	Return
	Left::
		WinActivate, Yes || No 
		WinWaitActive, Yes || No
		Send, {Left}
	Return
	Right::
		WinActivate, Yes || No 
		WinWaitActive, Yes || No
		Send, {Right}
	Return
#If WinActive("Delete File") || WinActive("Delete Folder") || WinActive("Delete Multiple Items")
	$Joy1::
		Send, {Enter}
	Return
	$Joy2::
		Send, {Esc}
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
			SetTimer, WatchPOV, On
			SetTimer, WatchJoystick, On  ; Monitor the movement of the joystick
			SetTimer, joyButtons, On
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
#IfWinActive, Lights
	Joy1::
		Send, {Enter}
	Return

	$k::
		WinClose, Lights
		Run, D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Lights\Off.vbs
		MsgBox, 0x1000, Button pressed, Turning the light off., 1
	Return

expSelect:
	MouseGetPos, mouseX, mouseY
	if(goingDown){
		if(WinActive("Recycle Bin") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\desktop.png
		}else if(WinActive("Desktop") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\pc.png
		}else if(WinActive("This PC") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\downloads.png
		}else if(WinActive("Downloads") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\sonarr.png
		}else if(WinActive("D:\Users\Bruno\Videos\Sonarr") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\series.png
		}else if(WinActive("D:\Users\Bruno\Videos\Series") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\documents.png
		}else if(WinActive("Documents") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\media.png
		}else if(WinActive("C:\Users\Bruno\Media") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\scripts.png
		}else if(WinActive("D:\Users\Bruno\Documents\Scripts") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\drive1.png
			if(ErrorLevel)
				ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\drive2.png

		}else if(WinActive("D:\Users\Bruno\Google Drive") && WinActive("ahk_exe explorer.exe") && !WinActive("D:\Users\Bruno\Google Drive\Registro")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\registro1.png
			if(ErrorLevel)
				ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\registro2.png
		}else if(WinActive("D:\Users\Bruno\Google Drive\Registro") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 0, 0, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\recycleEmpty.png
			if(ErrorLevel)
				ImageSearch, expX, expY, 0, 0, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\recycleFull.png
		}else{
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\sonarr.png
		}
	}else{
		if(WinActive("Recycle Bin") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\registro1.png
			if(ErrorLevel)
				ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\registro2.png
		}else if(WinActive("Desktop") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 0, 0, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\recycleEmpty.png
			if(ErrorLevel)
				ImageSearch, expX, expY, 0, 0, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\recycleFull.png
		}else if(WinActive("This PC") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\desktop.png
		}else if(WinActive("Downloads") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\pc.png
		}else if(WinActive("D:\Users\Bruno\Videos\Sonarr") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\downloads.png
		}else if(WinActive("D:\Users\Bruno\Videos\Series") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\sonarr.png
		}else if(WinActive("Documents") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\series.png
		}else if(WinActive("C:\Users\Bruno\Media") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\documents.png
		}else if(WinActive("D:\Users\Bruno\Documents\Scripts") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\media.png
		}else if(WinActive("D:\Users\Bruno\Google Drive") && WinActive("ahk_exe explorer.exe") && !WinActive("D:\Users\Bruno\Google Drive\Registro")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\scripts.png
		}else if(WinActive("D:\Users\Bruno\Google Drive\Registro") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\drive1.png
			if(ErrorLevel)
				ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\drive2.png
		}else{
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\sonarr.png
		}
	}

	MouseClick, Left, %expX%, %expY%, 1, 0
	MouseMove, %mouseX%, %mouseY%
	goingDown := 0
Return
#IfWinActive, ahk_exe explorer.exe
	$^Tab::
		Send, ^#{2}
	Return

	~$F2::
	Return

	$Joy5::
	$1::
		if(!GetKeyState("Joy7") && !GetKeyState("Joy8"))
			Gosub, expSelect
	Return

	$Joy6::
	$2::
		if(!GetKeyState("Joy7") && !GetKeyState("Joy8")){			
			goingDown := 1
			Gosub, expSelect
		}
	Return

	$Joy9::
		if(!(GetKeyState("Joy7")))
			Send, !{Left}
	Return
	$Joy10::
		if(!(GetKeyState("Joy7")))
			Send, !{Right}
	Return

; Vivaldi
downloadsPanel:
	MouseGetPos, mouseX, mouseY
	resFix(9, 85, 50, 120)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(9, 85, 50, 120)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg%A_ScreenHeight%.png
	if(!ErrorLevel){
		resFix(30, 600)
		PixelGetColor, panelExist, %xValue0%, %yValue0%, Fast RGB
		if(!(panelExist = "0x282828" || panelExist = "0x1C1D49" || panelExist = "0x2E2F36")){
			Send, +{F4}
			Sleep, 400
		}

		MouseGetPos, mouseX, mouseY
		resFix(200, 200)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(200, 200)
		ImageSearch, , , 0, 0, %xValue0%, %yValue0%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiDownloads%A_ScreenHeight%.png
		if(!Error){
			Send, ^{j}
		}
	}
Return
loadingPage:
	MouseGetPos, mouseX, mouseY
	resFix(80, 40, 160, 110)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(80, 40, 160, 110)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiPageLoading%A_ScreenHeight%.png
	pageLoading := ErrorLevel
	while(pageLoading = 0){
		MouseGetPos, mouseX, mouseY
		resFix(80, 40, 160, 110)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(80, 40, 160, 110)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiPageLoading%A_ScreenHeight%.png
		pageLoading := ErrorLevel
		Sleep, 50
	}
Return
isOnYt:
	MouseGetPos, mouseX, mouseY
	resFix(150, 30, 700, 90)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(150, 30, 700, 90)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\URLYT1%A_ScreenHeight%.png
	ytUrl1 := ErrorLevel
	resFix(150, 30, 700, 90)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\URLYT2%A_ScreenHeight%.png
	ytUrl2 := ErrorLevel
Return
actionOnYt:
	if(!ytUrl1 || !ytUrl2){
		MouseGetPos, mouseX, mouseY
		resFix(60, 360, 250, 410)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(0, 300, 250, 500)
;		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTHistory%A_ScreenHeight%.png
;		if(!ErrorLevel){
;			resFix(90, 160)
;			ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 ; left icons
;		}

		resFix(1750, 120, 1810, 160)
		PixelSearch, ytColorX, ytColorY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xCC0000, 20, Fast RGB
		if(!ErrorLevel){
			ControlClick, x%ytColorX% y%ytColorY%, ahk_exe vivaldi.exe, , Left, 1 ; notifications
			resFix(1500, 320)
			MouseMove, %xValue0%, %yValue0%, 0
		}
	}
Return
#IfWinActive, ahk_exe vivaldi.exe
	$^1::
		WinGet, window, MinMax
		if(window = 1){
			resFix(500, 100)
			PixelGetColor, colorVar, %xValue0%, %yValue0%, Fast RGB
			if(colorVar = 0x404076){ ; Incognito
				Send, ^{2}
				Return
			}

			MouseGetPos, mouseX, mouseY
			resFix(9, 85, 50, 140)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}
			resFix(9, 85, 50, 140)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg%A_ScreenHeight%.png
			vivaldiFullError := ErrorLevel
			if(ErrorLevel){
				Send, {Esc}
			}
			while(vivaldiFullError){
				resFix(9, 85, 50, 140)
				ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg%A_ScreenHeight%.png
				vivaldiFullError := ErrorLevel
			}
			MouseMove, %mouseX%, %mouseY%, 0

			Gosub, downloadsPanel
			Gosub, loadingPage
			Gosub, isOnYt
			resFix(80, 10, 80, 15)
			PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x2E2F37, 20, Fast RGB
			firstTab := ErrorLevel
			Send, ^{1}

			KeyWait, 1
			KeyWait, Control

			if((!ytUrl1 || !ytUrl2) && !firstTab){
				resFix(1790, 155)
				ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 ; notifications
				resFix(1500, 320)
				MouseMove, %xValue0%, %yValue0%, 0

				MouseGetPos, mouseX, mouseY
				resFix(60, 360, 250, 410)
				if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
					resFix(1000, 600)
					MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
				}

				resFix(0, 300, 250, 500)
;				ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTHistory%A_ScreenHeight%.png
;				if(!ErrorLevel){
;					resFix(90, 160)
;					ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 ; left icons
;				}
				MouseMove, %mouseX%, %mouseY%, 0
			}else if(!(!ytUrl1 || !ytUrl2) && !firstTab){
				Send, ^{l}
				Sleep, 100
				Send, youtube.com
				Send, {Enter}
				sleepTime(500)
				Gosub, loadingPage
				Sleep, 1600
				Gosub, isOnYt
				Gosub, actionOnYt
			}else{
				Sleep, 200
				Gosub, isOnYt
				resFix(80, 10, 80, 15)
				PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x2E2F37, 20, Fast RGB
				firstTab := ErrorLevel
				if(!(!ytUrl1 || !ytUrl2) && !firstTab){
					Sleep, 500
					Gosub, isOnYt
					resFix(80, 10, 80, 15)
					PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x2E2F37, 20, Fast RGB
					firstTab := ErrorLevel

					if(!(!ytUrl1 || !ytUrl2) && !firstTab){
						resFix(80, 10, 80, 15)
						PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x2E2F37, 20, Fast RGB
						firstTab := ErrorLevel
						Send, ^{l}
						Sleep, 100
						Send, youtube.com
						Send, {Enter}

						Sleep, 500
						Gosub, loadingPage
						Gosub, isOnYt
						Gosub, actionOnYt
					}else if((!ytUrl1 || !ytUrl2) && !firstTab){
						Gosub, actionOnYt
					}
				}else if ((!ytUrl1 || !ytUrl2) && !firstTab){
					Gosub, actionOnYt
				}
			}
		}else{
			Send, ^{1}
		}
	Return

/*	$^2::
		Gosub, downloadsPanel

		resFix(500, 100)
		PixelGetColor, colorVar, %xValue0%, %yValue0%, Fast RGB
		if(colorVar = 0x404076){ ; Incognito
			Send, ^{2}
			Return
		}

		MouseGetPos, mouseX, mouseY
		resFix(180, 130, 350, 180)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(180, 130, 350, 180)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\TwitterLogo%A_ScreenHeight%.png
		twitterLogo := ErrorLevel
		Send, ^{2}

		MouseGetPos, mouseX, mouseY
		resFix(9, 85, 50, 140)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(9, 85, 50, 140)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg%A_ScreenHeight%.png
		if(!ErrorLevel){
			Send, {Esc}
		}

		if(!twitterLogo){
			KeyWait, LCtrl
			resFix(300, 220)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1
		}
	Return
*/
	~$^3::
	~$^4::
	~$^5::
	~$^6::
	~$^7::
	~$^8::
	~$^9::
		MouseGetPos, mouseX, mouseY
		
		resFix(9, 85, 50, 140)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(9, 85, 50, 140)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg%A_ScreenHeight%.png
		if(ErrorLevel){
			Send, {Esc}
		}
		Gosub, downloadsPanel
	Return

	$^w::
		MouseGetPos, mouseX, mouseY
		resFix(9, 85, 50, 140)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(9, 85, 50, 140)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg%A_ScreenHeight%.png
		if(ErrorLevel){
			Send, {Esc}
		}
		Send, ^{w}
		Sleep, 200
		Gosub, downloadsPanel
		Gosub, isOnYt
		Gosub, actionOnYt
	Return
/*	
	~^r::
	~$F5::
		MouseGetPos, mouseX, mouseY
		resFix(9, 85, 50, 140)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}
		resFix(9, 85, 50, 140)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg%A_ScreenHeight%.png
		vivaldiFullError := ErrorLevel
		if(ErrorLevel){
			Send, {Esc}
		}
		while(vivaldiFullError){
			resFix(9, 85, 50, 140)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg%A_ScreenHeight%.png
			vivaldiFullError := ErrorLevel
		}
		MouseMove, %mouseX%, %mouseY%, 0

		Gosub, downloadsPanel
		Sleep, 500
		Gosub, loadingPage
		Sleep, 500
		Gosub, isOnYt
		resFix(80, 10, 80, 15)
		PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x2E2F37, 20, Fast RGB
		firstTab := ErrorLevel

		if((!ytUrl1 || !ytUrl2) && !firstTab){
			MouseGetPos, mouseX, mouseY
			resFix(60, 360, 250, 410)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}

			resFix(0, 300, 250, 500)
;			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTHistory%A_ScreenHeight%.png
;			if(!ErrorLevel){
;				resFix(90, 160)
;				ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 ; left icons
;			}
			MouseMove, %mouseX%, %mouseY%, 0
		}
		if((!(!ytUrl1 || !ytUrl2)) && !firstTab){
			Sleep, 500
			Gosub, isOnYt

			if((!(!ytUrl1 || !ytUrl2)) && !firstTab){
				Send, ^{l}
				Sleep, 50
				Send, youtube.com
				Send, {Enter}
				sleepTime(500)
				Gosub, loadingPage
				Sleep, 1600
				Gosub, isOnYt
				Gosub, actionOnYt
			}
		}
	Return
*/
lbActions:
	resFix(500, 100)
	PixelGetColor, colorVar, %xValue0%, %yValue0%, Fast RGB
	if(colorVar = 0x404076){
		Return
	}
	MouseGetPos, mouseX, mouseY
	if(A_ScreenHeight = "1080"){
		if((mouseX > 133 && mouseY > 145 && mouseX < 222 && mouseY < 168) ; YT logo
		|| (mouseX > 94 && mouseY > 47 && mouseX < 136 && mouseY < 87) ; Reload page 
		|| (mouseX > 1844 && mouseY > 47 && mouseX < 1886 && mouseY < 87) ;Reload all pages 
		|| (mouseX > 52 && mouseY > 9 && mouseX < 88 && mouseY < 46)){ ; First tab (YT)
			if(mouseX > 94 && mouseY > 47 && mouseX < 136 && mouseY < 87){
				MouseMove, 1000, 600, 0 ; Center of the page
			}else if(mouseX > 1844 && mouseY > 47 && mouseX < 1886 && mouseY < 87){
				Send, ^{r}
			}
			Gosub, downloadsPanel
			Sleep, 500
		;	Gosub, loadingPage
			Gosub, isOnYt
			Gosub, actionOnYt
		}
	}else if(A_ScreenHeight = "768"){
		if((mouseX > 108 && mouseY > 116 && mouseX < 188 && mouseY < 132) ; YT logo
		|| (mouseX > 76 && mouseY > 38 && mouseX < 109 && mouseY < 70) ; Reload page
		|| (mouseX > 1306 && mouseY > 38 && mouseX < 1339 && mouseY < 70) ;Reload all pages
		|| (mouseX > 42 && mouseY > 8 && mouseX < 71 && mouseY < 37)){ ; First tab (YT)
			if(mouseX > 76 && mouseY > 38 && mouseX < 109 && mouseY < 70){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}else if(mouseX > 1306 && mouseY > 38 && mouseX < 1339 && mouseY < 70){
				Send, ^{r}
			}
			Gosub, downloadsPanel
			Sleep, 500
		;	Gosub, loadingPage
			Gosub, isOnYt
			Gosub, actionOnYt
		}
	}
Return
	~LButton::
		KeyWait, LButton
		Gosub, lbActions
	Return

	$F1::
	$F2::
	$F3::
		WinGet, window, MinMax
		if(window = 1){
			resFix(1270, 340)
			PixelGetColor, searchBar, %xValue0%, %yValue0%, Fast RGB
			if(searchBar != "0x2B2B2B" || searchBar != "0x2B2C34"){
				Send, {Esc}
				Send, {F1}
				Input, searchWord, I V E, {Enter}{Esc}{LButton}{F1}{F2}{F3}
			}else{
				Send, {F1}
			}
		}else{
			Send, {F1}
		}

		if(searchWord = "i" && ErrorLevel = "EndKey:Enter"){
			KeyWait, Enter
			WinWaitActive, Instagram - Vivaldi, , 2
			Gosub, loadingPage

			DllCall("ShowCursor", Int,0)
			MouseGetPos, mouseX, mouseY
			resFix(460, 270, 650, 330)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}
			resFix(460, 270, 650, 330)
			PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xFFFFFF, 20, Fast RGB
			loadingInsta := ErrorLevel
			while(loadingInsta){
				ToolTip, loading
				resFix(460, 270, 650, 330)
				if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
					resFix(1000, 600)
					MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
				}
				resFix(460, 270, 650, 330)
				PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xFFFFFF, 20, Fast RGB
				loadingInsta := ErrorLevel
			}
			ToolTip, 
			DllCall("ShowCursor", Int,1)

			resFix(456, 220, 566, 349)
			PixelSearch, storiesDetectedX, storiesDetectedY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xD72B7D, 20, Fast RGB
			if(!ErrorLevel){
				ControlClick, x%storiesDetectedX% y%storiesDetectedY%, ahk_exe vivaldi.exe, , Left, 1
			}
		}else if(searchWord = "f" && ErrorLevel = "EndKey:Enter"){
			KeyWait, Enter
			Sleep, 500
			Gosub, loadingPage
			Sleep, 800
			resFix(1820, 120, 1840, 160)
			PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xF02849, 20, Fast RGB
			if(!ErrorLevel){
				resFix(1810, 160)
				ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1
			}
		}
	Return

	$!d::
		MouseGetPos, mouseX, mouseY
		resFix(200, 200)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(200, 200)
		ImageSearch, , , 0, 0, %xValue0%, %yValue0%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiDownloads%A_ScreenHeight%.png
		if(!ErrorLevel){
			resFix(750, 250)
			ImageSearch, VivaldiRemoveDownloadsX, VivaldiRemoveDownloadsY, 0, 0, %xValue0%, %yValue0%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRemoveDownloads%A_ScreenHeight%.png
			ControlClick, x%VivaldiRemoveDownloadsX% y%VivaldiRemoveDownloadsY%, ahk_exe vivaldi.exe, , Left, 1
			Send, ^{j}
		}else{
			Send, ^{j}
		}
	Return

	~$^g::
		resFix(1300, 230)
		MouseMove, %xValue0%, %yValue0%, 0
	Return

	$^Enter::
		Send, .com
		Send, {Enter}
	Return

	$XButton1::
		Send, {LControl Down}
		KeyWait, XButton1
		Send, {LControl Up}
	Return
	$XButton2::
		Send, {Right Down}
		KeyWait, XButton2
		Send, {Right Up}
	Return

	$Joy5::
		if(!(GetKeyState("Joy7", "P")) && !(GetKeyState("Joy8")))
			Send, ^{F1}
		KeyWait, Joy5
	Return
	$Joy6::
		if(!(GetKeyState("Joy7", "P")) && !(GetKeyState("Joy8")))
			Send, ^{F2}
		KeyWait, Joy6
	Return


#IfWinActive, ahk_exe MusicBee.exe
	$^!Up::
	$^Up::
		Send, ^+{Up}
	Return
	$^!Down::
	$^Down::
		Send, ^+{Down}
	Return

	$!F4::
	$#Down::
		WinMinimize, ahk_exe MusicBee.exe
	Return

	$Down::
		Send, #{Up}
		MouseGetPos, mouseX, mouseY
		if(mouseX > 400 && mouseY > 0 && mouseX < 600 && mouseY < 100)
			MouseMove, 1000, 600, 0 ; Center of the page

		ImageSearch, , , 400, 0, 650, 100, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNowPlaying.png
		if(!ErrorLevel){
			MouseMove, 1460, 125, 0
			Send, {WheelDown}
		}else{
			Send, {WheelDown}
		}
	Return
	$s::
		if(A_CaretX = "" && A_CaretY = ""){	
			Send, #{Up}

			MouseGetPos, mouseX, mouseY
			if(mouseX > 400 && mouseY > 0 && mouseX < 600 && mouseY < 100)
				MouseMove, 1000, 600, 0 ; Center of the page

			ImageSearch, , , 400, 0, 650, 100, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNowPlaying.png
			if(!ErrorLevel){
				MouseMove, 1460, 125, 0
				Send, {WheelDown}
			}
		}else{
			Send, {s}
		}
	Return
	
	$Up::
		Send, #{Up}

		MouseGetPos, mouseX, mouseY
		if(mouseX > 400 && mouseY > 0 && mouseX < 600 && mouseY < 100)
			MouseMove, 1000, 600, 0 ; Center of the page

		ImageSearch, , , 400, 0, 650, 100, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNowPlaying.png
		if(!ErrorLevel){
			MouseMove, 1460, 125, 0
			Send, {WheelUp}
		}else{
			Send, {WheelUp}
		}
	Return
	$w::
		if(A_CaretX = "" && A_CaretY = ""){	
			Send, #{Up}

			MouseGetPos, mouseX, mouseY
			if(mouseX > 400 && mouseY > 0 && mouseX < 600 && mouseY < 0)
				MouseMove, 1000, 600, 0 ; Center of the page

			ImageSearch, , , 400, 0, 650, 100, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNowPlaying.png
			if(!ErrorLevel){
				MouseMove, 1460, 125, 0
				Send, {WheelUp}
			}
		}else{
			Send, {w}
		}
	Return

	$>!b::
	$<^>!b::
		ImageSearch, , , 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBPlaylists%A_ScreenHeight%.png
		if(ErrorLevel){
			resFix(410, 60)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
			Sleep 50
		}else{
			resFix(280, 60)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
			resFix(410, 60)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
		}

		MouseGetPos, mouseX, mouseY
		resFix(220, 120)
		MouseClick, Left, %xValue0%, %yValue0%, 2, 0 ; Classical
		Sleep 50
		MouseMove, %mouseX%, %mouseY%, 0
	Return
	$>!n::
	$<^>!n::
		ImageSearch, , , 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBPlaylists%A_ScreenHeight%.png
		if(ErrorLevel){
			resFix(410, 60)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
			Sleep 50
		}else{
			resFix(280, 60)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
			resFix(410, 60)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
		}

		MouseGetPos, mouseX, mouseY
		ImageSearch, MBnotClassicalX, MBnotClassicalY, 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNotClassical%A_ScreenHeight%.png
		MouseClick, Left, %MBnotClassicalX%, %MBnotClassicalY%, 2, 0 ; Not Classical
		Sleep 50
		MouseMove, %mouseX%, %mouseY%, 0
	Return

	$Esc::
		MouseClick, Left, 1700, 120, 1, 0
	Return

	$^1:: ControlClick, x150 y60, ahk_exe MusicBee.exe, , Left, 1
	$^2:: ControlClick, x280 y60, ahk_exe MusicBee.exe, , Left, 1
	$^3:: ControlClick, x410 y60, ahk_exe MusicBee.exe, , Left, 1
	$^4:: ControlClick, x540 y60, ahk_exe MusicBee.exe, , Left, 1

#IfWinActive, ahk_exe WhatsApp.exe
	$Down::
		Send, {WheelDown}
	Return
	$Up::
		Send, {WheelUp}
	Return

	$>!,::
	$<^>!,::
		WinGet, window, MinMax
		if(window != 1){
			Send, #{Up}
		}
		
		;if(!ProcessExist("WhatsappTray.exe")){
		if(!ProcessExist("Whatsapp.exe")){
			while(ProcessExist("WhatsApp.exe")){
				Process, Close, WhatsApp.exe
			}
			;Run, "D:\Program Files (x86)\WhatsappTray\WhatsappTray.exe"
			Run, C:\Users\Bruno\AppData\Local\WhatsApp\WhatsApp.exe
		}

		PixelGetColor, whatsappColor, 120, 20, Fast RGB
		if(whatsappColor != "0x00BFA5"){
			;Process, Close, WhatsappTray.exe
			;Process, WaitClose, WhatsappTray.exe
			Process, Close, Whatsapp.exe
			Process, WaitClose, Whatsapp.exe


			while(ProcessExist("WhatsApp.exe")){
				Process, Close, WhatsApp.exe
			}

			;Run, "D:\Program Files (x86)\WhatsappTray\WhatsappTray.exe"
			Run, C:\Users\Bruno\AppData\Local\WhatsApp\WhatsApp.exe
		}
		
		PixelSearch, , , 418, 68, 429, 79, 0x09D261, 20, Fast RGB
		if(!ErrorLevel){
			ControlClick, x418 y68, ahk_exe WhatsApp.exe, , Left, 1
			MouseMove, 300, 300, 0
		}else{
			MouseGetPos, mouseX, mouseY
			if(mouseX > 1790 && mouseY > 90 && mouseX < 1820 && mouseY < 120)
				MouseMove, 1000, 600, 0 ; Center of the page

			ImageSearch, , , 1790, 90, 1820, 120, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WhatsAppClose.png
			if(!ErrorLevel){
				Send, {Esc}
			}
			WinClose, ahk_exe WhatsApp.exe
			if(mpcWindow){
				WinActivate, ahk_exe mpc-hc64.exe
				WinWaitActive, ahk_exe mpc-hc64.exe, , 1
				Send, {f}
			}
			if(vivaldiWindow){
				WinActivate, ahk_exe vivaldi.exe
				WinWaitActive, ahk_exe vivaldi.exe, , 1
				Send, {f}
			}
		}
		vivaldiWindow := 0
		mpcWindow := 0
	Return

	$#Down::
		WinClose, ahk_exe WhatsApp.exe
	Return

#IfWinActive, ahk_exe witcher3.exe
	$NumpadEnd::
	$Numpad1::1
	Return

	$NumpadDown::
	$Numpad2::2
	Return

	$NumpadPgdn::
	$Numpad3::3
	Return

	$NumpadLeft::
	$Numpad4::4
	Return

	$NumpadClear::
	$Numpad5::5
	Return

	$NumpadRight::
	$Numpad6::6
	Return

	$NumpadHome::
	$Numpad7::7
	Return

	$NumpadUp::
	$Numpad8::8
	Return

	$NumpadPgup::
	$Numpad9::9
	Return

	$XButton1::F5
	
	$XButton2::
		Send, {i Down}
		Sleep, 100
		Send, {i Up}
	Return

	$^XButton2::
		Send, {j Down}
		Sleep, 100
		Send, {j Up}
	Return

	$+XButton2::
		Send, {m Down}
		Sleep, 100
		Send, {m Up}
	Return

#If (WinActive("ahk_exe Explorer.EXE") && WinActive("ahk_class Shell_TrayWnd")) || WinActive("ahk_exe SearchApp.exe") || WinActive("ahk_exe StartMenuExperienceHost.exe") || WinActive("ahk_exe ApplicationFrameHost.exe") || WinActive("ahk_exe ShellExperienceHost.exe")
	Joy5::
		if((MouseIsOver("ahk_exe Explorer.EXE") && MouseIsOver("ahk_class Shell_TrayWnd")) || MouseIsOver("ahk_exe SearchApp.exe") || MouseIsOver("ahk_exe StartMenuExperienceHost.exe") || MouseIsOver("ahk_exe ApplicationFrameHost.exe") || MouseIsOver("ahk_exe ShellExperienceHost.exe"))
			Send, {LButton}
	Return
	Joy6::
		if((MouseIsOver("ahk_exe Explorer.EXE") && MouseIsOver("ahk_class Shell_TrayWnd")) || MouseIsOver("ahk_exe SearchApp.exe") || MouseIsOver("ahk_exe StartMenuExperienceHost.exe") || MouseIsOver("ahk_exe ApplicationFrameHost.exe") || MouseIsOver("ahk_exe ShellExperienceHost.exe"))
			Send, {RButton}
	Return
Return





;	Hotkeys 		Function
;	AltGr+c 		Class Mode (English)
;	AltGr+e			Exit Class mode
;	AltGr+f 		Fatec Mode
;	AltGr+g 		Game mode
;	AltGr+h 		Hibernate Computer
;	AltGr+l 		Turn on || off the light
;	AltGr+m 		Open MusicBee
;	AltGr+r 		Start recording with OBS
; 	Alt+w 			Stop Wallpaper Engine
;	AltGr+,			Open WhatsApp

;	Numpad0 || 0	Disable 0 if it's in a video
;	F1 || F2 || F3	Suspend for Vivaldi search

;	AltGr+i 		Shortcuts list