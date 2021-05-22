#SingleInstance force
#NoEnv
;#Warn
#Persistent
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0 ; Comment this line to see the key history
#UseHook, On

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

#Include D:\Users\Bruno\Documents\Scripts\Shortcuts\Scripts\Tooltip.ahk
ToolTipColor("Black", "White")
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
SetTimer, checkHeadphones, 500

Status := 1
SetTimer, CheckIdle, 100

;SetTimer, checkActive, 500
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

CheckIdle:
	if (A_TimeIdleMouse > 5000)
	{
		if Status
			SystemCursor(Status := !Status)
	}
	else if !Status
		SystemCursor(Status := !Status)
return
SystemCursor(OnOff=1) {
	if(OnOff == 1)
	{
	   BlockInput MouseMoveOff
	   DllCall("ShowCursor", Int,1)	
	}else{
	   MouseGetPos, , , hwnd
	   Gui Cursor:+Owner%hwnd%
	   BlockInput MouseMove
	   DllCall("ShowCursor", Int,0)	
	}
}

checkHeadphones:
	if(lidState = "opened"){
		RegRead, headphones, HKEY_LOCAL_MACHINE, %headphonesPath%, %headphonesValue%
		if(headphones != 0 && prevValue != headphones){
			SoundSet, %highVol%, MASTER
			RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SOFTWARE\Dolby\DAX, DolbyEnable, 00000001
			Send, {Volume_Mute}
			Send, {Volume_Mute}
			Sleep, 200
			ImageSearch, , , 62, 75, 142, 249, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsMute.png
			if(!ErrorLevel){
				Send, {Volume_Mute}		
			}
		}else if(headphones != 1 && prevValue != headphones){
			SoundSet, %lowVol%, MASTER
			RegWrite, REG_DWORD, HKEY_LOCAL_MACHINE\SOFTWARE\Dolby\DAX, DolbyEnable, 00000000
			Send, {Volume_Mute}
			Send, {Volume_Mute}
			Sleep, 200
			ImageSearch, , , 62, 75, 142, 249, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsMute.png
			if(!ErrorLevel){
				Send, {Volume_Mute}		
			}
		}

		prevValue := headphones
	}
Return

checkActive:
	if(WinActive("ahk_exe vivaldi.exe")){
		PixelGetColor, firstTab, 80, 10, Fast RGB
		if(firstTab = 0x555555){
			Gosub, isOnYt
			if(!ytUrl1 || !ytUrl2 || !ytUrl3){
				ImageSearch, , , 60, 360, 200, 410, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTLibrary.png
				if(!ErrorLevel){
					ControlClick, x90 y160, ahk_exe vivaldi.exe, , Left, 1
				}
			}
		}
	}else if(WinActive("ahk_exe WhatsApp.exe")){
		WinGet, window, MinMax
		if(window != 1){
			Send, #{Up}
		}
	}
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
	}
	if(newstate = "opened"){
	 	SoundSet, %volume%, MASTER
	}
	lidState := newstate 
}

; Checks if Process exists
ProcessExist(Name){
	Process,Exist,%Name%
return Errorlevel
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

MouseIsOver(WinTitle){
    MouseGetPos,,, Win
	return WinExist(WinTitle . " ahk_id " . Win)
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
			PixelSearch, obsX, obsY, 1121, 1057, 1900, 1079, 0xFF0000, 0, Fast RGB
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
	Reload
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
	Reload
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
	Reload
Return

; Game mode
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
		}
		IfMsgBox, No
		{
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"
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
		PixelSearch, gameX, gameY, 9, 9, 300, 1000, 0xF5F5F5, 0, Fast RGB
		detected := !ErrorLevel
		while(detected = 0){
			WinActivate, ahk_class UnrealWindow
			WinWaitActive, ahk_class UnrealWindow, , 1.5
			PixelSearch, gameX, gameY, 9, 9, 300, 1000, 0xF5F5F5, 0, Fast RGB
			detected := !ErrorLevel
		}
		Sleep, 200
		MouseClick, Left, 120, 270, 1, 0 ; Click Library
		
		WinActivate, ahk_class UnrealWindow
		WinWaitActive, ahk_class UnrealWindow, , 1.5
		Sleep 200
		WinActivate, ahk_class UnrealWindow
		WinWaitActive, ahk_class UnrealWindow, , 1.5
		PixelSearch, gameX, gameY, 370, 150, 580, 435, 0x2D6DDD, 20, Fast RGB
		detected := !ErrorLevel
		while(detected = 0){
			WinActivate, ahk_class UnrealWindow
			WinWaitActive, ahk_class UnrealWindow, , 1.5
			PixelSearch, gameX, gameY, 370, 150, 580, 435, 0x2D6DDD, 20, Fast RGB
			detected := !ErrorLevel
		}
		Sleep, 200
		MouseClick, Left, 360, 410, 1, 0
	Gui, Destroy
	}

	if(GameChoice = "Close"){
		Send, ^{F23}
		Sleep, 50

		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\1080p.bat"
		if(!ProcessExist("vivaldi.exe")){
			Run, "C:\Users\Bruno\AppData\Local\Vivaldi\Application\vivaldi.exe"
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
	Gui, Destroy
	Reload
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
	Reload
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
	Reload
Return

; MusicBee
$>!m::
$<^>!m::
	if(!ProcessExist("MusicBee.exe")){
		Run, "D:\Program Files (x86)\MusicBee\MusicBee.exe"
		WinWait, ahk_exe MusicBee.exe
	}
	Sleep, 100
	Send, #{b}
	Sleep, 50
	CoordMode, Pixel, Screen
	MouseGetPos, origX, origY
	
	ImageSearch, musicBeeX, musicBeeY, 1450, 1042, 1700, 1080, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBLogo.png
	if(!ErrorLevel){
		MouseClick, Left, %musicBeeX%, %musicBeeY%, 2, 0
		MouseMove, %origX%, %origY%, 0

		WinActivate, ahk_exe MusicBee.exe
		WinWaitActive, ahk_exe MusicBee.exe
		Send, #{Up}
		WinActivate, ahk_exe MusicBee.exe
		WinWaitActive, ahk_exe MusicBee.exe
		Send, #{Up}
	}else{
/*
		runTime := ""
		startTime := A_TickCount
		ToolTip, MusicBee icon not found.
		Process, Exist 
		hwnd := WinExist("ahk_class tooltips_class32 ahk_pid " ErrorLevel) 
		WinGetPos,,,w,h,ahk_id %hwnd%
		While (DllCall("MoveWindow","Uptr",hwnd,"Int",x+20,"Int",y-10,"Int",w,"Int",h,"Int",0) && runTime <= 2000){
			MouseGetPos, x, y
			runTime := A_TickCount - startTime
		}

		ToolTip, 
*/
		MsgBox, 0x1000, MusicBee detection, MusicBee icon not found., 1
	}

	CoordMode, Pixel, Relative
Return

; Start || stop recording
$>!r::
$<^>!r::
	Suspend, Off
	if(ProcessExist("obs64.exe")){
		Send, #{b}
		Sleep, 50
		PixelSearch, obsX, obsY, 1121, 1057, 1900, 1079, 0xFF0000, 6, Fast RGB
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
	Reload
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

$PrintScreen::
	Send, ^{F24}
	SetTimer, CheckIdle, Off
	prtscCounter := 0
	while(1){
		if(GetKeyState("Enter", "P"))
			Break

		if(GetKeyState("LButton", "P")){
			KeyWait, LButton
			Break
		}
	}

	SetTimer, CheckIdle, On
Return

$>!,::
$<^>!,::
	if(WinActive("ahk_exe mpc-hc64.exe")){
		ImageSearch, , , 0, 0, 40, 40, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\mpcLogo.png
		if(ErrorLevel){
			Send, {f}
			mpcWindow := 1
		}
	}else if(WinActive("ahk_exe vivaldi.exe")){
		ImageSearch, , , 9, 85, 50, 120, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
		if(ErrorLevel){
			Send, {f}
			vivaldiWindow := 1
		}
	}
	
	Run, C:\Users\Bruno\AppData\Local\WhatsApp\WhatsApp.exe
	WinWait, ahk_exe WhatsApp.exe
	WinActivate, ahk_exe WhatsApp.exe
	WinSet, Top, , ahk_exe WhatsApp.exe
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

	ImageSearch, , , 1600, 110, 1910, 210, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniSession.png ; Detects if it's already on the page
	if(ErrorLevel){
		ImageSearch, , , 1400, 10, 1930, 360, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniExtension.png ; Detects if the extension is open
		waniKaniError := ErrorLevel
		if(waniKaniError){
			ControlClick, x1820 y70, ahk_exe vivaldi.exe, , Left, 1
			Sleep, 600
			ImageSearch, , , 1400, 10, 1930, 360, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniExtension.png ; Detects if the extension is open
			waniKaniError := ErrorLevel
		}
		varTime := 500
		while(waniKaniError){
			ControlClick, x1820 y70, ahk_exe vivaldi.exe, , Left, 1
			varTime := varTime + 100
			Sleep, %varTime%
			ImageSearch, , , 1400, 10, 1930, 360, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniExtension.png ; Detects if the extension is open
			waniKaniError := ErrorLevel
		}

		Sleep, 200
		PixelSearch, waniX, waniY, 1452, 228, 1824, 313, 0x00AAFF, 10, Fast RGB ; Review
		waniKaniReview := ErrorLevel
		if(!waniKaniReview){
			ControlClick, x1735 y260, ahk_exe vivaldi.exe, , Left, 1 ; Click on review
			Send, {Esc Down}
			Sleep, 10
			Send, {Esc Up}
			WinWaitActive, WaniKani / Reviews - Vivaldi, , 1.5
			Sleep, 400
			ControlClick, x1740 y160, ahk_exe vivaldi.exe, , Left, 1 ; Start review

			waniKaniLesson := 1
		}else{
			PixelSearch, , , 1452, 228, 1824, 313, 0xF100A1, 10, Fast RGB  ; Lesson
			waniKaniLesson := ErrorLevel			
		}

		if(!waniKaniLesson){
			ControlClick, x1540 y260, ahk_exe vivaldi.exe, , Left, 1 ; Click on lesson
			Send, {Esc Down}
			Sleep, 10
			Send, {Esc Up}
			WinWaitActive, WaniKani / Lessons - Vivaldi, , 1.5
			Sleep, 400
			ControlClick, x1740 y160, ahk_exe vivaldi.exe, , Left, 1 ; Start lesson
		}
		if(waniKaniReview){
			Send, {Esc}
			Sleep, 10
		}
	}else{
		ControlClick, x1740 y160, ahk_exe vivaldi.exe, , Left, 1 ; If it's already on review/lesson page
	}
Return

$F1::
$F2::
$F3::
	if(!ProcessExist("vivaldi.exe")){
		Run, C:\Users\Bruno\AppData\Local\Vivaldi\Application\vivaldi.exe
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

$<!Tab::
	if(WinActive("ahk_exe vivaldi.exe")){
		ImageSearch, , , 9, 85, 50, 120, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
		if(ErrorLevel){
			Send, {f}
			Sleep, 50
			vivaldiFull := 1
			vivaldiCounter := 1
		}
	}
	Send, {LAlt Down}{Tab}
	KeyWait, Tab
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
			KeyWait, Tab
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
	Sleep, 200
	CoordMode, Pixel, Screen
	ImageSearch, , , 1670, 1042, 1716, 1079, *TransBlack *200 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\JapaneseIME.png
	if(!ErrorLevel){
		Send, +{CapsLock}
	}
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

$\::
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
	if(mouseX > 62 && mouseY > 75 && mouseX < 696 && mouseY < 249){	
		MouseMove, 1000, 600, 0 ; Center of the page
	}

	Sleep, 100
	ImageSearch, , , 62, 75, 142, 249, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsMute.png
	if(!ErrorLevel){
		Send, {Volume_Mute}		
	}

	CoordMode, Mouse, Relative
Return

$^F3::Volume_Up
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
	if(mouseX > 62 && mouseY > 75 && mouseX < 696 && mouseY < 249){	
		MouseMove, 1000, 600, 0 ; Center of the page
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
	if(mouseX > 62 && mouseY > 75 && mouseX < 696 && mouseY < 249){	
		MouseMove, 1000, 600, 0 ; Center of the page
	}
	
	CoordMode, Mouse, Relative
Return

~$Media_Next::
~$Media_Prev::
~$Media_Play_Pause::
~$Volume_Mute::
	CoordMode, Mouse, Screen
	MouseGetPos, mouseX, mouseY
	if(mouseX > 62 && mouseY > 75 && mouseX < 696 && mouseY < 249){	
		MouseMove, 1000, 600, 0 ; Center of the page
	}
	CoordMode, Mouse, Relative
Return

$^F1::Volume_Mute

$^\::
	Send, {\}
Return

$^#Down:: 
	WinGetActiveTitle, winTitle
	WinMinimize, %winTitle%
Return

$#a::
	CoordMode, Mouse, Screen
	CoordMode, Pixel, Screen
	ImageSearch, , , 1750, 890, 1910, 930, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsNotifications.png
	if(!ErrorLevel){
		MouseGetPos, mouseX, mouseY
		MouseClick, , 1830, 920, 1, 0
		MouseMove, %mouseX%, %mouseY%, 0
		Send, #{a}
	}else{
		Send, #{a}
	}
	CoordMode, Mouse, Relative
	CoordMode, Pixel, Relative
Return




#IfWinExist, Resolution
	$7::
		WinClose, Resolution
		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\768p.bat"
	Return
	$9::
		WinClose, Resolution
		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"
	Return
	Esc::
	$1::
		WinClose, Resolution
	Return
	$Left::
		WinActivate, Resolution 
		WinWaitActive, Resolution
		Send, {Left}
	Return
	$Right::
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
	Esc::
	$n::
		WinClose, Yes || No
	Return
	$Left::
		WinActivate, Yes || No 
		WinWaitActive, Yes || No
		Send, {Left}
	Return
	$Right::
		WinActivate, Yes || No 
		WinWaitActive, Yes || No
		Send, {Right}
	Return

#IfWinActive, Games
	$Enter::
		Gosub, GameChoose
	Return
	$Esc::
		Gui, Destroy
	Return
#IfWinActive, Emulators
	$Enter::
		Gosub, EmuChoose
	Return
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
	PixelGetColor, expColor, 30, 286, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 0 ; Recycle Bin
		selectedQA := 1
	}
	PixelGetColor, expColor, 30, 316, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 1 ; Desktop
		selectedQA := 1
	}
	PixelGetColor, expColor, 30, 346, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 2 ; This PC
		selectedQA := 1
	}
	PixelGetColor, expColor, 30, 376, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 3 ; Downloads
		selectedQA := 1
	}
	PixelGetColor, expColor, 30, 406, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 4 ; Sonarr
		selectedQA := 1
	}
	PixelGetColor, expColor, 30, 436, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 5 ; Animes
		selectedQA := 1
	}
	PixelGetColor, expColor, 30, 466, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 6 ; Documents
		selectedQA := 1
	}
	PixelGetColor, expColor, 30, 496, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 7 ; Scripts
		selectedQA := 1
	}
	PixelGetColor, expColor, 30, 526, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 8 ; Media
		selectedQA := 1
	}
	PixelGetColor, expColor, 30, 556, Fast RGB
	if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
		expCounter := 9 ; Registro
		selectedQA := 1
	}
	if(selectedQA = 0){
		expCounter = 9
	}
Return
emptyDetection:
	Sleep, 200

	ImageSearch, , , 540, 250, 680, 310, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExplorerEmpty.png
	if(ErrorLevel){	
		MouseGetPos, mouseX, mouseY
		MouseClick, Left, 270, 280, 1, 0
		MouseMove, %mouseX%, %mouseY%, 0
	}
Return
expSelect:
	Switch expCounter
	{
		case 0:
			ControlClick, x110 y290, , , Left, 1
		case 1:
			ControlClick, x110 y320, , , Left, 1
		case 2:
			ControlClick, x110 y350, , , Left, 1
		case 3:
			ControlClick, x110 y380, , , Left, 1 ; 3Downloads
		case 4:
			ControlClick, x110 y410, , , Left, 1 ; 4Sonarr
		case 5:
			ControlClick, x110 y440, , , Left, 1 ; 5Animes
		case 6:
			ControlClick, x110 y470, , , Left, 1
		case 7:
			ControlClick, x110 y500, , , Left, 1
		case 8:
			ControlClick, x110 y530, , , Left, 1
		case 9:
			ControlClick, x110 y560, , , Left, 1
	}
	Send, {Enter}
Return
#IfWinActive, ahk_exe explorer.exe
	$^Tab::
		Send, ^#{2}
	Return

	~$F2::
	Return

	$1::
		if(A_CaretX = "" && A_CaretY = ""){
			Loop, 
			{	
				if(!(GetKeyState("1", "P")))
					Break

				WinGetActiveTitle, expTitle
				Sleep, 50

				Gosub, expGetColor

				if(expCounter <= 9 && expCounter > 0){
					expCounter--
				}else{
					expCounter := 9
				}

				Gosub, expSelect

				WinWaitNotActive, %expTitle%, , 1
				Send, {Tab}

				if(!(GetKeyState("1", "P")))
					Break
			}

			Sleep, 100
			Gosub, emptyDetection
		}else{
			Send, {1}
		}
	Return
	$2::
		if(A_CaretX = "" && A_CaretY = ""){	
			Loop, 
			{
				if(!(GetKeyState("2", "P")))
					Break

				WinGetActiveTitle, expTitle

				Gosub, expGetColor

				if(expCounter < 9 && expCounter >= 0){
					expCounter++
				}else{
					expCounter := 0
				}

				Gosub, expSelect

				WinWaitNotActive, %expTitle%, , 1
				Send, {Tab}

				if(!(GetKeyState("2", "P")))
					Break
			}
			
			Sleep, 100
			Gosub, emptyDetection
		}else{
			Send, {2}
		}
	Return
	
	$^d::
		ControlClick, x110 y380, , , Left, 1
		Send, {Enter}
		Send, {Tab}
		MouseGetPos, mouseX, mouseY
		MouseClick, Left, 270, 280, 1, 0
		MouseMove, %mouseX%, %mouseY%, 0
	Return
	$^s::
		ControlClick, x110 y410, , , Left, 1
		Send, {Enter}
		Send, {Tab}
		MouseGetPos, mouseX, mouseY
		MouseClick, Left, 270, 280, 1, 0
		MouseMove, %mouseX%, %mouseY%, 0
	Return

	$^1::
		PixelGetColor, expColor, 30, 286, Fast RGB
		if(expColor = "0x333333" || expColor = "0x626262" || expColor = "0x777777"){
			MsgBox, 0x1001, Recycle Bin, Empty Recycle Bin?
			IfMsgBox, Ok
			{
				FileRecycleEmpty, 
			}
		}else{
			ControlClick, x110 y290, , , Left, 1
			Send, {Enter}
		}
	Return
	$^2::
		ControlClick, x110 y320, , , Left, 1
		Send, {Enter}
	Return
	$^3::
		ControlClick, x110 y350, , , Left, 1
		Send, {Enter}
	Return
	$^4::
		ControlClick, x110 y380, , , Left, 1 ; 3Downloads
		Send, {Enter}
	Return
	$^5::
		ControlClick, x110 y410, , , Left, 1 ; 4Sonarr
		Send, {Enter}
	Return
	$^6::
		ControlClick, x110 y440, , , Left, 1 ; 5Animes
		Send, {Enter}
	Return
	$^7::
		ControlClick, x110 y470, , , Left, 1
		Send, {Enter}
	Return
	$^8::
		ControlClick, x110 y500, , , Left, 1
		Send, {Enter}
	Return
	$^9::
		ControlClick, x110 y530, , , Left, 1
		Send, {Enter}
	Return
	$^0::
		ControlClick, x110 y560, , , Left, 1
		Send, {Enter}
	Return

; Vivaldi
downloadsPanel:
	ImageSearch, , , 9, 85, 50, 120, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
	if(!ErrorLevel){
		PixelGetColor, panelExist, 30, 600, Fast RGB
		if(!(panelExist = "0x282828" || panelExist = "0x1C1D49")){
			Send, +{F4}
			Sleep, 400
		}
		ImageSearch, , , 55, 130, 180, 180, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiDownloads.png
		VivaldiDownloads := ErrorLevel
		ImageSearch, , , 55, 130, 180, 180, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiDownloads2.png
		VivaldiDownloads2 := ErrorLevel
		if(!VivaldiDownloads || !VivaldiDownloads2){
			Send, ^{j}
		}
	}
Return
loadingPage:
	ImageSearch, , , 80, 40, 140, 90, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiPageLoading.png
	pageLoading := ErrorLevel
	while(pageLoading = 0){
		ImageSearch, , , 80, 40, 140, 90, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiPageLoading.png
		pageLoading := ErrorLevel
		Sleep, 50
	}
Return
isOnYt:
/*
	ImageSearch, , , 60, 130, 110, 170, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTMenu.png
	ytMenu := ErrorLevel
	ImageSearch, , , 60, 130, 110, 170, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTMenu2.png
	ytMenu2 := ErrorLevel
	ImageSearch, , , 1660, 130, 1700, 180, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTApps.png
	ytApps := ErrorLevel

;if((!ytMenu || !ytMenu2) && !ytApps) >> if(!ytUrl1 || !ytUrl2 || !ytUrl3)
*/
	ImageSearch, , , 150, 30, 700, 90, *130 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTUrl1.png
	ytUrl1 := ErrorLevel
	ImageSearch, , , 150, 30, 700, 90, *130 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTUrl2.png
	ytUrl2 := ErrorLevel
	ImageSearch, , , 150, 30, 700, 90, *130 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTUrl3.png
	ytUrl3 := ErrorLevel
Return
actionOnYt:
	if(!ytUrl1 || !ytUrl2 || !ytUrl3){
		ImageSearch, , , 60, 360, 200, 410, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTLibrary.png
		if(!ErrorLevel){
			ControlClick, x90 y160, ahk_exe vivaldi.exe, , Left, 1
		}

		PixelGetColor, ytColor, 1810, 150, Fast RGB
		if(ytColor = "0xCC0000"){
			ControlClick, x1790 y155, ahk_exe vivaldi.exe, , Left, 1
			MouseMove, 1500, 390, 0
		}
	}
Return
#IfWinActive, ahk_exe vivaldi.exe
	$^1::
		Gosub, downloadsPanel

		PixelGetColor, colorVar, 500, 100, RGB
		if(colorVar = 0x404076){
			Send, ^{1}
			Return
		}

		Gosub, loadingPage
		Gosub, isOnYt
		Send, ^{1}
		ImageSearch, , , 9, 85, 50, 120, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
		if(ErrorLevel){
			Send, {Esc}
		}

		if(!ytUrl1 || !ytUrl2 || !ytUrl3){
			ControlClick, x1790 y155, ahk_exe vivaldi.exe, , Left, 1
			MouseMove, 1500, 390, 0
			ImageSearch, , , 60, 360, 200, 410, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTLibrary.png
			if(!ErrorLevel){
				ControlClick, x90 y160, ahk_exe vivaldi.exe, , Left, 1
			}
		}else{
			KeyWait, 1
			Sleep, 200
			Gosub, isOnYt
			PixelGetColor, firstTab, 80, 10, Fast RGB
			if(!(!ytUrl1 || !ytUrl2 || !ytUrl3) && firstTab = 0x555555){
				Sleep, 300
				Gosub, isOnYt
				PixelGetColor, firstTab, 80, 10, Fast RGB

				if(!(!ytUrl1 || !ytUrl2 || !ytUrl3) && firstTab = 0x555555){
					KeyWait, 1
					KeyWait, Control
					
					Send, ^{l}
					Sleep, 50
					Send, ^{l}
					Send, youtube.com
					Send, {Enter}

					Sleep, 500

					Gosub, loadingPage
					Gosub, isOnYt
					Gosub, actionOnYt
				}else if((!ytUrl1 || !ytUrl2 || !ytUrl3) && firstTab = 0x555555){
					Gosub, actionOnYt
				}
			}else{
				Gosub, actionOnYt
			}
		}
	Return

	$^2::
		Gosub, downloadsPanel

		PixelGetColor, colorVar, 500, 100, RGB
		if(colorVar = 0x404076){
			Send, ^{2}
			Return
		}

		ImageSearch, , , 250, 130, 350, 180, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\TwitterLogo.png
		twitterLogo := ErrorLevel
		Send, ^{2}

		ImageSearch, , , 9, 85, 50, 120, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
		if(!ErrorLevel){
			Send, {Esc}
		}

		if(!twitterLogo){
			KeyWait, 2
			KeyWait, Control
			ControlClick, x300 y220, ahk_exe vivaldi.exe, , Left, 1
		}
	Return

	~$^3::
	~$^4::
	~$^5::
	~$^6::
	~$^7::
	~$^8::
	~$^9::
		ImageSearch, , , 9, 85, 50, 120, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
		if(ErrorLevel){
			Send, {Esc}
		}
		Gosub, downloadsPanel
	Return

	$^w::
		ImageSearch, , , 9, 85, 50, 120, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg.png
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
		Gosub, downloadsPanel
		Sleep, 500
		Gosub, loadingPage
		Gosub, isOnYt
		Gosub, actionOnYt
		PixelGetColor, firstTab, 80, 10, Fast RGB
		if(!(!ytUrl1 || !ytUrl2 || !ytUrl3) && firstTab = 0x555555){
			Sleep, 300
			Gosub, isOnYt
			PixelGetColor, firstTab, 80, 10, Fast RGB

			if(!(!ytUrl1 || !ytUrl2 || !ytUrl3) && firstTab = 0x555555){
				KeyWait, r
				KeyWait, F5
				KeyWait, Control

				Send, ^{l}
				Sleep, 50
				Send, ^{l}
				Send, youtube.com
				Send, {Enter}

				Sleep, 500
				Gosub, loadingPage
				Gosub, isOnYt
				Gosub, actionOnYt
			}else if((!ytUrl1 || !ytUrl2 || !ytUrl3) && firstTab = 0x555555){
				Gosub, actionOnYt
			}
		}
	Return

	~$LButton::
		PixelGetColor, colorVar, 500, 100, RGB
		if(colorVar = 0x404076){
			Return
		}
		MouseGetPos, mouseX, mouseY
		KeyWait, LButton
		; (mouseX > 133 && mouseY > 145 && mouseX < 222 && mouseY < 168) YT logo
		; (mouseX > 94 && mouseY > 47 && mouseX < 136 && mouseY < 87) Reload page
		; (mouseX > 1844 && mouseY > 47 && mouseX < 1886 && mouseY < 87) Reload all pages
		; (mouseX > 52 && mouseY > 9 && mouseX < 88 && mouseY < 46) First tab (YT)
		if((mouseX > 133 && mouseY > 145 && mouseX < 222 && mouseY < 168) || (mouseX > 94 && mouseY > 47 && mouseX < 136 && mouseY < 87) || (mouseX > 1844 && mouseY > 47 && mouseX < 1886 && mouseY < 87) || (mouseX > 52 && mouseY > 9 && mouseX < 88 && mouseY < 46)){
			if((mouseX > 94 && mouseY > 47 && mouseX < 136 && mouseY < 87) || (mouseX > 1844 && mouseY > 47 && mouseX < 1886 && mouseY < 87)){
				MouseMove, 1000, 600, 0 ; Center of the page
			}
			Gosub, downloadsPanel
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
			PixelGetColor, searchBar, 1270, 340, Fast RGB
			if(searchBar != "0x2B2B2B"){
				Send, {Esc}
				Send, {F1}
			}else{
				Send, {F1}
			}
		}else{
			Send, {F1}
		}
	Return

	$!d::
		ImageSearch, , , 55, 130, 180, 180, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiDownloads.png
		VivaldiDownloads := ErrorLevel
		ImageSearch, , , 55, 130, 180, 180, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiDownloads2.png
		VivaldiDownloads2 := ErrorLevel
		if(!VivaldiDownloads || !VivaldiDownloads2){
			ControlClick, x680 y200, ahk_exe vivaldi.exe, , Left, 1
			Send, ^{j}
		}else{
			Send, ^{j}
		}
	Return

	~$^g::
		MouseMove, 1300, 230, 0
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
		ImageSearch, , , 400, 0, 600, 100, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNowPlaying.png
		if(!ErrorLevel){
			MouseMove, 1460, 125, 0
			Send, {WheelDown}
		}
	Return
	$s::
		if(A_CaretX = "" && A_CaretY = ""){	
			Send, #{Up}
			ImageSearch, , , 400, 0, 600, 100, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNowPlaying.png
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
		ImageSearch, , , 400, 0, 600, 100, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNowPlaying.png
		if(!ErrorLevel){
			MouseMove, 1460, 125, 0
			Send, {WheelUp}
		}
	Return
	$w::
		if(A_CaretX = "" && A_CaretY = ""){	
			Send, #{Up}
			ImageSearch, , , 400, 0, 600, 100, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNowPlaying.png
			if(!ErrorLevel){
				MouseMove, 1460, 125, 0
				Send, {WheelUp}
			}
		}else{
			Send, {w}
		}
	Return

	$>!m::
	$<^>!m::
		Send, #{Up}
		Sleep, 100
		ImageSearch, , , 400, 0, 600, 100, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBNowPlaying.png
		if(ErrorLevel){
			ControlClick, x490 y50, ahk_exe MusicBee.exe, , Left, 1
		}else{
			WinMinimize, ahk_exe MusicBee.exe
		}
	Return

	$Esc::
		MouseClick, Left, 1700, 120, 1, 0
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
		PixelSearch, , , 418, 68, 429, 79, 0x09D261, 20, Fast RGB
		if(!ErrorLevel){
			ControlClick, x418 y68, ahk_exe WhatsApp.exe, , Left, 1
			MouseMove, 300, 300, 0
		}else{
			ImageSearch, , , 1790, 90, 1820, 120, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WhatsAppClose.png
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
;	AltGr+e			Exit Class mode
;	AltGr+f 		Fatec Mode
;	AltGr+r 		Start recording with OBS
;	AltGr+c 		Class Mode (English)
;	AltGr+h 		Hibernate Computer
;	AltGr+l 		Turn on || off the light
;	AltGr+g 		Game mode
; 	Alt+w 			Stop Wallpaper Engine
;	Numpad0 || 0	Disable 0 if it's in a video
;	F1 || F2 || F3	Suspend for Vivaldi search

;	AltGr+i 		Shortcuts list

;X := Your_X_Value * (A_ScreenWidth / Designed_Width)
;Y := Your_Y_Value * (A_ScreenHeight / Designed_Height)