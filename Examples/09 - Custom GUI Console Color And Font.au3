#include "..\Loga.au3"


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
_LogaTrace("I'm Trace",2)
_LogaDebug("I'm Debug",2)
_LogaInfo("I'm Info",2)
;by instance handle
_LogaWarn("I'm Warn",$hLoga2)
_LogaError("I'm Error",$hLoga2)
_LogaFatal("I'm Fatal",$hLoga2)

MsgBox(0,"Info","Press Ok to Exit.")
