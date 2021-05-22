#SingleInstance force
#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
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
;OPTIMIZATIONS END

urlFail := 0
firstTime := 1
ModernBrowsers := "ApplicationFrameWindow,Chrome_WidgetWin_0,Chrome_WidgetWin_1,Maxthon3Cls_MainFrm,MozillaWindowClass,Slimjet_WidgetWin_1"
LegacyBrowsers := "IEFrame,OperaWindowClass"

Return
Return

; Backend Get URL
GetActiveBrowserURL() {
	global ModernBrowsers, LegacyBrowsers
	WinGetClass, sClass, A
	If sClass In % ModernBrowsers
		Return GetBrowserURL_ACC(sClass)
	Else If sClass In % LegacyBrowsers
		Return GetBrowserURL_DDE(sClass) ; empty string if DDE not supported (or not a browser)
	Else
		Return ""
}

; "GetBrowserURL_DDE" adapted from DDE code by Sean, (AHK_L version by maraskan_user)
; Found at http://autohotkey.com/board/topic/17633-/?p=434518

GetBrowserURL_DDE(sClass) {
	WinGet, sServer, ProcessName, % "ahk_class " sClass
	StringTrimRight, sServer, sServer, 4
	iCodePage := A_IsUnicode ? 0x04B0 : 0x03EC ; 0x04B0 = CP_WINUNICODE, 0x03EC = CP_WINANSI
	DllCall("DdeInitialize", "UPtrP", idInst, "Uint", 0, "Uint", 0, "Uint", 0)
	hServer := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", sServer, "int", iCodePage)
	hTopic := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "WWW_GetWindowInfo", "int", iCodePage)
	hItem := DllCall("DdeCreateStringHandle", "UPtr", idInst, "Str", "0xFFFFFFFF", "int", iCodePage)
	hConv := DllCall("DdeConnect", "UPtr", idInst, "UPtr", hServer, "UPtr", hTopic, "Uint", 0)
	hData := DllCall("DdeClientTransaction", "Uint", 0, "Uint", 0, "UPtr", hConv, "UPtr", hItem, "UInt", 1, "Uint", 0x20B0, "Uint", 10000, "UPtrP", nResult) ; 0x20B0 = XTYP_REQUEST, 10000 = 10s timeout
	sData := DllCall("DdeAccessData", "Uint", hData, "Uint", 0, "Str")
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hServer)
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hTopic)
	DllCall("DdeFreeStringHandle", "UPtr", idInst, "UPtr", hItem)
	DllCall("DdeUnaccessData", "UPtr", hData)
	DllCall("DdeFreeDataHandle", "UPtr", hData)
	DllCall("DdeDisconnect", "UPtr", hConv)
	DllCall("DdeUninitialize", "UPtr", idInst)
	csvWindowInfo := StrGet(&sData, "CP0")
	StringSplit, sWindowInfo, csvWindowInfo, `" ;"; comment to avoid a syntax highlighting issue in autohotkey.com/boards
	Return sWindowInfo2
}

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

accessibilityEnable:
	WinActivate, ahk_pid 10244
	Send, ^{t}
	Winwait, Start Page - Vivaldi
	Sleep, 200
	Send, ^{l}
	Send, ^{a}
	Send, ac
	Send, {Enter}	
	WinWait, Accessibility Internals - Vivaldi
	Sleep, 300

	PixelGetColor, box1, 70, 275
	PixelGetColor, box2, 70, 320
	PixelGetColor, box3, 70, 370
	PixelGetColor, box4, 70, 415
	PixelGetColor, box5, 70, 460

	checkBoxes:
	if(box1 = "0xFFFFFF"){
		doNothing()
		Sleep, 300
	}
	if(box1 = "0xE8E8E8" || box1 = "0xFFFFFF"){
		PixelGetColor, box1, 70, 275
		MouseClick, Left, 70, 275, 1, 0
		PixelGetColor, box1, 70, 275
	}
	while(box1 = "0xFFFFFF"){
		doNothing()
		Sleep, 300
	}
	if(box1 = "0xE8E8E8"){
		Goto, checkBoxes
	}

	if(box2 = "0xECECEC" || box2 = "0xFFFFFF"){
		PixelGetColor, box2, 70, 320
		MouseClick, Left, 70, 320, 1, 0
		PixelGetColor, box2, 70, 320
	}
	while(box2 = "0xFFFFFF"){
		doNothing()
		Sleep, 300
	}
	if(box1 = "0xE8E8E8" || box2 = "0xECECEC"){
		Goto, checkBoxes
	}

	PixelGetColor, gray, 95, 370
	while(gray = "0x99CFFF"){
		Sleep, 300
		PixelGetColor, gray, 95, 370
	}

	if(box3 = "0xE5E5E5" || box3 = "0xECECEC" || box3 = "0xFFFFFF"){
		PixelGetColor, box3, 70, 370
		MouseClick, Left, 70, 370, 1, 0
		PixelGetColor, box3, 70, 370
	}
	while(box3 = "0xFFFFFF"){
		doNothing()
		Sleep, 300
	}		
	if(box1 = "0xE8E8E8" || box2 = "0xECECEC" || box3 = "0xE5E5E5"){
		Goto, checkBoxes
	}

	if(box4 = "0xE8E8E8" || box4 = "0xEEEEEE" || box4 = "0xFFFFFF"){
		PixelGetColor, box4, 70, 415
		MouseClick, Left, 70, 415, 1, 0
		PixelGetColor, box4, 70, 415
	}
	while(box4 = "0xFFFFFF"){
		doNothing()
		Sleep, 300
	}		
	if(box1 = "0xE8E8E8" || box2 = "0xECECEC" || box3 = "0xE5E5E5" || box4 = "0xE8E8E8"){
		Goto, checkBoxes
	}
	
	if(box5 = "0xEBEBEB" || box5 = "0xF0F0F0" || box5 = "0xFFFFFF"){
		PixelGetColor, box5, 70, 460
		MouseClick, Left, 70, 460, 1, 0
		PixelGetColor, box5, 70, 460
	}
	while(box5 = "0xFFFFFF"){
		doNothing()
		Sleep, 300
	}		
	PixelGetColor, box1, 70, 275
	PixelGetColor, box2, 70, 320
	PixelGetColor, box3, 70, 370
	PixelGetColor, box4, 70, 415
	PixelGetColor, box5, 70, 460
	if(box1 = "0xE8E8E8" || box2 = "0xECECEC" || box3 = "0xE5E5E5" || box4 = "0xE8E8E8" || box5 = "0xEBEBEB"){
		Sleep, 600
		Goto, checkBoxes
	}
	Send, ^{w}
	urlFail := 0
Return


YTScript:
	MouseGetPos, xPos, yPos														; Gets mouse location
	location := 0
	if((xPos > 590 && xPos < 1320 && yPos > 130 && yPos < 180) || (xPos > 180 && xPos < 1700 && yPos > 55 && yPos < 85)){
		location := 1
	}
	cURL := GetActiveBrowserURL()												; Gets URL and parses it

	while pos := RegExMatch(cURL, "://\K([^/:\s]+)", m, A_Index=1?1:pos+StrLen(m))
	cAddress := m1
	if(cAddress = ""){
		Gosub, YTScript
		urlFail := urlFail + 1
	}
	if(cAddress = "" && urlFail => 1 && urlFail <= 3){
		Gosub, accessibilityEnable
	}Else{
		if(urlFail => 3){
			MsgBox, Failed too many times
			urlFail := 0
		}
	}
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
Return
On:
	Run, D:\Users\Bruno\Documents\Scripts\Lights\On.vbs
	MsgBox, , Button pressed, Turning the light on., 1
	Gui, Cancel
Return
Off:
	Run, D:\Users\Bruno\Documents\Scripts\Lights\Off.vbs
	MsgBox, , Button pressed, Turning the light off., 1
  	Gui, Cancel
Return
GuiClose:
	Gui, Cancel
Return






#IfWinActive, ahk_exe vivaldi.exe
	; Disable "Disable num keys on Youtube"
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
	; Disable num keys on Youtube
	$Numpad0::
	$0::
		runYTScript := 0
		If !ProcessExist("Teams.exe"){													; Checks if Teams is running
			runYTScript := 1
		}Else{
			runYTScript := 0
		}
		urlFail := 0
		runAccFail := 0

		startAgain:
		cAddress := ""
		if(runYTScript = 1){						; IN VIVALDI
			if(firstTime = 1){
				Gosub, accessibilityEnable
				firstTime := 0
			}
			Gosub, YTScript

			if(cAddress = "www.youtube.com"){
				if(location = 0){
					doNothing()
				}
				if(location = 1){
					Send {Numpad0}
				}
				if(cAddress = ""){
					Goto, startAgain
				}
			}Else{
				Send {Numpad0}
			}

			if(cAddress = ""){ 															; Shows ToolTip
				ToolTip, Not recognized, xPos, yPos
				SetTimer, RemoveToolTip, -200
			}Else if(cAddress = "www.youtube.com"){
				ToolTip, YT; L = %location%, xPos, yPos
				SetTimer, RemoveToolTip, -200
			}Else{
				ToolTip, %cAddress%, xPos, yPos
				SetTimer, RemoveToolTip, -200
			}
			location := 0
		}Else{																			; NOT IN VIVALDI
			Send {Numpad0}
			ToolTip, Teams is running
			SetTimer, RemoveToolTip, -200
		}

		urlFail := 0
		runAccFail := 0
	Return

	RAlt & LButton::
		Send, {LCtrl Down}
		Sleep, 100
		Send, {LButton}{LCtrl Up}
	Return
	; Exit class mode
	RAlt & e::
		if(ProcessExist("NVIDIA RTX Voice.exe")){
			Process, Close, NVIDIA RTX Voice.exe
		}
		if(ProcessExist("Teams.exe")){
			Process, Close, Teams.exe
		}
		if(ProcessExist("obs64.exe")){
			PixelGetColor, obsC, 1594, 1062
			if(obsC = "0x0000FF"){
				Send, {F22 Down}
				Sleep, 100
				Send, {F22 Up}
				Sleep, 500
				Process, Close, obs64.exe
			}Else{
				Process, Close, obs64.exe
			}
		}
		MsgBox, , Hotkey Pressed, Class mode closed., 1
	Return
	; Fatec class mode
	RAlt & f::
		if(!ProcessExist("Teams.exe")){
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Teams.bat"
		}
		if(!ProcessExist("obs64.exe")){
			Run, "D:\Program Files\obs-studio\bin\64bit\obs64.exe", D:\Program Files\obs-studio\bin\64bit
		}
		if(!ProcessExist("NVIDIA RTX Voice.exe")){
			Run, "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe", C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice, Hide
		}
		Process, Exist, vivaldi.exe
		vivaldiPID=%Errorlevel%
		if vivaldiPID {
			WinActivate ahk_pid %vivaldiPID%
			Send, !{F4}
		}
		WinWait, ahk_class RTXVoiceWindowClass
		MsgBox, , Hotkey Pressed, Fatec class mode, 1
		WinActivate, ahk_class RTXVoiceWindowClass
		Send, !{F4}
	Return
	RAlt & r::
		PixelGetColor, obsC, 1594, 1062
		if(ProcessExist("obs64.exe")){
			if(obsC = "0x000000"){
				Send, {F22 Down}
				Sleep, 100
				Send, {F22 Up}
				MsgBox, , Hotkey Pressed, Started recording., 1
			}
			if(obsC = "0x00006A"){
				Send, {F22 Down}
				Sleep, 100
				Send, {F22 Up}
				MsgBox, , Hotkey Pressed, Stopped recording., 1
			}
			if(!(obsC = "0x00006A" || obsC = "0x000000")){
				MsgBox, Error: state not found.
			}
		}Else{
			MsgBox, , Hotkey Pressed, OBS is not running., 1
		}
	Return

	; English class mode
	RAlt & c::
		Run, "D:\Users\Bruno\Google Drive\Cursos\Supreme Educators\Life\1 - Beginner"
		Run, "D:\Users\Bruno\Google Drive\Cursos\Supreme Educators\Life\1 - Beginner\Life Beginner Student's book.pdf", , Max
		if(!ProcessExist("NVIDIA RTX Voice.exe")){
			Run, "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe", C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice, Hide
		}
		Process, Close, MusicBee.exe
		Run, https://docs.google.com/spreadsheets/d/1_K11pBdyy8-2Yl_V1QYJ5UXpPc88xxJt6B5SQAU5a-8/edit#gid=0
		Run, https://calendar.google.com/calendar/r
		WinWait, ahk_class RTXVoiceWindowClass
		MsgBox, , Hotkey Pressed, English class mode, 1
		WinActivate, ahk_class RTXVoiceWindowClass
		Send, !{F4}
	Return


	; Win+H = Hibernate computer
	RAlt & h::
		MsgBox, , Hotkey Pressed, Hibernating., 1
		Run, D:\Users\Bruno\Documents\Scripts\Hibernate.bat
	Return


	; Turn the lights On or Off
	RAlt & l::
		Gui, Add, Button, x15 y50 w50 gOn, On
		Gui, Add, Button, x+20 w50 gOff, Off
		Gui, Add, Text, x25 y15, Click a button.
		Gui, Show, w150 h80, Test
	Return
	; Show all the shortcuts
RAlt & i::
	MsgBox,	, List of shortcuts,
	(
AltGr+e: Exit Class mode
AltGr+f: Fatec Mode
AltGr+r: Start recording with OBS
AltGr+c: Class Mode (English)
AltGr+h: Hibernate Computer
AltGr+l: Turn on or off the light
Numpad0 or 0: Disable 0 if it's in a video
F1 or F2: Suspend for Vivaldi search
	)
Return
Return
#IfWinActive, 
	; Exit class mode
	RAlt & e::
		if(ProcessExist("NVIDIA RTX Voice.exe")){
			Process, Close, NVIDIA RTX Voice.exe
		}
		if(ProcessExist("Teams.exe")){
			Process, Close, Teams.exe
		}
		if(ProcessExist("obs64.exe")){
			PixelGetColor, obsC, 1594, 1062
			if(obsC = "0x0000FF"){
				Send, {F22 Down}
				Sleep, 100
				Send, {F22 Up}
				Sleep, 500
				Process, Close, obs64.exe
			}Else{
				Process, Close, obs64.exe
			}
		}
		MsgBox, , Hotkey Pressed, Class mode closed., 1
	Return
	; Fatec class mode
	RAlt & f::
		if(!ProcessExist("Teams.exe")){
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Teams.bat"
		}
		if(!ProcessExist("obs64.exe")){
			Run, "D:\Program Files\obs-studio\bin\64bit\obs64.exe", D:\Program Files\obs-studio\bin\64bit
		}
		if(!ProcessExist("NVIDIA RTX Voice.exe")){
			Run, "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe", C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice, Hide
		}
		Process, Exist, vivaldi.exe
		vivaldiPID=%Errorlevel%
		if vivaldiPID {
			WinActivate ahk_pid %vivaldiPID%
			Send, !{F4}
		}
		WinWait, ahk_class RTXVoiceWindowClass
		MsgBox, , Hotkey Pressed, Fatec class mode, 1
		WinActivate, ahk_class RTXVoiceWindowClass
		Send, !{F4}
	Return
	RAlt & r::
		PixelGetColor, obsC, 1594, 1062
		if(ProcessExist("obs64.exe")){
			if(obsC = "0x000000"){
				Send, {F22 Down}
				Sleep, 100
				Send, {F22 Up}
				MsgBox, , Hotkey Pressed, Started recording., 1
			}
			if(obsC = "0x00006A"){
				Send, {F22 Down}
				Sleep, 100
				Send, {F22 Up}
				MsgBox, , Hotkey Pressed, Stopped recording., 1
			}
			if(!(obsC = "0x00006A" || obsC = "0x000000")){
				MsgBox, Error: state not found.
			}
		}Else{
			MsgBox, , Hotkey Pressed, OBS is not running., 1
		}
	Return

	; English class mode
	RAlt & c::
		Run, "D:\Users\Bruno\Google Drive\Cursos\Supreme Educators\Life\1 - Beginner"
		Run, "D:\Users\Bruno\Google Drive\Cursos\Supreme Educators\Life\1 - Beginner\Life Beginner Student's book.pdf", , Max
		if(!ProcessExist("NVIDIA RTX Voice.exe")){
			Run, "C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice\NVIDIA RTX Voice.exe", C:\Program Files\NVIDIA Corporation\NVIDIA RTX Voice, Hide
		}
		Process, Close, MusicBee.exe
		Run, https://docs.google.com/spreadsheets/d/1_K11pBdyy8-2Yl_V1QYJ5UXpPc88xxJt6B5SQAU5a-8/edit#gid=0
		Run, https://calendar.google.com/calendar/r
		WinWait, ahk_class RTXVoiceWindowClass
		MsgBox, , Hotkey Pressed, English class mode, 1
		WinActivate, ahk_class RTXVoiceWindowClass
		Send, !{F4}
	Return


	; Win+H = Hibernate computer
	RAlt & h::
		MsgBox, , Hotkey Pressed, Hibernating., 1
		Run, D:\Users\Bruno\Documents\Scripts\Hibernate.bat
	Return


	; Turn the lights On or Off
	RAlt & l::
		Gui, Add, Button, x15 y50 w50 gOn, On
		Gui, Add, Button, x+20 w50 gOff, Off
		Gui, Add, Text, x25 y15, Click a button.
		Gui, Show, w150 h80, Test
	Return
	; Show all the shortcuts
RAlt & i::
	MsgBox,	, List of shortcuts,
	(
AltGr+e: Exit Class mode
AltGr+f: Fatec Mode
AltGr+r: Start recording with OBS
AltGr+c: Class Mode (English)
AltGr+h: Hibernate Computer
AltGr+l: Turn on or off the light
Numpad0 or 0: Disable 0 if it's in a video
F1 or F2: Suspend for Vivaldi search
	)
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


;	Hotkeys 		Function
;	AltGr+e			Exit Class mode
;	AltGr+f 		Fatec Mode
;	AltGr+r 		Start recording with OBS
;	AltGr+c 		Class Mode (English)
;	AltGr+h 		Hibernate Computer
;	AltGr+l 		Turn on or off the light
;	Numpad0 || 0	Disable 0 if it's in a video
;	F1 || F2 		Suspend for Vivaldi search

;	AltGr+i 		Shortcuts list