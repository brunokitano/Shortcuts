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

ModernBrowsers := "ApplicationFrameWindow,Chrome_WidgetWin_0,Chrome_WidgetWin_1,Maxthon3Cls_MainFrm,MozillaWindowClass,Slimjet_WidgetWin_1"
LegacyBrowsers := "IEFrame,OperaWindowClass"

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

/*
; Suspend script when F1 || F2 || F3 is pressed
susVivaldi:
	~$Esc::
	~$LButton::
	~$enter:: 
	~$F1::
	~$F2::
	~$F3:: 
	suspend
	suspend,off
	Sleep, 200
	allowNum0 := 1
	Gosub, URLScript
	Gosub, urlDecision
Return

GetBrowserURL_ACC(sClass){
	if(WinActive("ahk_exe vivaldi.exe")){
	global nWindow, accAddressBar
		If (nWindow != WinExist("ahk_class " sClass)) ; reuses accAddressBar if it's the same window
		{
			nWindow := WinExist("ahk_class " sClass)
			accAddressBar := GetAddressBar(Acc_ObjectFromWindow(nWindow))
		}
		Try sURL := accAddressBar.accValue(0)
		If ((sURL != "") and (SubStr(sURL, 1, 4) != "http")) ; Modern browsers omit "http://"
			sURL := "http://" sURL
		If (sURL == "")
			nWindow := -1 ; Don't remember the window if there is no URL
		Return sURL
	}
}

GetAddressBar(accObj){
	Try If ((accObj.accRole(0) == 42) and IsURL(accObj.accValue(0)))
		Return accObj
	For nChild, accChild in Acc_Children(accObj)
		If IsObject(accAddressBar := GetAddressBar(accChild))
			Return accAddressBar
}

IsURL(sURL){
	Return RegExMatch(sURL, "^(?<Protocol>https?|ftp)://(?<Domain>(?:[\w-]+\.)+\w\w+)(?::(?<Port>\d+))?/?(?<Path>(?:[^:/?# ]*/?)+)(?:\?(?<Query>[^#]+)?)?(?:\#(?<Hash>.+)?)?$")
}

Acc_Init(){
	static h
	If Not h
		h:=DllCall("LoadLibrary","Str","oleacc","Ptr")
}
Acc_ObjectFromWindow(hWnd, idObject = 0){
	Acc_Init()
	If DllCall("oleacc\AccessibleObjectFromWindow", "Ptr", hWnd, "UInt", idObject&=0xFFFFFFFF, "Ptr", -VarSetCapacity(IID,16)+NumPut(idObject==0xFFFFFFF0?0x46000000000000C0:0x719B3800AA000C81,NumPut(idObject==0xFFFFFFF0?0x0000000000020400:0x11CF3C3D618736E0,IID,"Int64"),"Int64"), "Ptr*", pacc)=0
	Return ComObjEnwrap(9,pacc,1)
}
Acc_Query(Acc){
	Try Return ComObj(9, ComObjQuery(Acc,"{618736e0-3c3d-11cf-810c-00aa00389b71}"), 1)
}
Acc_Children(Acc){
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

; Enable Accessibility
waitLoading:
	ToolTip, Waiting
	ImageSearch, imX, imY, 940, 270, 1900, 370, D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\AccessibilityEnable.png
	loadingPage := ErrorLevel
	while(!loadingPage){
		ToolTip, Loading
		MouseMove, 1400, 250, 0
		Sleep, 10
		MouseMove, 1400, 300, 0
		ImageSearch, imX, imY, 940, 270, 1900, 370, D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\AccessibilityEnable.png
		loadingPage := ErrorLevel
	}
	ToolTip, 
Return
accessibilityEnable:
	Send, #{Up}
	
	startPage:
	if(WinActive("ahk_exe vivaldi.exe")){
		WinWaitNotActive, Vivaldi - Vivaldi
		Sleep, 200
		if(!WinActive("Start Page - Vivaldi")){
			Send, ^{t Down}
			Sleep, 50
			Send, ^{t Up}
			Sleep, 50
		}
		WinWaitNotActive, Vivaldi - Vivaldi
		Sleep, 300
		If(WinActive("Start Page - Vivaldi")){
			Send, ^{l}
			Send, ^{a}
			Send, ac
			Send, {Enter}
		}else{
			Sleep, 200
			Goto, startPage
		}

		Sleep, 500
		
		WinWait, Accessibility Internals - Vivaldi
		PixelGetColor, load, 1500, 600, RGB
		while(load = "0x2E2E2E"){
			PixelGetColor, load, 1500, 600, RGB
		}
		Sleep, 400
	}

	checkBoxes:
		if(WinActive("ahk_exe vivaldi.exe")){
		PixelSearch, , , 23, 278, 79, 292, 0x808080, 10, Fast RGB ; box1
		if(ErrorLevel){
			PixelSearch, box1X, , 23, 278, 79, 292, 0xE7E7E7, 10, Fast RGB	
			MouseClick, Left, % box1X+6, % 278+6, 1, 0
		}

		Gosub, waitLoading

		PixelSearch, , , 23, 325, 79, 339, 0x808080, 10, Fast RGB ; box2
		if(ErrorLevel){
			PixelSearch, box2X, , 23, 325, 79, 339, 0xE7E7E7, 10, Fast RGB	
			MouseClick, Left, % box2X+6, % 325+6, 1, 0
		}

		Gosub, waitLoading

		PixelSearch, , , 23, 278, 79, 292, 0x808080, 10, Fast RGB ; box1
		chkBox1 := ErrorLevel
		PixelSearch, , , 23, 325, 79, 339, 0x808080, 10, Fast RGB ; box2
		chkBox2 := ErrorLevel
		if((chkBox1 = 1 || chkBox2 = 1) && WinActive("ahk_exe vivaldi.exe")){
			chkBox1 := 0
			chkBox2 := 0
			Goto, checkBoxes
		}

		PixelSearch, , , 90, 415, 230, 430, 0x6981B7, 0, Fast RGB ; wait
		chkGray := ErrorLevel
		while(!chkGray && WinActive("ahk_exe vivaldi.exe")){
			PixelSearch, , , 90, 415, 230, 430, 0x6981B7, 0, Fast RGB
			chkGray := ErrorLevel
			ToolTip, Waiting
			PixelSearch, , , 23, 278, 79, 292, 0x808080, 10, Fast RGB ; box1
			chkBox1 := ErrorLevel
			PixelSearch, , , 23, 325, 79, 339, 0x808080, 10, Fast RGB ; box2
			chkBox2 := ErrorLevel
			if((chkBox1 = 1 || chkBox2 = 1) && WinActive("ahk_exe vivaldi.exe")){
				chkBox1 := 0
				chkBox2 := 0
				Goto, checkBoxes
			}
		}
		ToolTip,

		Gosub, waitLoading

		PixelSearch, , , 23, 465, 79, 478, 0x808080, 10, Fast RGB ; box5
		if(ErrorLevel){
			PixelSearch, box3X, , 23, 465, 79, 478, 0xE7E7E7, 10, Fast RGB	
			MouseClick, Left, % box3X+6, % 465+6, 1, 0
		}

		PixelSearch, , , 23, 278, 79, 292, 0x808080, 10, Fast RGB ; box1
		chkBox1 := ErrorLevel
		PixelSearch, , , 23, 325, 79, 339, 0x808080, 10, Fast RGB ; box2
		chkBox2 := ErrorLevel
		PixelSearch, , , 23, 465, 79, 478, 0x808080, 10, Fast RGB ; box5
		chkBox5 := ErrorLevel
		if((chkBox1 = 0 && chkBox2 = 0 && chkBox5 = 0) && WinActive("ahk_exe vivaldi.exe")){
			Send, ^{w}
			Return
		}else{
			chkBox1 := 0
			chkBox2 := 0
			chkBox5 := 0
			if(WinActive("ahk_exe vivaldi.exe")){
				Goto, checkBoxes
			}
		}
	}
Return

URLScript:
	if WinActive("ahk_exe vivaldi.exe"){
		WinWaitNotActive, Vivaldi - Vivaldi

		cAddress := ""
		cURL := ""
		times := 0
		firstTime := 1
		getURL:
		times := times + 1
		cURL := GetBrowserURL_ACC("Chrome_WidgetWin_1")

		while pos := RegExMatch(cURL, "://\K([^/:\s]+)", m, A_Index=1?1:pos+StrLen(m))
		cAddress := m1

		WinGetActiveTitle, phrase
		if(WinActive("Start Page - Vivaldi") || WinActive("Accessibility Internals - Vivaldi") || InStr(phrase, "Bookmarks - ") || InStr(phrase, "Settings – ") || InStr(phrase, "Sonarr - Vivaldi")){
			cAddress := "allowed"
			Return
		}

		if((cAddress = "" || cURL = "") && WinActive("ahk_exe vivaldi.exe")){
			if(times > 10 && WinActive("ahk_exe vivaldi.exe")){
				times := 0
				Gosub, accessibilityEnable
			}else{
				if(WinActive("ahk_exe vivaldi.exe")){
					Goto, getURL
				}
			}	
		}
	}
Return

; Disable "Disable num keys on YouTube"
urlDecision:
	if(cAddress = "www.youtube.com"){
		allowNum0 := 0
	}Else{
		allowNum0 := 1
	}
	if(cAddress = ""){
		allowNum0 := 0
	}
Return

teamsState:
	If !ProcessExist("Teams.exe"){													; Checks if Teams is running
		runURLScript := 1
	}else{
		runURLScript := 0
	}
Return

chkAllScript:
	Gosub, teamsState

	if(runURLScript = 1){										; before: runURLScript = 1 && addressBar = 1
		Gosub, URLScript
	}

	Gosub, urlDecision
Return
*/

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
/*
	if(GameChoice = "Fall Guys"){
		; update to coordmode window
		fallGuys := 1
		Send, ^{F23}
		Sleep, 50

		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"

		Process, Close, steam.exe
		Sleep, 200
		Run, D:\Users\Bruno\Documents\Scripts\Shortcuts\Shortcuts\Steam Ryurrey
		WinWaitActive, ahk_class vguiPopupWindow
		Sleep, 500
		WinWait, Steam
		Sleep, 500
		WinActivate, ahk_class vguiPopupWindow, , Steam Login
		WinWaitActive, ahk_class vguiPopupWindow, , , Steam Login
		Sleep, 1000
		Send, #{Up}
		Sleep, 3000


		MouseClick, Left, 210, 50, 1, 0 ; Open Library
		Sleep, 2000
		MouseClick, Left, 100, 180, 1, 0  ; Select searchbox
		Sleep, 1000
		Send, fall
		MouseClick, Left, 100, 245, 1, 0 ; Open Fall Guys Steam page
		Sleep, 1000
		MouseClick, Left, 400, 430, 1, 0 ; Open Fall Guys
	}
*/

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

/*
#If WinActive("ahk_exe vivaldi.exe")	
	; Get the data from the website
	~$LButton::
		if(A_TimeSincePriorHotkey<400 && A_TimeSincePriorHotkey<>-1)
		{
			ToolTip, Do nothing
			Sleep, 1000
			ToolTip, 
		}else{
			ToolTip, Searching for URL
			Gosub, chkAllScript
			ToolTip,
		}
	Return

	$~Enter::
	$~BackSpace::
	$~^w::
	$~^1::
	$~^2::
	$~^3::
	$~^4::
	$~^5::
	$~^6::
	$~^7::
	$~^8::
	$~^9::
		Suspend, Off
		WinWaitNotActive, Vivaldi - Vivaldi
		Gosub, chkAllScript		
	Return

	; Disable num keys on YouTube
	$^0::
		Suspend, Off
		KeyWait, LControl
		if(WinActive("ahk_exe vivaldi.exe")){
			Gosub, accessibilityEnable
		}
	Return
	$Numpad0::
	$0::
		Suspend, Off
		if(allowNum0 = 0){
				MouseGetPos, vivaldiX, vivaldiY
				if(vivaldiX > 0 && vivaldiX < 1930 && vivaldiY > 0 && vivaldiY < 180){
					youtubeMouse := 1	
				}else{
					youtubeMouse := 0
				}
				
				if(youtubeMouse = 1 && cAddress = "www.youtube.com"){
					ToolTip, Sending 0
					Send {Numpad0}
				}else if(youtubeMouse = 0 && cAddress = "www.youtube.com"){
					ToolTip, You are on YouTube
				}else if(cAddress = ""){
					Tooltip, Blank URL
				}else{
					ToolTip, Not recognized
				}
		}else{																			; Teams is running
			Send, {Numpad0}
			if(runURLScript = 1){
				ToolTip, %cAddress%
			}else{
				ToolTip, Teams is running
			}
		}
		SetTimer, RemoveToolTip, -300
	Return

	~$F1::
	~$F2::
	~$F3::
		if(WinActive("ahk_exe vivaldi.exe")){
			suspend,on
		return
			Gosub, susVivaldi
		return
		}
	Return
Return
*/

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