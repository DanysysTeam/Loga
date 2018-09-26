#include "..\Loga.au3"

;~ _LogaSetLevel($LOGA_INFO);Uncomment this line to override instances settings

Global $hLoga1 = _LogaNew() ;create new intance with default settings
Global $iCustomLevel1=BitOR($LOGA_TRACE,$LOGA_FATAL) ;this will log only Trace and Fatal
_LogaSetInstanceLevel($iCustomLevel1) ;set level default parameter is first instance

Global $hLoga2 = _LogaNew() ;create new intance with default settings
Global $iCustomLevel2=BitOR($LOGA_DEBUG,$LOGA_WARN) ;this will log only Debug and Warn
_LogaSetInstanceLevel($iCustomLevel2, 2)  ;set level using Instance handle



;Instance 1
;using Instance Index
_LogaTrace("I'm Trace", 1)
_LogaDebug("I'm Debug", 1)
_LogaInfo("I'm Info", 1)
;using Instance handle
_LogaWarn("I'm Warn", $hLoga1)
_LogaError("I'm Error", $hLoga1)
_LogaFatal("I'm Fatal", $hLoga1)

ConsoleWrite(@CRLF)

;Instance 2
;using Instance Index
_LogaTrace("I'm Trace", 2)
_LogaDebug("I'm Debug", 2)
_LogaInfo("I'm Info", 2)
;using Instance handle
_LogaWarn("I'm Warn", $hLoga2)
_LogaError("I'm Error", $hLoga2)
_LogaFatal("I'm Fatal", $hLoga2)

