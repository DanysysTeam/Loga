#include "..\Loga.au3"



;Allowed Macros
;{Symbol}
;{LogIndex}
; {LogaName}
;{LevelName}
;{Date}
;{Time}
;{DateTime}
;{LongDateTime}
;{Message}
;{Error}
;{Extended}

Global $sSettings='Format="{LevelName} {LogaName} {DateTime} {Message} ' & @TAB & 'Error={Error} Extended={Extended}", Name="AutoIt Rocks-1"'
Global $hLoga=_LogaNew($sSettings) ;create instance with custom settings
SetError(1,2) ;set @Error and @Extended for testing
_LogaTrace("I'm Trace")
_LogaDebug("I'm Debug")
_LogaInfo("I'm Info")
_LogaWarn("I'm Warn")
_LogaError("I'm Error")
_LogaFatal("I'm Fatal")

;change format
$hLoga.Format="{Symbol}{LevelName}  {DateTime} {Message}"
_LogaRefreshSettings($hLoga)
_LogaTrace("I'm Trace")
_LogaDebug("I'm Debug")
_LogaInfo("I'm Info")
_LogaWarn("I'm Warn")
_LogaError("I'm Error")
_LogaFatal("I'm Fatal")



