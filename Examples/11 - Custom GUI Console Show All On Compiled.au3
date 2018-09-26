#include "..\Loga.au3"



;By default console GUI is not show in compiled scripts
;You can enable it using _LogaShowGUIOnCompiled or enable it in settings using "ShowGUIOnCompiled" field
If not @Compiled Then Exit MsgBox(0,"Info","Run this example Compiled")

_LogaShowAllGUIOnCompiled(True) ;this will force all GUI to be shown on Compiled scripts

Local $sSettings1='LogToGUI="true", GUIBkColor="0x000000", Trans="230", ' & _
'InfoFontColor="0xd0ffbc", WarnFontColor="0x53b6ff", ErrorFontColor="0x4a22a8", ' & _
'_FatalFontColor="0x0000FF", DebugFontColor="0xffab64", TraceFontColor="0xfff0a7"'

Local $hLoga1=_LogaNew($sSettings1) ;create instance with custom settings
_LogaTrace("I'm Trace")
_LogaDebug("I'm Debug")
_LogaInfo("I'm Info")
_LogaWarn("I'm Warn")
_LogaError("I'm Error")
_LogaFatal("I'm Fatal")


Local $sSettings2='LogToGUI="true", Left="650" , AppendType="$LOGA_APPEND_TOP", ' & _
'InfoFontBkColor="0xd0ffbc", WarnFontBkColor="0x53b6ff", ErrorFontBkColor="0x4a22a8", ' & _
'_FatalFontBkColor="0x0000FF", DebugFontBkColor="0xffab64" , TraceFontBkColor="0xfff0a7", TraceFontSize="8", FatalFontSize="12"'


Local $hLoga2=_LogaNew($sSettings2) ;create instance with custom settings
;by instance index
_LogaShowGUIOnCompiled(False,$hLoga2)
_LogaTrace("I'm Trace",2)
_LogaDebug("I'm Debug",2)
_LogaInfo("I'm Info",2)
;by instance handle
_LogaWarn("I'm Warn",$hLoga2)
_LogaError("I'm Error",$hLoga2)
_LogaFatal("I'm Fatal",$hLoga2)

MsgBox(0,"Info","Instance one is shown." & @CRLF & _
"Instance Two is shown." & @CRLF & _
"Press Ok to Exit.")
