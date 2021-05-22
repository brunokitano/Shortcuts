#SingleInstance force
#NoEnv
#Persistent
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
;#KeyHistory 0
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
Thread, Interrupt, -1

; accessibilityEnable
y1 := 285
y2 := 330
y3 := 470
pos1Color := "0xE6E6E6"
pos2Color := "0xEAEAEA"
pos5Color := "0xE9E9E9"
loading := "0xFFFFFF"

;OPTIMIZATIONS END
Return
Return

; Backend Do Nothing
doNothing(){
Return
}

; Remove Tooltip
RemoveToolTip:
	ToolTip
return

; Checks if Process exists
ProcessExist(Name){
	Process,Exist,%Name%
return Errorlevel
}

lightButtons: 
	IfWinNotExist, Lights
		return  ; Keep waiting.
	SetTimer, lightButtons, Off 
	WinActivate 
	ControlSetText, Button1, &On
	ControlSetText, Button2, &Off
return

yesNo: 
	IfWinNotExist, Yes || No
		return  ; Keep waiting.
	SetTimer, yesNo, Off 
	WinActivate 
	ControlSetText, Button1, &Yes
	ControlSetText, Button2, &No
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
$<^>!c::
	Suspend, Off
	SetTimer, closeClass, 50
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
			Sleep, 100
			PixelSearch, obsX, obsY, 1121, 1057, 1900, 1079, 0xFF0000, 0, Fast RGB
			if(!(ErrorLevel)){ ; Stops recording and closes
				Send, {F22 Down}
				Sleep, 100
				Send, {F22 Up}
				Sleep, 200
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

; Fatec class mode
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
;		if(ProcessExist("livelywpf.exe")){
;			Process, Close, livelywpf.exe
;		}
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
		WinWaitActive, ahk_class RTXVoiceWindowClass
		Send, !{F4}
	}
	Else
	{
		MsgBox, 0x1000, Button pressed, Cancelled., 1
	}
	Reload
Return

; Start || stop recording
$<^>!r::
	Suspend, Off
	if(ProcessExist("obs64.exe")){
		Send, #{b}
		Sleep, 100
		PixelSearch, obsX, obsY, 1121, 1057, 1900, 1079, 0xFF0000, 6, Fast RGB
		if(!(ErrorLevel)){
			Send, {F22 Down}
			Sleep, 100
			Send, {F22 Up}
			Send, !{Tab}
			MsgBox, 0x1000, Hotkey Pressed, Stopped recording., 1				
		}Else{
			Send, {F22 Down}
			Sleep, 100
			Send, {F22 Up}
			Send, !{Tab}
			MsgBox, 0x1000, Hotkey Pressed, Started recording., 1
		}
	}Else{
		MsgBox, 0x1000, Hotkey Pressed, OBS is not running., 1
	}
	Reload
Return

; English class mode
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
		WinWaitActive, ahk_class RTXVoiceWindowClass
		Send, !{F4}
	}
	Else
	{
		MsgBox, 0x1000, Button pressed, Cancelled., 1
	}
	Reload
Return


; Win+H = Hibernate computer
$<^>!h::
	Suspend, Off
	Run, D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Hibernate.bat
	MsgBox, 0x1000, Hotkey Pressed, Hibernating., 1
Return


; Turn the lights On || Off
$<^>!l::
	Suspend, Off
	SetTimer, lightButtons, 50
	MsgBox, 0x1001, Lights, What do you want to do with the lights?
	IfMsgBox, OK
	{
		Run, D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Lights\On.vbs
		MsgBox, 0x1000, Button pressed, Turning the light on., 1
	}
	Else
	{
		Run, D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Lights\Off.vbs
		MsgBox, 0x1000, Button pressed, Turning the light off., 1
	}
	Reload
Return

$<!w::
	Send, ^{F23}
	Suspend, Off
Return

$PrintScreen:: Send, ^{F24}

	; Show all the shortcuts
$<^>!i::
	Suspend, Off
	MsgBox, , List of shortcuts,
	(
AltGr+c: Close Class mode
AltGr+f: Fatec Mode
AltGr+r: Start recording with OBS
AltGr+e: English Class Mode
AltGr+h: Hibernate Computer
AltGr+l: Turn on || off the light
AltGr+g: Game mode
Alt+w: Stop Wallpaper Engine
Numpad0 || 0: Disable 0 if it's in a video
F1 || F2 || F3: Suspend for Vivaldi search
	)
	Reload
Return

; Game mode	
$<^>!g::
	Suspend, Off
	Gui, Destroy
	Gui +AlwaysOnTop -0x30000
	;Gui, Add, DropDownList, vGameChoice Choose1, General|Rocket League|Fall Guys|Close
	Gui, Add, DropDownList, vGameChoice Choose1, General|Rocket League|Emulation|Close
	Gui, Add, Button, gChoose, Choose
	Gui, Show, , Games
Return
Choose:
	Gui, Submit
	if(GameChoice = "General"){
		Send, ^{F23}
		Sleep, 50
		Gui, Destroy

		Process, Close, WhatsApp.exe

		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"
		if(!ProcessExist("Steam.exe")){
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Shortcuts\Steam Ryuiti"
			WinWait, Steam
			Sleep, 500
			WinActivate, ahk_class vguiPopupWindow, , Steam Login
			WinWaitActive, ahk_class vguiPopupWindow, , , Steam Login
			Sleep, 1000
			WinActivate, ahk_class vguiPopupWindow, , Steam Login
			WinWaitActive, ahk_class vguiPopupWindow, , , Steam Login
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
		if(WinExist("ahk_exe vivaldi.exe")){
			GroupAdd, vivaldi, ahk_exe vivaldi.exe
			While(colorVar != 0x2E3064){
				GroupActivate, vivaldi
				Sleep, 400
				PixelGetColor, colorVar, 500, 100, RGB
				Sleep, 400
			}
		}
	
		SetTimer, stores, 50
		MsgBox, 0x1001, Stores, Which one do you want to open?
		IfMsgBox, OK
		{
			Run, steam://rungameid/14209988591219638272 ; GOG 2.0
		}
		Else
		{
			Run, steam://rungameid/15475259589817008128	; Epic Games Launcher
		}
		
		if(runDiscord = 1){
			WinWait, ahk_class RTXVoiceWindowClass
			Sleep, 200
			WinActivate, ahk_class RTXVoiceWindowClass
			WinWaitActive, ahk_class RTXVoiceWindowClass
			Send, !{F4}				
			runDiscord := 0
		}
	Gui, Destroy
	}

	if(GameChoice = "Rocket League"){
		Send, ^{F23}
		Sleep, 50

		Process, Close, WhatsApp.exe

		if(!ProcessExist("Steam.exe")){
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Shortcuts\Steam Ryuiti"
			WinWait, Steam
			Sleep, 500
			WinActivate, ahk_class vguiPopupWindow, , Steam Login
			WinWaitActive, ahk_class vguiPopupWindow, , , Steam Login
			Sleep, 1000
			WinActivate, ahk_class vguiPopupWindow, , Steam Login
			WinWaitActive, ahk_class vguiPopupWindow, , , Steam Login
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
			runDiscord := 1
		}

		WinWait, ahk_class UnrealWindow
		Sleep, 200
		WinActivate, ahk_class UnrealWindow
		WinWaitActive, ahk_class UnrealWindow
		Sleep, 100
		Send, #{Up Down}
		Sleep, 100
		Send, #{Up Up}
		WinActivate, ahk_class UnrealWindow
		WinWaitActive, ahk_class UnrealWindow
		Sleep, 500
		PixelSearch, gameX, gameY, 9, 9, 300, 1000, 0xF5F5F5, 0, Fast RGB
		detected := !ErrorLevel
		while(detected = 0){
			WinActivate, ahk_class UnrealWindow
			WinWaitActive, ahk_class UnrealWindow
			PixelSearch, gameX, gameY, 9, 9, 300, 1000, 0xF5F5F5, 0, Fast RGB
			detected := !ErrorLevel
		}
		Sleep, 200
		MouseClick, Left, 120, 270, 1, 0 ; Click Library
		Sleep, 100

		if(runDiscord = 1){
			WinWait, ahk_class RTXVoiceWindowClass
			Sleep, 200
			WinActivate, ahk_class RTXVoiceWindowClass
			WinWaitActive, ahk_class RTXVoiceWindowClass
			Send, !{F4}				
			runDiscord := 0
		}
		
		WinActivate, ahk_class UnrealWindow
		WinWaitActive, ahk_class UnrealWindow
		Sleep 200
		WinActivate, ahk_class UnrealWindow
		WinWaitActive, ahk_class UnrealWindow
		PixelSearch, gameX, gameY, 370, 150, 580, 435, 0x2D6DDD, 20, Fast RGB
		detected := !ErrorLevel
		while(detected = 0){
			WinActivate, ahk_class UnrealWindow
			WinWaitActive, ahk_class UnrealWindow
			PixelSearch, gameX, gameY, 370, 150, 580, 435, 0x2D6DDD, 20, Fast RGB
			detected := !ErrorLevel
		}
		Sleep, 200
		MouseClick, Left, 360, 410, 1, 0
		Sleep, 100
	Gui, Destroy
	}

	if(GameChoice = "Close"){
		Send, ^{F23}
		Sleep, 50
		
		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\1080p.bat"
;			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Restart explorer.bat"
		Process, Close, NVIDIA RTX Voice.exe
		Process, Close, GalaxyClient.exe
		Process, Close, EpicGamesLauncher.exe
		Process, Close, Discord.exe
		Process, Close, retroarch.exe

		if(fallGuys = 1){
			Process, Close, steam.exe
			Sleep, 200
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Shortcuts\Steam Ryuiti"
			WinWait, Steam
			Sleep, 500
			WinActivate, ahk_class vguiPopupWindow, , Steam Login
			WinWaitActive, ahk_class vguiPopupWindow, , , Steam Login
			Sleep, 1000
			WinActivate, ahk_class vguiPopupWindow, , Steam Login
			WinWaitActive, ahk_class vguiPopupWindow, , , Steam Login
			Send, !{F4}
			fallGuys := 0
		}
	Gui, Destroy
	Reload
	}

	if(GameChoice = "Emulation"){
		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"

		Send, ^{F23}
		Sleep, 50

		Gui, Destroy
		Gui +AlwaysOnTop -0x30000
		Gui, Add, DropDownList, vemuChoice Choose1, RetroArch|Citra|Cemu
		Gui, Add, Button, gemuChoose, Choose
		Gui, Show, , Emulators
	}
Return
emuChoose:
	if(emuChoice = "RetroArch"){
		Run, "D:\Users\Bruno\AppData\Roaming\RetroArch\retroarch.exe"
	}
	if(emuChoice = "Citra"){
		Run, "C:\Users\Bruno\AppData\Local\Citra\canary-mingw\citra-qt.exe"
		Run, "D:\Program Files (x86)\JoyToKey\JoyToKey.exe"
	}
	if(emuChoice = "Cemu"){
		Run, "D:\Users\Bruno\Documents\Emulators\Wii U\Cemu\Cemu.exe"
	}
	Gui, Destroy
Return

#IfWinActive, Games
	$Enter::
		Gosub, Choose
	Return
	$Esc::
		Gui, Destroy
	Return
Return
#IfWinActive, Emulators
	$Enter::
		Gosub, emuChoose
	Return
	$Esc::
		Gui, Destroy
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