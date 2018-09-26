#include "..\Loga.au3"


Local $hLoga1 = _LogaNew()
Local $hLoga2 = _LogaNew()

;using Instance Index
_LogaTrace("I'm Trace", 1)
_LogaDebug("I'm Debug", 1)
_LogaInfo("I'm Info", 1)
;using Instance handle
_LogaWarn("I'm Warn", $hLoga1)
_LogaError("I'm Error", $hLoga1)
_LogaFatal("I'm Fatal", $hLoga1)

;using Instance Index
_LogaTrace("I'm Trace", 2)
_LogaDebug("I'm Debug", 2)
_LogaInfo("I'm Info", 2)
;using Instance handle
_LogaWarn("I'm Warn", $hLoga2)
_LogaError("I'm Error", $hLoga2)
_LogaFatal("I'm Fatal", $hLoga2)

