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
;#Include D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\Tooltip.ahk
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


gotActivated := 0
previousDirectory := ""
currentDirectory := ""
SetTimer, programRoutine, 50

; Sound output
outputChange := 0 

SetTimer, sharedVariables, 50

Run, D:\Users\Bruno\Documents\Scripts\Shortcuts\Joysticks.ahk
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

#Include D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\Functions.ahk
return





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
			resFix(1080, 1121, 1050, 1900, 1079)
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
$>!l::
$<^>!l::
	Goto, turnOnOffLights
Return

; MusicBee
$>!b::
$<^>!b::
	Gosub, musicBee

	Sleep, 200
	ImageSearch, , , 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBPlaylists%A_ScreenHeight%.png
	if(ErrorLevel){
		resFix(1080, 410, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
	}else{
		resFix(1080, 280, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
		resFix(1080, 410, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
	}

	MouseGetPos, mouseX, mouseY
	resFix(1080, 220, 120)
	MouseClick, Left, %xValue0%, %yValue0%, 2, 0 ; Classical
	MouseMove, %mouseX%, %mouseY%, 0
Return
$>!n::
$<^>!n::
	Gosub, musicBee

	Sleep, 200
	ImageSearch, , , 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBPlaylists%A_ScreenHeight%.png
	if(ErrorLevel){
		resFix(1080, 410, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
	}else{
		resFix(1080, 280, 60)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
		resFix(1080, 410, 60)
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
		resFix(1080, 1121, 1050, 1900, 1079)
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
		resFix(1080, 50, 50)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1080, 1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(1080, 50, 50)
		ImageSearch, , , 0, 0, %xValue0%, %yValue0%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\mpcLogo%A_ScreenHeight%.png
		if(ErrorLevel){
			Send, {f}
			mpcWindow := 1
		}

		MouseMove, %mouseX%, %mouseY%, 0
	}else if(WinActive("ahk_exe vivaldi.exe")){
		MouseGetPos, mouseX, mouseY

		resFix(1080, 9, 85, 50, 140)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1080, 1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(768, 1330, 40, 1360, 70)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiFull%A_ScreenHeight%.png
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
$>+/::
$>+;::
	reviewAndLesson := 1
	Gosub, waniKaniAuto
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

		resFix(1080, 1270, 340)
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

	resFix(1080, 1270, 340)
	PixelGetColor, searchBar, %xValue0%, %yValue0%, Fast RGB
	if(searchBar != "0x2B2B2B" || searchBar != "0x2B2C34"){
		Send, {Esc}
		Send, {F1}
	}else{
		Send, {F1}
	}
Return

F12::
	Goto, fxSoundChangeOutput
Return

$<!Tab::
	if(WinActive("ahk_exe vivaldi.exe")){
		MouseGetPos, mouseX, mouseY
		resFix(1080, 9, 85, 50, 140)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1080, 1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(768, 1330, 40, 1360, 70)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiFull%A_ScreenHeight%.png
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
	reload := 0
	Reload
Return

~$#Space::
	KeyWait, #
	Sleep, 500
	CoordMode, Pixel, Screen

	MouseGetPos, mouseX, mouseY
	resFix(1080, 1600, 1042, 1716, 1079)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1080, 1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(1080, 1600, 1042, 1716, 1079)
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
	resFix(1080, 62, 75, 696, 280)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1080, 1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	Sleep, 100
	resFix(1080, 62, 75, 142, 280)
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
	resFix(1080, 1700, 850, 1910, 930)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1080, 1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(1080, 1700, 850, 1910, 930)
	ImageSearch, WinNotif1X, WinNotif1Y, %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsNotifications1%A_ScreenHeight%.png
	windowsNotifications1 := ErrorLevel
	resFix(1080, 1700, 850, 1910, 930)
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
#IfWinActive, Lights
	Joy1::
		Send, {Enter}
	Return

	$k::
		WinClose, Lights
		Run, D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Lights\Off.vbs
		MsgBox, 0x1000, Button pressed, Turning the light off., 1
	Return

#IfWinActive, ahk_exe explorer.exe
	$^Tab::
		Send, ^#{2}
	Return

	~$F2::
	Return

	$Joy5::
	$1::
		KeyWait, 1
		KeyWait, Joy5

		if(!GetKeyState("Joy7") && !GetKeyState("Joy8"))
			Gosub, expSelect
	Return

	$Joy6::
	$2::
		KeyWait, 2
		KeyWait, Joy6

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
#IfWinActive, ahk_exe vivaldi.exe
	$^1::
		WinGet, window, MinMax
		if(window = 1){
			resFix(1080, 500, 100)
			PixelGetColor, colorVar, %xValue0%, %yValue0%, Fast RGB
			if(colorVar = 0x404076){ ; Incognito
				Send, ^{2}
				Return
			}

			MouseGetPos, mouseX, mouseY
			resFix(1080, 9, 85, 50, 140)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1080, 1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}
			resFix(768, 1330, 40, 1360, 70)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiFull%A_ScreenHeight%.png
			vivaldiFullError := ErrorLevel
			if(ErrorLevel){
				Send, {Esc}
			}
			while(vivaldiFullError){
				resFix(768, 1330, 40, 1360, 70)
				ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiFull%A_ScreenHeight%.png
				vivaldiFullError := ErrorLevel
			}
			MouseMove, %mouseX%, %mouseY%, 0

			Gosub, downloadsPanel
			Gosub, loadingPage
			Gosub, isOnYt
			resFix(1080, 80, 10, 80, 15)
			PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x2E2F37, 20, Fast RGB
			firstTab := ErrorLevel
			Send, ^{1}

			KeyWait, 1
			KeyWait, Control

			if((!ytUrl1 || !ytUrl2) && !firstTab){
				resFix(1080, 1790, 155)
				ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 ; notifications
				resFix(1080, 1500, 320)
				MouseMove, %xValue0%, %yValue0%, 0

				MouseGetPos, mouseX, mouseY
				resFix(1080, 60, 360, 250, 410)
				if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
					resFix(1080, 1000, 600)
					MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
				}

				resFix(1080, 0, 300, 250, 500)
;				ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTHistory%A_ScreenHeight%.png
;				if(!ErrorLevel){
;					resFix(1080, 90, 160)
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
				resFix(1080, 80, 10, 80, 15)
				PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x2E2F37, 20, Fast RGB
				firstTab := ErrorLevel
				if(!(!ytUrl1 || !ytUrl2) && !firstTab){
					Sleep, 500
					Gosub, isOnYt
					resFix(1080, 80, 10, 80, 15)
					PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x2E2F37, 20, Fast RGB
					firstTab := ErrorLevel

					if(!(!ytUrl1 || !ytUrl2) && !firstTab){
						resFix(1080, 80, 10, 80, 15)
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

		resFix(1080, 500, 100)
		PixelGetColor, colorVar, %xValue0%, %yValue0%, Fast RGB
		if(colorVar = 0x404076){ ; Incognito
			Send, ^{2}
			Return
		}

		MouseGetPos, mouseX, mouseY
		resFix(1080, 180, 130, 350, 180)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1080, 1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(1080, 180, 130, 350, 180)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\TwitterLogo%A_ScreenHeight%.png
		twitterLogo := ErrorLevel
		Send, ^{2}

		MouseGetPos, mouseX, mouseY
		resFix(1080, 9, 85, 50, 140)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1080, 1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(1080, 9, 85, 50, 140)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg%A_ScreenHeight%.png
		if(!ErrorLevel){
			Send, {Esc}
		}

		if(!twitterLogo){
			KeyWait, LCtrl
			resFix(1080, 300, 220)
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
		
		resFix(1080, 9, 85, 50, 140)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1080, 1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(768, 1330, 40, 1360, 70)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiFull%A_ScreenHeight%.png
		if(ErrorLevel){
			Send, {Esc}
		}
		Gosub, downloadsPanel
	Return

	$^w::
		MouseGetPos, mouseX, mouseY
		resFix(1080, 9, 85, 50, 140)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1080, 1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(768, 1330, 40, 1360, 70)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiFull%A_ScreenHeight%.png
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
		resFix(1080, 9, 85, 50, 140)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1080, 1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}
		resFix(1080, 9, 85, 50, 140)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg%A_ScreenHeight%.png
		vivaldiFullError := ErrorLevel
		if(ErrorLevel){
			Send, {Esc}
		}
		while(vivaldiFullError){
			resFix(1080, 9, 85, 50, 140)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRarbg%A_ScreenHeight%.png
			vivaldiFullError := ErrorLevel
		}
		MouseMove, %mouseX%, %mouseY%, 0

		Gosub, downloadsPanel
		Sleep, 500
		Gosub, loadingPage
		Sleep, 500
		Gosub, isOnYt
		resFix(1080, 80, 10, 80, 15)
		PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x2E2F37, 20, Fast RGB
		firstTab := ErrorLevel

		if((!ytUrl1 || !ytUrl2) && !firstTab){
			MouseGetPos, mouseX, mouseY
			resFix(1080, 60, 360, 250, 410)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1080, 1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}

			resFix(1080, 0, 300, 250, 500)
;			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTHistory%A_ScreenHeight%.png
;			if(!ErrorLevel){
;				resFix(1080, 90, 160)
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

	~LButton::
		KeyWait, LButton
		Gosub, lbActions
	Return

	$F1::
	$F2::
	$F3::
		WinGet, window, MinMax
		if(window = 1){
			resFix(1080, 1270, 340)
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
			resFix(1080, 460, 270, 650, 330)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1080, 1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}
			resFix(1080, 460, 270, 650, 330)
			PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xFFFFFF, 20, Fast RGB
			loadingInsta := ErrorLevel
			while(loadingInsta){
				ToolTip, loading
				resFix(1080, 460, 270, 650, 330)
				if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
					resFix(1080, 1000, 600)
					MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
				}
				resFix(1080, 460, 270, 650, 330)
				PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xFFFFFF, 20, Fast RGB
				loadingInsta := ErrorLevel
			}
			ToolTip, 
			DllCall("ShowCursor", Int,1)

			resFix(1080, 456, 220, 566, 349)
			PixelSearch, storiesDetectedX, storiesDetectedY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xD72B7D, 20, Fast RGB
			if(!ErrorLevel){
				ControlClick, x%storiesDetectedX% y%storiesDetectedY%, ahk_exe vivaldi.exe, , Left, 1
			}
		}else if(searchWord = "f" && ErrorLevel = "EndKey:Enter"){
			KeyWait, Enter
			Sleep, 500
			Gosub, loadingPage
			Sleep, 800
			resFix(1080, 1820, 120, 1840, 160)
			PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xF02849, 20, Fast RGB
			if(!ErrorLevel){
				resFix(1080, 1810, 160)
				ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1
			}
		}
	Return

	$!d::
		MouseGetPos, mouseX, mouseY
		resFix(1080, 200, 200)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1080, 1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(1080, 200, 200)
		ImageSearch, , , 0, 0, %xValue0%, %yValue0%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiDownloads%A_ScreenHeight%.png
		if(!ErrorLevel){
			resFix(1080, 750, 250)
			ImageSearch, VivaldiRemoveDownloadsX, VivaldiRemoveDownloadsY, 0, 0, %xValue0%, %yValue0%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiRemoveDownloads%A_ScreenHeight%.png
			ControlClick, x%VivaldiRemoveDownloadsX% y%VivaldiRemoveDownloadsY%, ahk_exe vivaldi.exe, , Left, 1
			Send, ^{j}
		}else{
			Send, ^{j}
		}
	Return

	~$^g::
		resFix(1080, 1300, 230)
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
			resFix(1080, 410, 60)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
			Sleep 50
		}else{
			resFix(1080, 280, 60)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
			resFix(1080, 410, 60)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
		}

		MouseGetPos, mouseX, mouseY
		resFix(1080, 220, 120)
		MouseClick, Left, %xValue0%, %yValue0%, 2, 0 ; Classical
		Sleep 50
		MouseMove, %mouseX%, %mouseY%, 0
	Return
	$>!n::
	$<^>!n::
		ImageSearch, , , 0, 0, %A_ScreenWidth%, %A_ScreenHeight%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\MBPlaylists%A_ScreenHeight%.png
		if(ErrorLevel){
			resFix(1080, 410, 60)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
			Sleep 50
		}else{
			resFix(1080, 280, 60)
			ControlClick, x%xValue0% y%yValue0%, ahk_exe MusicBee.exe, , Left, 1
			resFix(1080, 410, 60)
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