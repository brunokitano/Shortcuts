#Include D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\FindText.ahk
#Include D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\GetUrl.ahk
Return

sharedVariables:
; First line is for WatchPOV
	FileReadLine, WatchPOVVar, D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt, 1
	if(WatchPOV = 0 && WatchPOVVar = 1)
		ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 1, "0")
	else if(WatchPOV = 1 && WatchPOVVar = 0)
		ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 1, "1")
	
; Second line is for WatchJoystick
	FileReadLine, WatchJoystickVar, D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt, 2
	if(WatchJoystick = 0 && WatchJoystickVar = 1)
		ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 2, "0")
	else if(WatchJoystick = 1 && WatchJoystickVar = 0)
		ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 2, "1")

;Third line is for joyButtons
	FileReadLine, joyButtonsVar, D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt, 3
	if(joyButtons = 0 && joyButtonsVar = 1)
		ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 3, "0")
	else if(joyButtons = 1 && joyButtonsVar = 0)
		ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 3, "1")

;Forth line is for WatchPOVandStick
	FileReadLine, WatchPOVandStickVar, D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt, 4
	if(WatchPOVandStick = 0 && WatchPOVandStickVar = 1)
		ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 4, "0")
	else if(WatchPOVandStick = 1 && WatchPOVandStickVar = 0)
		ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 4, "1")

;Fifth line is to joystick to read for Reloading
	FileReadLine, reloadReadVar, D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt, 5
	if(reloadRead = 0 && reloadReadVar = 1)
		ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 5, "0")
	else if(reloadRead = 1 && reloadReadVar = 0)
		ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 5, "1")

;Sixth line is to joystick to write for Reloading
	FileReadLine, reloadWriteVar, D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt, 6
	if(reloadWriteVar = 1){
		ReplaceLine("D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\sharedVariables.txt", 6, "0")
		Reload
	}
Return
ReplaceLine(filePath, strNum, text) {
   oFile := FileOpen(filePath, "rw")
   start := oFile.Pos
   Loop % strNum {
      line := oFile.ReadLine()
      if (A_Index = strNum - 1)
         start := oFile.Pos
      if (A_Index = strNum) {
         end := oFile.Pos
         rest := oFile.Read()
      }
   } until oFile.AtEOF
   if end {
      oFile.Pos := start
      oFile.Write(text . ( end + 1 > oFile.Length ? "" : RegExReplace(line, "[^`r`n]+") ))
      oFile.Write(rest)
      oFile.Length := oFile.Pos
   }
   oFile.Close()
}

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
			resFix(1080, 62, 75, 696, 280)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1080, 1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}

			resFix(1080, 62, 75, 142, 280)
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
			resFix(1080, 62, 75, 696, 280)
			if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
				resFix(1080, 1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}

			resFix(1080, 62, 75, 142, 280)
			ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WindowsMute%A_ScreenHeight%.png
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

vivaldiZoom:
	BlockInput, On
	WatchPOV := 0
	WatchJoystick := 0
	joyButtons := 0
	
	SetControlDelay, 80
	resFix(1080, 1800, 1030, 200, 10)
	if(desiredZoom = 110){
		if(useAlternate = 0)
			Text := "|<120>*109$38.tkS7sQsRX8yGQ7wbDgbtz9nt3yTaQy5zblbDy1tttnz9CQyQzknaTmDtYtUC7wsM"
		else if(useAlternate = 1)
			Text := "|<120>*89$38.lkQ7sQsNW9wGQ7waDAbly9nl3wTaQy1z7lbDy1lttnz1AQyMzUn6TWTt0lUADwsM"
		else if(useAlternate = 2)
			Text := "|<120>*97$37.nkwDsNlnAntAkzaNwoyTmQyEzDtCTUTbtbDyFnlnbzGNntnz9AtyNzAaQ1Vzb6"

		if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text)){
			Text := "|<->*96$22.zzzzzzzzzzzzzzzzzzzzzzz03zw0Dzzzzzzzzzzzzzzzzzzzzzzs"
			if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
				ControlClick, x%x% y%y%, ahk_exe vivaldi.exe, , Left, 1
		}else{
			if(useAlternate = 0)
				Text := "|<140>*96$38.tyS7sQsT78yGQ7lbDgbtsNnt3yS6Qy1zb9bDy1taNnz9CM0QzknbtmDtYtyS7wsM"
			else if(useAlternate = 1)
				Text := "|<140>*89$38.lyQ7sQsT69wGQ7laDAblsNnl3wQ6Qy1z79bDy1laNnz1AE0MzUn7tWTt0lyQDwsM"
			else if(useAlternate = 2)
				Text := "|<140>*50$39.tyA7sAQDVYT871w8nt1zD16D8Dts8ls3zC16Dw1tW8lz1DA06Ts8tyAXy9DDlUzX1U"

			if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text)){
				Text := "|<->*96$22.zzzzzzzzzzzzzzzzzzzzzzz03zw0Dzzzzzzzzzzzzzzzzzzzzzzs"
				if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
					ControlClick, x%x% y%y%, ahk_exe vivaldi.exe, , Left, 3
			}else{
				if(useAlternate = 0)
					Text := "|<Reset>*103$33.0zzzztbzzztCTzzz9n3VkUAn9gn8CRDCN9k4839aTsDtCHtYz9l11UMU"
				else if(useAlternate = 1)
					Text := "|<Reset>*102$33.1zzzztbzzznAzzzyNb3VkUAn9gmMAtDCH9UAM2NYztDnAHvAyNn13UMU"

				if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
					ControlClick, x%x% y%y%, ahk_exe vivaldi.exe, , Left, 1
			}
		}
	}else if(desiredZoom = 120){
		if(useAlternate = 0)
			Text := "|<110>*105$38.tyy7sQsSD8yGQ73bDgbtwtnt3yTCQy1zbnbDy1twtnz9CTCQzknbnmDtYtwy7wsM"
		else if(useAlternate = 1)
			Text := "|<110>*88$38.lww7sQsSC9wGQ73aDAblwtnl3wTCQy1z7nbDy1lwtnz1ATCMzUn7nWTt0lwwDwsM"
		else if(useAlternate = 2)
			Text := "|<110>*96$37.nwwDsNlsQntAksCNwoyTaQyEzDnCTUTbtbDyFnwnbzGNyNnz9AzCNzAaTbVzb6"

		if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text)){
			Text := "|<+>*120$10.wznzDww000wznzDwy"
			if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text)){
				ControlClick, x%x% y%y%, ahk_exe vivaldi.exe, , Left, 1
			}
		}else{
			if(useAlternate = 0)
				Text := "|<140>*96$38.tyS7sQsT78yGQ7lbDgbtsNnt3yS6Qy1zb9bDy1taNnz9CM0QzknbtmDtYtyS7wsM"
			else if(useAlternate = 1)
				Text := "|<140>*89$38.lyQ7sQsT69wGQ7laDAblsNnl3wQ6Qy1z79bDy1laNnz1AE0MzUn7tWTt0lyQDwsM"
			else if(useAlternate = 2)
				Text := "|<140>*50$39.tyA7sAQDVYT871w8nt1zD16D8Dts8ls3zC16Dw1tW8lz1DA06Ts8tyAXy9DDlUzX1U"

			if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text)){
				Text := "|<->*96$22.zzzzzzzzzzzzzzzzzzzzzzz03zw0Dzzzzzzzzzzzzzzzzzzzzzzs"
				if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
					ControlClick, x%x% y%y%, ahk_exe vivaldi.exe, , Left, 2
			}else{
				if(useAlternate = 0)
					Text := "|<Reset>*103$33.0zzzztbzzztCTzzz9n3VkUAn9gn8CRDCN9k4839aTsDtCHtYz9l11UMU"
				else if(useAlternate = 1)
					Text := "|<Reset>*102$33.1zzzztbzzznAzzzyNb3VkUAn9gmMAtDCH9UAM2NYztDnAHvAyNn13UMU"
				if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
					ControlClick, x%x% y%y%, ahk_exe vivaldi.exe, , Left, 1
			}
		}
	}else if(desiredZoom = 140){
		if(useAlternate = 0)
			Text := "|<110>*105$38.tyy7sQsSD8yGQ73bDgbtwtnt3yTCQy1zbnbDy1twtnz9CTCQzknbnmDtYtwy7wsM"
		else if(useAlternate = 1)
			Text := "|<110>*88$38.lww7sQsSC9wGQ73aDAblwtnl3wTCQy1z7nbDy1lwtnz1ATCMzUn7nWTt0lwwDwsM"
		else if(useAlternate = 2)
			Text := "|<110>*96$37.nwwDsNlsQntAksCNwoyTaQyEzDnCTUTbtbDyFnwnbzGNyNnz9AzCNzAaTbVzb6"

		if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text)){
			Text := "|<+>*120$10.wznzDww000wznzDwy"
			if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
				ControlClick, x%x% y%y%, ahk_exe vivaldi.exe, , Left, 3
		}else{
			if(useAlternate = 0)
				Text := "|<120>*109$38.tkS7sQsRX8yGQ7wbDgbtz9nt3yTaQy5zblbDy1tttnz9CQyQzknaTmDtYtUC7wsM"
			else if(useAlternate = 1)
				Text := "|<120>*89$38.lkQ7sQsNW9wGQ7waDAbly9nl3wTaQy1z7lbDy1lttnz1AQyMzUn6TWTt0lUADwsM"
			else if(useAlternate = 2)
				Text := "|<120>*97$37.nkwDsNlnAntAkzaNwoyTmQyEzDtCTUTbtbDyFnlnbzGNntnz9AtyNzAaQ1Vzb6"

			if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text)){
				Text := "|<+>*120$10.wznzDww000wznzDwy"
				if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
					ControlClick, x%x% y%y%, ahk_exe vivaldi.exe, , Left, 2
			}else{
				if(useAlternate = 0)
					Text := "|<Reset>*103$33.0zzzztbzzztCTzzz9n3VkUAn9gn8CRDCN9k4839aTsDtCHtYz9l11UMU"
				else if(useAlternate = 1)
					Text := "|<Reset>*102$33.1zzzztbzzznAzzzyNb3VkUAn9gmMAtDCH9UAM2NYztDnAHvAyNn13UMU"

				if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
					ControlClick, x%x% y%y%, ahk_exe vivaldi.exe, , Left, 1
			}
		}
	}
	ControlClick, , ahk_exe vivaldi.exe, , Left, 1, U
	SetControlDelay, 0
	BlockInput, Off
	WatchPOV := 1
	WatchJoystick := 1
	joyButtons := 1
Return
checkFindText:
	resFix(1080, 1800, 1030, 200, 10)
	useAlternate := ""

	Text := "|<Reset>*103$33.0zzzztbzzztCTzzz9n3VkUAn9gn8CRDCN9k4839aTsDtCHtYz9l11UMU"
	if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text)){
		useAlternate := 0
	}else{
		Text := "|<Reset>*102$33.1zzzztbzzznAzzzyNb3VkUAn9gmMAtDCH9UAM2NYztDnAHvAyNn13UMU"
		if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
			useAlternate := 1
		else{
			Text := "|<Reset>*102$34.0zzzzwlzzzwnbzzznCMAC60nAanAkQsCQnAk483AnDy7wnYyNDnD88C32"
			if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
				useAlternate := 2
			else{
				Text := "|<resetGray>*48$33.0zzzztbzzztCTzzz9n3VkUAn9gn8CRDCN9k4839aTsDtCHtYz9l11kMU"
				if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
					useAlternate := 0
				else{
					Text := "|<resetGray>*78$33.1zzzztbzzzvCzzzzNr3VkUAn9grMStDCP9UAM3NaztDvCnvAzNn13ksU"
					if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
						useAlternate := 1
					else{
						Text := "|<resetGray>*75$33.0zzzztnzzztCTzzz9n3VkkAnBwn8CRjiNAk6839aTwjtCHtYz9t1VkQU"
						if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
							useAlternate := 2
						else{
							MsgBox, , , Error, 1
							SetTimer, programRoutine, On
							Return
						}
					}
				}
			}
		}
	}
Return
selectDesiredZoom:
	if(desiredZoom = 110){
		if(useAlternate = 0)
			Text := "|<110>*105$38.tyy7sQsSD8yGQ73bDgbtwtnt3yTCQy1zbnbDy1twtnz9CTCQzknbnmDtYtwy7wsM"
		else if(useAlternate = 1)
			Text := "|<110>*88$38.lww7sQsSC9wGQ73aDAblwtnl3wTCQy1z7nbDy1lwtnz1ATCMzUn7nWTt0lwwDwsM"
		else if(useAlternate = 2)
			Text := "|<110>*96$37.nwwDsNlsQntAksCNwoyTaQyEzDnCTUTbtbDyFnwnbzGNyNnz9AzCNzAaTbVzb6"
	}else if(desiredZoom = 120){
		if(useAlternate = 0)
			Text := "|<120>*109$38.tkS7sQsRX8yGQ7wbDgbtz9nt3yTaQy5zblbDy1tttnz9CQyQzknaTmDtYtUC7wsM"
		else if(useAlternate = 1)
			Text := "|<120>*89$38.lkQ7sQsNW9wGQ7waDAbly9nl3wTaQy1z7lbDy1lttnz1AQyMzUn6TWTt0lUADwsM"
		else if(useAlternate = 2)
			Text := "|<120>*97$37.nkwDsNlnAntAkzaNwoyTmQyEzDtCTUTbtbDyFnlnbzGNntnz9AtyNzAaQ1Vzb6"
	}else if(desiredZoom = 140){
		if(useAlternate = 0)
			Text := "|<140>*96$38.tyS7sQsT78yGQ7lbDgbtsNnt3yS6Qy1zb9bDy1taNnz9CM0QzknbtmDtYtyS7wsM"
		else if(useAlternate = 1)
			Text := "|<140>*89$38.lyQ7sQsT69wGQ7laDAblsNnl3wQ6Qy1z79bDy1laNnz1AE0MzUn7tWTt0lyQDwsM"
		else if(useAlternate = 2)
			Text := "|<140>*50$39.tyA7sAQDVYT871w8nt1zD16D8Dts8ls3zC16Dw1tW8lz1DA06Ts8tyAXy9DDlUzX1U"
	}
	zoomASCII := Text
Return
useTheOtherAlternate:
	if(whichUseAltenateWasUsed = 001){
		useAlternate := 1
		whichUseAltenateWasUsed := 011
	}else if(whichUseAltenateWasUsed = 010){
		useAlternate := 0
		whichUseAltenateWasUsed := 011
	}else if(whichUseAltenateWasUsed = 100){
		useAlternate := 0
		whichUseAltenateWasUsed := 101
	}else if(whichUseAltenateWasUsed = 011){
		useAlternate := 2
		whichUseAltenateWasUsed := 111
	}else if(whichUseAltenateWasUsed = 110){
		useAlternate := 0
		whichUseAltenateWasUsed := 111
	}else if(whichUseAltenateWasUsed = 101){
		useAlternate := 1
		whichUseAltenateWasUsed := 111
	}
Return
programRoutine:
	SetTimer, programRoutine, Off

	WinGetTitle, winTitle, A

	if(WinExist("Games") || WinExist("Resolution") || WinExist("Yes || No")
	|| WinExist("Emulators") || WinExist("Stores")){
		WinActivate, Games
		WinActivate, Resolution
		WinActivate, Yes || No
		WinActivate, Emulators
		if(WinActive("ahk_exe AutoHotkey.exe")){

			WatchPOV := 0
			WatchJoystick := 0
			joyButtons := 0
			joystickAsMouseSwitch := 0

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

			while((KeyToHoldDownPOV = KeyToHoldDownPrevPOV) && !(KeyToHoldDownPOV = "" && KeyToHoldDownPrevPOV = "")){
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
			
				SetKeyDelay -1  ; Avoid delays between keystrokes.
				if KeyToHoldDownPOV   ; There is a key to press down.
				    Send, {%KeyToHoldDownPOV%}  ; Press it down.

				if(sameKeys = 0){
					startTime := A_TickCount
					runTime := 0
					while((runTime <= 500) && (KeyToHoldDownPOV = KeyToHoldDownPrevPOV) && !(KeyToHoldDownPOV = "" && KeyToHoldDownPrevPOV = "")){
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
						runTime := A_TickCount - startTime
					}
					sameKeys++
				}else if(sameKeys > 0){
					startTime := A_TickCount
					runTime := 0
					while((runTime <= 30) && (KeyToHoldDownPOV = KeyToHoldDownPrevPOV) && !(KeyToHoldDownPOV = "" && KeyToHoldDownPrevPOV = "")){
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
						runTime := A_TickCount - startTime
					}
					sameKeys++
				}
				sameKeys := 0
			}
		}
	}

	if InStr(winTitle, "Stories", CaseSensitive := false) and InStr(winTitle, "Instagram", CaseSensitive := false){
		ImageSearch, , , 1100, 150, 1200, 250, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\InstaMuted.png
		if(!ErrorLevel){
			ControlClick, x1150 y195, ahk_exe vivaldi.exe, , Left, 1
		}
		Sleep, 300 ; Make it scan less 
	}
	if(WinActive("ahk_class Chrome_WidgetWin_1") && WinActive("ahk_exe vivaldi.exe")){
		if(WinActive("WaniKani / Lessons - Vivaldi")){
			if(significantTab != "lessons"){
				Gosub, loadingPage

				desiredZoom := 140

				Gosub, checkFindText
				if(useAlternate = 0)
					whichUseAltenateWasUsed := 001
				else if(useAlternate = 1)
					whichUseAltenateWasUsed := 010
				else if(useAlternate = 2)
					whichUseAltenateWasUsed := 100

				Gosub, selectDesiredZoom

				zoomASCII := Text

				if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
					incorrectZoom := 0
				else
					incorrectZoom := 1

				i := 0
				while(incorrectZoom && whichUseAltenateWasUsed != 111 && WinActive("WaniKani / Lessons - Vivaldi")){
					Gosub, vivaldiZoom

					if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, zoomASCII))
						incorrectZoom := 0
					else
						incorrectZoom := 1

					i++
					if(i >= 3){
						Gosub, useTheOtherAlternate
						Gosub, selectDesiredZoom
						i := 0
					}

					if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, zoomASCII))
						incorrectZoom := 0
					else
						incorrectZoom := 1
				}

				if(whichUseAltenateWasUsed = 111){
					Tooltip, Tried all alternates
					Goto, smoothTooltip			
				}

				significantTab := "lessons"
				previousURL := "lessons"
			}
		}else if(WinActive("WaniKani / Reviews - Vivaldi")){
			if(significantTab != "reviews" || significantTab != "reviewsSession"){
				KeyWait, Joy1
				KeyWait, LButton

				previousURL := sURL
				sURL := GetUrl("A")

				if(previousURL = sURL){
					SetTimer, programRoutine, On
					Return
				}
				Gosub, loadingPage

				Gosub, checkFindText
				if(useAlternate = 0)
					whichUseAltenateWasUsed := 001
				else if(useAlternate = 1)
					whichUseAltenateWasUsed := 010
				else if(useAlternate = 2)
					whichUseAltenateWasUsed := 100

				if(sURL = "https://www.wanikani.com/review" && sURL != "https://www.wanikani.com/review/session"){
					if(significantTab = "reviews"){
						SetTimer, programRoutine, On
						Return
					}

					if(A_ScreenHeight = 768){
						desiredZoom := 110
					}else if(A_ScreenHeight = 1080){
						desiredZoom := 140
					}
				}else if(sURL != "https://www.wanikani.com/review" && sURL = "https://www.wanikani.com/review/session"){
					if(significantTab = "reviewsSession"){
						SetTimer, programRoutine, On
						Return
					}

					if(A_ScreenHeight = 768){
						desiredZoom := 110
					}else if(A_ScreenHeight = 1080){
						desiredZoom := 120
					}
				}
				Gosub, selectDesiredZoom

				zoomASCII := Text

				if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
					incorrectZoom := 0
				else
					incorrectZoom := 1

				i := 0
				while((incorrectZoom && whichUseAltenateWasUsed != 111 && (WinActive("WaniKani / Reviews - Vivaldi")))){
					Gosub, vivaldiZoom

					if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, zoomASCII))
						incorrectZoom := 0
					else
						incorrectZoom := 1

					i++
					if(i >= 3){
						Gosub, useTheOtherAlternate
						Gosub, selectDesiredZoom
						i := 0
					}

					if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, zoomASCII))
						incorrectZoom := 0
					else
						incorrectZoom := 1
				}

				if(whichUseAltenateWasUsed = 111){
					Tooltip, Tried all alternates
					Goto, smoothTooltip
				}

				if(sURL = "https://www.wanikani.com/review" && sURL != "https://www.wanikani.com/review/session")
					significantTab := "reviews"
				else if(sURL != "https://www.wanikani.com/review" && sURL = "https://www.wanikani.com/review/session")
					significantTab := "reviewsSession"
			}
		}else if(WinActive("WaniKani / Dashboard - Vivaldi")){
			if(significantTab != "dashboard"){
				Gosub, loadingPage

				Gosub, checkFindText
				if(useAlternate = 0)
					whichUseAltenateWasUsed := 001
				else if(useAlternate = 1)
					whichUseAltenateWasUsed := 010
				else if(useAlternate = 2)
					whichUseAltenateWasUsed := 100

				if(A_ScreenHeight = 768){
					desiredZoom := 110
				}else if(A_ScreenHeight = 1080){
					desiredZoom := 120		
				}
				Gosub, selectDesiredZoom

				zoomASCII := Text

				if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, Text))
					incorrectZoom := 0
				else
					incorrectZoom := 1

				i := 0
				while(incorrectZoom && whichUseAltenateWasUsed != 111 && (WinActive("WaniKani / Dashboard - Vivaldi"))){
				Sleep, 1000
					Gosub, vivaldiZoom

					if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, zoomASCII))
						incorrectZoom := 0
					else
						incorrectZoom := 1

					i++
					if(i >= 3){
						Gosub, useTheOtherAlternate
						Gosub, selectDesiredZoom
						i := 0
					}

					if(ok:=FindText(X, Y, xValue0-xValue1, yValue0-yValue1, xValue0+xValue1, yValue0+yValue1, 0, 0, zoomASCII))
						incorrectZoom := 0
					else
						incorrectZoom := 1
				}

				if(whichUseAltenateWasUsed = 111){
					Tooltip, Tried all alternates
					Goto, smoothTooltip
				}

				significantTab := "dashboard"
				previousURL := "dashboard"
			}
		}
	}

	if(WinActive("ahk_class CabinetWClass") && WinActive("ahk_exe explorer.exe")){
		WinGetActiveTitle, currentDirectory
		Sleep, 50

		if(GetKeyState("1", "P") || GetKeyState("2", "P") || GetKeyState("Joy5", "P") 
		|| GetKeyState("Joy6", "P") || GetKeyState("Joy1", "P") || GetKeyState("LButton", "P")){	
			if(GetKeyState("1", "P"))
				KeyWait, 1
			else if(GetKeyState("2", "P"))
				KeyWait, 2
			else if(GetKeyState("Joy5", "P"))
				KeyWait, Joy5
			else if(GetKeyState("Joy6", "P"))
				KeyWait, Joy6
			else if(GetKeyState("Joy1", "P"))
				KeyWait, Joy1
			else if(GetKeyState("LButton", "P"))
				KeyWait, LButton

			WinGetActiveTitle, changedDirectory
			runTime := 0
			startTime := A_TickCount
			while(currentDirectory = changedDirectory && runTime <= 200){
				WinGetActiveTitle, changedDirectory
				runTime := A_TickCount - startTime
			}
			Sleep, 100
		}

		WinGetPos, , , expW, expH, A
		WinGetActiveTitle, currentDirectory
		if(previousDirectory != currentDirectory){
			if(WinActive("D:\Users\Bruno\Videos\Sonarr")){
				previousDirectory := "D:\Users\Bruno\Videos\Sonarr"
				PixelGetColor, detailsPane, % expW-50, % expH-50, Fast RGB
				if(detailsPane != "0x0E0A04")
					Send, !+{p}
			}else if(WinActive("D:\Users\Bruno\Videos\Series")){
				previousDirectory := "D:\Users\Bruno\Videos\Series"
				PixelGetColor, detailsPane, % expW-50, % expH-50, Fast RGB
				if(detailsPane != "0x0E0A04")
					Send, !+{p}
			}else{
				WinGetActiveTitle, previousDirectory
				PixelGetColor, detailsPane, % expW-50, % expH-50, Fast RGB
				if(detailsPane = "0x0E0A04")
					Send, !+{p}
			}
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
	ControlSetText, Button3, &Xbox
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

resFix(res := 0, x0 := 0, y0 := 0, x1 := 0, y1 := 0){
	global
	if(res = 1080){
		xValue0 := x0 * (A_ScreenWidth / 1920)
		xValue0 := Round(xValue0)
		yValue0 := y0 * (A_ScreenHeight / 1080)
		yValue0 := Round(yValue0)

		xValue1 := x1 * (A_ScreenWidth / 1920)
		xValue1 := Round(xValue1)
		yValue1 := y1 * (A_ScreenHeight / 1080)
		yValue1 := Round(yValue1)
	}else if(res = 768){
		xValue0 := x0 * (A_ScreenWidth / 1366)
		xValue0 := Round(xValue0)
		yValue0 := y0 * (A_ScreenHeight / 768)
		yValue0 := Round(yValue0)

		xValue1 := x1 * (A_ScreenWidth / 1366)
		xValue1 := Round(xValue1)
		yValue1 := y1 * (A_ScreenHeight / 768)
		yValue1 := Round(yValue1)
	}else if(res = 720){
		xValue0 := x0 * (A_ScreenWidth / 1280)
		xValue0 := Round(xValue0)
		yValue0 := y0 * (A_ScreenHeight / 720)
		yValue0 := Round(yValue0)

		xValue1 := x1 * (A_ScreenWidth / 1280)
		xValue1 := Round(xValue1)
		yValue1 := y1 * (A_ScreenHeight / 720)
		yValue1 := Round(yValue1)
	}
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

vivaldiFullscreen:
	resFix(768, 1330, 40, 1360, 70)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiFull%A_ScreenHeight%.png
	vivaldiFullError := ErrorLevel
	while(vivaldiFullError && WinActive("ahk_exe vivaldi.exe")){
		Send, {Esc}
		Sleep, 150

		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiFull%A_ScreenHeight%.png
		vivaldiFullError := ErrorLevel
	}
Return

GameChoose:
	Gui, Submit

	if(GameChoice = "General"){
		Send, ^{F23}
		Sleep, 50
		Gui, Destroy

		SetTimer, stores, 50
		MsgBox, 0x1203, Stores, Which Store?
		IfMsgBox, Yes
		{
			Run, steam://rungameid/14209988591219638272 ; GOG 2.0
		}
		IfMsgBox, No
		{
			Run, "C:\Users\Bruno\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Steam\Big Picture.lnk"
		}
		IfMsgBox, Cancel
		{
			Run, shell:AppsFolder\Microsoft.GamingApp_8wekyb3d8bbwe!Microsoft.Xbox.App
		}
		WinWait, Resolution, , 2
		WinActivate, Resolution

		SetTimer, resolution, 50
		MsgBox, 0x1003, Resolution, Which resolution?
		IfMsgBox, Yes
		{
			if(A_ScreenHeight != 768)
				Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\768p.bat"
		}
		IfMsgBox, No
		{
			Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\900p.bat"
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

		WinWait, Yes || No, , 2
		WinActivate, Yes || No

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
		WatchPOVandStick := 0

	Gui, Destroy
	}

	if(GameChoice = "Close"){
		Send, ^{F23}
		Sleep, 50

;		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\1080p.bat"
		if(!ProcessExist("vivaldi.exe")){
			Run, "D:\Program Files\Vivaldi\Application\vivaldi.exe"
		}
;		if(!ProcessExist("WhatsApp.exe")){
;			Run, C:\Users\Bruno\AppData\Local\WhatsApp\WhatsApp.exe
;		}
;		Run, "D:\Users\Bruno\Documents\Scripts\Shortcuts\Bats\Restart explorer.bat"

		Process, Close, NVIDIA RTX Voice.exe
		Process, Close, GalaxyClient.exe
		;Process, Close, EpicGamesLauncher.exe
		WinActivate, Xbox
		WinWaitActive, Xbox, , 2
		WinKill, Xbox
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
		WatchPOVandStick := 0
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
	resFix(1080, 1450, 1042, 1700, 1080)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1080, 1000, 600)
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

waniKaniExtensionLoading:
	MouseGetPos, mouseX, mouseY

	resFix(1080, 1350, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1080, 1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(1080, 1350, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniExtension%A_ScreenHeight%.png ; Detects if the extension is open
	waniKaniError := ErrorLevel
	if(waniKaniError){
		resFix(1080, 1820, 70)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1
		Sleep, 10

		varTime := 1300
		Sleep, %varTime%

		resFix(1080, 1350, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniExtension%A_ScreenHeight%.png ; Detects if the extension is open
		waniKaniError := ErrorLevel
	}
	waniKaniErrorTimes := 0
	while(waniKaniError && waniKaniErrorTimes < 3){
		resFix(1080, 1820, 70)
		ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1
		varTime := varTime + 500
		Sleep, %varTime%

		MouseGetPos, mouseX, mouseY
		resFix(1080, 1350, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1080, 1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}
		
		resFix(1080, 1350, 10, 1930, 360) ; (mouseX > 1400 && mouseY > 10 && mouseX < 1930 && mouseY < 360)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\WaniKaniExtension%A_ScreenHeight%.png ; Detects if the extension is open
		waniKaniError := ErrorLevel

		waniKaniErrorTimes++
	}
Return
waniKaniReviewAndLesson:
	resFix(1080, 1452, 228, 1824, 313)
	PixelSearch, waniX, waniY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x00AAFF, 20, Fast RGB ; Review
	waniKaniReview := ErrorLevel
	if(!waniKaniReview){
		Send, {Esc}
		Sleep, 10
		Run, https://www.wanikani.com/review			
	}else{
		resFix(1080, 1452, 228, 1824, 313)
		PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xF100A1, 20, Fast RGB  ; Lesson
		waniLesson := ErrorLevel
		Send, {Esc}
		Sleep, 10
		if(!waniLesson)
			Run, https://www.wanikani.com/lesson/session
	}
Return
waniKaniAuto:
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

	Gosub, vivaldiFullscreen

	MouseGetPos, mouseX, mouseY

	resFix(1080, 1600, 110, 1910, 210) ; (mouseX > 1600 && mouseY > 110 && mouseX < 1910 && mouseY < 210)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1080, 1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	if(!WinActive("WaniKani / Reviews - Vivaldi") && !WinActive("WaniKani / Lessons - Vivaldi")){
		Gosub, waniKaniExtensionLoading
		if(reviewAndLesson = 1)
			Gosub, waniKaniReviewAndLesson
		else{
			resFix(1080, 1452, 228, 1824, 313)
			PixelSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xF100A1, 20, Fast RGB  ; Lesson
			waniLesson := ErrorLevel
			Send, {Esc}
			Sleep, 10
			if(!waniLesson)
				Run, https://www.wanikani.com/lesson/session
		}
	}else{
		resFix(768, 1130, 70, 1250, 268)

		PixelSearch, wanikaniButtonX, wanikaniButtonY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x2ECC71, 20, Fast RGB
		if(!ErrorLevel){
			ControlClick, x%wanikaniButtonX% y%wanikaniButtonY%, ahk_exe vivaldi.exe, , Left, 1 ; If it's already on review/lesson page
		}else{
			Send, +{PgUp}
			Sleep, 200
			PixelSearch, wanikaniButtonX, wanikaniButtonY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0x2ECC71, 20, Fast RGB
			if(!ErrorLevel){
				ControlClick, x%wanikaniButtonX% y%wanikaniButtonY%, ahk_exe vivaldi.exe, , Left, 1 ; If it's already on review/lesson page
			}else{
				ToolTip, WaniKani Button not found
				Goto, smoothTooltip
			}
		}		
	}
Return

FxSoundTrayTip:
	TrayTip, FxSound, Changing Output to %futureOutput%, 2.5
Return
fxSoundChangeOutput:
	WinGetActiveTitle, currentActive
	Process, Close, FxSound.exe
	
	;MySearchTerm := "philco"
	MySearchTerm := "panasonic"
	 
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
	if(currentOutput = ""){ ; Realtek is the current output, change it to TV
		;textContents := StrReplace(textContents, "Speakers (Realtek High Definition Audio)", "TV-PHILCO (Intel(R) Display Audio)")
		;textContents := StrReplace(textContents, "{0.0.0.00000000}.{577cb51f-f82d-456f-8878-44ea83a018d7}", "{0.0.0.00000000}.{f80174d9-5f21-4599-8957-2852f2495fb5}")
		textContents := StrReplace(textContents, "Speakers (Realtek High Definition Audio)", "Panasonic-TV (Intel(R) Display Audio)")
		textContents := StrReplace(textContents, "{0.0.0.00000000}.{577cb51f-f82d-456f-8878-44ea83a018d7}", "{0.0.0.00000000}.{67cee19e-936e-477f-9796-c7a6f230ff1e}")
		futureOutput := "TV"
	}else{
		;textContents := StrReplace(textContents, "TV-PHILCO (Intel(R) Display Audio)", "Speakers (Realtek High Definition Audio)")
		;textContents := StrReplace(textContents, "{0.0.0.00000000}.{f80174d9-5f21-4599-8957-2852f2495fb5}", "{0.0.0.00000000}.{577cb51f-f82d-456f-8878-44ea83a018d7}")
		textContents := StrReplace(textContents, "Panasonic-TV (Intel(R) Display Audio)", "Speakers (Realtek High Definition Audio)")
		textContents := StrReplace(textContents, "{0.0.0.00000000}.{67cee19e-936e-477f-9796-c7a6f230ff1e}", "{0.0.0.00000000}.{577cb51f-f82d-456f-8878-44ea83a018d7}")
		futureOutput := "Headphone Jack"
	}
	FileDelete, C:\Users\Bruno\AppData\Roaming\FxSound\FxSound.settings
	FileAppend, %textContents%, C:\Users\Bruno\AppData\Roaming\FxSound\FxSound.settings

	SetTimer, FxSoundTrayTip, -1
	Run, C:\ProgramData\Microsoft\Windows\Start Menu\Programs\FxSound\FxSound.lnk
Return

expSelect:
	MouseGetPos, mouseX, mouseY
	if(goingDown){ 
		if(WinActive("Recycle Bin") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\desktop%A_ScreenHeight%.png
		}else if(WinActive("Desktop") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\pc%A_ScreenHeight%.png
		}else if(WinActive("This PC") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\downloads%A_ScreenHeight%.png
		}else if(WinActive("Downloads") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\sonarr%A_ScreenHeight%.png
		}else if(WinActive("D:\Users\Bruno\Videos\Sonarr") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\series%A_ScreenHeight%.png
		}else if(WinActive("D:\Users\Bruno\Videos\Series") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\documents%A_ScreenHeight%.png
		}else if(WinActive("Documents") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\media%A_ScreenHeight%.png
		}else if(WinActive("C:\Users\Bruno\Media") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\scripts%A_ScreenHeight%.png
		}else if(WinActive("D:\Users\Bruno\Documents\Scripts") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\drive1_%A_ScreenHeight%.png
			if(ErrorLevel)
				ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\drive2_%A_ScreenHeight%.png

		}else if(WinActive("D:\Users\Bruno\Google Drive") && WinActive("ahk_exe explorer.exe") && !WinActive("D:\Users\Bruno\Google Drive\Registro")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\registro1_%A_ScreenHeight%.png
			if(ErrorLevel)
				ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\registro2_%A_ScreenHeight%.png
		}else if(WinActive("D:\Users\Bruno\Google Drive\Registro") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 0, 0, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\recycleEmpty%A_ScreenHeight%.png
			if(ErrorLevel)
				ImageSearch, expX, expY, 0, 0, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\recycleFull%A_ScreenHeight%.png
		}else{
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\sonarr%A_ScreenHeight%.png
		}
	}else{
		if(WinActive("Recycle Bin") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\registro1_%A_ScreenHeight%.png
			if(ErrorLevel)
				ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\registro2_%A_ScreenHeight%.png
		}else if(WinActive("Desktop") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 0, 0, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\recycleEmpty%A_ScreenHeight%.png
			if(ErrorLevel)
				ImageSearch, expX, expY, 0, 0, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\recycleFull%A_ScreenHeight%.png
		}else if(WinActive("This PC") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\desktop%A_ScreenHeight%.png
		}else if(WinActive("Downloads") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\pc%A_ScreenHeight%.png
		}else if(WinActive("D:\Users\Bruno\Videos\Sonarr") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\downloads%A_ScreenHeight%.png
		}else if(WinActive("D:\Users\Bruno\Videos\Series") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\sonarr%A_ScreenHeight%.png
		}else if(WinActive("Documents") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\series%A_ScreenHeight%.png
		}else if(WinActive("C:\Users\Bruno\Media") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\documents%A_ScreenHeight%.png
		}else if(WinActive("D:\Users\Bruno\Documents\Scripts") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\media%A_ScreenHeight%.png
		}else if(WinActive("D:\Users\Bruno\Google Drive") && WinActive("ahk_exe explorer.exe") && !WinActive("D:\Users\Bruno\Google Drive\Registro")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\scripts%A_ScreenHeight%.png
		}else if(WinActive("D:\Users\Bruno\Google Drive\Registro") && WinActive("ahk_exe explorer.exe")){
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\drive1_%A_ScreenHeight%.png
			if(ErrorLevel)
				ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\drive2_%A_ScreenHeight%.png
		}else{
			ImageSearch, expX, expY, 10, 150, 80, 500, *20 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\ExpQA\sonarr%A_ScreenHeight%.png
		}
	}

	MouseClick, Left, %expX%, %expY%, 1, 0
	MouseMove, %mouseX%, %mouseY%
	goingDown := 0
Return

downloadsPanel:
	MouseGetPos, mouseX, mouseY
	resFix(1080, 9, 85, 50, 120)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1080, 1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(768, 1330, 40, 1360, 70)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiFull%A_ScreenHeight%.png
	if(!ErrorLevel){
;		resFix(1080, 30, 600)
;		PixelGetColor, panelExist, %xValue0%, %yValue0%, Fast RGB
;		if(!(panelExist = "0x282828" || panelExist = "0x1C1D49" || panelExist = "0x2E2F36" || panelExist = "0x020203")){
;			Send, +{F4}
;			Sleep, 400
;		}

		MouseGetPos, mouseX, mouseY
		resFix(1080, 200, 200)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1080, 1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(1080, 200, 200)
		ImageSearch, , , 0, 0, %xValue0%, %yValue0%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiDownloads%A_ScreenHeight%.png
		if(!ErrorLevel){
			Send, ^{j}
		}
	}
Return
loadingPage:
	MouseGetPos, mouseX, mouseY
	resFix(1080, 80, 40, 160, 110)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1080, 1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(1080, 80, 40, 160, 110)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiPageLoading%A_ScreenHeight%.png
	pageLoading := ErrorLevel
	while(pageLoading = 0){
		MouseGetPos, mouseX, mouseY
		resFix(1080, 80, 40, 160, 110)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1080, 1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(1080, 80, 40, 160, 110)
		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *100 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\VivaldiPageLoading%A_ScreenHeight%.png
		pageLoading := ErrorLevel
		Sleep, 50
	}
Return
isOnYt:
	MouseGetPos, mouseX, mouseY
	resFix(1080, 150, 30, 700, 90)
	if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
		resFix(1080, 1000, 600)
		MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
	}

	resFix(1080, 150, 30, 700, 90)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\URLYT1%A_ScreenHeight%.png
	ytUrl1 := ErrorLevel
	resFix(1080, 150, 30, 700, 90)
	ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\URLYT2%A_ScreenHeight%.png
	ytUrl2 := ErrorLevel
Return
actionOnYt:
	if(!ytUrl1 || !ytUrl2){
		MouseGetPos, mouseX, mouseY
		resFix(1080, 60, 360, 250, 410)
		if(mouseX > xValue0 && mouseY > yValue0 && mouseX < xValue1 && mouseY < yValue1){
			resFix(1080, 1000, 600)
			MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
		}

		resFix(1080, 0, 300, 250, 500)
;		ImageSearch, , , %xValue0%, %yValue0%, %xValue1%, %yValue1%, *TransBlack *50 D:\Users\Bruno\Documents\Scripts\Shortcuts\Images\YTHistory%A_ScreenHeight%.png
;		if(!ErrorLevel){
;			resFix(1080, 90, 160)
;			ControlClick, x%xValue0% y%yValue0%, ahk_exe vivaldi.exe, , Left, 1 ; left icons
;		}

		resFix(1080, 1750, 120, 1810, 160)
		PixelSearch, ytColorX, ytColorY, %xValue0%, %yValue0%, %xValue1%, %yValue1%, 0xCC0000, 20, Fast RGB
		if(!ErrorLevel){
			ControlClick, x%ytColorX% y%ytColorY%, ahk_exe vivaldi.exe, , Left, 1 ; notifications
			resFix(1080, 1500, 320)
			MouseMove, %xValue0%, %yValue0%, 0
		}
	}
Return

lbActions:
	resFix(1080, 500, 100)
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
			Gosub, isOnYt
			Gosub, actionOnYt
		}
	}else if(A_ScreenHeight = "768"){
		if((mouseX > 108 && mouseY > 116 && mouseX < 188 && mouseY < 132) ; YT logo
		|| (mouseX > 76 && mouseY > 38 && mouseX < 109 && mouseY < 70) ; Reload page
		|| (mouseX > 1306 && mouseY > 38 && mouseX < 1339 && mouseY < 70) ;Reload all pages
		|| (mouseX > 42 && mouseY > 8 && mouseX < 71 && mouseY < 37)){ ; First tab (YT)
			if(mouseX > 76 && mouseY > 38 && mouseX < 109 && mouseY < 70){
				resFix(1080, 1000, 600)
				MouseMove, %xValue0%, %yValue0%, 0 ; Center of the page
			}else if(mouseX > 1306 && mouseY > 38 && mouseX < 1339 && mouseY < 70){
				Send, ^{r}
			}
			Gosub, downloadsPanel
			Sleep, 500
			Gosub, isOnYt
			Gosub, actionOnYt
		}
	}
Return