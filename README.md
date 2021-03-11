# Loga

[![Latest Version](https://img.shields.io/badge/Latest-v1.0.2-green.svg)]()
[![AutoIt Version](https://img.shields.io/badge/AutoIt-3.3.14.5-blue.svg)]()
[![MIT License](https://img.shields.io/github/license/mashape/apistatus.svg)]()
[![Made with Love](https://img.shields.io/badge/Made%20with-%E2%9D%A4-red.svg?colorB=e31b23)]()


Loga is a simple logging library to keep track of code with an integrated console.


## Features
* Common log levels.
* Integrated console.
* Multiple instances.
* Custom color and font for each instance log level.
* Define output format with macros.
* Conditional and occasional Logging.
* Easy to use.

## Log levels
| **Log Levels** | **Trace** | **Debug** | **Info** | **Warn** | **Error** | **Fatal** | **Off** |
|:---|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| ✒️**Trace**  | ✔️ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| 🐞**Debug** |  ✔️ | ✔️ | ❌ | ❌ | ❌ | ❌ | ❌ |
| 📢**Info** |  ✔️ | ✔️ | ✔️ | ❌ | ❌ | ❌ | ❌ |
| ⚠️**Warn** |  ✔️ | ✔️ | ✔️ | ✔️ | ❌ | ❌ | ❌ |
| ⛔️**Error** |  ✔️ | ✔️ | ✔️ | ✔️ | ✔️ | ❌ | ❌ |
| 💥**Fatal** |  ✔️ | ✔️ | ✔️ | ✔️ | ✔️ | ✔️ | ❌ |
| 🚫**Off** |  ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |

## Usage

##### Basic use:
```autoit

#include "..\Loga.au3"

_LogaTrace("I'm Trace")
_LogaDebug("I'm Debug")
_LogaInfo("I'm Info")
_LogaWarn("I'm Warn")
_LogaError("I'm Error")
_LogaFatal("I'm Fatal")

```
##### Short Wrapper Functions:

```autoit

#include "..\Loga.au3"

_LogaT("I'm Trace")
_LogaD("I'm Debug")
_LogaI("I'm Info")
_LogaW("I'm Warn")
_LogaE("I'm Error")
_LogaF("I'm Fatal")

```

##### Define Custom Console:
```autoit

#include "..\Loga.au3"


Local $sSettings1='LogToGUI="true", GUIBkColor="0x000000", Trans="230", ' & _
'InfoFontColor="0xd0ffbc", WarnFontColor="0x53b6ff", ErrorFontColor="0x4a22a8", ' & _
'_FatalFontColor="0x0000FF", DebugFontColor="0xffab64", TraceFontColor="0xfff0a7"'

Local $hLoga1=_LogaNew($sSettings1) ;create instance with custom settings
_LogaTrace("I'm Trace")
_LogaDebug("I'm Debug")
_LogaInfo("I'm Info")
_LogaWarn("I'm Warn")
_LogaError("I'm Error")
_LogaFatal("I'm Fatal")

MsgBox(0,"Info","Press Ok to Exit.")

```

##### Custom Console Preview:
![](https://github.com/DanysysTeam/ProjectsResources/blob/master/Loga/LogaCustomConsole1.png?raw=true)

![](https://github.com/DanysysTeam/ProjectsResources/blob/master/Loga/LogaCustomConsole2.png?raw=true)

##### More examples [here.](/Examples)


## Release History
See [CHANGELOG.md](CHANGELOG.md)


<!-- ## Acknowledgments & Credits -->


## License

Usage is provided under the [MIT](https://choosealicense.com/licenses/mit/) License.

Copyright © 2021, [Danysys.](https://www.danysys.com)