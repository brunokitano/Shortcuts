#Include, D:\Users\Bruno\Documents\Scripts\Shortcuts\Libraries\Acc.ahk
; Version: 2022.02.27.1
; https://gist.github.com/anonymous1184/7cce378c9dfdaf733cb3ca6df345b140

GetUrl(WinTitle*)
{
	hWnd := WinExist(WinTitle*)
	if (!hWnd)
		throw Exception("Couldn't find the window.", -1)
	oAcc := Acc_ObjectFromWindow(hWnd)
	oAcc := GetUrl_Recurse(oAcc)
	return oAcc.accValue(0)
}

GetUrl_Recurse(oAcc)
{
	Try if (oAcc.accValue(0) ~= "^http")
		return oAcc
	Try for i,accChild in Acc_Children(oAcc) {
		oAcc := GetUrl_Recurse(accChild)
		if IsObject(oAcc)
			return oAcc
	}
}
