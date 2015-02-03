#cs
InputBlocker 1.0 napísaný v AutoIt 3
Autor: Tibor Repček
Web: http://tiborepcek.com/input-blocker/
#ce

#NoTrayIcon
Opt("GUICloseOnESC", 0)
#RequireAdmin


#include <ButtonConstants.au3>
#include <Date.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

GUICreate("InputBlocker 1.0", 319, 190, -1, -1)
GUICtrlCreateLabel("Chcem zablokovať klávesnicu a myš na tomto počítači", 20, 20, 279, 17, $SS_CENTER)
GUICtrlCreateLabel("o (v sekundách)", 20, 49, 80, 17)
$inputZakazatO = GUICtrlCreateInput("", 105, 46, 50, 21, $ES_NUMBER)
GUICtrlCreateLabel("na (v minútach)", 163, 49, 80, 17)
$inputZakazatNa = GUICtrlCreateInput("", 245, 46, 50, 21, $ES_NUMBER)
GUICtrlCreateLabel("Stav:", 20, 79, 29, 17)
$labelStavSet = GUICtrlCreateLabel("Pripravený", 47, 79, 60, 17)
GUICtrlSetColor(-1, 0x006400)
GUICtrlCreateLabel("Odblokuje sa:", 130, 79, 78, 17)
$labelOdblokCas = GUICtrlCreateLabel("", 196, 79, 120, 17)
$btnZakaz = GUICtrlCreateButton("Zablokovať klávesnicu a myš", 20, 107, 278, 30)
GUICtrlSetFont(-1, 10, 800, 0, "Verdana")
GUICtrlCreateLabel("Autor: Tibor Repček, tiborepcek.com", 24, 152, 184, 17, $SS_CENTER)
$btnWeb = GUICtrlCreateButton("Web autora", 218, 146, 80, 25)
GUISetState(@SW_SHOW)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		
		Case $btnZakaz
			If GUICtrlRead($inputZakazatO) = "" Then
				GUICtrlSetBkColor($inputZakazatO, 0xff0000)
				GUICtrlSetState($inputZakazatO, $GUI_FOCUS)
			ElseIf GUICtrlRead($inputZakazatNa) = "" Then
				GUICtrlSetBkColor($inputZakazatNa, 0xff0000)
				GUICtrlSetState($inputZakazatNa, $GUI_FOCUS)
			Else
				$seconds = GUICtrlRead($inputZakazatO) * 1000
				$minutes = GUICtrlRead($inputZakazatNa) * 1000
				$minutes = $minutes * 60
				Sleep($seconds)
				GUICtrlSetData($labelStavSet, "Zakázaný")
				GUICtrlSetColor($labelStavSet, 0xff0000)
				$odblokCas = _DateAdd("n", GUICtrlRead($inputZakazatNa), _NowCalc())
				$odblokCas = StringSplit($odblokCas, "/")
				$odblokCasTime = StringSplit($odblokCas[3], " ")
				$odblokCasFinal = $odblokCasTime[1] & ". " & $odblokCas[2] & ". " & $odblokCas[1] & " o " & StringTrimRight($odblokCasTime[2], 3)
				GUICtrlSetData($labelOdblokCas,  $odblokCasFinal)
				GUICtrlSetColor($labelOdblokCas, 0x006400)
				BlockInput(1)
				$mysPozicia = MouseGetPos()
				Beep(100, 2000)
				While 1
					Sleep(1000)
					$mysPoziciaNova = MouseGetPos()
					If $odblokCasFinal = @MDAY & ". " & @MON & ". " & @YEAR & " o " & @HOUR & ":" & @MIN Or $mysPozicia[0] & $mysPozicia[1] <> $mysPoziciaNova[0] & $mysPoziciaNova[1] Then
						BlockInput(0)
						Beep(100, 2000)
						GUICtrlSetData($labelOdblokCas,  "")
						GUICtrlSetData($labelStavSet, "Pripravený")
						GUICtrlSetColor($labelStavSet, 0x006400)
						ExitLoop
					Else
						ContinueLoop
					EndIf
				WEnd
			EndIf
			
		Case $btnWeb
			ShellExecute("http://tiborepcek.com/")

	EndSwitch
WEnd
