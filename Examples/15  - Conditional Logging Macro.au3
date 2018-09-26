#include "..\Loga.au3"


;This are some of the default settings:
;Default log level $LOGA_LEVEL_TRACE
;output format: {Symbol}{LogIndex} {LevelName} {LongDateTime} {Message}
;Log to File is enabled.
;Log file name format: YYYYMMDDHHMM-Loga-InstanceIndex.log
;Custom Console is disabled by default.
;By default log to STDOUT.

Local $hLoga=_LogaNew()

Local $iVariable1=1
Local $iVariable2=1
_LogaTraceIf($iVariable1=$iVariable2, "$iVariable1 and $iVariable2 are equals.")
_LogaDebug("I'm Debug")
_LogaInfo("I'm Info")
_LogaWarnIf($iVariable1<10,"$iVariable1 less than 10.")
_LogaError("I'm Error")
_LogaFatal("I'm Fatal")


