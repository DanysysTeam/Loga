#include "..\Loga.au3"



;LogFileAutoFlush Eeable vs  LogFileAutoFlush Disable
Local $sInstancesComparison = ""

Local $sSettings1 = 'FilePath="FileLoga1.log"'
Local $hLoga1 = _LogaNew($sSettings1) ;create instance with custom settings

Local $hTimer = TimerInit()
For $i = 1 To 100
	_LogaTrace("I'm Trace" & @TAB & $i)
	_LogaDebug("I'm Debug" & @TAB & $i)
	_LogaInfo("I'm Info" & @TAB & $i)
	_LogaWarn("I'm Warn" & @TAB & $i)
	_LogaError("I'm Error" & @TAB & $i)
	_LogaFatal("I'm Fatal" & @TAB & $i)
Next

$sInstancesComparison = "Time Elapsed Instance 1: " & TimerDiff($hTimer) & @CRLF

Local $sSettings2 = 'FilePath="FileLoga2.log" LogFileAutoFlush="false"'
Local $hLoga2 = _LogaNew($sSettings2) ;create instance with custom settings

$hTimer = TimerInit()
For $i = 1 To 100
	;by instance index
	_LogaTrace("I'm Trace" & @TAB & $i, 2)
	_LogaDebug("I'm Debug" & @TAB & $i, 2)
	_LogaInfo("I'm Info" & @TAB & $i, 2)
	;by instance handle
	_LogaWarn("I'm Warn" & @TAB & $i, $hLoga2)
	_LogaError("I'm Error" & @TAB & $i, $hLoga2)
	_LogaFatal("I'm Fatal" & @TAB & $i, $hLoga2)
Next

$sInstancesComparison &= "Time Elapsed Instance 2: " & TimerDiff($hTimer) & @CRLF
ConsoleWrite($sInstancesComparison)
MsgBox(0,"Info",$sInstancesComparison)


