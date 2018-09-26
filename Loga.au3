#cs Copyright
	Copyright 2018 Danysys. <hello@danysys.com>

	Licensed under the MIT license.
	See LICENSE file or go to https://opensource.org/licenses/MIT for details.
#ce Copyright

#cs Information
	Author(s)......: Danyfirex & Dany3j
	Description....: Loga is a simple logging library to keep track of code with an integrated console.
	Version........: 1.0.0
	AutoIt Version.: 3.3.14.5
#ce Information

#Region Settings
#AutoIt3Wrapper_AU3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#EndRegion Settings

#Region Include
#include-once
#include <GUIConstants.au3>
#include <GuiRichEdit.au3>
#include <EditConstants.au3>
#include <WinAPI.au3>
#EndRegion Include

; #VARIABLES# ===================================================================================================================
#Region - Internal Varibales
Global $__g_iLogaInstances = 0 ;number of instances
Global $__g_atLogaInstances[0] ;array of instances (array if structures)
Global $__g_aaLogaInstances[0] ;array of Instances (array of arrays)
Global $__g_hLogaCallback = 0 ;subclass callback handle
Global $__g_pLogaCallback = 0 ;subclass callback pointer
Global $__g_bShowAllGUIOnCompiled = False
Global $__g_iLevel = -1 ;global level override instance levels
#EndRegion - Internal Varibales
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
#Region - Public Constants
Global Const $LOGA_ALL = 64
Global Const $LOGA_TRACE = 32
Global Const $LOGA_DEBUG = 16
Global Const $LOGA_INFO = 8
Global Const $LOGA_WARN = 4
Global Const $LOGA_ERROR = 2
Global Const $LOGA_FATAL = 1

Global Const $LOGA_LEVEL_ALL = BitOR($LOGA_ALL, $LOGA_TRACE, $LOGA_DEBUG, $LOGA_INFO, $LOGA_WARN, $LOGA_ERROR, $LOGA_FATAL)
Global Const $LOGA_LEVEL_TRACE = BitOR($LOGA_TRACE, $LOGA_DEBUG, $LOGA_INFO, $LOGA_WARN, $LOGA_ERROR, $LOGA_FATAL)
Global Const $LOGA_LEVEL_DEBUG = BitOR($LOGA_DEBUG, $LOGA_INFO, $LOGA_WARN, $LOGA_ERROR, $LOGA_FATAL)
Global Const $LOGA_LEVEL_INFO = BitOR($LOGA_INFO, $LOGA_WARN, $LOGA_ERROR, $LOGA_FATAL)
Global Const $LOGA_LEVEL_WARN = BitOR($LOGA_WARN, $LOGA_ERROR, $LOGA_FATAL)
Global Const $LOGA_LEVEL_ERROR = BitOR($LOGA_ERROR, $LOGA_FATAL)
Global Const $LOGA_LEVEL_FATAL = $LOGA_FATAL
Global Const $LOGA_LEVEL_OFF = 0 ;not log
Global Const $LOGA_LEVEL_INSTANCE = -1 ;disable global overwrite level
Global Const $LOGA_APPEND_END = 1 ;just for Logger GUI
Global Const $LOGA_APPEND_TOP = 2 ;just for Logger GUI

#EndRegion - Public Constants

#Region - Internal Constants
Global Const $__g_sLogaVersion = "1.0.0"
Global Const $__g_LogaSubClassID = 76797165 ;subclass ID
;Constants for fast access through array
Global Enum $eLOGA___InstanceIndex, $eLOGA___LogIndex, $eLOGA_Name, $eLOGA_Level, $eLOGA_LogToFile, $eLOGA_LogFileAutoFlush, $eLOGA_hFile, _
		$eLOGA_LogToGUI, $eLOGA_LogToStdError, $eLOGA_ShowGUIOnCompiled, _
		$eLOGA___hGUI, $eLOGA___hRichEdit, $eLOGA_AppendType, $eLOGA_GUIBkColor, $eLOGA_GUIShowLevelSymbol, $eLOGA_Trans, $eLOGA_Left, $eLOGA_Top, $eLOGA_Width, $eLOGA_Height, _
		$eLOGA_FilePath, $eLOGA_Format, $eLOGA_EndOfLine, _
		$eLOGA_TraceSymbol, $eLOGA_TraceFontName, $eLOGA_TraceString, $eLOGA_TraceFontColor, $eLOGA_TraceFontBkColor, $eLOGA_TraceFontSize, $eLOGA_TraceCharSet, _
		$eLOGA_DebugSymbol, $eLOGA_DebugFontName, $eLOGA_DebugString, $eLOGA_DebugFontColor, $eLOGA_DebugFontBkColor, $eLOGA_DebugFontSize, $eLOGA_DebugCharSet, _
		$eLOGA_InfoSymbol, $eLOGA_InfoFontName, $eLOGA_InfoString, $eLOGA_InfoFontColor, $eLOGA_InfoFontBkColor, $eLOGA_InfoFontSize, $eLOGA_InfoCharSet, _
		$eLOGA_WarnSymbol, $eLOGA_WarnFontName, $eLOGA_WarnString, $eLOGA_WarnFontColor, $eLOGA_WarnFontBkColor, $eLOGA_WarnFontSize, $eLOGA_WarnCharSet, _
		$eLOGA_ErrorSymbol, $eLOGA_ErrorFontName, $eLOGA_ErrorString, $eLOGA_ErrorFontColor, $eLOGA_ErrorFontBkColor, $eLOGA_ErrorFontSize, $eLOGA_ErrorCharSet, _
		$eLOGA_FatalSymbol, $eLOGA_FatalFontName, $eLOGA_FatalString, $eLOGA_FatalFontColor, $eLOGA_FatalFontBkColor, $eLOGA_FatalFontSize, $eLOGA_FatalCharSet
#EndRegion - Internal Constants
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _IfLoga
; _LogaT
; _LogaD
; _LogaI
; _LogaW
; _LogaE
; _LogaF
; _LogaTraceIf
; _LogaDebugIf
; _LogaInfoIf
; _LogaWarnIf
; _LogaErrorIf
; _LogaFatalIf
; _LogaTrace
; _LogaDebug
; _LogaInfo
; _LogaWarn
; _LogaError
; _LogaFatal
; _LogaShowGUIOnCompiled
; _LogaShowAllGUIOnCompiled
; _LogaSetLevel
; _LogaSetInstanceLevel
; _LogaGetVersion
; _LogaGetHandleFromInstanceIndex
; _LogaRemove
; _LogaFileClose
; _LogaFileFlush
; _LogaGUIShow
; _LogaGUIHide
; _LogaSetDefaultSettings
; _LogaRefreshSettings
; _LogaNew
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; __LogaCallbackProc
; __LogaFreeOnExit
; __LogaFormatMessage
; __LogaFontInfo
; __LogaWriteMessage
; __LogaGUIAppendText
; __LogaGetInstanceLevel
; __LogaRefreshSettingsFromString
; __LogaRefreshSettingsFromStructure
; __LogaRefreshGUISettings
; __LogaRefreshArrayFromStructure
; __CreateLogGUI
; __LogaGetRichEditHandleFromWindowHandle
; __LogaLoadSettingsFromString
; __LogaSetDefaultSettings
; __LogaCreateSettingsArrayFromStructure
; ===============================================================================================================================

$__g_iLevel = $LOGA_LEVEL_INSTANCE ;set default global level
OnAutoItExitRegister('__LogaFreeOnExit') ;register free function

#Region Public Functions

Func _IfLoga($iLevel, $iLogaInstance = 1)
	Local $iInstanceLevel = __LogaGetInstanceLevel($iLogaInstance)
	If $iInstanceLevel = -1 Then Return False
	Return BitAND($iLevel, $iInstanceLevel) = $iLevel
EndFunc   ;==>_IfLoga

Func _LogaT($sLogaMessage, $iLogaInstance = 1)
	__LogaWriteMessage($sLogaMessage, $LOGA_TRACE, $iLogaInstance)
EndFunc   ;==>_LogaT

Func _LogaD($sLogaMessage, $iLogaInstance = 1)
	__LogaWriteMessage($sLogaMessage, $LOGA_DEBUG, $iLogaInstance)
EndFunc   ;==>_LogaD


Func _LogaI($sLogaMessage, $iLogaInstance = 1)
	__LogaWriteMessage($sLogaMessage, $LOGA_INFO, $iLogaInstance)
EndFunc   ;==>_LogaI

Func _LogaW($sLogaMessage, $iLogaInstance = 1)
	__LogaWriteMessage($sLogaMessage, $LOGA_WARN, $iLogaInstance)
EndFunc   ;==>_LogaW

Func _LogaE($sLogaMessage, $iLogaInstance = 1)
	__LogaWriteMessage($sLogaMessage, $LOGA_ERROR, $iLogaInstance)
EndFunc   ;==>_LogaE

Func _LogaF($sLogaMessage, $iLogaInstance = 1)
	__LogaWriteMessage($sLogaMessage, $LOGA_FATAL, $iLogaInstance)
EndFunc   ;==>_LogaF


Func _LogaTraceIf($iCondition, $sMessage, $iLogaInstance = 1)
	If $iCondition Then
		_LogaTrace($sMessage, $iLogaInstance)
	EndIf
EndFunc   ;==>_LogaTraceIf

Func _LogaDebugIf($iCondition, $sMessage, $iLogaInstance = 1)
	If $iCondition Then
		_LogaDebug($sMessage, $iLogaInstance)
	EndIf
EndFunc   ;==>_LogaDebugIf

Func _LogaInfoIf($iCondition, $sMessage, $iLogaInstance = 1)
	If $iCondition Then
		_LogaInfo($sMessage, $iLogaInstance)
	EndIf
EndFunc   ;==>_LogaInfoIf

Func _LogaWarnIf($iCondition, $sMessage, $iLogaInstance = 1)
	If $iCondition Then
		_LogaWarn($sMessage, $iLogaInstance)
	EndIf
EndFunc   ;==>_LogaWarnIf

Func _LogaErrorIf($iCondition, $sMessage, $iLogaInstance = 1)
	If $iCondition Then
		_LogaError($sMessage, $iLogaInstance)
	EndIf
EndFunc   ;==>_LogaErrorIf

Func _LogaFatalIf($iCondition, $sMessage, $iLogaInstance = 1)
	If $iCondition Then
		_LogaFatal($sMessage, $iLogaInstance)
	EndIf
EndFunc   ;==>_LogaFatalIf

Func __LogaGetInstanceLevel($iLogaInstance = 1)
	Local $iInstance = 0
	If IsDllStruct($iLogaInstance) Then
		$iInstance = $iLogaInstance.__InstanceIndex
	Else
		If $iLogaInstance > $__g_iLogaInstances Or $iLogaInstance <= 0 Then Return -1
		$iInstance = $iLogaInstance
	EndIf
	Return ($__g_aaLogaInstances[$iInstance - 1])[$eLOGA_Level]
EndFunc   ;==>__LogaGetInstanceLevel

Func _LogaTrace($sLogaMessage, $iLogaInstance = 1)
	__LogaWriteMessage($sLogaMessage, $LOGA_TRACE, $iLogaInstance)
EndFunc   ;==>_LogaTrace

Func _LogaDebug($sLogaMessage, $iLogaInstance = 1)
	__LogaWriteMessage($sLogaMessage, $LOGA_DEBUG, $iLogaInstance)
EndFunc   ;==>_LogaDebug

Func _LogaInfo($sLogaMessage, $iLogaInstance = 1)
	__LogaWriteMessage($sLogaMessage, $LOGA_INFO, $iLogaInstance)
EndFunc   ;==>_LogaInfo

Func _LogaWarn($sLogaMessage, $iLogaInstance = 1)
	__LogaWriteMessage($sLogaMessage, $LOGA_WARN, $iLogaInstance)
EndFunc   ;==>_LogaWarn

Func _LogaError($sLogaMessage, $iLogaInstance = 1)
	__LogaWriteMessage($sLogaMessage, $LOGA_ERROR, $iLogaInstance)
EndFunc   ;==>_LogaError

Func _LogaFatal($sLogaMessage, $iLogaInstance = 1)
	__LogaWriteMessage($sLogaMessage, $LOGA_FATAL, $iLogaInstance)
EndFunc   ;==>_LogaFatal

Func _LogaShowGUIOnCompiled($bShow, $iLogaInstance = 1)
	Local $iInstance = 0
	If IsDllStruct($iLogaInstance) Then
		$iInstance = $iLogaInstance.__InstanceIndex
	Else
		If $iLogaInstance > $__g_iLogaInstances Or $iLogaInstance <= 0 Then Return
		$iInstance = $iLogaInstance
	EndIf
	Local $aLoga = $__g_aaLogaInstances[$iInstance - 1]
	$aLoga[$eLOGA_ShowGUIOnCompiled] = $bShow
	GUISetState(@SW_SHOW, $aLoga[$eLOGA___hGUI])
	$__g_aaLogaInstances[$iInstance - 1] = $aLoga
EndFunc   ;==>_LogaShowGUIOnCompiled

Func _LogaShowAllGUIOnCompiled($bShow)
	$__g_bShowAllGUIOnCompiled = $bShow
EndFunc   ;==>_LogaShowAllGUIOnCompiled


Func _LogaSetLevel($iLevel)
	$__g_iLevel = $iLevel
EndFunc   ;==>_LogaSetLevel

Func _LogaSetInstanceLevel($iLevel, $iLogaInstance = 1)
	Local $iInstance = 0
	If IsDllStruct($iLogaInstance) Then
		$iInstance = $iLogaInstance.__InstanceIndex
	Else
		If $iLogaInstance > $__g_iLogaInstances Or $iLogaInstance <= 0 Then Return
		$iInstance = $iLogaInstance
	EndIf
	Local $aLoga = $__g_aaLogaInstances[$iInstance - 1]
	$aLoga[$eLOGA_Level] = $iLevel
	$__g_aaLogaInstances[$iInstance - 1] = $aLoga
EndFunc   ;==>_LogaSetInstanceLevel

Func _LogaGetVersion()
	Return $__g_sLogaVersion
EndFunc   ;==>_LogaGetVersion

Func _LogaGetHandleFromInstanceIndex($iLogaInstance = 1)
	If $iLogaInstance <= 0 Or $iLogaInstance > $__g_iLogaInstances Then Return SetError(1, 0, 0) ;not a valid instance
	Return $__g_atLogaInstances[$__g_iLogaInstances - 1]
EndFunc   ;==>_LogaGetHandleFromInstanceIndex

Func _LogaRemove($iLogaInstance = 1)
	Local $iInstance = 0
	If IsDllStruct($iLogaInstance) Then
		$iInstance = $iLogaInstance.__InstanceIndex
	Else
		If $iLogaInstance > $__g_iLogaInstances Or $iLogaInstance <= 0 Then Return
		$iInstance = $iLogaInstance
	EndIf
	If $iInstance > 0 Then
		Local $aLoga = $__g_aaLogaInstances[$iInstance - 1]
		_WinAPI_RemoveWindowSubclass($aLoga[$eLOGA___hGUI], $__g_pLogaCallback, $__g_LogaSubClassID) ;remove Subclass Instance
		$aLoga[$eLOGA___InstanceIndex] = -1
		GUIDelete($aLoga[$eLOGA___hGUI])
		$__g_aaLogaInstances[$iInstance - 1] = $aLoga ;save to global array access
	EndIf
EndFunc   ;==>_LogaRemove

Func _LogaFileClose($iLogaInstance = 1)
	Local $hFile = 0
	If IsDllStruct($iLogaInstance) Then
		$hFile = $iLogaInstance.hFile
	Else
		If $iLogaInstance > $__g_iLogaInstances Or $iLogaInstance <= 0 Then Return
		$hFile = ($__g_aaLogaInstances[$iLogaInstance - 1])[$eLOGA_hFile]
	EndIf
	$hFile = Int($hFile)
	FileFlush($hFile)
	FileClose($hFile)
EndFunc   ;==>_LogaFileClose

Func _LogaFileFlush($iLogaInstance = 1)
	Local $hFile = 0
	If IsDllStruct($iLogaInstance) Then
		$hFile = $iLogaInstance.hFile
	Else
		If $iLogaInstance > $__g_iLogaInstances Or $iLogaInstance <= 0 Then Return
		$hFile = ($__g_aaLogaInstances[$iLogaInstance - 1])[$eLOGA_hFile]
	EndIf
	FileFlush($hFile)
EndFunc   ;==>_LogaFileFlush

Func _LogaGUIShow($iLogaInstance = 1)
	Local $hGUI = 0
	If IsDllStruct($iLogaInstance) Then
		$hGUI = $iLogaInstance.__hGUI
	Else
		If $iLogaInstance > $__g_iLogaInstances Or $iLogaInstance <= 0 Then Return
		$hGUI = ($__g_aaLogaInstances[$iLogaInstance - 1])[$eLOGA___hGUI]
	EndIf
	If WinExists($hGUI) Then GUISetState(@SW_SHOW, $hGUI)
EndFunc   ;==>_LogaGUIShow

Func _LogaGUIHide($iLogaInstance = 1)
	Local $hGUI = 0
	If IsDllStruct($iLogaInstance) Then
		$hGUI = $iLogaInstance.__hGUI
	Else
		If $iLogaInstance > $__g_iLogaInstances Or $iLogaInstance <= 0 Then Return
		$hGUI = ($__g_aaLogaInstances[$iLogaInstance - 1])[$eLOGA___hGUI]
	EndIf
	If WinExists($hGUI) Then GUISetState(@SW_HIDE, $hGUI)
EndFunc   ;==>_LogaGUIHide

Func _LogaSetDefaultSettings($tLoga)
	__LogaSetDefaultSettings($tLoga)
EndFunc   ;==>_LogaSetDefaultSettings

Func _LogaRefreshSettings($tLoga, $sLogaSettings = "")
	If $sLogaSettings = "" Then
		__LogaRefreshSettingsFromStructure($tLoga)
	Else
		__LogaRefreshSettingsFromString($tLoga, $sLogaSettings)
	EndIf
EndFunc   ;==>_LogaRefreshSettings


Func _LogaNew($sLogaSettings = "")
	If Not $__g_hLogaCallback Then ;register callback once
		$__g_hLogaCallback = DllCallbackRegister('__LogaCallbackProc', 'lresult', 'hwnd;uint;wparam;lparam;uint_ptr;dword_ptr')
		$__g_pLogaCallback = DllCallbackGetPtr($__g_hLogaCallback)
	EndIf

	;create structure for allowing dot access
	Local $tLoga = DllStructCreate("uint __InstanceIndex;ulong __LogIndex;wchar Name[512];uint Level;" & _
			"bool LogToFile;bool LogFileAutoFlush;handle hFile;bool LogToGUI;bool ShowGUIOnCompiled;bool LogToStdError;" & _
			"handle __hGUI;handle __hRichEdit;int AppendType;bool GUIShowLevelSymbol;int GUIBkColor;uint Trans;int Left;int Top;int Width;int Height;" & _
			"wchar FilePath[512];wchar Format[512];wchar EndOfLine[128];" & _
			"wchar TraceSymbol[2];wchar TraceFontName[512];wchar TraceString[512];int TraceFontColor;Int TraceFontBkColor;int TraceFontSize;int TraceCharSet;" & _
			"wchar DebugSymbol[2];wchar DebugFontName[512];wchar DebugString[512];int DebugFontColor;Int DebugFontBkColor;int DebugFontSize;int DebugCharSet;" & _
			"wchar InfoSymbol[2];wchar InfoFontName[512];wchar InfoString[512];int InfoFontColor;Int InfoFontBkColor;int InfoFontSize;int InfoCharSet;" & _
			"wchar WarnSymbol[2];wchar WarnFontName[512];wchar WarnString[512];int WarnFontColor;Int WarnFontBkColor;int WarnFontSize;int WarnCharSet;" & _
			"wchar ErrorSymbol[2];wchar ErrorFontName[512];wchar ErrorString[512];int ErrorFontColor;Int ErrorFontBkColor;int ErrorFontSize;int ErrorCharSet;" & _
			"wchar FatalSymbol[2];wchar FatalFontName[512];wchar FatalString[512];int FatalFontColor;Int FatalFontBkColor;int FatalFontSize;int FatalCharSet;")

	$__g_iLogaInstances += 1 ;increment instances
	$tLoga.__InstanceIndex = $__g_iLogaInstances
	$tLoga.__LogIndex = 1

	__LogaSetDefaultSettings($tLoga) ;Create a Structure for dot access
	__LogaLoadSettingsFromString($tLoga, $sLogaSettings) ;Load settings from string
	Local $aLoga = __LogaCreateSettingsArrayFromStructure($tLoga) ;Fast access

	;load settings
	If IsArray($aLoga) Then

		If $aLoga[$eLOGA_LogToGUI] Then ;create logger GUI
			Local $aLogGUIInfo = __CreateLogGUI($aLoga[$eLOGA_Name], $aLoga[$eLOGA_Width], $aLoga[$eLOGA_Height], $aLoga[$eLOGA_Left], $aLoga[$eLOGA_Top], _
					$aLoga[$eLOGA_GUIBkColor], $aLoga[$eLOGA_Trans], $aLoga[$eLOGA_ShowGUIOnCompiled])

			$tLoga.__hGUI = $aLogGUIInfo[0] ;save GUI handle
			$tLoga.__hRichEdit = $aLogGUIInfo[1] ;save RichEdit handle

			__LogaRefreshArrayFromStructure($tLoga, $aLoga) ;refresh Array from structure

			;set subclass for handle RichEdit Console GUI resize
			_WinAPI_SetWindowSubclass($aLoga[$eLOGA___hGUI], $__g_pLogaCallback, $__g_LogaSubClassID, 0)
		EndIf

		If $aLoga[$eLOGA_LogToFile] Then ;write message to File
			If Not $aLoga[$eLOGA_LogFileAutoFlush] Then $aLoga[$eLOGA_hFile] = FileOpen($aLoga[$eLOGA_FilePath], $FO_OVERWRITE)
			$tLoga.hFile = $aLoga[$eLOGA_hFile] ;save filehandle
			__LogaRefreshArrayFromStructure($tLoga, $aLoga) ;refresh Array from structure
		EndIf

	EndIf

	ReDim $__g_atLogaInstances[$__g_iLogaInstances] ;redim global array of structures
	ReDim $__g_aaLogaInstances[$__g_iLogaInstances] ;redim global array of arrays
	$__g_atLogaInstances[$__g_iLogaInstances - 1] = $tLoga ;save global array of structures
	$__g_aaLogaInstances[$__g_iLogaInstances - 1] = $aLoga ;save global array of arrays
	Return $__g_atLogaInstances[$__g_iLogaInstances - 1] ;return Loga instance probably change to return array
EndFunc   ;==>_LogaNew

#EndRegion Public Functions


#Region Internal Functions

Func __LogaCallbackProc($hWnd, $iMsg, $wParam, $lParam, $iID, $pData)
	#forceref $iID, $pData
	Local Const $SC_CLOSE = 0xF060

	If $iMsg = $WM_SIZE Then
		Local $hRitchEdit = __LogaGetRichEditHandleFromWindowHandle($hWnd)
		If $hRitchEdit Then
			Local $NewW = _WinAPI_LoWord($lParam)
			Local $NewH = _WinAPI_HiWord($lParam)
			_WinAPI_SetWindowPos($hRitchEdit, 0, 0, 0, $NewW - 1, $NewH - 1, BitOR($SWP_NOACTIVATE, $SWP_NOZORDER))
			Return $GUI_RUNDEFMSG
		EndIf
	EndIf
	If $iMsg = $WM_SYSCOMMAND And $wParam = $SC_CLOSE Then
		GUISetState(@SW_HIDE, $hWnd)
		Return $GUI_RUNDEFMSG
	EndIf

	Return _WinAPI_DefSubclassProc($hWnd, $iMsg, $wParam, $lParam)
EndFunc   ;==>__LogaCallbackProc

Func __LogaFreeOnExit()
	Local $hGUI = 0
	For $i = 0 To $__g_iLogaInstances - 1
		_LogaFileClose(($__g_aaLogaInstances[$i])[$eLOGA_hFile])
		$hGUI = ($__g_aaLogaInstances[$i])[$eLOGA___hGUI]
		If WinExists($hGUI) Then _WinAPI_RemoveWindowSubclass($hGUI, $__g_pLogaCallback, $__g_LogaSubClassID) ;remove each Subclass Instance
	Next
	If $__g_hLogaCallback Then DllCallbackFree($__g_hLogaCallback)
EndFunc   ;==>__LogaFreeOnExit

Func __LogaFormatMessage($aLoga, $iLogaLevelType, $sLogaMessage)

	Local $sFormatedMessage = $aLoga[$eLOGA_Format]

	;Check if Symbol will be use
	If StringInStr($sFormatedMessage, "{Symbol}", 2) Then

		;replace Log Symbol
		Select

			Case $iLogaLevelType = $LOGA_TRACE
				$sFormatedMessage = StringReplace($sFormatedMessage, "{Symbol}", $aLoga[$eLOGA_TraceSymbol])

			Case $iLogaLevelType = $LOGA_DEBUG
				$sFormatedMessage = StringReplace($sFormatedMessage, "{Symbol}", $aLoga[$eLOGA_DebugSymbol])

			Case $iLogaLevelType = $LOGA_INFO
				$sFormatedMessage = StringReplace($sFormatedMessage, "{Symbol}", $aLoga[$eLOGA_InfoSymbol])

			Case $iLogaLevelType = $LOGA_WARN
				$sFormatedMessage = StringReplace($sFormatedMessage, "{Symbol}", $aLoga[$eLOGA_WarnSymbol])

			Case $iLogaLevelType = $LOGA_ERROR
				$sFormatedMessage = StringReplace($sFormatedMessage, "{Symbol}", $aLoga[$eLOGA_ErrorSymbol])

			Case $iLogaLevelType = $LOGA_FATAL
				$sFormatedMessage = StringReplace($sFormatedMessage, "{Symbol}", $aLoga[$eLOGA_FatalSymbol])

			Case Else

		EndSelect

	EndIf

	;replace date and time
	Select

		Case StringInStr($sFormatedMessage, "{LongDateTime}", 2)
			$sFormatedMessage = StringReplace($sFormatedMessage, "{LongDateTime}", StringFormat("%02d\\%02d\\%04d %02d:%02d:%02d", @MDAY, @MON, @YEAR, @HOUR, @MIN, @SEC))

		Case StringInStr($sFormatedMessage, "{DateTime}", 2)
			$sFormatedMessage = StringReplace($sFormatedMessage, "{DateTime}", StringFormat("%02d\\%02d\\%04d %02d:%02d", @MDAY, @MON, @YEAR, @HOUR, @MIN))

		Case StringInStr($sFormatedMessage, "{Date}", 2)
			$sFormatedMessage = StringReplace($sFormatedMessage, "{Date}", StringFormat("%02d\\%02d\\%04d", @MDAY, @MON, @YEAR))

		Case StringInStr($sFormatedMessage, "{Time}", 2)
			$sFormatedMessage = StringReplace($sFormatedMessage, "{Time}", StringFormat("%02d:%02d:%02d", @HOUR, @MIN, @SEC))

		Case Else

	EndSelect

	;Check if Symbol will be use
	If StringInStr($sFormatedMessage, "{LevelName}", 2) Then

		Select

			Case $iLogaLevelType = $LOGA_TRACE
				$sFormatedMessage = StringReplace($sFormatedMessage, "{LevelName}", $aLoga[$eLOGA_TraceString])

			Case $iLogaLevelType = $LOGA_DEBUG
				$sFormatedMessage = StringReplace($sFormatedMessage, "{LevelName}", $aLoga[$eLOGA_DebugString])

			Case $iLogaLevelType = $LOGA_INFO
				$sFormatedMessage = StringReplace($sFormatedMessage, "{LevelName}", $aLoga[$eLOGA_InfoString])

			Case $iLogaLevelType = $LOGA_WARN
				$sFormatedMessage = StringReplace($sFormatedMessage, "{LevelName}", $aLoga[$eLOGA_WarnString])

			Case $iLogaLevelType = $LOGA_ERROR
				$sFormatedMessage = StringReplace($sFormatedMessage, "{LevelName}", $aLoga[$eLOGA_ErrorString])

			Case $iLogaLevelType = $LOGA_FATAL
				$sFormatedMessage = StringReplace($sFormatedMessage, "{LevelName}", $aLoga[$eLOGA_FatalString])

			Case Else

		EndSelect

	EndIf

	;replace Message
	If StringInStr($sFormatedMessage, "{Message}", 2) Then
		$sFormatedMessage = StringReplace($sFormatedMessage, "{Message}", $sLogaMessage)
	EndIf

	;replace Loga Name
	If StringInStr($sFormatedMessage, "{LogaName}", 2) Then
		$sFormatedMessage = StringReplace($sFormatedMessage, "{LogaName}", $aLoga[$eLOGA_Name])
	EndIf

	;replace Log Index
	If StringInStr($sFormatedMessage, "{LogIndex}", 2) Then
		$sFormatedMessage = StringReplace($sFormatedMessage, "{LogIndex}", StringFormat("%010s", $aLoga[$eLOGA___LogIndex]))
	EndIf

	Return $sFormatedMessage & $aLoga[$eLOGA_EndOfLine]
EndFunc   ;==>__LogaFormatMessage


Func __LogaFontInfo($aLoga, $iLogaLevelType)
	Local $aInfo[5] = ["Consolas", 10, 0x000000, 0xFFFFFF, 1]
	Select

		Case $iLogaLevelType = $LOGA_TRACE
			$aInfo[0] = $aLoga[$eLOGA_TraceFontName]
			$aInfo[1] = $aLoga[$eLOGA_TraceFontSize]
			$aInfo[2] = $aLoga[$eLOGA_TraceFontColor]
			$aInfo[3] = $aLoga[$eLOGA_TraceFontBkColor]
			$aInfo[4] = $aLoga[$eLOGA_TraceCharSet]

		Case $iLogaLevelType = $LOGA_DEBUG
			$aInfo[0] = $aLoga[$eLOGA_DebugFontName]
			$aInfo[1] = $aLoga[$eLOGA_DebugFontSize]
			$aInfo[2] = $aLoga[$eLOGA_DebugFontColor]
			$aInfo[3] = $aLoga[$eLOGA_DebugFontBkColor]
			$aInfo[4] = $aLoga[$eLOGA_DebugCharSet]


		Case $iLogaLevelType = $LOGA_INFO
			$aInfo[0] = $aLoga[$eLOGA_InfoFontName]
			$aInfo[1] = $aLoga[$eLOGA_InfoFontSize]
			$aInfo[2] = $aLoga[$eLOGA_InfoFontColor]
			$aInfo[3] = $aLoga[$eLOGA_InfoFontBkColor]
			$aInfo[4] = $aLoga[$eLOGA_InfoCharSet]

		Case $iLogaLevelType = $LOGA_WARN
			$aInfo[0] = $aLoga[$eLOGA_WarnFontName]
			$aInfo[1] = $aLoga[$eLOGA_WarnFontSize]
			$aInfo[2] = $aLoga[$eLOGA_WarnFontColor]
			$aInfo[3] = $aLoga[$eLOGA_WarnFontBkColor]
			$aInfo[4] = $aLoga[$eLOGA_WarnCharSet]

		Case $iLogaLevelType = $LOGA_ERROR
			$aInfo[0] = $aLoga[$eLOGA_ErrorFontName]
			$aInfo[1] = $aLoga[$eLOGA_ErrorFontSize]
			$aInfo[2] = $aLoga[$eLOGA_ErrorFontColor]
			$aInfo[3] = $aLoga[$eLOGA_ErrorFontBkColor]
			$aInfo[4] = $aLoga[$eLOGA_ErrorCharSet]

		Case $iLogaLevelType = $LOGA_FATAL
			$aInfo[0] = $aLoga[$eLOGA_FatalFontName]
			$aInfo[1] = $aLoga[$eLOGA_FatalFontSize]
			$aInfo[2] = $aLoga[$eLOGA_FatalFontColor]
			$aInfo[3] = $aLoga[$eLOGA_FatalFontBkColor]
			$aInfo[4] = $aLoga[$eLOGA_FatalCharSet]

		Case Else

	EndSelect

	Return $aInfo
EndFunc   ;==>__LogaFontInfo


Func __LogaWriteMessage($sLogaMessage, $iLogaLevelType, $iLogaInstance = 1) ;$LOGA_ALL Log to all Instances

	If IsDllStruct($iLogaInstance) Then
		$iLogaInstance = $iLogaInstance.__InstanceIndex ;intance by handle
	Else
		If $__g_iLogaInstances = 0 Then _LogaNew() ;create New Instance if does not exist
		If $iLogaInstance > $__g_iLogaInstances Then $iLogaInstance = 1 ;if instance does not exist log to default
		If $iLogaInstance <= 0 Then $iLogaInstance = 1 ;if instance does not exist log to default
	EndIf

	Local $aLoga = $__g_aaLogaInstances[$iLogaInstance - 1]
	Local $iLevel = $aLoga[$eLOGA_Level]

	If $aLoga[$eLOGA___InstanceIndex] = -1 Then Return SetError(0, 0, 0) ;loga instance is removed

	If $iLevel = $LOGA_LEVEL_OFF Then Return SetError(0, 0, 0) ;not log

	If Not BitAND($__g_iLevel, $iLogaLevelType) Then ;check global log level
		Return SetError(0, 0, 0) ;out of Log level
	EndIf

	If $__g_iLevel = $LOGA_LEVEL_INSTANCE Then ;if global log level is set it will not handle instance levels
		If Not BitAND($iLevel, $iLogaLevelType) Then ;check global log level
			Return SetError(0, 0, 0) ;out of Log level
		EndIf
	EndIf

	Local $sFormatedMessage = __LogaFormatMessage($aLoga, $iLogaLevelType, $sLogaMessage)
	ConsoleWrite($sFormatedMessage) ;write message to console
	If $aLoga[$eLOGA_LogToStdError] Then ConsoleWriteError($sFormatedMessage) ;write to stderr

	$aLoga[$eLOGA___LogIndex] += 1 ;add log index
	$__g_aaLogaInstances[$iLogaInstance - 1] = $aLoga ;save global array


	If $aLoga[$eLOGA_LogToGUI] And ((Not @Compiled) Or $aLoga[$eLOGA_ShowGUIOnCompiled] Or $__g_bShowAllGUIOnCompiled) Then ;write message to GUI console
		Local $aFontInfo = __LogaFontInfo($aLoga, $iLogaLevelType)
		Local $FontName = $aFontInfo[0]
		Local $FontSize = $aFontInfo[1]
		Local $iFontColor = "0x" & $aFontInfo[2]
		Local $iFontBkColor = "0x" & $aFontInfo[3]
		Local $iFontCharSet = $aFontInfo[4]

		If $aLoga[$eLOGA_GUIShowLevelSymbol] Then
			__LogaGUIAppendText($aLoga[$eLOGA___hRichEdit], $sFormatedMessage, $FontName, $FontSize, _
					$iFontColor, $iFontBkColor, $iFontCharSet, $aLoga[$eLOGA_AppendType])
		Else
			Local $sSymbol = StringMid($sFormatedMessage, 1) ;get first string character
			Local $sSymbolToReplace = $aLoga[$eLOGA_DebugSymbol] & "|" & $aLoga[$eLOGA_TraceSymbol] & "|" & _ ;replaceable symbols
					$aLoga[$eLOGA_WarnSymbol] & "|" & $aLoga[$eLOGA_InfoSymbol] & "|" & $aLoga[$eLOGA_ErrorSymbol] & "|" & $aLoga[$eLOGA_FatalSymbol]

			$sSymbolToReplace = StringRegExpReplace($sSymbolToReplace, '+', '\+') ;cure + symbol
			If StringRegExp($sSymbol, $sSymbolToReplace) Then $sFormatedMessage = StringMid($sFormatedMessage, 2)
			__LogaGUIAppendText($aLoga[$eLOGA___hRichEdit], $sFormatedMessage, $FontName, $FontSize, _
					$iFontColor, $iFontBkColor, $iFontCharSet, $aLoga[$eLOGA_AppendType])
		EndIf
	EndIf

	If $aLoga[$eLOGA_LogToFile] Then ;write message to File
		If $aLoga[$eLOGA_LogFileAutoFlush] Then
			FileWrite($aLoga[$eLOGA_FilePath], $sFormatedMessage)
		Else
			FileWrite(Int($aLoga[$eLOGA_hFile]), $sFormatedMessage)
		EndIf
	EndIf
EndFunc   ;==>__LogaWriteMessage


Func __LogaGUIAppendText($hWnd, $sText, $iFontName, $iFontSize, $iFontColor, $iFontBkColor, $iFontCharSet, $iAppendType)
;~ 	_GUICtrlRichEdit_SetFont($hWnd, $iFontSize, $iFontName, $iFontCharSet)
	ConsoleWrite($iFontName & @CRLF)

	Local $iLength = _GUICtrlRichEdit_GetTextLength($hWnd, True, True)
	Local $iCp = _GUICtrlRichEdit_GetCharPosOfNextWord($hWnd, $iLength)

	If $iAppendType = $LOGA_APPEND_END Then
		_GUICtrlRichEdit_AppendText($hWnd, $sText)
		_GUICtrlRichEdit_SetSel($hWnd, $iCp - 1, $iLength + StringLen($sText), False)
	Else ;$LOGA_APPEND_TOP
		_GUICtrlRichEdit_SetSel($hWnd, 0, 0, True)
		_GUICtrlRichEdit_InsertText($hWnd, $sText)
		_GUICtrlRichEdit_SetSel($hWnd, 0, StringLen($sText) - 1, True)
	EndIf
	_GUICtrlRichEdit_SetFont($hWnd, $iFontSize, $iFontName, $iFontCharSet)
	_GUICtrlRichEdit_SetCharColor($hWnd, $iFontColor)
	_GUICtrlRichEdit_SetCharBkColor($hWnd, $iFontBkColor)
	_GUICtrlRichEdit_Deselect($hWnd)
	_WinAPI_HideCaret($hWnd)

EndFunc   ;==>__LogaGUIAppendText

Func __LogaRefreshSettingsFromString($tLoga, $sLogaSettings)
	If Not IsDllStruct($tLoga) Then Return
	Local $iLogaInstance = $tLoga.__InstanceIndex
	If $iLogaInstance <= 0 Or $iLogaInstance > $__g_iLogaInstances Then Return SetError(1, 0, 0) ;not a valid instance

	;reset loga settings
	__LogaLoadSettingsFromString($tLoga, $sLogaSettings) ;Load settings from string
	$tLoga.__LogIndex = ($__g_aaLogaInstances[$iLogaInstance - 1])[$eLOGA___LogIndex] ;keep log index
	Local $aLoga = __LogaCreateSettingsArrayFromStructure($tLoga) ;Fast access


	;refresh GUI settings
	Local $aLogGUIInfo = __LogaRefreshGUISettings($aLoga)
	If IsArray($aLogGUIInfo) Then
		$tLoga.__hGUI = $aLogGUIInfo[0] ;save GUI handle
		$tLoga.__hRichEdit = $aLogGUIInfo[1] ;save RichEdit handle
	EndIf

	;refresh write file
	If $tLoga.LogToFile Then ;write message to File
		_LogaFileClose($tLoga) ;close file
		$tLoga.hFile = 0 ; clear
		If Not $tLoga.LogFileAutoFlush Then $tLoga.hFile = FileOpen($tLoga.FilePath, $FO_OVERWRITE)
	EndIf
	__LogaRefreshArrayFromStructure($tLoga, $aLoga) ;refresh Array from structure

	$__g_atLogaInstances[$__g_iLogaInstances - 1] = $tLoga ;save global array of structures
	$__g_aaLogaInstances[$__g_iLogaInstances - 1] = $aLoga ;save global array of arrays
EndFunc   ;==>__LogaRefreshSettingsFromString


Func __LogaRefreshSettingsFromStructure($tLoga)
	If Not IsDllStruct($tLoga) Then Return
	Local $iLogaInstance = $tLoga.__InstanceIndex
	If $iLogaInstance <= 0 Or $iLogaInstance > $__g_iLogaInstances Then Return SetError(1, 0, 0) ;not a valid instance

	$tLoga.__LogIndex = ($__g_aaLogaInstances[$iLogaInstance - 1])[$eLOGA___LogIndex] ;keep log index
	;reset loga settings
	Local $aLoga = __LogaCreateSettingsArrayFromStructure($tLoga) ;Fast access

	;refresh GUI settings
	Local $aLogGUIInfo = __LogaRefreshGUISettings($aLoga)
	If IsArray($aLogGUIInfo) Then
		$tLoga.__hGUI = $aLogGUIInfo[0] ;save GUI handle
		$tLoga.__hRichEdit = $aLogGUIInfo[1] ;save RichEdit handle
	EndIf

	;refresh write file
	If $tLoga.LogToFile Then ;write message to File
		_LogaFileClose($tLoga) ;close file
		$tLoga.hFile = 0 ; clear
		If Not $tLoga.LogFileAutoFlush Then $tLoga.hFile = FileOpen($tLoga.FilePath, $FO_OVERWRITE)
	EndIf

	__LogaRefreshArrayFromStructure($tLoga, $aLoga) ;refresh Arraym from structure
	$__g_atLogaInstances[$__g_iLogaInstances - 1] = $tLoga ;save global array of structures
	$__g_aaLogaInstances[$__g_iLogaInstances - 1] = $aLoga ;save global array of arrays
EndFunc   ;==>__LogaRefreshSettingsFromStructure


Func __LogaRefreshGUISettings($aLoga)
	If $aLoga[$eLOGA_LogToGUI] = False Then Return GUIDelete($aLoga[$eLOGA___hGUI])

	If WinExists($aLoga[$eLOGA___hGUI]) Then
		WinMove($aLoga[$eLOGA___hGUI], "", $aLoga[$eLOGA_Left], $aLoga[$eLOGA_Top], $aLoga[$eLOGA_Width] + 14, $aLoga[$eLOGA_Height] + 14)
		WinSetTitle($aLoga[$eLOGA___hGUI], "", StringFormat("%s%05s", "Loga-", $aLoga[$eLOGA___InstanceIndex]))
		WinSetTrans($aLoga[$eLOGA___hGUI], "", $aLoga[$eLOGA_Trans])
		Return
	EndIf

	Local $aLogGUIInfo = __CreateLogGUI($aLoga[$eLOGA_Name], $aLoga[$eLOGA_Width], $aLoga[$eLOGA_Height], $aLoga[$eLOGA_Left], $aLoga[$eLOGA_Top], _
			$aLoga[$eLOGA_GUIBkColor], $aLoga[$eLOGA_Trans], $aLoga[$eLOGA_ShowGUIOnCompiled])

	Return $aLogGUIInfo
EndFunc   ;==>__LogaRefreshGUISettings

Func __LogaRefreshArrayFromStructure($tLoga, ByRef $aLoga)
	If IsArray($aLoga) Then

		$aLoga[$eLOGA___InstanceIndex] = $tLoga.__InstanceIndex
		$aLoga[$eLOGA___LogIndex] = $tLoga.__LogIndex
		$aLoga[$eLOGA_Name] = $tLoga.Name
		$aLoga[$eLOGA_Level] = $tLoga.Level
		$aLoga[$eLOGA_LogToFile] = $tLoga.LogToFile
		$aLoga[$eLOGA_LogFileAutoFlush] = $tLoga.LogFileAutoFlush
		$aLoga[$eLOGA_hFile] = $tLoga.hFile
		$aLoga[$eLOGA_LogToGUI] = $tLoga.LogToGUI
		$aLoga[$eLOGA_LogToStdError] = $tLoga.LogToStdError
		$aLoga[$eLOGA_ShowGUIOnCompiled] = $tLoga.ShowGUIOnCompiled

		$aLoga[$eLOGA___hGUI] = $tLoga.__hGUI
		$aLoga[$eLOGA___hRichEdit] = $tLoga.__hRichEdit
		$aLoga[$eLOGA_AppendType] = $tLoga.AppendType
		$aLoga[$eLOGA_GUIShowLevelSymbol] = $tLoga.GUIShowLevelSymbol
		$aLoga[$eLOGA_GUIBkColor] = Hex($tLoga.GUIBkColor)
		$aLoga[$eLOGA_Trans] = $tLoga.Trans
		$aLoga[$eLOGA_Left] = $tLoga.Left
		$aLoga[$eLOGA_Top] = $tLoga.Top
		$aLoga[$eLOGA_Width] = $tLoga.Width
		$aLoga[$eLOGA_Height] = $tLoga.Height

		$aLoga[$eLOGA_FilePath] = $tLoga.FilePath
		$aLoga[$eLOGA_Format] = $tLoga.Format
		$aLoga[$eLOGA_EndOfLine] = $tLoga.EndOfLine

		$aLoga[$eLOGA_TraceSymbol] = $tLoga.TraceSymbol
		$aLoga[$eLOGA_TraceFontName] = $tLoga.TraceFontName
		$aLoga[$eLOGA_TraceString] = $tLoga.TraceString
		$aLoga[$eLOGA_TraceFontColor] = Hex($tLoga.TraceFontColor)
		$aLoga[$eLOGA_TraceFontBkColor] = ($tLoga.TraceFontBkColor = -1) ? $aLoga[$eLOGA_GUIBkColor] : Hex($tLoga.TraceFontBkColor)
		$aLoga[$eLOGA_TraceFontSize] = $tLoga.TraceFontSize
		$aLoga[$eLOGA_TraceCharSet] = $tLoga.TraceCharSet

		$aLoga[$eLOGA_DebugSymbol] = $tLoga.DebugSymbol
		$aLoga[$eLOGA_DebugFontName] = $tLoga.DebugFontName
		$aLoga[$eLOGA_DebugString] = $tLoga.DebugString
		$aLoga[$eLOGA_DebugFontColor] = Hex($tLoga.DebugFontColor)
		$aLoga[$eLOGA_DebugFontBkColor] = ($tLoga.DebugFontBkColor = -1) ? $aLoga[$eLOGA_GUIBkColor] : Hex($tLoga.DebugFontBkColor)
		$aLoga[$eLOGA_DebugFontSize] = $tLoga.DebugFontSize
		$aLoga[$eLOGA_DebugCharSet] = $tLoga.DebugCharSet

		$aLoga[$eLOGA_InfoSymbol] = $tLoga.InfoSymbol
		$aLoga[$eLOGA_InfoFontName] = $tLoga.InfoFontName
		$aLoga[$eLOGA_InfoString] = $tLoga.InfoString
		$aLoga[$eLOGA_InfoFontColor] = Hex($tLoga.InfoFontColor)
		$aLoga[$eLOGA_InfoFontBkColor] = ($tLoga.InfoFontBkColor = -1) ? $aLoga[$eLOGA_GUIBkColor] : Hex($tLoga.InfoFontBkColor)
		$aLoga[$eLOGA_InfoFontSize] = $tLoga.InfoFontSize
		$aLoga[$eLOGA_InfoCharSet] = $tLoga.InfoCharSet

		$aLoga[$eLOGA_WarnSymbol] = $tLoga.WarnSymbol
		$aLoga[$eLOGA_WarnFontName] = $tLoga.WarnFontName
		$aLoga[$eLOGA_WarnString] = $tLoga.WarnString
		$aLoga[$eLOGA_WarnFontColor] = Hex($tLoga.WarnFontColor)
		$aLoga[$eLOGA_WarnFontBkColor] = ($tLoga.WarnFontBkColor = -1) ? $aLoga[$eLOGA_GUIBkColor] : Hex($tLoga.WarnFontBkColor)
		$aLoga[$eLOGA_WarnFontSize] = $tLoga.WarnFontSize
		$aLoga[$eLOGA_WarnCharSet] = $tLoga.WarnCharSet

		$aLoga[$eLOGA_ErrorSymbol] = $tLoga.ErrorSymbol
		$aLoga[$eLOGA_ErrorFontName] = $tLoga.ErrorFontName
		$aLoga[$eLOGA_ErrorString] = $tLoga.ErrorString
		$aLoga[$eLOGA_ErrorFontColor] = Hex($tLoga.ErrorFontColor)
		$aLoga[$eLOGA_ErrorFontBkColor] = ($tLoga.ErrorFontBkColor = -1) ? $aLoga[$eLOGA_GUIBkColor] : Hex($tLoga.ErrorFontBkColor)
		$aLoga[$eLOGA_ErrorFontSize] = $tLoga.ErrorFontSize
		$aLoga[$eLOGA_ErrorCharSet] = $tLoga.ErrorCharSet

		$aLoga[$eLOGA_FatalSymbol] = $tLoga.FatalSymbol
		$aLoga[$eLOGA_FatalFontName] = $tLoga.FatalFontName
		$aLoga[$eLOGA_FatalString] = $tLoga.FatalString
		$aLoga[$eLOGA_FatalFontColor] = Hex($tLoga.FatalFontColor)
		$aLoga[$eLOGA_FatalFontBkColor] = ($tLoga.FatalFontBkColor = -1) ? $aLoga[$eLOGA_GUIBkColor] : Hex($tLoga.FatalFontBkColor)
		$aLoga[$eLOGA_FatalFontSize] = $tLoga.FatalFontSize
		$aLoga[$eLOGA_FatalCharSet] = $tLoga.FatalCharSet

	EndIf

EndFunc   ;==>__LogaRefreshArrayFromStructure

Func __CreateLogGUI($sTitle, $iWidth, $iHeight, $ileft, $iTop, $iGUIBkColor, $iTrans, $iShowOnCompiled)
	Local $hGUI = GUICreate($sTitle, $iWidth, $iHeight, $ileft, $iTop, BitOR($WS_SIZEBOX, $WS_MINIMIZEBOX), $WS_EX_TOPMOST)
	Local $hRitchEdit = _GUICtrlRichEdit_Create($hGUI, "", 0, 0, $iWidth, $iHeight, $ES_READONLY + $WS_HSCROLL + $ES_MULTILINE + $WS_VSCROLL + $ES_AUTOVSCROLL)
	_WinAPI_HideCaret($hRitchEdit)
	GUISetBkColor($iGUIBkColor, $hGUI)
	_GUICtrlRichEdit_SetBkColor($hRitchEdit, $iGUIBkColor)
	WinSetTrans($hGUI, "", $iTrans)
	Local $aInfo[2] = [$hGUI, $hRitchEdit]

	If ((Not @Compiled) Or $iShowOnCompiled Or $__g_bShowAllGUIOnCompiled) Then
		GUISetState(@SW_SHOW, $hGUI)
	EndIf

	Return $aInfo
EndFunc   ;==>__CreateLogGUI


Func __LogaGetRichEditHandleFromWindowHandle($hWnd)
	Local $hRitchEdit = 0
	For $i = 0 To $__g_iLogaInstances - 1
		If ($__g_aaLogaInstances[$i])[$eLOGA___hGUI] = $hWnd Then
			$hRitchEdit = ($__g_aaLogaInstances[$i])[$eLOGA___hRichEdit]
			ExitLoop
		EndIf
	Next
	Return $hRitchEdit
EndFunc   ;==>__LogaGetRichEditHandleFromWindowHandle


Func __LogaLoadSettingsFromString($tLoga, $sLogaSettings)
	Local Const $sValidVariables = "Name|Level|LogToFile|LogFileAutoFlush|LogToGUI|ShowGUIOnCompiled|LogToStdError|GUIShowLevelSymbol|GUIBkColor|" & _
			"Trans|Left|Top|Width|Height|FilePath|Format|EndOfLine|AppendType|" & _
			"TraceSymbol|TraceFontName|TraceString|TraceFontColor|TraceFontBkColor|TraceFontSize|TraceCharSet|" & _
			"DebugSymbol|DebugFontName|DebugString|DebugFontColor|DebugFontBkColor|DebugFontSize|DebugCharSet|" & _
			"InfoSymbol|InfoFontName|InfoString|InfoFontColor|InfoFontBkColor|InfoFontSize|InfoCharSet|" & _
			"WarnSymbol|WarnFontName|WarnString|WarnFontColor|WarnFontBkColor|WarnFontSize|WarnCharSet|" & _
			"ErrorSymbol|ErrorFontName|ErrorString|ErrorFontColor|ErrorFontBkColor|ErrorFontSize|ErrorCharSet|" & _
			"FatalSymbol|FatalFontName|FatalString|FatalFontColor|FatalFontBkColor|FatalFontSize|FatalCharSet|"

	If $sLogaSettings = "" Then Return

	If IsDllStruct($tLoga) Then

		Local $aRegSettings = StringRegExp($sLogaSettings, '(?>' & $sValidVariables & ')="[^"]*"', 3)
		Local $aSettingName = ""
		Local $sSettingName = ""
		Local $aSettingValue = ""
		Local $sSettingValue = ""
		Local $sExeValue = ""

		For $i = 0 To UBound($aRegSettings) - 1
			$aSettingName = StringRegExp($aRegSettings[$i], '^[^=]+', 3) ;get variable name
			$aSettingValue = StringRegExp($aRegSettings[$i], '"([^"]*)"', 3) ;get variable value

			If IsArray($aSettingName) And IsArray($aSettingValue) Then
				$sSettingName = $aSettingName[0]
				$sSettingValue = $aSettingValue[0]

				;cure parameter for Execute and valid type for DllStructSetData
				$sExeValue = StringRegExp($sSettingValue, "true|false|0[xX][0-9a-fA-F]+|^\d+$|^\$") ? $sSettingValue : '"' & $sSettingValue & '"'
				If StringRegExp($sSettingName, $sValidVariables) Then ;check if is valid structure field
					Execute('DllStructSetData($tLoga,"' & $sSettingName & '",' & $sExeValue & ')') ;set structure field value
				EndIf
			EndIf
		Next
	EndIf
EndFunc   ;==>__LogaLoadSettingsFromString


Func __LogaSetDefaultSettings($tLoga)
	If IsDllStruct($tLoga) Then
		$tLoga.Name = StringFormat("%s%05s", "Loga-", $tLoga.__InstanceIndex)
		$tLoga.Level = $LOGA_LEVEL_ALL
		$tLoga.LogToFile = True
		$tLoga.LogFileAutoFlush = True
		$tLoga.hFile = 0

		$tLoga.LogToGUI = False
		$tLoga.LogToStdError = False
		$tLoga.ShowGUIOnCompiled = False

		$tLoga.__hGUI = 0
		$tLoga.___hRichEdit = 0
		$tLoga.AppendType = $LOGA_APPEND_END
		$tLoga.GUIShowLevelSymbol = False
		$tLoga.GUIBkColor = 0xFFFFFF
		$tLoga.Trans = 255
		$tLoga.Left = 1
		$tLoga.Top = 1
		$tLoga.Width = 600
		$tLoga.Height = 300

		$tLoga.FilePath = @ScriptDir & "\" & @YEAR & @MON & @MDAY & @HOUR & @MIN & "-Loga-" & $tLoga.__InstanceIndex & ".log"
		$tLoga.Format = "{Symbol}{LogIndex} {LevelName} {LongDateTime} {Message}"
		$tLoga.EndOfLine = @CRLF

		$tLoga.TraceSymbol = ">"
		$tLoga.TraceFontName = "Consolas"
		$tLoga.TraceString = StringFormat("%-7s", "[Trace]")
		$tLoga.TraceFontColor = 0x000000 ;Only Valid For Log to GUI
		$tLoga.TraceFontBkColor = -1 ;Only Valid For Log to GUI
		$tLoga.TraceFontSize = 10 ;Only Valid For Log to GUI
		$tLoga.TraceCharSet = 1 ;Only Valid For Log to GUI

		$tLoga.DebugSymbol = ">"
		$tLoga.DebugFontName = "Consolas"
		$tLoga.DebugString = StringFormat("%-7s", "[Debug]")
		$tLoga.DebugFontColor = 0x000000 ;Only Valid For Log to GUI
		$tLoga.DebugFontBkColor = -1 ;Only Valid For Log to GUI
		$tLoga.DebugFontSize = 10 ;Only Valid For Log to GUI
		$tLoga.DebugCharSet = 1 ;Only Valid For Log to GUI

		$tLoga.InfoSymbol = "+"
		$tLoga.InfoFontName = "Consolas"
		$tLoga.InfoString = StringFormat("%-7s", "[Info]")
		$tLoga.InfoFontColor = 0x000000 ;Only Valid For Log to GUI
		$tLoga.InfoFontBkColor = -1 ;Only Valid For Log to GUI
		$tLoga.InfoFontSize = 10 ;Only Valid For Log to GUI
		$tLoga.InfoCharSet = 1 ;Only Valid For Log to GUI

		$tLoga.WarnSymbol = "-"
		$tLoga.WarnFontName = "Consolas"
		$tLoga.WarnString = StringFormat("%-7s", "[Warn]")
		$tLoga.WarnFontColor = 0x000000 ;Only Valid For Log to GUI
		$tLoga.WarnFontBkColor = -1 ;Only Valid For Log to GUI
		$tLoga.WarnFontSize = 10 ;Only Valid For Log to GUI
		$tLoga.WarnCharSet = 1 ;Only Valid For Log to GUI

		$tLoga.ErrorSymbol = "!"
		$tLoga.ErrorFontName = "Consolas"
		$tLoga.ErrorString = StringFormat("%-7s", "[Error]")
		$tLoga.ErrorFontColor = 0x000000 ;Only Valid For Log to GUI
		$tLoga.ErrorFontBkColor = -1 ;Only Valid For Log to GUI
		$tLoga.ErrorFontSize = 10 ;Only Valid For Log to GUI
		$tLoga.ErrorCharSet = 1 ;Only Valid For Log to GUI

		$tLoga.FatalSymbol = "!"
		$tLoga.FatalFontName = "Consolas"
		$tLoga.FatalString = StringFormat("%-7s", "[Fatal]")
		$tLoga.FatalFontColor = 0x000000 ;Only Valid For Log to GUI
		$tLoga.FatalFontBkColor = -1 ;Only Valid For Log to GUI
		$tLoga.FatalFontSize = 10 ;Only Valid For Log to GUI
		$tLoga.FatalCharSet = 1 ;Only Valid For Log to GUI

	EndIf
EndFunc   ;==>__LogaSetDefaultSettings


Func __LogaCreateSettingsArrayFromStructure($tLoga)

	If IsDllStruct($tLoga) Then
		Local $aLoga[65]

		$aLoga[$eLOGA___InstanceIndex] = $tLoga.__InstanceIndex
		$aLoga[$eLOGA_Name] = $tLoga.Name
		$aLoga[$eLOGA_Level] = $tLoga.Level
		$aLoga[$eLOGA_LogToFile] = $tLoga.LogToFile
		$aLoga[$eLOGA_LogFileAutoFlush] = $tLoga.LogFileAutoFlush
		$aLoga[$eLOGA_hFile] = $tLoga.hFile
		$aLoga[$eLOGA_LogToGUI] = $tLoga.LogToGUI
		$aLoga[$eLOGA_LogToStdError] = $tLoga.LogToStdError
		$aLoga[$eLOGA_ShowGUIOnCompiled] = $tLoga.ShowGUIOnCompiled

		$aLoga[$eLOGA___hGUI] = $tLoga.__hGUI
		$aLoga[$eLOGA___hRichEdit] = $tLoga.__hRichEdit
		$aLoga[$eLOGA_GUIShowLevelSymbol] = $tLoga.GUIShowLevelSymbol
		$aLoga[$eLOGA_GUIBkColor] = $tLoga.GUIBkColor
		$aLoga[$eLOGA_Trans] = $tLoga.Trans
		$aLoga[$eLOGA_Left] = $tLoga.Left
		$aLoga[$eLOGA_Top] = $tLoga.Top
		$aLoga[$eLOGA_Width] = $tLoga.Width
		$aLoga[$eLOGA_Height] = $tLoga.Height

		$aLoga[$eLOGA_FilePath] = $tLoga.FilePath
		$aLoga[$eLOGA_Format] = $tLoga.Format
		$aLoga[$eLOGA_EndOfLine] = $tLoga.EndOfLine

		$aLoga[$eLOGA_TraceSymbol] = $tLoga.TraceSymbol
		$aLoga[$eLOGA_TraceFontName] = $tLoga.TraceFontName
		$aLoga[$eLOGA_TraceString] = $tLoga.TraceString
		$aLoga[$eLOGA_TraceFontColor] = $tLoga.TraceFontColor
		$aLoga[$eLOGA_TraceFontBkColor] = $tLoga.TraceFontBkColor
		$aLoga[$eLOGA_TraceFontSize] = $tLoga.TraceFontSize
		$aLoga[$eLOGA_TraceCharSet] = $tLoga.TraceCharSet

		$aLoga[$eLOGA_DebugSymbol] = $tLoga.DebugSymbol
		$aLoga[$eLOGA_DebugFontName] = $tLoga.DebugFontName
		$aLoga[$eLOGA_DebugString] = $tLoga.DebugString
		$aLoga[$eLOGA_DebugFontColor] = $tLoga.DebugFontColor
		$aLoga[$eLOGA_DebugFontBkColor] = $tLoga.DebugFontBkColor
		$aLoga[$eLOGA_DebugFontSize] = $tLoga.DebugFontSize
		$aLoga[$eLOGA_DebugCharSet] = $tLoga.DebugCharSet

		$aLoga[$eLOGA_InfoSymbol] = $tLoga.InfoSymbol
		$aLoga[$eLOGA_InfoFontName] = $tLoga.InfoFontName
		$aLoga[$eLOGA_InfoString] = $tLoga.InfoString
		$aLoga[$eLOGA_InfoFontColor] = $tLoga.InfoFontColor
		$aLoga[$eLOGA_InfoFontBkColor] = $tLoga.InfoFontBkColor
		$aLoga[$eLOGA_InfoFontSize] = $tLoga.InfoFontSize
		$aLoga[$eLOGA_InfoCharSet] = $tLoga.InfoCharSet

		$aLoga[$eLOGA_WarnSymbol] = $tLoga.WarnSymbol
		$aLoga[$eLOGA_WarnFontName] = $tLoga.WarnFontName
		$aLoga[$eLOGA_WarnString] = $tLoga.WarnString
		$aLoga[$eLOGA_WarnFontColor] = $tLoga.WarnFontColor
		$aLoga[$eLOGA_WarnFontBkColor] = $tLoga.WarnFontBkColor
		$aLoga[$eLOGA_WarnFontSize] = $tLoga.WarnFontSize
		$aLoga[$eLOGA_WarnCharSet] = $tLoga.WarnCharSet

		$aLoga[$eLOGA_ErrorSymbol] = $tLoga.ErrorSymbol
		$aLoga[$eLOGA_ErrorFontName] = $tLoga.ErrorFontName
		$aLoga[$eLOGA_ErrorString] = $tLoga.ErrorString
		$aLoga[$eLOGA_ErrorFontColor] = $tLoga.ErrorFontColor
		$aLoga[$eLOGA_ErrorFontBkColor] = $tLoga.ErrorFontBkColor
		$aLoga[$eLOGA_ErrorFontSize] = $tLoga.ErrorFontSize
		$aLoga[$eLOGA_ErrorCharSet] = $tLoga.ErrorCharSet

		$aLoga[$eLOGA_FatalSymbol] = $tLoga.FatalSymbol
		$aLoga[$eLOGA_FatalFontName] = $tLoga.FatalFontName
		$aLoga[$eLOGA_FatalString] = $tLoga.FatalString
		$aLoga[$eLOGA_FatalFontColor] = $tLoga.FatalFontColor
		$aLoga[$eLOGA_FatalFontBkColor] = $tLoga.FatalFontBkColor
		$aLoga[$eLOGA_FatalFontSize] = $tLoga.FatalFontSize
		$aLoga[$eLOGA_FatalCharSet] = $tLoga.FatalCharSet

	EndIf

	Return $aLoga
EndFunc   ;==>__LogaCreateSettingsArrayFromStructure

#EndRegion Internal Functions
