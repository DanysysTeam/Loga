#include "..\Loga.au3"


;This are some of the default settings:
;Default log level $LOGA_LEVEL_TRACE
;output format: {Symbol}{LogIndex} {LevelName} {LongDateTime} {Message}
;Log to File is enabled.
;Log file name format: YYYYMMDDHHMM-Loga-InstanceIndex.log
;Custom Console is disabled by default.
;By default log to STDOUT.

Global $hLoga=_LogaNew('Level="$LOGA_LEVEL_DEBUG"')

_LogaTrace("I'm Trace")
_LogaDebug("I'm Debug")
_LogaInfo("I'm Info")
_LogaWarn("I'm Warn")
_LogaError("I'm Error")
_LogaFatal("I'm Fatal")

;In some cases there is a need to perform a group of actions depending on the current log level.

If _IfLoga($LOGA_DEBUG) Then
	MsgBox(0,"Info","Do something when Debug.")
EndIf

If _IfLoga($LOGA_TRACE) Then ;this will not run
	MsgBox(0,"Info","Do something when Trace.")
EndIf

