#include "..\Loga.au3"


;This are some of the default settings:
;Default log level $LOGA_LEVEL_TRACE
;output format: {Symbol}{LogIndex} {LevelName} {LongDateTime} {Message}
;Log to File is enabled.
;Log file name format: YYYYMMDDHHMM-Loga-InstanceIndex.log
;Custom Console is disabled by default.
;By default log to STDOUT.

_LogaT("I'm Trace")
_LogaD("I'm Debug")
_LogaI("I'm Info")
_LogaW("I'm Warn")
_LogaE("I'm Error")
_LogaF("I'm Fatal")

