#include "..\Loga.au3"


;This are some of the default settings:
;Default log level $LOGA_LEVEL_TRACE
;output format: {Symbol}{LogIndex} {LevelName} {LongDateTime} {Message}
;Log to File is enabled.
;Log file name format: YYYYMMDDHHMM-Loga-InstanceIndex.log
;Custom Console is disabled by default.
;By default log to STDOUT.


Global $hLoga=_LogaNew() ;create instance with default settings
$hLoga.Level=$LOGA_LEVEL_INFO
$hLoga.LogToFile=False
_LogaRefreshSettings($hLoga) ;refresh settings
_LogaTrace("I'm Trace")
_LogaDebug("I'm Debug")
_LogaInfo("I'm Info")
_LogaWarn("I'm Warn")
_LogaError("I'm Error")
_LogaFatal("I'm Fatal")

ConsoleWrite(@CRLF)

;possible to refresh settings by string
Global $sSettings='Level="$LOGA_LEVEL_TRACE", LogToFile="true"'
_LogaRefreshSettings($hLoga,$sSettings) ;refresh settings by string
_LogaTrace("I'm Trace")
_LogaDebug("I'm Debug")
_LogaInfo("I'm Info")
_LogaWarn("I'm Warn")
_LogaError("I'm Error")
_LogaFatal("I'm Fatal")

