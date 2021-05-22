#SingleInstance force
#NoEnv
#Persistent
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
;#KeyHistory 0
#UseHook, On
ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, 0, 0
SetMouseDelay, 0
SetDefaultMouseSpeed, 0
SetWinDelay, 0
SetControlDelay, 0
SendMode Input
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
SetControlDelay, 0
Thread, Interrupt, -1

; accessibilityEnable
x := 80
y1 := 285
y2 := 330
y3 := 470

ModernBrowsers := "ApplicationFrameWindow,Chrome_WidgetWin_0,Chrome_WidgetWin_1,Maxthon3Cls_MainFrm,MozillaWindowClass,Slimjet_WidgetWin_1"
LegacyBrowsers := "IEFrame,OperaWindowClass"

;OPTIMIZATIONS END
Return
Return

GetBrowserURL_ACC(sClass) {
	global nWindow, accAddressBar
	If (nWindow != WinExist("ahk_class " sClass)) ; reuses accAddressBar if it's the same window
	{
		nWindow := WinExist("ahk_class " sClass)
		accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindow))
	}
	Try sURL := accAddressBar.accValue(0)
	If (sURL == "") {
		WinGet, nWindows, List, % "ahk_class " sClass ; In case of a nested browser window as in the old CoolNovo (TO DO: check if still needed)
		If (nWindows > 1) {
			accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindows2))
			Try sURL := accAddressBar.accValue(0)
		}
	}
	If ((sURL != "") and (SubStr(sURL, 1, 4) != "http")) ; Modern browsers omit "http://"
		sURL := "http://" sURL
	If (sURL == "")
		nWindow := -1 ; Don't remember the window if there is no URL
	Return sURL
}

; "GetAddressBar" based in code by uname
; Found at http://autohotkey.com/board/topic/103178-/?p=637687

GetAddressBar(accObj) {
	Try If ((accObj.accRole(0) == 42) and IsURL(accObj.accValue(0)))
		Return accObj
	Try If ((accObj.accRole(0) == 42) and IsURL("http://" accObj.accValue(0))) ; Modern browsers omit "http://"
		Return accObj
	For nChild, accChild in Acc_Children(accObj)
		If IsObject(accAddressBar := GetAddressBar(accChild))
			Return accAddressBar
}

IsURL(sURL) {
	Return RegExMatch(sURL, "^(?<Protocol>https?|ftp)://(?<Domain>(?:[\w-]+\.)+\w\w+)(?::(?<Port>\d+))?/?(?<Path>(?:[^:/?# ]*/?)+)(?:\?(?<Query>[^#]+)?)?(?:\#(?<Hash>.+)?)?$")
}

; The code below is part of the Acc.ahk Standard Library by Sean (updated by jethrow)
; Found at http://autohotkey.com/board/topic/77303-/?p=491516

Acc_Init()
{
	static h
	If Not h
		h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}
Acc_ObjectFromWindow(hWnd, idObject = 0)
{
	Acc_Init()
	If DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
	Return ComObjEnwrap(9,pacc,1)
}
Acc_Query(Acc) {
	Try Return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}
Acc_Children(Acc) {
	Try{
		If ComObjType(Acc,"Name") != "IAccessible"
			ErrorLevel := "Invalid IAccessible Object"
		Else {
			Acc_Init(), cChildren:=Acc.accChildCount, Children:=[]
			If DllCall("oleacc\AccessibleChildren", "Ptr",ComObjValue(Acc), "Int",0, "Int",cChildren, "Ptr",VarSetCapacity(varChildren,cChildren*(8+2*A_PtrSize),0)*0+&varChildren, "Int*",cChildren)=0 {
				Loop %cChildren%
					i:=(A_Index-1)*(A_PtrSize*2+8)+8, child:=NumGet(varChildren,i), Children.Insert(NumGet(varChildren,i-8)=9?Acc_Query(child):child), NumGet(varChildren,i-8)=9?ObjRelease(child):
				Return Children.MaxIndex()?Children:
			} Else
				ErrorLevel := "AccessibleChildren DllCall Failed"
		}
	}
}

; Backend Do Nothing
doNothing(){
Return
}

; Enable Accessibility
getColor:
	PixelGetColor, box1, %x%, %y1%, RGB
	PixelGetColor, box2, %x%, %y2%, RGB
	PixelGetColor, box5, %x%, %y3%, RGB
Return

accessibilityEnable:
	CoordMode, Mouse, Relative
	CoordMode, Pixel, Relative

	MouseGetPos, oriPosX, oriPosY

	startPage:
	Send, ^{t}
	WinWaitNotActive, Vivaldi - Vivaldi
	Sleep, 200
	If(WinActive("Start Page - Vivaldi")){
		Send, ^{l}
		Send, ^{a}
		Send, ac
		Send, {Enter}
	}else{
		Goto, startPage
	}

	WinWait, Accessibility Internals - Vivaldi
	PixelGetColor, load, 1500, 600, RGB
	while(load = "0x2E2E2E"){
		PixelGetColor, load, 1500, 600, RGB
	}
	Sleep, 100
	Gosub, getColor

	checkBoxes:
	Gosub, getColor
	while(box1 = "0xFFFFFF" && box2 = "0xFFFFFF" && box5 = "0xFFFFFF"){
		Gosub, getColor
	}
	if(box1 = "0xE6E6E6"){
		Gosub, getColor
		MouseClick, Left, %x%, %y1%, 1, 0
		Gosub, getColor
	}
	while(box1 = "0xFFFFFF" && box2 = "0xFFFFFF" && box5 = "0xFFFFFF"){
		Gosub, getColor
	}	
	if(box1 = "0xE6E6E6"){
		Goto, checkBoxes
	}

	if(box2 = "0xEAEAEA"){
		Gosub, getColor
		MouseClick, Left, %x%, %y2%, 1, 0
		Gosub, getColor
	}
	while(box1 = "0xFFFFFF" && box2 = "0xFFFFFF" && box5 = "0xFFFFFF"){
		Gosub, getColor
	}
	if(box1 = "0xE6E6E6" or box2 = "0xEAEAEA"){
		Goto, checkBoxes
	}

	PixelGetColor, gray, 104, 379, RGB
	while(gray = "0x99CFFF" or gray = "0xFFFFFF"){
		PixelGetColor, gray, 104, 379, RGB
	}

	if(box1 = "0xE6E6E6" or box2 = "0xEAEAEA"){
		Goto, checkBoxes
	}
	
	if(box5 = "0xE9E9E9" or box5 = "0xF0F0F0" or box5 = "0xFFFFFF"){
		Gosub, getColor
		MouseClick, Left, %x%, %y3%, 1, 0
		Gosub, getColor
	}
	while(box1 = "0xFFFFFF" && box2 = "0xFFFFFF" && box5 = "0xFFFFFF"){
		Gosub, getColor
	}		
	Gosub, getColor
	while(box1 = "0xFFFFFF" && box2 = "0xFFFFFF" && box5 = "0xFFFFFF"){
		Gosub, getColor
	}	
	Gosub, getColor
	if(box1 = "0xE6E6E6" or box2 = "0xEAEAEA" or box5 = "0xE9E9E9"){
		Goto, checkBoxes
	}
	MouseMove, %oriPosX%, %oriPosY%, 0
	if(WinActive("Accessibility Internals - Vivaldi")){
		Send, ^{w}
	}

	CoordMode, Mouse, Screen
	CoordMode, Pixel, Screen
Return

; Remove Tooltip
RemoveToolTip:
	ToolTip
return

; Checks if Process exists
ProcessExist(Name){
	Process,Exist,%Name%
return Errorlevel
}

; Suspend script when F1 or F2 is pressed
susVivaldi:
	~Esc::
	~LButton::
	~enter:: 
	~F1::
	~F2:: 
	suspend
	suspend,off
	Sleep, 200
	allowNum0 := 1
	Gosub, URLScript
	Gosub, urlDecision
Return

lightButtons: 
	IfWinNotExist, Lights
		return  ; Keep waiting.
	SetTimer, lightButtons, Off 
	WinActivate 
	ControlSetText, Button1, &On
	ControlSetText, Button2, &Off
return

yesNo: 
	IfWinNotExist, Yes or No
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

URLScript:
	WinWaitNotActive, Vivaldi - Vivaldi
	if(WinActive("Start Page - Vivaldi") or WinActive("Calendar - Sonarr - Vivaldi") or WinActive("Sonarr - Vivaldi") or WinActive("Activity - Sonarr - Vivaldi") or WinActive("Accessibility Internals - Vivaldi")){
		cAddress := "allowed"
		Return
	}

	cAddress := ""
	cURL := ""
	times := 0
	firstTime := 1
	getURL:
	cURL := GetBrowserURL_ACC("Chrome_WidgetWin_1")

	while pos := RegExMatch(cURL, "://\K([^/:\s]+)", m, A_Index=1?1:pos+StrLen(m))
	cAddress := m1
	if(cAddress = "" or cURL = ""){
		Goto, getURL
	}
Return
	; Disable "Disable num keys on YouTube"

urlDecision:
	if(cAddress = "www.youtube.com"){
		allowNum0 := 0
	}
	if(cAddress != "www.youtube.com"){
		allowNum0 := 1
	}
Return

teamsState:
	If !ProcessExist("Teams.exe"){													; Checks if Teams is running
		runURLScript := 1
	}else{
		runURLScript := 0
	}
Return

lbScript:
	Gosub, teamsState

	if(runURLScript = 1){										; before: runURLScript = 1 && addressBar = 1
		Gosub, URLScript
	}

	Gosub, urlDecision
Return

; Close class mode
<^>!c::
	SetTimer, closeClass, 50
	MsgBox, 0x1001, Close Class, Do you want to close Class mode?
	IfMsgBox, OK
	{
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
	;		if(!ProcessExist("livelywpf.exe")){
	;			Run, "D:\Users\Bruno\AppData\Local\Programs\Lively Wallpaper\livelywpf.exe"
	;		}
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
		MsgBox, 0x1000, Button pressed, Cancelled., 1
	}
Return

; Fatec class mode
<^>!f::
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
Return

; Start or stop recording
<^>!r::
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
Return

; English class mode
<^>!e::
	MsgBox, 0x1001, Close Class, Do you want to start English class mode?
	IfMsgBox, OK
	{
		if(!ProcessExist("NVIDIA RTX Voice.exe")){
			Run, "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe", C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice, Hide
		}
		message := "eClass"
		SetTimer, showMessage, -10
		Run, "D:\Users\Bruno\Google Drive\Cursos\Supreme Educators\Life\1 - Beginner"
		Run, "D:\Users\Bruno\Google Drive\Cursos\Supreme Educators\Life\1 - Beginner\Life Beginner Student's book.pdf", , Max
		if(ProcessExist("MusicBee.exe")){
			Process, close, MusicBee.exe
		}
;		if(ProcessExist("livelywpf.exe")){
;			Process, Close, livelywpf.exe
;		}
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
Return


; Win+H = Hibernate computer
<^>!h::
	Run, D:\Users\Bruno\Documents\Scripts\Hibernate.bat
	MsgBox, 0x1000, Hotkey Pressed, Hibernating., 1
Return


; Turn the lights On or Off
<^>!l::
	SetTimer, lightButtons, 50
	MsgBox, 0x1001, Lights, What do you want to do with the lights?
	IfMsgBox, OK
	{
		Run, D:\Users\Bruno\Documents\Scripts\Lights\On.vbs
		MsgBox, 0x1000, Button pressed, Turning the light on., 1
	}
	Else
	{
		Run, D:\Users\Bruno\Documents\Scripts\Lights\Off.vbs
		MsgBox, 0x1000, Button pressed, Turning the light off., 1
	}
Return

LAlt & w:: Send, ^{F23}

; Game mode	
<^>!g::
	Gui, Destroy
	Gui +AlwaysOnTop -0x30000
	Gui, Add, DropDownList, vGameChoice Choose1, General|Rocket League|Close
	Gui, Add, Button, gChoose, Choose
	Gui, Show, , Games
Return
#IfWinActive, ahk_class AutoHotkeyGUI
	Enter::
		Gosub, Choose
	Return
	Esc::
		Gui, Destroy
	Return
Return
Choose:
	Gui, Submit
	if(GameChoice = "General"){
		Send, ^{F23}
		Sleep, 50
		Gui, Destroy

		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"
		if(!ProcessExist("Steam.exe")){
			Run, E:\Program Files (x86)\Steam\Steam.exe
		}

		SetTimer, yesNo, 50
		MsgBox, 0x1001, Yes or No, Do you want to open Discord and RTX Voice?
		IfMsgBox, OK
		{
			Run, "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe", C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice, Hide
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Discord.bat"
			runDiscord := 1
		}

		SetTimer, stores, 50
		MsgBox, 0x1001, Stores, Which one do you want to open?
		IfMsgBox, OK
		{
			Run, steam://rungameid/14209988591219638272 ; GOG 2.0
		}
		Else
		{
			Run, steam://rungameid/17404004625060724736	; Epic Games Launcher
		}
		
		if(runDiscord = 1){
			WinWait, ahk_class RTXVoiceWindowClass
			Sleep, 200
			WinActivate, ahk_class RTXVoiceWindowClass
			WinWaitActive, ahk_class RTXVoiceWindowClass
			Send, !{F4}				
			runDiscord := 0
		}
	}

	if(GameChoice = "Rocket League"){
		Send, ^{F23}
		Sleep, 50

		if(!ProcessExist("Steam.exe")){
			Run, E:\Program Files (x86)\Steam\Steam.exe
		}
		Run, steam://rungameid/17404004625060724736	; Epic Games Launcher
		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"

		SetTimer, yesNo, 50
		MsgBox, 0x1001, Yes or No, Do you want to open Discord and RTX Voice?
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
		PixelSearch, gameX, gameY, 0, 20, 270, 540, 0xFFFFFF, 20, Fast RGB
		detected := !ErrorLevel
		while(detected = 0){
			PixelSearch, gameX, gameY, 0, 20, 270, 540, 0xFFFFFF, 20, Fast RGB
			detected := !ErrorLevel
		}
		Sleep, 200
		MouseClick, Left, 120, 330, 1, 0
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
		PixelSearch, gameX, gameY, 370, 150, 580, 435, 0x2D6DDD, 20, Fast RGB
		detected := !ErrorLevel
		while(detected = 0){
			PixelSearch, gameX, gameY, 370, 150, 580, 435, 0x2D6DDD, 20, Fast RGB
			detected := !ErrorLevel
		}
		Sleep, 200
		MouseClick, Left, 400, 480, 1, 0
		Sleep, 100
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
	}
	Gui, Destroy
Return

	; Show all the shortcuts
<^>!i:: 
	MsgBox, , List of shortcuts,
	(
AltGr+c: Close Class mode
AltGr+f: Fatec Mode
AltGr+r: Start recording with OBS
AltGr+e: English Class Mode
AltGr+h: Hibernate Computer
AltGr+l: Turn on or off the light
AltGr+g: Game mode
Alt+w: Stop Wallpaper Engine
Numpad0 or 0: Disable 0 if it's in a video
F1 or F2: Suspend for Vivaldi search
	)
Return

#IfWinActive, ahk_exe vivaldi.exe
	~$LButton::
		KeyWait, LButton, U
		KeyWait, LButton, U, T0.3
		doubleClick := ErrorLevel
		WinWaitNotActive, Vivaldi - Vivaldi
		WinGetActiveTitle, prevActiveTab
		If (doubleClick = 0 && cAddress = "www.youtube.com"){
			WinGetActiveTitle, currActiveTab
			if(prevActiveTab = currActiveTab){
				Return
			}else{
				Gosub, lbScript
			}
		}else{
			WinGetActiveTitle, currActiveTab
			if(prevActiveTab = currActiveTab){
				Return
			}else{
				Gosub, lbScript
			}
		}
	Return

	~BackSpace::
	~^w::
	~^1::
	~^2::
	~^3::
	~^4::
	~^5::
	~^6::
	~^7::
	~^8::
	~^9::
		controlState := GetKeyState("LControl", "P")
		while(controlState = 1){
			controlState := GetKeyState("LControl", "P")
		}
		WinWaitNotActive, Vivaldi - Vivaldi

		Gosub, teamsState

		if(runURLScript = 1){
			Gosub, URLScript
		}

		Gosub, urlDecision
	Return

	~F1::
		if(WinActive("ahk_exe vivaldi.exe")){
			suspend,on
		return
			Gosub, susVivaldi
		return
		}
	Return

	~F2::
		if(WinActive("ahk_exe vivaldi.exe")){
			suspend,on
		return
			Gosub, susVivaldi
		return
		}
	Return

	; Disable num keys on YouTube
	$^0::
		KeyWait, LControl
		Gosub, accessibilityEnable
	Return
	$Numpad0::
	$0::
		if(allowNum0 = 0){
				CoordMode, Mouse, Relative
				MouseGetPos, vivaldiX, vivaldiY

				if((vivaldiX > 0 && vivaldiX < 1930 && vivaldiY > 0 && vivaldiY < 180) && cAddress = "www.youtube.com"){
					ToolTip, Sending 0
					Send {Numpad0}
				}
				if(!(vivaldiX > 0 && vivaldiX < 1930 && vivaldiY > 0 && vivaldiY < 180) && cAddress = "www.youtube.com"){
					ToolTip, You are on YouTube
				}
				CoordMode, Mouse, Screen
		}
		if(allowNum0 = 1){																			; Teams is running
			Send, {Numpad0}
			if(runURLScript = 1){
				ToolTip, %cAddress%
			}else{
				ToolTip, Teams is running
			}
		}
		SetTimer, RemoveToolTip, -200
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
; 3.8 Start Nvidia RTX Voice, added MsgBox, added F1 and F2 on susVivaldi, optimized code
; 3.9 Optmized code, close and open livelywpf, improved obs recording state detection
; 4.0 solved Critical Error, optmized code, changed lively to Wallpaper Engine, changed gui to MsgBox on selection, 
;optimized temporary MsgBox, fixed close teams, improved OBS recording, msgbox always on top (0x1000 = AoT; 0x1001 = AoT + OkCancel)
; 4.1 Implemented Game mode, confirmation for class modes

; 5.0.0 Rewrote too many stuff

;	Hotkeys 		Function
;	AltGr+e			Exit Class mode
;	AltGr+f 		Fatec Mode
;	AltGr+r 		Start recording with OBS
;	AltGr+c 		Class Mode (English)
;	AltGr+h 		Hibernate Computer
;	AltGr+l 		Turn on or off the light
;	AltGr+g 		Game mode
; 	Alt+w 			Stop Wallpaper Engine
;	Numpad0 || 0	Disable 0 if it's in a video
;	F1 || F2 		Suspend for Vivaldi search

;	AltGr+i 		Shortcuts list