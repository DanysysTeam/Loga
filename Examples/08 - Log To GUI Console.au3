#include "..\Loga.au3"


Local $sSettings='LogToGUI="true"'

Local $hLoga=_LogaNew($sSettings) ;create instance with custom settings
_LogaTrace("I'm Trace")
_LogaDebug("I'm Debug")
_LogaInfo("I'm Info")
_LogaWarn("I'm Warn")
_LogaError("I'm Error")
_LogaFatal("I'm Fatal")

MsgBox(0,"Info","Lines Appended  To End")


;AppendType
;$LOGA_APPEND_END Default
;$LOGA_APPEND_TOP

;by dot access
;~ $hLoga.AppendType=$LOGA_APPEND_TOP
;~ _LogaRefreshSettings($hLoga)

;by string
_LogaRefreshSettings($hLoga,'AppendType="$LOGA_APPEND_TOP"')

_LogaDebug("I'm Debug")
_LogaTrace("I'm Trace")
_LogaDebug("I'm Debug")
_LogaInfo("I'm Info")
_LogaWarn("I'm Warn")
_LogaError("I'm Error")
_LogaFatal("I'm Fatal")

MsgBox(0,"Info","Lines Appended  To Top")