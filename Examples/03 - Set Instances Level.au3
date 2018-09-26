#include "..\Loga.au3"


Global $hLoga1 = _LogaNew() ;create new intance with default settings
_LogaSetInstanceLevel($LOGA_LEVEL_DEBUG) ;set level default parameter is first instance
;~  _LogaSetInstanceLevel($LOGA_LEVEL_DEBUG,1) ;set level using Instance Index
;~ _LogaSetInstanceLevel($LOGA_LEVEL_DEBUG,$hLoga1) ;set level using Instance handle

Global $hLoga2 = _LogaNew() ;create new intance with default settings
_LogaSetInstanceLevel($LOGA_LEVEL_WARN, 2)  ;set level using Instance handle
;~ _LogaSetInstanceLevel($LOGA_LEVEL_WARN, $hLoga2) ;set level using Instance Index


;Instance 1
;using Instance Index
_LogaTrace("I'm Trace. I'm out of the level.", 1)
_LogaDebug("I'm Debug", 1)
_LogaInfo("I'm Info", 1)
;using Instance handle
_LogaWarn("I'm Warn", $hLoga1)
_LogaError("I'm Error", $hLoga1)
_LogaFatal("I'm Fatal", $hLoga1)

ConsoleWrite(@CRLF)

;Instance 2
;using Instance Index
_LogaTrace("I'm Trace. I'm out of the level.", 2)
_LogaDebug("I'm Debug. I'm out of the level.", 2)
_LogaInfo("I'm Info. I'm out of the level.", 2)
;using Instance handle
_LogaWarn("I'm Warn", $hLoga2)
_LogaError("I'm Error", $hLoga2)
_LogaFatal("I'm Fatal", $hLoga2)

