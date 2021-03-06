#SingleInstance force
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

;SetTimer, checkKDE, 10000
;SetTimer, reopenKDE, 1800000 ; 30mins

gotActivated := 0
SetTimer, programRoutine, 300

joystickSwitch := 0
SetTimer, WatchPOVandStick, 20

resChange := 0

; Sound output
outputChange := 0 

; Joystic as mouse
JoyMultiplier = 0.30 
JoyThreshold = 0
InvertYAxis := false
ButtonLeft = 1
ButtonRight = 2
ButtonMiddle = 3
WheelDelay = 250
JoystickNumber = 1

JoystickPrefix = %JoystickNumber%Joy
Hotkey, %JoystickPrefix%%ButtonLeft%, ButtonLeft
Hotkey, %JoystickPrefix%%ButtonRight%, ButtonRight
Hotkey, %JoystickPrefix%%ButtonMiddle%, ButtonMiddle

; Calculate the axis displacements that are needed to start moving the cursor:
JoyThresholdUpper := 50 + JoyThreshold
JoyThresholdLower := 50 - JoyThreshold
if InvertYAxis
	YAxisMultiplier = -1
else
	YAxisMultiplier = 1

SetTimer, WatchJoystick, 10  ; Monitor the movement of the joystick.
SetTimer, joyButtons, 10

GetKeyState, JoyInfo, %JoystickNumber%JoyInfo
IfInString, JoyInfo, P  ; Joystick has POV control, so use it as a mouse wheel.
	SetTimer, MouseWheel, %WheelDelay%
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
Send, {?? up}         
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

startTime := A_TickCount
ToolTip, Shortcuts reloaded.
Process, Exist 
hwnd := WinExist("ahk_class tooltips_class32 ahk_pid " ErrorLevel) 
WinGetPos,,,w,h,ahk_id %hwnd%
While (DllCall("MoveWindow","Uptr",hwnd,"Int",x+20,"Int",y-10,"Int",w,"Int",h,"Int",0) && runTime <= 1000){
	MouseGetPos, x, y
	runTime := A_TickCount - startTime
}

ToolTip, 
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
			resFix(62, 75, 142, 249) ; mouseX > 62 && mouseY > 75 && mouseX < 142 && mouseY < 249
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}

			resFix(62, 75, 142, 249)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsMute.png
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
			resFix(62, 75, 142, 249)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}

			resFix(62, 75, 142, 249)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsMute.png
			if(!ErrorLevel){
				Send, {Volume_Mute}		
			}
		}

		prevValue := headphones
	}

	SetTimer, checkHeadphones, On
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

programRoutine:
	SetTimer, programRoutine, Off

	WinGetTitle, winTitle, A

	if(WinExist("Games") || WinExist("Resolution") || WinExist("Yes || No") || WinExist("Emulators")){
		SetTimer, WatchJoystick, Off
		SetTimer, MouseWheel, Off
		SetTimer, joyButtons, Off

		WinActivate, Games
		WinActivate, Resolution
		WinActivate, Yes || No
		WinActivate, Emulators
	}else if InStr(winTitle, "Stories", CaseSensitive := false) and InStr(winTitle, "Instagram", CaseSensitive := false){
		resFix(1100, 150, 1200, 250)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\InstaMuted.png
		if(!ErrorLevel){
			resFix(1150, 195)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1
		}
		Sleep, 300 ; Make it scan less 
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
	ControlSetText, Button2, &EGS
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

WatchPOVandStick:
	if(WinActive("Games") || WinActive("Resolution") || WinActive("Yes || No") || WinActive("Emulators")){
		joystickSwitch := !joystickSwitch

		if(joystickSwitch){		
		    POV := GetKeyState("JoyPOV")  ; Get position of the POV control.
		    KeyToHoldDownPrevPOV := KeyToHoldDownPOV  ; Prev now holds the key that was down before (if any).

		    ; Some joysticks might have a smooth/continous POV rather than one in fixed increments.
		    ; To support them all, use a range:
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

		    if (KeyToHoldDownPOV = KeyToHoldDownPrevPOV)  ; The correct key is already down (or no key is needed).
		        return  ; Do nothing.

		    ; Otherwise, release the previous key and press down the new key:
		    SetKeyDelay -1  ; Avoid delays between keystrokes.
		    if KeyToHoldDownPrevPOV   ; There is a previous key to release.
		        Send, {%KeyToHoldDownPrevPOV% up}  ; Release it.
		    if KeyToHoldDownPOV   ; There is a key to press down.
		        Send, {%KeyToHoldDownPOV% down}  ; Press it down.
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
return

ButtonLeft:
	SetMouseDelay, -1  ; Makes movement smoother.
	MouseClick, left,,, 1, 0, D  ; Hold down the left mouse button.
	SetTimer, WaitForLeftButtonUp, 10
return
ButtonRight:
	SetMouseDelay, -1  ; Makes movement smoother.
	MouseClick, right,,, 1, 0, D  ; Hold down the right mouse button.
	SetTimer, WaitForRightButtonUp, 10
return
ButtonMiddle:
	SetMouseDelay, -1  ; Makes movement smoother.
	MouseClick, middle,,, 1, 0, D  ; Hold down the right mouse button.
	SetTimer, WaitForMiddleButtonUp, 10
return
WaitForLeftButtonUp:
	if GetKeyState(JoystickPrefix . ButtonLeft)
		return  ; The button is still, down, so keep waiting.
	; Otherwise, the button has been released.
	SetTimer, WaitForLeftButtonUp, Off
	SetMouseDelay, -1  ; Makes movement smoother.
	MouseClick, left,,, 1, 0, U  ; Release the mouse button.
return
WaitForRightButtonUp:
	if GetKeyState(JoystickPrefix . ButtonRight)
		return  ; The button is still, down, so keep waiting.
	; Otherwise, the button has been released.
	SetTimer, WaitForRightButtonUp, Off
	MouseClick, right,,, 1, 0, U  ; Release the mouse button.
return
WaitForMiddleButtonUp:
	if GetKeyState(JoystickPrefix . ButtonMiddle)
		return  ; The button is still, down, so keep waiting.
	; Otherwise, the button has been released.
	SetTimer, WaitForMiddleButtonUp, Off
	MouseClick, middle,,, 1, 0, U  ; Release the mouse button.
return
WatchJoystick:
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
return
MouseWheel:
	GetKeyState, JoyPOV, %JoystickNumber%JoyPOV
	if JoyPOV = -1  ; No angle.
		return
	if (JoyPOV > 31500 or JoyPOV < 4500)  ; Forward
		Send {WheelUp}
	else if JoyPOV between 13500 and 22500  ; Back
		Send {WheelDown}
return
joyButtons:
	SetTimer, joyButtons, Off
	if GetKeyState("Joy1", "P"){
		Send, {LButton Down}
		KeyWait, Joy1
		Send, {LButton Up}
	}
	if GetKeyState("Joy3", "P"){
		Send, ^{LButton Down}
		Send, ^{LButton Up}
		KeyWait, Joy3
	}
	if GetKeyState("Joy2", "P"){
		Send, {RButton Down}
		KeyWait, Joy2
		Send, {RButton Up}
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
			resFix(1121, 1057, 1900, 1079)
			PixelSearch, obsX, obsY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xFF0000, 20, Fast RGB
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
		if(!ProcessExist("NVIDIA RTX Voice.exe")){
			Run, "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe", C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice, Hide
		}
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

; Game mode
VK07::
	KeyWait, VK07
	KeyWait, Joy1, D T0.5
	if(!ErrorLevel){
		joysticAsMouseSwitch := !joysticAsMouseSwitch
		if(joysticAsMouseSwitch){
			SetTimer, WatchJoystick, On  ; Monitor the movement of the joystick
			GetKeyState, JoyInfo, %JoystickNumber%JoyInfo
			IfInString, JoyInfo, P  ; Joystick has POV control, so use it as a mouse wheel.
				SetTimer, MouseWheel, On
			SetTimer, joyButtons, On
		}else{
			SetTimer, WatchJoystick, Off
			SetTimer, MouseWheel, Off
			SetTimer, joyButtons, Off
		}
	}else{
		Suspend, Off
		Gui, Destroy
		Gui +AlwaysOnTop -0x30000
		Gui, Add, DropDownList, vGameChoice Choose1, General|Rocket League|Emulation|Close
		Gui, Add, Button, gGameChoose, Choose
		Gui, Show, , Games
	}
Return
$>!g::
$<^>!g::
	Suspend, Off
	Gui, Destroy
	Gui +AlwaysOnTop -0x30000
	Gui, Add, DropDownList, vGameChoice Choose1, General|Rocket League|Emulation|Close
	Gui, Add, Button, gGameChoose, Choose
	Gui, Show, , Games
Return
GameChoose:
	Gui, Submit

	if(GameChoice = "General"){
		Send, ^{F23}
		Sleep, 50
		Gui, Destroy
		
		Run, steam://rungameid/14209988591219638272 ; GOG 2.0

		SetTimer, resolution, 50
		MsgBox, 0x1003, Resolution, Which resolution?
		IfMsgBox, Yes
		{
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\768p.bat"
			resChange := 1
		}
		IfMsgBox, No
		{
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"
			resChange := 1
		}

		Process, Exist, vivaldi.exe
		vivaldiPID=%Errorlevel%
		if(vivaldiPID){
			WinActivate ahk_pid %vivaldiPID%
			WinWaitActive, ahk_exe vivaldi.exe, , 1.5
			Send, !{F4}
		}
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
		MsgBox, 0x1001, Yes || No, Do you want to open Discord and RTX Voice?
		IfMsgBox, OK
		{
			Run, "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe", C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice, Hide
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Discord.bat"
			runDiscord := 1
		}
		
		if(runDiscord){
			WinWait, ahk_class RTXVoiceWindowClass
			Sleep, 200
			WinActivate, ahk_class RTXVoiceWindowClass
			WinWaitActive, ahk_class RTXVoiceWindowClass, , 1.5
			Send, !{F4}				
			runDiscord := 0
		}

	Gui, Destroy
	}

	if(GameChoice = "Rocket League"){
		Send, ^{F23}
		Sleep, 50
		Process, Exist, vivaldi.exe
		vivaldiPID=%Errorlevel%
		if(vivaldiPID){
			WinActivate ahk_pid %vivaldiPID%
			WinWaitActive, ahk_exe vivaldi.exe, , 1.5
			Send, !{F4}
		}
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
		Run, steam://rungameid/15475259589817008128	; Epic Games Launcher
		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"

		SetTimer, yesNo, 50
		MsgBox, 0x1001, Yes || No, Do you want to open Discord and RTX Voice?
		IfMsgBox, OK
		{
			Run, "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe", C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice, Hide
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Discord.bat"
		}

		WinWait, ahk_class UnrealWindow
		Sleep, 200
		WinActivate, ahk_class UnrealWindow
		WinWaitActive, ahk_class UnrealWindow, , 1.5
		Sleep, 50
		Send, #{Up Down}
		Sleep, 50
		Send, #{Up Up}
		WinActivate, ahk_class UnrealWindow
		WinWaitActive, ahk_class UnrealWindow, , 1.5
		Sleep, 500
		resFix(9, 9, 300, 1000)
		PixelSearch, gameX, gameY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xF5F5F5, 20, Fast RGB
		detected := !ErrorLevel
		while(detected = 0){
			WinActivate, ahk_class UnrealWindow
			WinWaitActive, ahk_class UnrealWindow, , 1.5
			resFix(9, 9, 300, 1000)
			PixelSearch, gameX, gameY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xF5F5F5, 20, Fast RGB
			detected := !ErrorLevel
		}
		Sleep, 200
		resFix(120, 270)
		MouseClick, Left, %xValue0%, %yValue0%, 1, 0 ; Click Library
		
		WinActivate, ahk_class UnrealWindow
		WinWaitActive, ahk_class UnrealWindow, , 1.5
		Sleep 200
		WinActivate, ahk_class UnrealWindow
		WinWaitActive, ahk_class UnrealWindow, , 1.5
		resFix(370, 150, 580, 435)
		PixelSearch, gameX, gameY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x2D6DDD, 20, Fast RGB
		detected := !ErrorLevel
		while(detected = 0){
			WinActivate, ahk_class UnrealWindow
			WinWaitActive, ahk_class UnrealWindow, , 1.5
			resFix(370, 150, 580, 435)
			PixelSearch, gameX, gameY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x2D6DDD, 20, Fast RGB
			detected := !ErrorLevel
		}
		Sleep, 200
		resFix(360, 410)
		MouseClick, Left, %xValue0%, %yValue0%, 1, 0
	Gui, Destroy
	}

	if(GameChoice = "Close"){
		Send, ^{F23}
		Sleep, 50

		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\1080p.bat"
		if(!ProcessExist("vivaldi.exe")){
			Run, "D:\Program Files\Vivaldi\Application\vivaldi.exe"
		}
		if(!ProcessExist("WhatsApp.exe")){
			Run, C:\Users\Bruno\AppData\Local\WhatsApp\WhatsApp.exe
		}
		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Restart explorer.bat"

		Process, Close, NVIDIA RTX Voice.exe
		Process, Close, GalaxyClient.exe
;		Process, Close, EpicGamesLauncher.exe
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

		if(resChange){
			Sleep, 5000
			Reload
		}
	Gui, Destroy
	}

	if(GameChoice = "Emulation"){
		Send, ^{F23}
		Sleep, 50
		
		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"
		Process, Exist, vivaldi.exe
		vivaldiPID=%Errorlevel%
		if(vivaldiPID){
			WinActivate ahk_pid %vivaldiPID%
			WinWaitActive, ahk_exe vivaldi.exe, , 1.5
			Send, !{F4}
		}
	;	Process, Close, WhatsApp.exe
		Process, Close, AoTClock.exe

		Gui, Destroy
		Gui +AlwaysOnTop -0x30000
		Gui, Add, DropDownList, vEmuChoice Choose1, RetroArch|Citra|Cemu|Close
		Gui, Add, Button, gEmuChoose, Choose
		Gui, Show, , Emulators
	}
Return
EmuChoose:
	Gui, Submit
	if(EmuChoice = "RetroArch"){
		Run, "D:\Users\Bruno\AppData\Roaming\RetroArch\retroarch.exe"
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
$>!l::
$<^>!l::
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

	resFix(1450, 1042, 1700, 1080)
	ImageSearch, musicBeeX, musicBeeY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBLogo.png
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
	resFix(200, 0, 500, 100)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBPlaylists.png
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
$>!m::
$<^>!m::
	Gosub, musicBee
Return
$>!n::
$<^>!n::
	Gosub, musicBee

	Sleep, 200
	resFix(200, 0, 500, 100)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBPlaylists.png
	if(ErrorLevel){
		resFix(410, 60)
		ControlClick, x410 y60, ahk_exe MusicBee.exe, , Left, 1
	}else{
		resFix(280, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
		resFix(280, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
	}

	MouseGetPos, mouseX, mouseY
	resFix(220, 140)
	MouseClick, Left, %xValue0%, %yValue0%, 2, 0 ; Not Classical
	MouseMove, %mouseX%, %mouseY%, 0
Return

; Start || stop recording
$>!r::
$<^>!r::
	Suspend, Off
	if(ProcessExist("obs64.exe")){
		Send, #{b}
		Sleep, 50
		resFix(1121, 1057, 1900, 1079)
		PixelSearch, obsX, obsY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xFF0000, 20, Fast RGB
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
		resFix(40, 40)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(40, 40)
		ImageSearch, , , 0, 0, %xValue0%, %yValue0%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\mpcLogo.png
		if(ErrorLevel){
			Send, {f}
			mpcWindow := 1
		}

		MouseMove, %mouseX%, %mouseY%, 0
	}else if(WinActive("ahk_exe vivaldi.exe")){
		MouseGetPos, mouseX, mouseY
		resFix(9, 85, 50, 120)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(9, 85, 50, 120)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
		if(ErrorLevel){
			Send, {f}
			vivaldiWindow := 1
		}
		MouseMove, %mouseX%, %mouseY%, 0
	}

	if(!ProcessExist("WhatsappTray.exe")){
		while(ProcessExist("WhatsApp.exe")){
			Process, Close, WhatsApp.exe
		}
		Run, "D:\Program Files (x86)\WhatsappTray\WhatsappTray.exe"
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
$>+/::
$>+;::
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
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *120 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniSession.png ; Detects if it's already on the page
	if(ErrorLevel){
		MouseGetPos, mouseX, mouseY

		resFix(1400, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(1400, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *120 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniExtension.png ; Detects if the extension is open
		waniKaniError := ErrorLevel
		if(waniKaniError){
			resFix(1820, 70)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1
			Sleep, 10

			varTime := 1000
			Sleep, %varTime%

			resFix(1400, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *120 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniExtension.png ; Detects if the extension is open
			waniKaniError := ErrorLevel
		}
		while(waniKaniError){
			resFix(1820, 70)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1
			varTime := varTime + 100
			Sleep, %varTime%

			MouseGetPos, mouseX, mouseY
			resFix(1400, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}
			
			resFix(1400, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *120 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniExtension.png ; Detects if the extension is open
			waniKaniError := ErrorLevel
		}

		resFix(1452, 228, 1824, 313)
		PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xF100A1, 20, Fast RGB  ; Lesson
		waniKaniLesson := ErrorLevel
		if(!waniKaniLesson){
			Send, {Esc}
			Sleep, 10
			Run, https://www.wanikani.com/lesson/session

			waniKaniReview := 1
		}else{
			resFix(1452, 228, 1824, 313)
			PixelSearch, waniX, waniY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x00AAFF, 20, Fast RGB ; Review
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

$F1::
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

	Send, {F1}
Return

F12::
	WinGetActiveTitle, activeWindow
	Send, #{m}
	Run, C:\Program Files\FxSound LLC\FxSound\FxSound.exe
	WinActivate, ahk_exe FxSound.exe
	WinWaitActive, ahk_exe FxSound.exe
	Sleep, 600

	CoordMode, Mouse, Screen
	MouseGetPos, mouseX, mouseY
	resFix(600, 80, 1100, 200) ; (mouseX > 600 && mouseY > 80 && mouseX < 1100 && mouseY < 200)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%
	}

	CoordMode, Mouse, Relative
	resFix(600, 80, 1100, 200) ; (mouseX > 600 && mouseY > 80 && mouseX < 1100 && mouseY < 200)
	WinActivate, ahk_exe FxSound.exe
	WinWaitActive, ahk_exe FxSound.exe 
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\FxSoundRealtek%A_ScreenHeight%.png
	if(!ErrorLevel){ ; Output is Laptop
		SoundSet, %lowVol%, MASTER
		resFix(800, 130)
		MouseClick, Left, %xValue0%, %yValue0%, 1, 0
		sleepTime(300)
		resFix(800, 180)
		MouseMove, %xValue0%, %yValue0%
		Sleep, 2000
		MouseClick, Left, %xValue0%, %yValue0%, 1, 0
	}else{ ; Output is TV
		SoundSet, %highVol%, MASTER
		resFix(800, 130)
		MouseClick, Left, %xValue0%, %yValue0%, 1, 0
		sleepTime(300)
		resFix(800, 230)
		MouseMove, %xValue0%, %yValue0%
		Sleep, 2000
		MouseClick, Left, %xValue0%, %yValue0%, 1, 0
	}
	sleepTime(300)
	CoordMode, Mouse, Screen
	CoordMode, Pixel, Screen
	resFix(1930, 1080)
	ImageSearch, fxCloseX, fxCloseY, 0, 0, %xValue0%, %yValue0%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\FxSoundClose.png
	MouseMove, %fxCloseX%, %fxCloseY%
	resFix(8, 8)
	MouseClick, Left, % fxCloseX+%xValue0%, % fxCloseY+%xValue0%, 1, 0
	Sleep, 50

	MouseMove, %mouseX%, %mouseY%, 0
	CoordMode, Mouse, Relative
	CoordMode, Pixel, Relative
	WinActivate, %activeWindow%
Return

$<!Tab::
	if(WinActive("ahk_exe vivaldi.exe")){
		MouseGetPos, mouseX, mouseY
		resFix(9, 85, 50, 120)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(9, 85, 50, 120)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
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
	resFix(1670, 1042, 1716, 1079)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(1670, 1042, 1716, 1079)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\JapaneseIME.png
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
	Else
		{
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
	resFix(62, 75, 696, 249)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	Sleep, 100
	resFix(62, 75, 142, 249)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsMute.png
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

	CoordMode, Mouse, Screen

	MouseGetPos, mouseX, mouseY
	resFix(62, 75, 696, 249)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	CoordMode, Mouse, Relative
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

	CoordMode, Mouse, Screen

	MouseGetPos, mouseX, mouseY
	resFix(62, 75, 696, 249)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}
	
	CoordMode, Mouse, Relative
Return

~$Media_Next::
~$Media_Prev::
~$Media_Play_Pause::
~$Volume_Mute::
	CoordMode, Mouse, Screen
	MouseGetPos, mouseX, mouseY
	resFix(62, 75, 696, 249)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}
	CoordMode, Mouse, Relative
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
	resFix(1750, 890, 1910, 930)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(1750, 890, 1910, 930)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsNotifications1.png
	windowsNotifications1 := ErrorLevel
	resFix(1750, 890, 1910, 930)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsNotifications2.png
	windowsNotifications2 := ErrorLevel
	if(!windowsNotifications1 || !windowsNotifications2){
		MouseGetPos, mouseX, mouseY
		resFix(1830, 920)
		MouseClick, , %xValue0%, %yValue0%, 1, 0
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
		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\768p.bat"
	Return
	$9::
		WinClose, Resolution
		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"
	Return

	$Joy1::
		Send, {Enter}
	Return
	$Joy2::
	Esc::
	$1::
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

#IfWinActive, Games
	$Joy1::
	$Enter::
		Gosub, GameChoose
	Return
	$vk07::
	$Joy2::
	$Esc::
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
#IfWinActive, Lights
	$k::
		WinClose, Lights
		Run, D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Lights\Off.vbs
		MsgBox, 0x1000, Button pressed, Turning the light off., 1
	Return

expGetColor:
	selectedQA := 0
	resFix(30, 286)
	PixelGetColor, expColor, %xValue0%, %yValue0%, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 0 ; Recycle Bin
		selectedQA := 1
	}
	resFix(30, 316)
	PixelGetColor, expColor, %xValue0%, %yValue0%, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 1 ; Desktop
		selectedQA := 1
	}
	resFix(30, 346)
	PixelGetColor, expColor, %xValue0%, %yValue0%, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 2 ; This PC
		selectedQA := 1
	}
	resFix(30, 376)
	PixelGetColor, expColor, %xValue0%, %yValue0%, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 3 ; Downloads
		selectedQA := 1
	}
	resFix(30, 406)
	PixelGetColor, expColor, %xValue0%, %yValue0%, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 4 ; Sonarr
		selectedQA := 1
	}
	resFix(30, 436)
	PixelGetColor, expColor, %xValue0%, %yValue0%, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 5 ; Animes
		selectedQA := 1
	}
	resFix(30, 466)
	PixelGetColor, expColor, %xValue0%, %yValue0%, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 6 ; Documents
		selectedQA := 1
	}
	resFix(30, 496)
	PixelGetColor, expColor, %xValue0%, %yValue0%, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 7 ; Scripts
		selectedQA := 1
	}
	resFix(30, 526)
	PixelGetColor, expColor, %xValue0%, %yValue0%, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 8 ; Media
		selectedQA := 1
	}
	resFix(30, 556)
	PixelGetColor, expColor, %xValue0%, %yValue0%, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 9 ; Registro
		selectedQA := 1
	}
	if(selectedQA = 0){
		expCounter = 9
	}
Return
emptyDetection:
	MouseGetPos, mouseX, mouseY
	resFix(540, 250, 680, 310)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(540, 250, 680, 310)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExplorerEmpty.png
	if(ErrorLevel){	
		resFix(270, 280)
		MouseClick, Left, %xValue0%, %yValue0%, 1, 0
	}
	resFix(300, 300)
	MouseMove, %xValue0%, %yValue0%, 0
Return
expSelect:
	Switch expCounter
	{
		case 0:
			resFix(110, 290)
			MouseClick, Left, %xValue0%, %yValue0%, 1, 0
		case 1:
			resFix(110, 320)
			MouseClick, Left, %xValue0%, %yValue0%, 1, 0
		case 2:
			resFix(110, 350)
			MouseClick, Left, %xValue0%, %yValue0%, 1, 0
		case 3:
			resFix(110, 380)
			MouseClick, Left, %xValue0%, %yValue0%, 1, 0
		case 4:
			resFix(110, 410)
			MouseClick, Left, %xValue0%, %yValue0%, 1, 0
		case 5:
			resFix(110, 440)
			MouseClick, Left, %xValue0%, %yValue0%, 1, 0
		case 6:
			resFix(110, 470)
			MouseClick, Left, %xValue0%, %yValue0%, 1, 0
		case 7:
			resFix(110, 500)
			MouseClick, Left, %xValue0%, %yValue0%, 1, 0
		case 8:
			resFix(110, 530)
			MouseClick, Left, %xValue0%, %yValue0%, 1, 0
		case 9:
			resFix(110, 560)
			MouseClick, Left, %xValue0%, %yValue0%, 1, 0
	}
	resFix(300, 300)
	MouseMove, %xValue0%, %yValue0%, 0
Return
#IfWinActive, ahk_exe explorer.exe
	$^Tab::
		Send, ^#{2}
	Return

	~$F2::
	Return

	$1::
		if(A_CaretX = "" && A_CaretY = ""){
			Gosub, expGetColor
			if(expCounter <= 9 && expCounter > 0){
				expCounter--
			}else{
				expCounter := 9
			}

			Gosub, expSelect
			sleepTime(150)

			while(GetKeyState("1", "P")){
				if(expCounter <= 9 && expCounter > 0){
					expCounter--
				}else{
					expCounter := 9
				}

				Gosub, expSelect

				sleepTime(150)
			}

			SetTimer, emptyDetection, -100
		}else{
			Send, {1}
		}
	Return

	$2::
		if(A_CaretX = "" && A_CaretY = ""){	
			Gosub, expGetColor
			if(expCounter < 9 && expCounter >= 0){
				expCounter++
			}else{
				expCounter := 0
			}

			Gosub, expSelect
			sleepTime(150)

			while(GetKeyState("2", "P")){
				if(expCounter < 9 && expCounter >= 0){
					expCounter++
				}else{
					expCounter := 0
				}

				Gosub, expSelect

				sleepTime(150)
			}
			
			SetTimer, emptyDetection, -100
		}else{
			Send, {2}
		}
	Return
	
	$^d::
		resFix(110, 380)
		ControlClick, x%xValue0% y%yValue0%, , , Left, 1
		Send, {Enter}
		Send, {Tab}
		MouseGetPos, mouseX, mouseY
		resFix(270, 280)
		MouseClick, Left, %xValue0%, %yValue0%, 1, 0
		MouseMove, %mouseX%, %mouseY%, 0
	Return
	$^s::
		resFix(110, 410)
		ControlClick, x%xValue0% y%yValue0%, , , Left, 1
		Send, {Enter}
		Send, {Tab}
		MouseGetPos, mouseX, mouseY
		resFix(270, 280)
		MouseClick, Left, %xValue0%, %yValue0%, 1, 0
		MouseMove, %mouseX%, %mouseY%, 0
	Return

	$^1::
		resFix(30, 286)
		PixelGetColor, expColor, %xValue0%, %yValue0%, Fast RGB
		if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
			MsgBox, 0x1001, Recycle Bin, Empty Recycle Bin?
			IfMsgBox, Ok
			{
				FileRecycleEmpty, 
			}
		}else{
			resFix(110, 290)
			ControlClick, x%xValue0% y%yValue0%, , , Left, 1
			Send, {Enter}
		}
	Return
	$^2::
		resFix(110, 320)
		ControlClick, x%xValue0% y%yValue0%, , , Left, 1
		Send, {Enter}
	Return
	$^3::
		resFix(110, 350)
		ControlClick, x%xValue0% y%yValue0%, , , Left, 1
		Send, {Enter}
	Return
	$^4::
		resFix(110, 380)
		ControlClick, x%xValue0% y%yValue0%, , , Left, 1 ; 3Downloads
		Send, {Enter}
	Return
	$^5::
		resFix(110, 410)
		ControlClick, x%xValue0% y%yValue0%, , , Left, 1 ; 4Sonarr
		Send, {Enter}
	Return
	$^6::
		resFix(110, 440)
		ControlClick, x%xValue0% y%yValue0%, , , Left, 1 ; 5Animes
		Send, {Enter}
	Return
	$^7::
		resFix(110, 470)
		ControlClick, x%xValue0% y%yValue0%, , , Left, 1
		Send, {Enter}
	Return
	$^8::
		resFix(110, 500)
		ControlClick, x%xValue0% y%yValue0%, , , Left, 1
		Send, {Enter}
	Return
	$^9::
		resFix(110, 530)
		ControlClick, x%xValue0% y%yValue0%, , , Left, 1
		Send, {Enter}
	Return
	$^0::
		resFix(110, 560)
		ControlClick, x%xValue0% y%yValue0%, , , Left, 1
		Send, {Enter}
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
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
	if(!ErrorLevel){
		resFix(30, 600)
		PixelGetColor, panelExist, %xValue0%, %yValue0%, Fast RGB
		if(!(panelExist = "0x282828" || panelExist = "0x1C1D49" || panelExist = "0x2E2F36")){
			Send, +{F4}
			Sleep, 400
		}

		MouseGetPos, mouseX, mouseY
		resFix(55, 130, 180, 180)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(55, 130, 180, 180)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiDownloads.png
		VivaldiDownloads := ErrorLevel
		resFix(55, 130, 180, 180)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiDownloads2.png
		VivaldiDownloads2 := ErrorLevel
		if(!VivaldiDownloads || !VivaldiDownloads2){
			Send, ^{j}
		}
	}
Return
loadingPage:
	MouseGetPos, mouseX, mouseY
	resFix(80, 40, 140, 90)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(80, 40, 140, 90)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiPageLoading.png
	pageLoading := ErrorLevel
	while(pageLoading = 0){
		MouseGetPos, mouseX, mouseY
		resFix(80, 40, 140, 90)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(80, 40, 140, 90)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiPageLoading.png
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
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *150 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\URLYT1.png
	ytUrl1 := ErrorLevel
	resFix(150, 30, 700, 90)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *150 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\URLYT2.png
	ytUrl2 := ErrorLevel
	resFix(150, 30, 700, 90)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *150 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\URLYT3.png
	ytUrl3 := ErrorLevel
Return
actionOnYt:
	if(!ytUrl1 || !ytUrl2 || !ytUrl3){
		MouseGetPos, mouseX, mouseY
		resFix(60, 360, 200, 410)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(0, 300, 200, 500)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTHistory.png
		if(!ErrorLevel){
			resFix(90, 160)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 ; left icons
		}

		resFix(1810, 150)
		PixelGetColor, ytColor, %xValue0%, %yValue0%, Fast RGB
		if(ytColor = "0xCC0000"){
			resFix(1790, 155)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 ; notifications
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
			PixelGetColor, colorVar, %xValue0%, %yValue0%, RGB
			if(colorVar = 0x404076){ ; Incognito
				Send, ^{2}
				Return
			}

			MouseGetPos, mouseX, mouseY
			resFix(9, 85, 50, 120)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}
			resFix(9, 85, 50, 120)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
			vivaldiFullError := ErrorLevel
			if(ErrorLevel){
				Send, {Esc}
			}
			while(vivaldiFullError){
				resFix(9, 85, 50, 120)
				ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
				vivaldiFullError := ErrorLevel
			}
			MouseMove, %mouseX%, %mouseY%, 0

			Gosub, downloadsPanel
			Gosub, loadingPage
			Gosub, isOnYt
			resFix(80, 10)
			PixelGetColor, firstTab, %xValue0%, %yValue0%, Fast RGB
			Send, ^{1}

			KeyWait, 1
			KeyWait, Control

			if((!ytUrl1 || !ytUrl2 || !ytUrl3) && firstTab = 0x2E2F37){
				resFix(1790, 155)
				ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 ; notifications
				resFix(1500, 320)
				MouseMove, %xValue0%, %yValue0%, 0

				MouseGetPos, mouseX, mouseY
				resFix(61, 360, 2000, 410)
				if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
					resFix(1000, 600)
					MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
				}
				resFix(0, 300, 200, 500)
				ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTHistory.png
				if(!ErrorLevel){
					resFix(90, 160)
					ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 ; left icons
				}
				MouseMove, %mouseX%, %mouseY%, 0
			}else if(!(!ytUrl1 || !ytUrl2 || !ytUrl3) && firstTab = 0x2E2F37){
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
				resFix(80, 10)
				PixelGetColor, firstTab, %xValue0%, %yValue0%, Fast RGB
				if(!(!ytUrl1 || !ytUrl2 || !ytUrl3) && firstTab = 0x2E2F37){
					Sleep, 500
					Gosub, isOnYt
					resFix(80, 10)
					PixelGetColor, firstTab, %xValue0%, %yValue0%, Fast RGB

					if(!(!ytUrl1 || !ytUrl2 || !ytUrl3) && firstTab = 0x2E2F37){
						resFix(80, 10)
						PixelGetColor, firstTab, %xValue0%, %yValue0%, Fast RGB		
						Send, ^{l}
						Sleep, 100
						Send, youtube.com
						Send, {Enter}

						Sleep, 500
						Gosub, loadingPage
						Gosub, isOnYt
						Gosub, actionOnYt
					}else if((!ytUrl1 || !ytUrl2 || !ytUrl3) && firstTab = 0x2E2F37){
						Gosub, actionOnYt
					}
				}else if ((!ytUrl1 || !ytUrl2 || !ytUrl3) && firstTab = 0x2E2F37){
					Gosub, actionOnYt
				}
			}
		}else{
			Send, ^{1}
		}
	Return

	$^2::
		Gosub, downloadsPanel

		resFix(500, 100)
		PixelGetColor, colorVar, %xValue0%, %yValue0%, RGB
		if(colorVar = 0x404076){ ; Incognito
			Send, ^{2}
			Return
		}

		MouseGetPos, mouseX, mouseY
		resFix(250, 130, 340, 180)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(250, 130, 350, 180)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\TwitterLogo.png
		twitterLogo := ErrorLevel
		Send, ^{2}

		MouseGetPos, mouseX, mouseY
		resFix(9, 85, 50, 120)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(9, 85, 50, 120)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
		if(!ErrorLevel){
			Send, {Esc}
		}

		if(!twitterLogo){
			KeyWait, LCtrl
			resFix(300, 220)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1
		}
	Return

	~$^3::
	~$^4::
	~$^5::
	~$^6::
	~$^7::
	~$^8::
	~$^9::
		MouseGetPos, mouseX, mouseY
		resFix(90, 85, 50, 120)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(9, 85, 50, 120)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
		if(ErrorLevel){
			Send, {Esc}
		}
		Gosub, downloadsPanel
	Return

	$^w::
		MouseGetPos, mouseX, mouseY
		resFix(9, 85, 50, 120)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(9, 85, 50, 120)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
		if(ErrorLevel){
			Send, {Esc}
		}
		Send, ^{w}
		Sleep, 200
		Gosub, downloadsPanel
		Gosub, isOnYt
		Gosub, actionOnYt
	Return
	~^r::
	~$F5::
		MouseGetPos, mouseX, mouseY
		resFix(9, 85, 50, 120)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}
		resFix(9, 85, 50, 120)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
		vivaldiFullError := ErrorLevel
		if(ErrorLevel){
			Send, {Esc}
		}
		while(vivaldiFullError){
			resFix(9, 85, 50, 120)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
			vivaldiFullError := ErrorLevel
		}
		MouseMove, %mouseX%, %mouseY%, 0

		Gosub, downloadsPanel
		Sleep, 500
		Gosub, loadingPage
		Sleep, 500
		Gosub, isOnYt
		resFix(80, 10)
		PixelGetColor, firstTab, %xValue0%, %yValue0%, Fast RGB

		if((!ytUrl1 || !ytUrl2 || !ytUrl3) && firstTab = 0x2E2F37){
			MouseGetPos, mouseX, mouseY
			resFix(61, 360, 2000, 410)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}
			resFix(0, 300, 200, 500)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTHistory.png
			if(!ErrorLevel){
				resFix(90, 160)
				ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 ; left icons
			}
			MouseMove, %mouseX%, %mouseY%, 0
		}
		if((!(!ytUrl1 || !ytUrl2 || !ytUrl3)) && firstTab = 0x2E2F37){
			Sleep, 500
			Gosub, isOnYt

			if((!(!ytUrl1 || !ytUrl2 || !ytUrl3)) && firstTab = 0x2E2F37){
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

	~LButton::
		KeyWait, LButton
		resFix(500, 100)
		PixelGetColor, colorVar, %xValue0%, %yValue0%, RGB
		if(colorVar = 0x404076){
			Return
		}
		MouseGetPos, mouseX, mouseY
		; (mouseX > 133 && mouseY > 145 && mouseX < 222 && mouseY < 168) YT logo
		; (mouseX > 94 && mouseY > 47 && mouseX < 136 && mouseY < 87) Reload page
		; (mouseX > 1844 && mouseY > 47 && mouseX < 1886 && mouseY < 87) Reload all pages
		; (mouseX > 52 && mouseY > 9 && mouseX < 88 && mouseY < 46) First tab (YT)
		resFix(133, 145, 222, 168)
		ytLogoX0 := xValue0
		ytLogoY0 := yValue0
		ytLogoX1 := xValue1
		ytLogoY1 := yValue1

		resFix(94, 47, 136, 87)
		reloadPageX0 := xValue0
		reloadPageY0 := yValue0
		reloadPageX1 := xValue1
		reloadPageY1 := yValue1

		resFix(1844, 47, 1886, 87)
		reloadAllX0 := xValue0
		reloadAllY0 := yValue0
		reloadAllX1 := xValue1
		reloadAllY1 := yValue1

		resFix(52, 9, 88, 46)

		if((mouseX > ytLogoX0 && mouseY > ytLogoY0 && mouseX < ytLogoX1 && mouseY < ytLogoY1) 
		|| (mouseX > reloadPageX0 && mouseY > reloadPageY0 && mouseX < reloadPageX1 && mouseY < reloadPageY1) 
		|| (mouseX > reloadAllX0 && mouseY > reloadAllY0 && mouseX < reloadAllX1 && mouseY < reloadAllY1) 
		|| (mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1)){
			
			if(mouseX > reloadPageX0 && mouseY > reloadPageY0 && mouseX < reloadPageX1 && mouseY < reloadPageY1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}else if(mouseX > reloadAllX0 && mouseY > reloadAllY0 && mouseX < reloadAllX1 && mouseY < reloadAllY1){
				Send, ^{r}
			}
			Gosub, downloadsPanel
			Sleep, 500
			Gosub, loadingPage
			Gosub, isOnYt
			Gosub, actionOnYt
		}
	Return

	$F1::
	$F2::
	$F3::
		WinGet, window, MinMax
		if(window = 1){
			resFix(1270, 340)
			PixelGetColor, searchBar, %xValue0%, %yValue0%, Fast RGB
			if(searchBar != "0x2B2B2B"){
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
				resFix(460, 270, 650, 330)
				if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
					resFix(1000, 600)
					MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
				}
				resFix(460, 270, 650, 330)
				PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xFFFFFF, 20, Fast RGB
				loadingInsta := ErrorLevel
			}
			DllCall("ShowCursor", Int,1)

			resFix(512, 241)
			PixelGetColor, instaColor, %xValue0%, %yValue0%, Fast RGB
			if(instaColor = "0xD72B7D"){
				resFix(500, 270)
				ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1
			}
		}else if(searchWord = "s" && ErrorLevel = "EndKey:Enter"){
			KeyWait, Enter
			WinWaitActive, Calendar - Sonarr - Vivaldi, , 2
			Gosub, loadingPage
			Sleep, 200
			resFix(1300, 140, 1320, 180)
			PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x990C08, 20, Fast RGB
			if(!ErrorLevel){
				resFix(1270, 190)
				ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 		; System
				WinWaitActive, System - Sonarr - Vivaldi, , 1
				Sleep, 400

				MouseGetPos, mouseX, mouseY
				resFix(600, 450, 950, 650)
				if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
					resFix(1000, 600)
					MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
				}

				resFix(600, 450, 950, 650)
				ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *130 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\SonarrUtorrent.png
				if(!ErrorLevel){
					if(!ProcessExist("uTorrent.exe")){
						Run, C:\Users\Bruno\AppData\Roaming\uTorrent\uTorrent.exe
						WinWait, ahk_exe uTorrent.exe
						WinClose, ahk_exe uTorrent.exe

						Process, Exist, vivaldi.exe
						vivaldiPID=%Errorlevel%
						if(vivaldiPID){
							WinActivate ahk_pid %vivaldiPID%
							WinWaitActive, ahk_exe vivaldi.exe, , 1.5
						}
					}
					resFix(1160, 190)
					ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 	; Settings
					WinWaitActive, Settings - Sonarr - Vivaldi, , 1
					resFix(1100, 360)
					ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 	; Download Clients Tab
					Sleep, 800
					resFix(550, 700)
					ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 	; uTorrent
					Sleep, 600
					resFix(1190, 880)
					ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1	; Test
					Sleep, 100
					resFix(1330, 880)
					ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 	; Save
				}
			}
		}else if(searchWord = "f" && ErrorLevel = "EndKey:Enter"){
			KeyWait, Enter
			Sleep, 500
			Gosub, loadingPage
			Sleep, 800
			resFix(1820, 120, 1840, 140)
			PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xF02849, 20, Fast RGB
			if(!ErrorLevel){
				resFix(1810, 160)
				ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1
			}
		}
	Return

	$!d::
		MouseGetPos, mouseX, mouseY
		resFix(55, 130, 180, 180)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(55, 130, 180, 180)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiDownloads.png
		VivaldiDownloads := ErrorLevel
		resFix(55, 130, 180, 180)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiDownloads2.png
		VivaldiDownloads2 := ErrorLevel
		if(!VivaldiDownloads || !VivaldiDownloads2){
			resFix(680, 200)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1
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
		resFix(400, 0, 600, 100)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(400, 0, 650, 100)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNowPlaying.png
		if(!ErrorLevel){
			resFix(1460, 125)
			MouseMove, %xValue0%, %yValue0%, 0
			Send, {WheelDown}
		}else{
			Send, {WheelDown}
		}
	Return
	$s::
		if(A_CaretX = "" && A_CaretY = ""){	
			Send, #{Up}

			MouseGetPos, mouseX, mouseY
			resFix(400, 0, 600, 100)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}

			resFix(400, 0, 650, 100)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNowPlaying.png
			if(!ErrorLevel){
				resFix(1460, 125)
				MouseMove, %xValue0%, %yValue0%, 0
				Send, {WheelDown}
			}
		}else{
			Send, {s}
		}
	Return
	
	$Up::
		Send, #{Up}

		MouseGetPos, mouseX, mouseY
		resFix(400, 0, 600, 100)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(400, 0, 650, 100)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNowPlaying.png
		if(!ErrorLevel){
			resFix(1460, 125)
			MouseMove, %xValue0%, %yValue0%, 0
			Send, {WheelUp}
		}else{
			Send, {WheelUp}
		}
	Return
	$w::
		if(A_CaretX = "" && A_CaretY = ""){	
			Send, #{Up}

			MouseGetPos, mouseX, mouseY
			resFix(400, 0, 600, 0)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}

			resFix(400, 0, 650, 100)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNowPlaying.png
			if(!ErrorLevel){
				resFix(1460, 125)
				MouseMove, %xValue0%, %yValue0%, 0
				Send, {WheelUp}
			}
		}else{
			Send, {w}
		}
	Return

	$>!b::
	$<^>!b::
		resFix(200, 0, 500, 100)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBPlaylists.png
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
		ImageSearch, , , 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBPlaylists%A_ScreenHeight%.png
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
		resFix(220, 140)
		MouseClick, Left, %xValue0%, %yValue0%, 2, 0 ; Not Classical
		MouseMove, %mouseX%, %mouseY%, 0
	Return

	$>!m::
	$<^>!m::
		Send, #{Up}
		Sleep, 100

		MouseGetPos, mouseX, mouseY
		resFix(400, 0, 600, 100)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		ImageSearch, , , 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNowPlaying%A_ScreenHeight%.png
		if(ErrorLevel){
			resFix(540, 50)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
		}else{
			WinMinimize, ahk_class WindowsForms10.Window.8.app.0.2bf8098_r7_ad1
		}
	Return

	$Esc::
		resFix(1700, 120)
		MouseClick, Left, %xValue0%, %yValue0%, 1, 0
	Return

	$^1::
		resFix(150, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
	Return
	$^2::
		resFix(280, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
	Return
	$^3::
		resFix(410, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
	Return
	$^4::
		resFix(540, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
	Return

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
		
		if(!ProcessExist("WhatsappTray.exe")){
			while(ProcessExist("WhatsApp.exe")){
				Process, Close, WhatsApp.exe
			}
			Run, "D:\Program Files (x86)\WhatsappTray\WhatsappTray.exe"
		}

		resFix(120, 20)
		PixelGetColor, whatsappColor, %xValue0%, %yValue0%, Fast RGB
		if(whatsappColor != "0x00BFA5"){
			Process, Close, WhatsappTray.exe
			Process, WaitClose, WhatsappTray.exe

			while(ProcessExist("WhatsApp.exe")){
				Process, Close, WhatsApp.exe
			}

			Run, "D:\Program Files (x86)\WhatsappTray\WhatsappTray.exe"
		}
		
		resFix(418, 68, 429, 79)
		PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x09D261, 20, Fast RGB
		if(!ErrorLevel){
			resFix(418, 68)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe WhatsApp.exe, , Left, 1
			resFix(300, 300)
			MouseMove, %xValue0%, %yValue0%, 0
		}else{
			MouseGetPos, mouseX, mouseY
			resFix(1790, 90, 1820, 120)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}

			resFix(1790, 90, 1820, 120)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WhatsAppClose.png
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
Return





; CHANGELOG
; 3.1 Changed shortcut (#+h to AltGr+h)
; 3.2 Optimized code
; 3.3 Changed optmization settings, optimized 0, added returns and implemented Class mode
; 3.4 Implemented accessibility check
; 3.5 Start recording with OBS, optimized code and changed AltGr+l logics
; 3.5 Implemented AltGr+r to start recording with OBS, close vivaldi if it's running

; 3.7 AltGr as Ctrl in vivaldi
; 3.8 Start Nvidia RTX Voice, added MsgBox, added F1, F2 and F3 on susVivaldi, optimized code
; 3.9 Optmized code, close and open livelywpf, improved obs recording state detection
; 4.0 solved Critical Error, optmized code, changed lively to Wallpaper Engine, changed gui to MsgBox on selection, 
;optimized temporary MsgBox, fixed close teams, improved OBS recording, msgbox always on top (0x1000 = AoT; 0x1001 = AoT + OkCancel)
; 4.1 Implemented Game mode, confirmation for class modes

; 5.0.0 Rewrote too many stuff
; 5.0.1 Disabled a lot of things
; 5.0.2 Erased disabled things
; 5.0.3 Did so many things, but the ^1 and ^2 on vivaldi is "working"
; 5.0.4 Backing up, because I will change ControlClick to mouseclick on explorer directories

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

;X := Your_X_Value * (A_ScreenWidth / Designed_Width)
;Y := Your_Y_Value * (A_ScreenHeight / Designed_Height)