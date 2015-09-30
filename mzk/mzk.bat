@ECHO OFF

REM * Setup - Move to MZK Path
PUSHD "%~dp0"

CLS

REM * Check - Compression
IF NOT EXIST "DB\CHECK\MZK" (
	ECHO 압축 파일을 올바르게 해제 후 실행해주시기 바랍니다.
	ECHO.
	PAUSE
	EXIT /B
)

REM * Setup - Variable Initialization
SET ACTIVESCAN=0
SET AUTOMODE=0
SET CHKEXPLORER=0
SET CURRENTDATE=NULL
SET DATECHK=0
SET DDRV=NULL
SET ERRCODE=0
SET NUMTMP=0
SET OSVER=NULL
SET PATHDUMP=NULL
SET REGTMP=NULL
SET RPTDATE=NULL
SET STRTMP=NULL
SET VK=0

SET MZKALLUSERSPROFILE=
SET MZKAPPDATA=
SET MZKCOMMONPROGRAMFILES=
SET MZKCOMMONPROGRAMFILESX86=
SET MZKLOCALAPPDATA=
SET MZKLOCALLOWAPPDATA=
SET MZKPROGRAMFILES=
SET MZKPROGRAMFILESX86=
SET MZKPUBLIC=
SET MZKSYSTEMROOT=
SET MZKUSERPROFILE=

SET YNAAA=
SET YNBBB=
SET YNCCC=

GOTO PASSED

:ERROR104
SET ERRCODE=104 & GOTO MZK

:PASSED
REM * Check - Required Variables
IF NOT DEFINED SYSTEMDRIVE (
	IF NOT DEFINED HOMEDRIVE (
		SET ERRCODE=104
	) ELSE (
		SET "SYSTEMDRIVE=%HOMEDRIVE%"
	)
)
IF NOT DEFINED SYSTEMROOT (
	IF NOT DEFINED WINDIR (
		SET ERRCODE=104
	) ELSE (
		SET "SYSTEMROOT=%WINDIR%"
	)
)

REM * Setup - Path
IF DEFINED PATH SET "PATHDUMP=%PATH%"
SET "PATH=%SYSTEMROOT%\System32;%SYSTEMROOT%\SysWOW64;%SYSTEMROOT%\System32\wbem;%SYSTEMROOT%\SysWOW64\wbem;%PATH%"

REM * Check - Random Variables
IF NOT DEFINED RANDOM (
	SET RANDOM=11111
)

REM * Setup - Random Variables
SET /A RAND=%RANDOM% * 99

DEL /F /Q /A DB_ACTIVE\*.DB >Nul 2>Nul & DEL /F /Q /S /A DB_EXEC\*.DB >Nul 2>Nul

REM * Check - Supported Language
SETLOCAL ENABLEDELAYEDEXPANSION
CHCP.COM 949 2>Nul|TOOLS\GREP\GREP.EXE -Fq "949" >Nul 2>Nul
IF !ERRORLEVEL! NEQ 0 (
	ENDLOCAL
	CLS
	ECHO Oops, Unsupported Korean Language ^!
	ECHO.
	PAUSE
	EXIT
) ELSE (
	ENDLOCAL
)

CLS

>VARIABLE\CHCK ECHO 0

REM * Reset - Malicious AppInit_DLLs Values (x64 or x86)
FOR /F "DELIMS=" %%Z IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs" 2^>Nul') DO (
	IF /I "%%Z" == "WS2HELP.DLL" (
		TOOLS\000.000 ADD "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs /d "" /f >Nul 2>Nul
		>VARIABLE\CHCK ECHO 1
	)
)
FOR /F "DELIMS=" %%Z IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs" 2^>Nul') DO (
	IF /I "%%Z" == "WS2HELP.DLL" (
		TOOLS\000.000 ADD "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs /d "" /f >Nul 2>Nul
		>VARIABLE\CHCK ECHO 1
	)
)
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\CHCK SET /P CHCK=
IF !CHCK! EQU 1 (
	ENDLOCAL
	ECHO ⓘ 알림
	ECHO.
	ECHO 스크립트 실행을 방해하는 악성 자동 실행 라이브러리 값이 발견되어 제거했습니다.
	ECHO.
	ECHO 재부팅 후 다시 실행해주시기 바랍니다.
	ECHO.
	PAUSE
	EXIT /B
) ELSE (
	ENDLOCAL
)

REM * Setup - Window Size
MODE.COM CON COLS=98 LINES=30 >Nul 2>Nul

REM * Setup *****
<TOOLS\000.001 SET /P DBDATE=
<TOOLS\000.002 SET /P CKEY=
<TOOLS\000.003 SET /P COUNT=
<TOOLS\000.004 SET /P DBVER=
<TOOLS\000.006 SET /P CURRENTDATE=

REM * Setup - Title
SET "MZKTITLE=Malware Zero Kit / Virus Zero Season 2 / ViOLeT / DB: %DBDATE% V%DBVER%"

TITLE %MZKTITLE% 2>Nul

REM * Initialization
ECHO  ────────────────────────────────────────────────
ECHO.
ECHO.
ECHO         ■      ■    ■■■    ■          ■      ■    ■■■    ■■■■    ■■■■■
ECHO         ■■  ■■  ■      ■  ■          ■  ■  ■  ■      ■  ■      ■  ■
ECHO         ■  ■  ■  ■■■■■  ■          ■  ■  ■  ■■■■■  ■■■■    ■■■■
ECHO         ■      ■  ■      ■  ■          ■  ■  ■  ■      ■  ■      ■  ■
ECHO         ■      ■  ■      ■  ■■■■■    ■  ■    ■      ■  ■      ■  ■■■■■
ECHO.
ECHO         ■■■■■  ■■■■■  ■■■■      ■■■    ■      ■  ■■■■■  ■■■■■
ECHO               ■    ■          ■      ■  ■      ■  ■  ■■        ■          ■
ECHO             ■      ■■■■    ■■■■    ■      ■  ■■            ■          ■
ECHO           ■        ■          ■      ■  ■      ■  ■  ■■        ■          ■
ECHO         ■■■■■  ■■■■■  ■      ■    ■■■    ■      ■  ■■■■■      ■
ECHO.
ECHO.
ECHO                                      ^[DB: %DBDATE% V%DBVER%^]
ECHO.
IF %RANDOM% EQU 7777 (
	ECHO                                        새는? 왱알앵알 . . .
) ELSE (
	ECHO                                      스크립트 초기화중 . . .
)
ECHO.
ECHO.
ECHO  ────────────────────────────────────────────────
ECHO.
ECHO           경고 ^! 타 사이트/카페/블로그/토렌트 등에서 배포/개작 및 상업적 이용 절대 금지 ^!
ECHO.
ECHO           진행중 창이 멈추거나 종료되는 경우, 동봉된 ^<3. 문제 해결^> 문서를 참고해주세요.
ECHO.
ECHO                                   Script by Virus Zero Season 2

DIR /B * >Nul 2>Nul
IF %ERRORLEVEL% NEQ 0 (
	SET ERRCODE=105
	GOTO MZK
)

FOR /F "DELIMS=" %%A IN ('TOOLS\DOFF\DOFF.EXE "yyyymmdd" -7 2^>Nul') DO (
	IF "%CURRENTDATE%" LEQ "%%A" SET DATECHK=1
)

REM * Check - Operating System Version
VER|TOOLS\GREP\GREP.EXE -Eiq "Version 6.0." >Nul 2>Nul
IF %ERRORLEVEL% EQU 0 SET OSVER=VISTA
VER|TOOLS\GREP\GREP.EXE -Eiq "Version 6.1." >Nul 2>Nul
IF %ERRORLEVEL% EQU 0 SET OSVER=7
VER|TOOLS\GREP\GREP.EXE -Eiq "Version 6.(2|3)." >Nul 2>Nul
IF %ERRORLEVEL% EQU 0 SET OSVER=8
VER|TOOLS\GREP\GREP.EXE -Eiq "Version 10.0." >Nul 2>Nul
IF %ERRORLEVEL% EQU 0 SET OSVER=10
IF /I "%OSVER%" == "NULL" (
	SET ERRCODE=100
	GOTO MZK
)

REM * Check - Current Directories
IF NOT DEFINED ALLUSERSPROFILE GOTO ERROR104
SET "MZKSYSTEMROOT=%SYSTEMROOT%"
SET "MZKSYSTEMROOT=%MZKSYSTEMROOT:(=^(%"
SET "MZKSYSTEMROOT=%MZKSYSTEMROOT:)=^)%"
SET "MZKSYSTEMROOT=%MZKSYSTEMROOT:&=^&%"
IF NOT DEFINED ALLUSERSPROFILE GOTO ERROR104
SET "MZKALLUSERSPROFILE=%ALLUSERSPROFILE%"
SET "MZKALLUSERSPROFILE=%MZKALLUSERSPROFILE:(=^(%"
SET "MZKALLUSERSPROFILE=%MZKALLUSERSPROFILE:)=^)%"
SET "MZKALLUSERSPROFILE=%MZKALLUSERSPROFILE:&=^&%"
IF NOT DEFINED USERPROFILE GOTO ERROR104
SET "MZKUSERPROFILE=%USERPROFILE%"
SET "MZKUSERPROFILE=%MZKUSERPROFILE:(=^(%"
SET "MZKUSERPROFILE=%MZKUSERPROFILE:)=^)%"
SET "MZKUSERPROFILE=%MZKUSERPROFILE:&=^&%"
IF NOT DEFINED APPDATA GOTO MZK_DS1X
SET "MZKAPPDATA=%APPDATA%"
SET "MZKAPPDATA=%MZKAPPDATA:(=^(%"
SET "MZKAPPDATA=%MZKAPPDATA:)=^)%"
SET "MZKAPPDATA=%MZKAPPDATA:&=^&%"
GOTO MZK_DS1Q
:MZK_DS1X
SET "APPDATA=%USERPROFILE%\AppData\Roaming"
SET "MZKAPPDATA=%MZKUSERPROFILE%\AppData\Roaming"
:MZK_DS1Q
IF NOT DEFINED LOCALAPPDATA GOTO MZK_DS2X
SET "LOCALLOWAPPDATA=%LOCALAPPDATA%Low"
SET "MZKLOCALAPPDATA=%LOCALAPPDATA%"
SET "MZKLOCALAPPDATA=%MZKLOCALAPPDATA:(=^(%"
SET "MZKLOCALAPPDATA=%MZKLOCALAPPDATA:)=^)%"
SET "MZKLOCALAPPDATA=%MZKLOCALAPPDATA:&=^&%"
SET "MZKLOCALLOWAPPDATA=%LOCALLOWAPPDATA%"
SET "MZKLOCALLOWAPPDATA=%MZKLOCALLOWAPPDATA:(=^(%"
SET "MZKLOCALLOWAPPDATA=%MZKLOCALLOWAPPDATA:)=^)%"
SET "MZKLOCALLOWAPPDATA=%MZKLOCALLOWAPPDATA:&=^&%"
GOTO MZK_DS2Q
:MZK_DS2X
SET "LOCALAPPDATA=%USERPROFILE%\AppData\Local"
SET "LOCALLOWAPPDATA=%USERPROFILE%\AppData\LocalLow"
SET "MZKLOCALAPPDATA=%MZKUSERPROFILE%\AppData\Local"
SET "MZKLOCALLOWAPPDATA=%MZKUSERPROFILE%\AppData\LocalLow"
:MZK_DS2Q
IF NOT DEFINED PUBLIC GOTO MZK_DS3X
SET "MZKPUBLIC=%PUBLIC%"
SET "MZKPUBLIC=%MZKPUBLIC:(=^(%"
SET "MZKPUBLIC=%MZKPUBLIC:)=^)%"
SET "MZKPUBLIC=%MZKPUBLIC:&=^&%"
GOTO MZK_DS3Q
:MZK_DS3X
SET "PUBLIC=%SYSTEMDRIVE%\Users\Public"
SET "MZKPUBLIC=%SYSTEMDRIVE%\Users\Public"
:MZK_DS3Q
IF NOT DEFINED PROGRAMFILES GOTO MZK_DS4X
SET "MZKPROGRAMFILES=%PROGRAMFILES%"
SET "MZKPROGRAMFILES=%MZKPROGRAMFILES:(=^(%"
SET "MZKPROGRAMFILES=%MZKPROGRAMFILES:)=^)%"
SET "MZKPROGRAMFILES=%MZKPROGRAMFILES:&=^&%"
GOTO MZK_DS4Q
:MZK_DS4X
SET "PROGRAMFILES=%SYSTEMDRIVE%\Program Files"
SET "MZKPROGRAMFILES=%SYSTEMDRIVE%\Program Files"
:MZK_DS4Q
IF NOT DEFINED PROGRAMFILES^(x86^) GOTO MZK_DS5X
SET "PROGRAMFILESX86=%PROGRAMFILES(x86)%"
SET "MZKPROGRAMFILESX86=%PROGRAMFILESX86%"
SET "MZKPROGRAMFILESX86=%MZKPROGRAMFILESX86:(=^(%"
SET "MZKPROGRAMFILESX86=%MZKPROGRAMFILESX86:)=^)%"
SET "MZKPROGRAMFILESX86=%MZKPROGRAMFILESX86:&=^&%"
GOTO MZK_DS5Q
:MZK_DS5X
SET "PROGRAMFILESX86=%SYSTEMDRIVE%\Program Files (x86)"
SET "MZKPROGRAMFILESX86=%SYSTEMDRIVE%\Program Files ^(x86^)"
:MZK_DS5Q
IF NOT DEFINED COMMONPROGRAMFILES GOTO MZK_DS6X
SET "MZKCOMMONPROGRAMFILES=%COMMONPROGRAMFILES%"
SET "MZKCOMMONPROGRAMFILES=%MZKCOMMONPROGRAMFILES:(=^(%"
SET "MZKCOMMONPROGRAMFILES=%MZKCOMMONPROGRAMFILES:)=^)%"
SET "MZKCOMMONPROGRAMFILES=%MZKCOMMONPROGRAMFILES:&=^&%"
GOTO MZK_DS6Q
:MZK_DS6X
SET "COMMONPROGRAMFILES=%SYSTEMDRIVE%\Program Files\Common Files"
SET "MZKCOMMONPROGRAMFILES=%SYSTEMDRIVE%\Program Files\Common Files"
:MZK_DS6Q
IF NOT DEFINED COMMONPROGRAMFILES^(x86^) GOTO MZK_DS7X
SET "COMMONPROGRAMFILESX86=%COMMONPROGRAMFILES(x86)%"
SET "MZKCOMMONPROGRAMFILESX86=%COMMONPROGRAMFILESX86%"
SET "MZKCOMMONPROGRAMFILESX86=%MZKCOMMONPROGRAMFILESX86:(=^(%"
SET "MZKCOMMONPROGRAMFILESX86=%MZKCOMMONPROGRAMFILESX86:)=^)%"
SET "MZKCOMMONPROGRAMFILESX86=%MZKCOMMONPROGRAMFILESX86:&=^&%"
GOTO MZK_DS7Q
:MZK_DS7X
SET "COMMONPROGRAMFILESX86=%SYSTEMDRIVE%\Program Files (x86)\Common Files"
SET "MZKCOMMONPROGRAMFILESX86=%SYSTEMDRIVE%\Program Files ^(x86^)\Common Files"
:MZK_DS7Q
IF NOT DEFINED TEMP SET "TEMP=%LOCALAPPDATA%\Temp"

REM * Check - Validate Directories
IF /I "%SYSTEMDRIVE%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%ALLUSERSPROFILE%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%USERPROFILE%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%APPDATA%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%LOCALAPPDATA%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%LOCALLOWAPPDATA%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%PUBLIC%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%PROGRAMFILES%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%PROGRAMFILESX86%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%COMMONPROGRAMFILES%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%COMMONPROGRAMFILESX86%" == "%SYSTEMROOT%" SET ERRCODE=104

REM * Check - Validate Temporary Directories
ECHO "%TEMP%"|TOOLS\GREP\GREP.EXE -Eixq "(\")[A-Z]:\\?(\")" >Nul 2>Nul
IF %ERRORLEVEL% EQU 0 SET ERRCODE=104
IF /I "%TEMP%" == "%SYSTEMDRIVE%" SET ERRCODE=104
IF /I "%TEMP%" == "%SYSTEMROOT%" SET ERRCODE=104
IF /I "%TEMP%" == "%SYSTEMROOT%\" SET ERRCODE=104
IF /I "%TEMP%" == "%ALLUSERSPROFILE%" SET ERRCODE=104
IF /I "%TEMP%" == "%ALLUSERSPROFILE%\" SET ERRCODE=104
IF /I "%TEMP%" == "%USERPROFILE%" SET ERRCODE=104
IF /I "%TEMP%" == "%USERPROFILE%\" SET ERRCODE=104
IF /I "%TEMP%" == "%APPDATA%" SET ERRCODE=104
IF /I "%TEMP%" == "%APPDATA%\" SET ERRCODE=104
IF /I "%TEMP%" == "%LOCALAPPDATA%" SET ERRCODE=104
IF /I "%TEMP%" == "%LOCALAPPDATA%\" SET ERRCODE=104
IF /I "%TEMP%" == "%LOCALLOWAPPDATA%" SET ERRCODE=104
IF /I "%TEMP%" == "%LOCALLOWAPPDATA%\" SET ERRCODE=104
IF /I "%TEMP%" == "%PUBLIC%" SET ERRCODE=104
IF /I "%TEMP%" == "%PUBLIC%\" SET ERRCODE=104
IF /I "%TEMP%" == "%PROGRAMFILES%" SET ERRCODE=104
IF /I "%TEMP%" == "%PROGRAMFILES%\" SET ERRCODE=104
IF /I "%TEMP%" == "%PROGRAMFILESX86%" SET ERRCODE=104
IF /I "%TEMP%" == "%PROGRAMFILESX86%\" SET ERRCODE=104
IF /I "%TEMP%" == "%COMMONPROGRAMFILES%" SET ERRCODE=104
IF /I "%TEMP%" == "%COMMONPROGRAMFILES%\" SET ERRCODE=104
IF /I "%TEMP%" == "%COMMONPROGRAMFILESX86%" SET ERRCODE=104
IF /I "%TEMP%" == "%COMMONPROGRAMFILESX86%\" SET ERRCODE=104
IF /I "%TEMP%" == "\" SET ERRCODE=104

IF %ERRCODE% NEQ 0 GOTO MZK

REM * Check - Administrator Privileges
AT.EXE >Nul 2>Nul
IF %ERRORLEVEL% NEQ 0 SET /A NUMTMP+=1
BCDEDIT.EXE >Nul 2>Nul
IF %ERRORLEVEL% NEQ 0 SET /A NUMTMP+=1
NET.EXE SESSION >Nul 2>Nul
IF %ERRORLEVEL% NEQ 0 SET /A NUMTMP+=1
MKDIR "%SYSTEMROOT%\System32\AdminAuthTest%RAND%" >Nul 2>Nul
IF %ERRORLEVEL% NEQ 0 (
	SET /A NUMTMP+=1
) ELSE (
	RMDIR "%SYSTEMROOT%\System32\AdminAuthTest%RAND%" >Nul 2>Nul
)
IF %NUMTMP% EQU 4 SET ERRCODE=103
SET NUMTMP=0

IF %ERRCODE% NEQ 0 GOTO MZK

REM * Check - Anti-Shutdown
SHUTDOWN.EXE /A >Nul 2>Nul

REM * Check - Database File Count
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "DELIMS=" %%A IN ('DIR /S /A-D "DB\*.DB" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fi ".DB" 2^>Nul') DO SET /A NUMTMP+=1
IF !COUNT! NEQ !NUMTMP! (
	ENDLOCAL
	SET ERRCODE=107
	GOTO MZK
) ELSE (
	ENDLOCAL
)
SET NUMTMP=0

REM * Setup - Use Virtual Keyboard
IF /I "%1" == "VK" (
	SET VK=1
)

REM * Setup - Use Auto Mode
IF /I "%1" == "AUTO" (
	SET AUTOMODE=1
)

REM * Setup - Architecture
IF /I "%PROCESSOR_ARCHITECTURE%" == "AMD64" (
	SET ARCHITECTURE=x64
) ELSE (
	SET ARCHITECTURE=x86
)

REM * Setup - HashDeep Architecture
IF /I "%ARCHITECTURE%" == "x64" (
	SET MD5CHK=MD5DEEP64
	SET SHACHK=SHA256DEEP64
) ELSE (
	SET MD5CHK=MD5DEEP
	SET SHACHK=SHA256DEEP
)

REM * Setup - Database Initialization
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "DB\*.DB" 2^>Nul') DO (
	TOOLS\CRYPT\CRYPT.EXE -decrypt -key "%DBDATE%%CKEY%" -infile "DB\%%A" -outfile "DB_EXEC\%%A" >Nul 2>Nul
	TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "DB_EXEC\%%A" -ot file -actn ace -ace "n:Everyone;p:FILE_ADD_FILE;m:deny" -silent >Nul 2>Nul
)
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "DB\" 2^>Nul') DO (
	IF /I NOT "%%A" == "EXCEPT" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "DB\%%A\*.DB" 2^>Nul') DO (
			TOOLS\CRYPT\CRYPT.EXE -decrypt -key "%DBDATE%%CKEY%" -infile "DB\%%A\%%B" -outfile "DB_EXEC\%%A\%%B" >Nul 2>Nul
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "DB_EXEC\%%A\%%B" -ot file -actn ace -ace "n:Everyone;p:FILE_ADD_FILE;m:deny" -silent >Nul 2>Nul
		)
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "DB\ACTIVESCAN\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "DB\ACTIVESCAN\%%A\*.DB" 2^>Nul') DO (
		TOOLS\CRYPT\CRYPT.EXE -decrypt -key "%DBDATE%%CKEY%" -infile "DB\ACTIVESCAN\%%A\%%B" -outfile "DB_EXEC\ACTIVESCAN\%%A\%%B" >Nul 2>Nul
		TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "DB_EXEC\ACTIVESCAN\%%A\%%B" -ot file -actn ace -ace "n:Everyone;p:FILE_ADD_FILE;m:deny" -silent >Nul 2>Nul
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "DB\THREAT\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "DB\THREAT\%%A\*.DB" 2^>Nul') DO (
		TOOLS\CRYPT\CRYPT.EXE -decrypt -key "%DBDATE%%CKEY%" -infile "DB\THREAT\%%A\%%B" -outfile "DB_EXEC\THREAT\%%A\%%B" >Nul 2>Nul
		TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "DB_EXEC\THREAT\%%A\%%B" -ot file -actn ace -ace "n:Everyone;p:FILE_ADD_FILE;m:deny" -silent >Nul 2>Nul
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "DB\EXCEPT\*.DB" 2^>Nul') DO (
	TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "DB\EXCEPT\%%A" -ot file -actn ace -ace "n:Everyone;p:FILE_ADD_FILE;m:deny" -silent >Nul 2>Nul
)
ATTRIB.EXE +R +H "DB_EXEC\*" /S /D >Nul 2>Nul

REM * Check - Required Files
IF NOT EXIST DB_EXEC\CHECK\CHK_REQUIREDFILES.DB (
	SET ERRCODE=101
	GOTO MZK
)
FOR /F "DELIMS=" %%A IN (DB_EXEC\CHECK\CHK_REQUIREDFILES.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF NOT EXIST "%%A" (
			SET "STRTMP=%%~nxA"
			SET ERRCODE=101
			GOTO MZK
		)
	)
)

REM * Check - Validate Required Files
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "DB_EXEC\*.DB" 2^>Nul') DO (
	FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "DB_EXEC\%%A" 2^>Nul') DO (
		FOR /F %%X IN ('ECHO "%%B|E\%%A"^|TOOLS\GREP\GREP.EXE -Fxvf TOOLS\000.005 2^>Nul') DO (
			SET ERRCODE=107
			GOTO MZK
		)
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "DB_EXEC\" 2^>Nul') DO (
	IF /I NOT "%%A" == "EXCEPT" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "DB_EXEC\%%A\*.DB" 2^>Nul') DO (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "DB_EXEC\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('ECHO "%%C|E\%%A\%%B"^|TOOLS\GREP\GREP.EXE -Fxvf TOOLS\000.005 2^>Nul') DO (
					SET ERRCODE=107
					GOTO MZK
				)
			)
		)
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "DB_EXEC\ACTIVESCAN\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "DB_EXEC\ACTIVESCAN\%%A\*.DB" 2^>Nul') DO (
		FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "DB_EXEC\ACTIVESCAN\%%A\%%B" 2^>Nul') DO (
			FOR /F %%X IN ('ECHO "%%C|E\AS\%%A\%%B"^|TOOLS\GREP\GREP.EXE -Fxvf TOOLS\000.005 2^>Nul') DO (
				SET ERRCODE=107
				GOTO MZK
			)
		)
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "DB_EXEC\THREAT\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "DB_EXEC\THREAT\%%A\*.DB" 2^>Nul') DO (
		FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "DB_EXEC\THREAT\%%A\%%B" 2^>Nul') DO (
			FOR /F %%X IN ('ECHO "%%C|E\TH\%%A\%%B"^|TOOLS\GREP\GREP.EXE -Fxvf TOOLS\000.005 2^>Nul') DO (
				SET ERRCODE=107
				GOTO MZK
			)
		)
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "*" 2^>Nul') DO (
	FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%%A" 2^>Nul') DO (
		IF /I NOT "%%~xA" == ".TXT" (
			FOR /F %%X IN ('ECHO "%%B|XXX\%%A"^|TOOLS\GREP\GREP.EXE -Fxvf TOOLS\000.005 2^>Nul') DO (
				SET ERRCODE=107
				GOTO MZK
			)
		)
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /S /B /A-D "TOOLS\*" 2^>Nul') DO (
	FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%%A" 2^>Nul') DO (
		IF /I NOT "%%~xA" == ".TXT" (
			IF /I NOT "%%~xA" == ".XML" (
				IF /I NOT "%%~nxA" == "000.005" (
					FOR /F %%X IN ('ECHO "%%B|TOOLS\%%~nxA"^|TOOLS\GREP\GREP.EXE -Fxvf TOOLS\000.005 2^>Nul') DO (
						SET ERRCODE=107
						GOTO MZK
					)
				)
			)
		)
	)
)
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "DB\EXCEPT\*.DB" 2^>Nul') DO (
	FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "DB\EXCEPT\%%A" 2^>Nul') DO (
		FOR /F %%X IN ('ECHO "%%B|X\%%A"^|TOOLS\GREP\GREP.EXE -Fxvf TOOLS\000.005 2^>Nul') DO (
			SET ERRCODE=107
			GOTO MZK
		)
	)
)

REM * Check - Malicious Command-Line Autorun
FOR /F "TOKENS=2,*" %%A IN ('TOOLS\000.000 QUERY "HKCU\Software\Microsoft\Command Processor" /v AutoRun 2^>Nul^|TOOLS\GREP\GREP.EXE -Ei "[[:space:]]REG_(SZ|(EXPAND|MULTI)_SZ|(D|Q)WORD|BINARY|NONE)[[:space:]]" 2^>Nul') DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	ECHO "%%B"|TOOLS\GREP\GREP.EXE -Fiq "WINDOWS\IEUPDATE" >Nul 2>Nul
	IF !ERRORLEVEL! EQU 0 (
		ENDLOCAL
		TOOLS\000.000 DELETE "HKCU\Software\Microsoft\Command Processor" /v AutoRun /f >Nul 2>Nul
	) ELSE (
		ENDLOCAL
	)
)

REM * Check - Image File Execution Options
FOR /F "DELIMS=" %%A IN (DB_EXEC\CHECK\CHK_REQUIREDFILES_IMGFILEEXECOP.DB) DO (
	IF /I NOT "%%~nxA" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		SETLOCAL ENABLEDELAYEDEXPANSION
		TOOLS\000.000 DELETE "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%~nxA" /f >Nul 2>Nul
		IF !ERRORLEVEL! NEQ 0 (
			ENDLOCAL
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%~nxA" -ot reg -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -rec yes -actn setowner -ownr "n:Administrators" -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul
			TOOLS\000.000 DELETE "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%~nxA" /f >Nul 2>Nul
		) ELSE (
			ENDLOCAL
		)
		IF /I "%ARCHITECTURE%" == "x64" (
			SETLOCAL ENABLEDELAYEDEXPANSION
			TOOLS\000.000 DELETE "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%~nxA" /f >Nul 2>Nul
			IF !ERRORLEVEL! NEQ 0 (
				ENDLOCAL
				TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%~nxA" -ot reg -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -rec yes -actn setowner -ownr "n:Administrators" -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul
				TOOLS\000.000 DELETE "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%~nxA" /f >Nul 2>Nul
			) ELSE (
				ENDLOCAL
			)
		)
	)
)

REM * Repair - Required Files
FOR /F "DELIMS=" %%A IN (DB_EXEC\CHECK\CHK_REQUIREDFILES_SYSTEM.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF NOT EXIST "%SYSTEMROOT%\System32\%%A" (
			COPY /Y "%SYSTEMROOT%\System32\DllCache\%%A" "%SYSTEMROOT%\System32\" >Nul 2>Nul
			IF NOT EXIST "%SYSTEMROOT%\System32\%%A" (
				SET "STRTMP=%SYSTEMROOT%\System32\%%A"
				SET ERRCODE=102
				GOTO MZK
			)
		)
	)
)

REM * Check - Malicious Service Stop
REM :HKLM\System\CurrentControlSet\Services\6to4\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\6to4\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "6TO4SVC.DLL" (
		SC.EXE STOP "6to4" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\AeLookupSvc\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\AeLookupSvc\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "AELUPSVC.DLL" (
		SC.EXE STOP "AeLookupSvc" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\Appinfo\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Appinfo\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "APPINFO.DLL" (
		SC.EXE STOP "Appinfo" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\AppMgmt\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\AppMgmt\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "APPMGMTS.DLL" (
		SC.EXE STOP "AppMgmt" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\BITS\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\BITS\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "QMGR.DLL" (
		SC.EXE STOP "BITS" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\Browser\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Browser\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "BROWSER.DLL" (
		SC.EXE STOP "Browser" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\dmserver\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\dmserver\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "DMSERVER.DLL" (
		SC.EXE STOP "dmserver" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\DsmSvc\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\DsmSvc\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "DEVICESETUPMANAGER.DLL" (
		SC.EXE STOP "DsmSvc" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\Emproxy (ImagePath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Emproxy\ImagePath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "EMPROXY.EXE" (
		SC.EXE STOP "Emproxy" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\FastUserSwitchingCompatibility\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\FastUserSwitchingCompatibility\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "SHSVCS.DLL" (
		SC.EXE STOP "FastUserSwitchingCompatibility" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\Ias\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Ias\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IAS.DLL" (
		SC.EXE STOP "Ias" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\IKEEXT\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\IKEEXT\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IKEEXT.DLL" (
		SC.EXE STOP "IKEEXT" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\Irmon\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Irmon\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IRMON.DLL" (
		SC.EXE STOP "Irmon" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\MSiSCSI\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\MSiSCSI\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "ISCSIEXE.DLL" (
		SC.EXE STOP "MSiSCSI" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\NWCWorkstation\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\NWCWorkstation\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "NWWKS.DLL" (
		SC.EXE STOP "NWCWorkstation" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ip (DllPath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ip\DllPath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IPRTRMGR.DLL" (
		SC.EXE STOP "RemoteAccess" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipv6 (DllPath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipv6\DllPath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IPRTRMGR.DLL" (
		SC.EXE STOP "RemoteAccess" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipx (DllPath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipx\DllPath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IPXRTMGR.DLL" (
		SC.EXE STOP "RemoteAccess" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\Schedule\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Schedule\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "SCHEDSVC.DLL" (
		SC.EXE STOP "Schedule" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\StiSvc\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\StiSvc\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "WIASERVC.DLL" (
		SC.EXE STOP "StiSvc" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\SuperProServer (ImagePath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\SuperProServer\ImagePath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "SPNSRVNT.EXE" (
		SC.EXE STOP "SuperProServer" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\TermService\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\TermService\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "TERMSRV.DLL" (
		IF /I NOT "%%~nxA" == "RDPWRAP.DLL" (
			SC.EXE STOP "TermService" >Nul 2>Nul
		)
	)
)
REM :HKLM\System\CurrentControlSet\Services\UxSms\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\UxSms\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "UXSMS.DLL" (
		SC.EXE STOP "UxSms" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\Winmgmt\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Winmgmt\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "WMISVC.DLL" (
		SC.EXE STOP "Winmgmt" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\WmdmPmSN\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\WmdmPmSN\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "MSPMSNSV.DLL" (
		SC.EXE STOP "WmdmPmSN" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\WmdmPmSp\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\WmdmPmSp\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "MSPMSPSV.DLL" (
		SC.EXE STOP "WmdmPmSp" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\wuauserv\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\wuauserv\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "WUAUENG.DLL" (
		SC.EXE STOP "wuauserv" >Nul 2>Nul
	)
)
REM :HKLM\System\CurrentControlSet\Services\xmlprov\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\xmlprov\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "XMLPROV.DLL" (
		SC.EXE STOP "xmlprov" >Nul 2>Nul
	)
)

REG.EXE QUERY HKLM >Nul 2>Nul
IF %ERRORLEVEL% NEQ 0 (
	SET ERRCODE=106
	GOTO MZK
)

IF EXIST D:\MZKTEMP DEL /F /Q /A D:\MZKTEMP >Nul 2>Nul
COPY DB_ACTIVE\MZK D:\MZKTEMP >Nul 2>Nul
IF EXIST D:\MZKTEMP (
	SET DDRV=TRUE
	DEL /F /Q /A D:\MZKTEMP >Nul 2>Nul
)

REM * Reset - Count Value (All)
CALL :RESETVAL ALL

:MZK
COLOR 1F

CLS

REM * Start
ECHO ────────────────────────────────────────────────
ECHO.
ECHO      Malware Zero Kit  ^[DB: %DBDATE% V%DBVER%^]
ECHO.
ECHO      Virus Zero Season 2 : cafe.naver.com/malzero
ECHO.     Batch Script : ViOLeT ^(archguru^)
ECHO.
ECHO      경고 ^! 타 사이트/카페/블로그/토렌트 등에서 배포/개작 및 상업적 이용 절대 금지 ^!
ECHO.
ECHO ────────────────────────────────────────────────
ECHO.

REM * Check - Error Code
IF %ERRCODE% EQU 100 GOTO FAILEDOS
IF %ERRCODE% EQU 101 GOTO NOFILE
IF %ERRCODE% EQU 102 GOTO NOSYSF
IF %ERRCODE% EQU 103 GOTO FAILED
IF %ERRCODE% EQU 104 GOTO NOVAR
IF %ERRCODE% EQU 105 GOTO MALWARE
IF %ERRCODE% EQU 106 GOTO REGBLOCK
IF %ERRCODE% EQU 107 GOTO NOCOUNT

ECHO ⓘ 검사 진행 전에 반드시 읽어주세요 ^!
ECHO.
ECHO    검사 진행 시, 실행중인 프로그램을 모두 종료하므로 작업중인 것은 반드시 저장해주세요.
ECHO.
ECHO    해당 스크립트의 원활한 검사를 위해 안전 모드 환경에서의 실행을 권장합니다. ^(필수 아님^)
ECHO    표준 환경에서는 악성코드에 의한 강제 재부팅 또는 블루 스크린이 발생할 수 있습니다.
ECHO    ^(악성코드 유형에 따라 치료 후, 부팅 장애나 느려짐 등의 부작용 발생 가능성 존재^)
ECHO.
ECHO    이 스크립트는 악성 루트킷^(Rootkit^), 여러 유형의 악성코드 및 유해 가능 프로그램을 제거합니다.
ECHO    이 스크립트는 검사 시 위협 요소 및 임시 파일을 자동으로 제거하며, 오진 발생 시 문의주세요.
ECHO    이 스크립트는 보안 제품의 실시간 감시 기능이 동작 중일 경우, 검사 시간이 증가할 수 있습니다.
ECHO    이 스크립트는 보조 수단으로 한정되어야 하며, 필요한 경우에만 사용해주시기 바랍니다.
ECHO.
ECHO    스크립트 사용 후 반드시 보안 제품^(백신^)을 이용하여 정밀 검사를 수행해주세요.
ECHO.
ECHO    실행 시 창이 꺼지거나 검사 중 장시간 동작하지 않으면 ^<3. 문제 해결^> 문서를 참고해주세요.
ECHO.

PING.EXE -n 2 0 >Nul 2>Nul

IF %VK% EQU 1 START TOOLS\MAGNETOK\MAGNETOK.EXE >Nul 2>Nul

IF %AUTOMODE% EQU 1 (
	ECHO ⓘ 약 1분 후에 자동으로 검사를 진행합니다. 진행을 원하지 않으시면 종료해주세요 . . .

	PING.EXE -n 60 0 >Nul 2>Nul

	SET YNAAA=Y
) ELSE (
	SET /P YNAAA="● 선택: 동의 및 검사를 진행하시겠습니까 (Y/N)? "
)
IF /I NOT "%YNAAA%" == "ㅛ" (
	IF /I NOT "%YNAAA%" == "Y" (
		SET ERRCODE=999
		GOTO END
	)
)

IF %DATECHK% EQU 1 (
	COLOR 6F
	ECHO.
	ECHO ⓘ 경고 ^! 데이터베이스^(DB^) 버전이 오래되어 악성 프로그램을 효과적으로 제거할 수 없습니다.
	ECHO.
	ECHO    현재 사용중인 스크립트를 삭제 후, 새로 내려받아 검사를 진행해주시기 바랍니다.
	IF %AUTOMODE% NEQ 1 (
		ECHO.
		SET /P YNBBB="● 선택: 계속 진행하시겠습니까 (Y/N)? "
	) ELSE (
		SET YNBBB=Y
	)
) ELSE (
	SET YNBBB=Y
)
IF /I NOT "%YNBBB%" == "ㅛ" (
	IF /I NOT "%YNBBB%" == "Y" (
		SET ERRCODE=999
		GOTO END
	)
)

ECHO.

IF %AUTOMODE% NEQ 1 (
	ECHO ⓘ 악성 프로그램 및 악성코드를 효과적으로 제거하기 위해 Windows 탐색기를 종료합니다.
	ECHO.
	ECHO    종료 시 검사 완료 시 까지 바탕 화면이 비활성화 되며, 파일 복사/이동/삭제 작업이 취소됩니다.
	ECHO.
	ECHO    또한, 관리자 권한 문제로 인해 재부팅 전까지 프로그램 실행 및 설정 시 제약이 발생하므로
	ECHO    검사 완료 후 반드시 재부팅을 진행해주시기 바랍니다.
	ECHO.
	ECHO    종료 후, 검사 중 창이 꺼지거나 장시간 동작하지 않으면 CTRL ^+ ALT ^+ DEL 키를 동시에 누르세요.
	ECHO    이후, 종료 버튼 및 메뉴를 통해 재부팅 후 ^<3. 문제 해결^> 문서를 참고해주세요.
	ECHO.

	SET /P YNCCC="● 선택: Windows 탐색기를 종료하시겠습니까 (Y/N)? "

	ECHO.
) ELSE (
	SET YNCCC=N
)
IF /I NOT "%YNCCC%" == "ㅛ" (
	IF /I "%YNCCC%" == "Y" (
		SET CHKEXPLORER=1
		TOOLS\TASKS\TASKKILL.EXE /F /IM "EXPLORER.EXE" >Nul 2>Nul
	)
)

SCHTASKS.EXE /End /TN "\Microsoft\Windows\TextServicesFramework\MsCtfMonitor" >Nul 2>Nul
SCHTASKS.EXE /End /TN "\Microsoft\Windows\Multimedia\SystemSoundsService" >Nul 2>Nul

TOOLS\TASKS\TASKKILL.EXE /IM "CSCRIPT.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "DLLHOST.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "RUNDLL32.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "SCHTASKS.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "WSCRIPT.EXE" >Nul 2>Nul

TOOLS\TASKS\TASKKILL.EXE /F /IM "CSCRIPT.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /F /IM "DLLHOST.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /F /IM "RUNDLL32.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /F /IM "SCHTASKS.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /F /IM "WSCRIPT.EXE" >Nul 2>Nul

SET "STRTMP=%DATE% %TIME%"

SET "RPTDATE=%STRTMP:-=%"
SET "RPTDATE=%RPTDATE:/=%"
SET "RPTDATE=%RPTDATE::=%"
SET "RPTDATE=%RPTDATE:.=%"
SET "RPTDATE=%RPTDATE: =%"

REM * Setup - Quarantine
MKDIR "%SYSTEMDRIVE%\Quarantine_MZK" >Nul 2>Nul
MKDIR "%SYSTEMDRIVE%\Quarantine_MZK\Files" >Nul 2>Nul
MKDIR "%SYSTEMDRIVE%\Quarantine_MZK\Folders" >Nul 2>Nul
MKDIR "%SYSTEMDRIVE%\Quarantine_MZK\Registrys" >Nul 2>Nul
MKDIR "%SYSTEMDRIVE%\Quarantine_MZK\Files\%RPTDATE%" >Nul 2>Nul
MKDIR "%SYSTEMDRIVE%\Quarantine_MZK\Folders\%RPTDATE%" >Nul 2>Nul
MKDIR "%SYSTEMDRIVE%\Quarantine_MZK\Registrys\%RPTDATE%" >Nul 2>Nul

SET "QRoot=%SYSTEMDRIVE%\Quarantine_MZK"
SET "QFiles=%QRoot%\Files\%RPTDATE%"
SET "QFolders=%QRoot%\Folders\%RPTDATE%"
SET "QRegistrys=%QRoot%\Registrys\%RPTDATE%"

TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%QFiles%" -ot file -actn ace -ace "n:Everyone;p:FILE_TRAVERSE;m:deny" -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%QFolders%" -ot file -actn ace -ace "n:Everyone;p:FILE_TRAVERSE;m:deny" -silent >Nul 2>Nul

SET "QLog=%QRoot%\Report [%RPTDATE%].mzk.log"

REM * Setup - Start Logging
ECHO ◇ 검사 기록 시작 및 악성코드 격리를 위한 검역소 생성 . . .
ECHO    검사 일시 : %STRTMP%
ECHO    검역소 폴더 : %QRoot%
ECHO    기록 : %QLog%

>>"%QLog%" ECHO Malware Zero Kit Report File
>>"%QLog%" ECHO.
>>"%QLog%" ECHO -- 경고 --
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    데이터베이스는 자동으로 갱신되지 않기 때문에, 필요할 때마다 새로 내려받아 검사하시기 바랍니다.
>>"%QLog%" ECHO    오래된 데이터베이스로는 신규 악성 프로그램을 제거할 수 없습니다.
>>"%QLog%" ECHO.
>>"%QLog%" ECHO -- 알림 --
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    스크립트 사용 후, 아래 사항 반드시 확인
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    ① 악성코드 제거에 실패했을 경우, 안전 모드에서 검사를 진행하거나 재부팅 후 재검사 진행
>>"%QLog%" ECHO    ② 메모리를 활용하는 악성코드에 감염되었을 경우, 검사 후 반드시 재부팅 진행
>>"%QLog%" ECHO    ③ 웹 브라우저에서 악성 광고 창이 생성될 경우, 페이지 설정 및 부가/확장 프로그램 점검 및 재설치
>>"%QLog%" ECHO    ④ 한글 입력 불가 및 특정 프로그램^(예^: Classic Shell^)이 정상 실행되지 않을 경우 재부팅 진행
>>"%QLog%" ECHO    ⑤ 사용한 스크립트가 삭제되지 않을 경우, 재부팅 후 삭제 진행
>>"%QLog%" ECHO    ⑥ 검사 후 네트워크에 연결되지 않을 경우, ^<3. 문제 해결^> 문서 ^<문제 07^> 항목 참고
>>"%QLog%" ECHO    ⑦ 검사 중 오진 및 오동작이 발생한다면 ^<3. 문제 해결^> 문서 ^<문제 05^> 항목 참고
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    악성코드 제거 후, 보안 제품^(백신^)이 정상 동작하지 않는 상황이 지속될 경우 아래 사항 확인
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    ① 애드웨어 등 불필요 및 유해 가능 프로그램을 제거 후 다시 검사^(중요^)
>>"%QLog%" ECHO    ② 보안 업체에서 제공하는 전용 백신 추가 사용
>>"%QLog%" ECHO    ③ 동작하지 않는 보안 제품 제거 → 재부팅 → 설치 파일 새로 내려받기 → 재설치
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    ※ 자기 자신부터 보안 실천 ^! ^! ^! ^<5. 악성코드 감염 예방^> 문서 참고
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    ※ 악성코드 분석 요청 시 ^<3. 문제 해결^> 문서 ^<문제 17^> 항목 참고
>>"%QLog%" ECHO.
>>"%QLog%" ECHO -- 검사 정보 --
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    데이터베이스 버전 : %DBDATE% V%DBVER%
>>"%QLog%" ECHO.
FOR /F "DELIMS=" %%A IN ('VER 2^>Nul') DO (
	>>"%QLog%" ECHO    운영체제^(OS^) : %%A, %ARCHITECTURE%
)
IF NOT DEFINED SAFEBOOT_OPTION (
	>>"%QLog%" ECHO    검사 환경 : 표준
) ELSE (
	IF /I "%SAFEBOOT_OPTION%" == "MINIMAL" (
		>>"%QLog%" ECHO    검사 환경 : 안전 모드
	) ELSE (
		IF /I "%SAFEBOOT_OPTION%" == "NETWORK" (
			>>"%QLog%" ECHO    검사 환경 : 안전 모드 ^(네트워킹 사용^)
		) ELSE (
			>>"%QLog%" ECHO    검사 환경 : 안전 모드 ^(기타^)
		)
	)
)
>>"%QLog%" ECHO    검사 일시 : %STRTMP%
IF %VK% EQU 1 (
	>>"%QLog%" ECHO    검사 형식 : 가상 키보드
) ELSE (
	IF %AUTOMODE% EQU 1 (
		>>"%QLog%" ECHO    검사 형식 : 자동
	) ELSE (
		>>"%QLog%" ECHO    검사 형식 : 반자동
	)
)
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    검역소 폴더 : %QRoot%
>>"%QLog%" ECHO.

SET STRTMP=NULL

PING.EXE -n 4 0 >Nul 2>Nul

ECHO.

REM * Check - User Account Control
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System\EnableLUA" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%A" == "1" (
		>>"%QLog%" ECHO -- 사용자 계정 컨트롤^(UAC^) --
		>>"%QLog%" ECHO.
		>>"%QLog%" ECHO    ★ 위험 ★ 사용자 계정 컨트롤^(UAC^) 기능이 비활성화 되어 있습니다.
		>>"%QLog%" ECHO.

		ECHO ★ 위험 ★ 사용자 계정 컨트롤^(UAC^) 기능이 비활성화 되어 있습니다.
		ECHO.
		>VARIABLE\XXYY ECHO 1
	) ELSE (
		>>"%QLog%" ECHO -- 사용자 계정 컨트롤^(UAC^) --
		>>"%QLog%" ECHO.
		>>"%QLog%" ECHO    ★ 안전 ★ 사용자 계정 컨트롤^(UAC^) 기능이 활성화 되어 있습니다.
		>>"%QLog%" ECHO.
	)
)

>>"%QLog%" ECHO -- 상세 보고 --
>>"%QLog%" ECHO.

REM * Check - Required System Files
ECHO ◇ 필수 시스템 파일 존재 유/무 확인중 . . . & >>"%QLog%" ECHO    ■ 필수 시스템 파일 존재 유/무 확인 :
FOR /F "TOKENS=1,2,3 DELIMS=|" %%A IN (DB_EXEC\CHECK\CHK_SYSTEMFILE.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF EXIST "DB_EXEC\MD5CHK\CHK_MD5_%%A.DB" (
			>VARIABLE\TXT2 ECHO %%A
			TITLE 확인중 "%%A" 2>Nul
			IF %%B EQU 1 (
				>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%
				CALL :CHK_SYSF
			) ELSE (
				IF %%C EQU 1 (
					IF /I "%ARCHITECTURE%" == "x64" (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64
					) ELSE (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32
					)
					CALL :CHK_SYSF
				) ELSE (
					IF /I "%ARCHITECTURE%" == "x64" (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64
						CALL :CHK_SYSF
					)
					>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32
					CALL :CHK_SYSF
				)
			)
		)
	)
)
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\SRCH SET /P SRCH=
IF !SRCH! EQU 0 (
	ENDLOCAL
	ECHO    존재하지 않는 파일이 없습니다. & >>"%QLog%" ECHO    존재하지 않는 파일이 없음
	SET "YNCCC=Y"
) ELSE (
	ENDLOCAL
	>VARIABLE\XXXX ECHO 1
	IF %AUTOMODE% EQU 1 (
		ECHO.
		ECHO ⓘ 필수 시스템 파일이 존재하지 않아, 더이상 자동으로 진행할 수 없습니다.
		ECHO.
		SET "YNCCC=N"
	) ELSE (
		ECHO.
		ECHO ⓘ 필수 시스템 파일이 존재하지 않아, 만약을 위해 파일 복원 후 검사하는 것을 권장합니다.
		ECHO.
		SET /P YNCCC="● 선택: 검사를 계속 진행하시겠습니까 (Y/N)? "
	)
)
IF /I NOT "%YNCCC%" == "ㅛ" (
	IF /I NOT "%YNCCC%" == "Y" (
		SET ERRCODE=999
		GOTO END
	)
)

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset - Malicious AppInit_DLLs Values (x64 or x86)
ECHO ◇ 악성 및 유해 가능 자동 실행 라이브러리^(AppInit_DLLs^) 값 확인중 . . . & >>"%QLog%" ECHO    ■ 악성 및 유해 가능 자동 실행 라이브러리^(AppInit_DLLs^) 값 확인 :
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%Z IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	SET "REGTMP=%%Z"
	SETLOCAL ENABLEDELAYEDEXPANSION
	SET "REGTMP=!REGTMP:"=!"
	FOR /F "TOKENS=1,2,3,4,5 DELIMS=," %%A IN ("!REGTMP!") DO (
		IF NOT "%%~nxA" == "" (
			IF /I "%%~xA" == ".TXT" (
				>>VARIABLE\RGST ECHO "FAKETEXT"
			) ELSE (
				>>VARIABLE\RGST ECHO "%%~nxA"
			)
		)
		IF NOT "%%~nxB" == "" (
			IF /I "%%~xB" == ".TXT" (
				>>VARIABLE\RGST ECHO "FAKETEXT"
			) ELSE (
				>>VARIABLE\RGST ECHO "%%~nxB"
			)
		)
		IF NOT "%%~nxC" == "" (
			IF /I "%%~xC" == ".TXT" (
				>>VARIABLE\RGST ECHO "FAKETEXT"
			) ELSE (
				>>VARIABLE\RGST ECHO "%%~nxC"
			)
		)
		IF NOT "%%~nxD" == "" (
			IF /I "%%~xD" == ".TXT" (
				>>VARIABLE\RGST ECHO "FAKETEXT"
			) ELSE (
				>>VARIABLE\RGST ECHO "%%~nxD"
			)
		)
		IF NOT "%%~nxE" == "" (
			IF /I "%%~xE" == ".TXT" (
				>>VARIABLE\RGST ECHO "FAKETEXT"
			) ELSE (
				>>VARIABLE\RGST ECHO "%%~nxE"
			)
		)
	)
	ENDLOCAL
)
FOR /F "DELIMS=" %%A IN (VARIABLE\RGST) DO (
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%~A" DB_EXEC\CHECK\CHK_APPINIT_DLLS.DB 2^>Nul') DO (
		SETLOCAL ENABLEDELAYEDEXPANSION
		>VARIABLE\CHCK ECHO 1
		REG.EXE EXPORT "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" "!QRegistrys!\HKLM_WinNT_Windows.reg" /y >Nul 2>Nul
		REG.EXE ADD "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs /d "" /f >Nul 2>Nul
		IF !ERRORLEVEL! EQU 0 (
			ECHO    비정상 값이 발견되어 초기화를 진행합니다. ^(재부팅 필요^) & >>"!QLog!" ECHO    비정상 값이 발견되어 초기화 진행 ^(재부팅 필요^)
		) ELSE (
			ECHO    비정상 값이 발견되어 초기화를 진행하였으나 오류가 발생했습니다. & >>"!QLog!" ECHO    비정상 값이 발견되어 초기화 진행 ^(실패 - 오류 발생^)
		)
		ENDLOCAL & GOTO GO_INIT1
	)
)
:GO_INIT1
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\CHCK SET /P CHCK=
IF !CHCK! EQU 0 (
	ENDLOCAL
	ECHO    문제점이 발견되지 않았습니다. & >>"%QLog%" ECHO    문제점이 발견되지 않음
) ELSE (
	ENDLOCAL
	>VARIABLE\XXXX ECHO 1 & COLOR 4F
)
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset - Malicious AppInit_DLLs Values (x86)
IF /I "%ARCHITECTURE%" == "x64" (
	ECHO ◇ 악성 및 유해 가능 자동 실행 라이브러리^(AppInit_DLLs, 32bit^) 값 확인중 . . . & >>"%QLog%" ECHO    ■ 악성 및 유해 가능 자동 실행 라이브러리^(AppInit_DLLs, 32bit^) 값 확인 :
	TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
	FOR /F "TOKENS=2,*" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows\AppInit_DLLs" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
		SET "REGTMP=%%Z"
		SETLOCAL ENABLEDELAYEDEXPANSION
		SET "REGTMP=!REGTMP:"=!"
		FOR /F "TOKENS=1,2,3,4,5 DELIMS=," %%A IN ("!REGTMP!") DO (
			IF NOT "%%~nxA" == "" (
				IF /I "%%~xA" == ".TXT" (
					>>VARIABLE\RGST ECHO "FAKETEXT"
				) ELSE (
					>>VARIABLE\RGST ECHO "%%~nxA"
				)
			)
			IF NOT "%%~nxB" == "" (
				IF /I "%%~xB" == ".TXT" (
					>>VARIABLE\RGST ECHO "FAKETEXT"
				) ELSE (
					>>VARIABLE\RGST ECHO "%%~nxB"
				)
			)
			IF NOT "%%~nxC" == "" (
				IF /I "%%~xC" == ".TXT" (
					>>VARIABLE\RGST ECHO "FAKETEXT"
				) ELSE (
					>>VARIABLE\RGST ECHO "%%~nxC"
				)
			)
			IF NOT "%%~nxD" == "" (
				IF /I "%%~xD" == ".TXT" (
					>>VARIABLE\RGST ECHO "FAKETEXT"
				) ELSE (
					>>VARIABLE\RGST ECHO "%%~nxD"
				)
			)
			IF NOT "%%~nxE" == "" (
				IF /I "%%~xE" == ".TXT" (
					>>VARIABLE\RGST ECHO "FAKETEXT"
				) ELSE (
					>>VARIABLE\RGST ECHO "%%~nxE"
				)
			)
		)
		ENDLOCAL
	)
	FOR /F "DELIMS=" %%A IN (VARIABLE\RGST) DO (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%~A" DB_EXEC\CHECK\CHK_APPINIT_DLLS.DB 2^>Nul') DO (
			SETLOCAL ENABLEDELAYEDEXPANSION
			>VARIABLE\CHCK ECHO 1
			REG.EXE EXPORT "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows" "!QRegistrys!\HKLM_WinNT_Windows(x86).reg" /y >Nul 2>Nul
			REG.EXE ADD "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows" /v AppInit_DLLs /d "" /f >Nul 2>Nul
			IF !ERRORLEVEL! EQU 0 (
				ECHO    비정상 값이 발견되어 초기화를 진행합니다. ^(재부팅 필요^) & >>"!QLog!" ECHO    비정상 값이 발견되어 초기화 진행 ^(재부팅 필요^)
			) ELSE (
				ECHO    비정상 값이 발견되어 초기화를 진행하였으나 오류가 발생했습니다. & >>"!QLog!" ECHO    비정상 값이 발견되어 초기화 진행 ^(실패 - 오류 발생^)
			)
			ENDLOCAL & GOTO GO_INIT2
		)
	)
	:GO_INIT2
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		ECHO    문제점이 발견되지 않았습니다. & >>"%QLog%" ECHO    문제점이 발견되지 않음
	) ELSE (
		ENDLOCAL
		>VARIABLE\XXXX ECHO 1 & COLOR 4F
	)
	REM :Reset Value
	CALL :RESETVAL

	TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.
)

REM * Delete - Malicious Services
ECHO ◇ 악성 및 유해 가능 서비스 제거중 . . . & >>"%QLog%" ECHO    ■ 악성 및 유해 가능 서비스 제거 :
>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services
SET "STRTMP=HKLM_Services"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\System\CurrentControlSet\Services" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB_EXEC\CHECK\CHK_TRUSTEDSERVICES.DB 2^>Nul') DO (
	TITLE 검사중 "%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%A^|
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\SERVICE\DEL_SERVICE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_SVC NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\%%A\Description" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%Y
			FOR /F %%Z IN ('TOOLS\GREP\GREP.EXE -Fxf DB_EXEC\THREAT\SERVICE\DEL_SERVICE_DESCRIPTION.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_SVC NULL BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\%%A\DisplayName" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%Y
			FOR /F %%Z IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\SERVICE\DEL_SERVICE_DISPLAYNAME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_SVC NULL BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\SERVICE\PATTERN_TYPE1.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_SVC ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\SERVICE\PATTERN_TYPE2.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_SVC ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\%%A\ImagePath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%Y
			FOR /F %%Z IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\SERVICE\PATTERN_IMAGEPATH.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_SVC ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\%%A\ImagePath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%Y
			FOR /F %%Z IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\SERVICE\PATTERN_IMAGEPATH_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_SVC ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\%%A\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%Y
			FOR /F %%Z IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\SERVICE\PATTERN_SERVICEDLL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_SVC ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :Result
CALL :P_RESULT RECK CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Check - Required System Files <#1>
ECHO ◇ 필수 시스템 파일 확인중 - 1차 . . . & >>"%QLog%" ECHO    ■ 필수 시스템 파일 확인 - 1차 :
FOR /F "TOKENS=1,2,3 DELIMS=|" %%A IN (DB_EXEC\CHECK\CHK_SYSTEMFILE.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ MZK CHECK CHK_SYSTEMFILE.DB ~~~~~~~~~~" (
		IF EXIST "DB_EXEC\MD5CHK\CHK_MD5_%%A.DB" (
			>VARIABLE\TXT2 ECHO %%A
			TITLE 확인중 "%%A" 2>Nul
			IF %%B EQU 1 (
				>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%
				CALL :CHK_SYSX
			) ELSE (
				IF %%C EQU 1 (
					IF /I "%ARCHITECTURE%" == "x64" (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64
					) ELSE (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32
					)
					CALL :CHK_SYSX
				) ELSE (
					IF /I "%ARCHITECTURE%" == "x64" (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64
						CALL :CHK_SYSX
					)
					>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32
					CALL :CHK_SYSX
				)
			)
		)
	)
)
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\SRCH SET /P SRCH=
<VARIABLE\FAIL SET /P FAIL=
IF !SRCH! EQU 0 (
	ECHO    문제점이 발견되지 않았습니다. & >>"%QLog%" ECHO    문제점이 발견되지 않음
) ELSE (
	>VARIABLE\XXYY ECHO 1
	IF !FAIL! EQU 1 (
		ECHO. & >>"!QLog!" ECHO.
		ECHO    ⓘ 상세 진단 기록 확인 후 ^<3. 문제 해결^> 문서 ^<문제 13^> 항목 참고 & >>"!QLog!" ECHO    ⓘ ^<3. 문제 해결^> 문서 ^<문제 13^> 항목 참고
	)
)
ENDLOCAL
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset Process Autorun Registry
ECHO ◇ 초기화 대상 프로세스 자동 실행 레지스트리 확인중 . . . & >>"%QLog%" ECHO    ■ 초기화 대상 프로세스 자동 실행 레지스트리 확인 :
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
REM :HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (Shell)
TITLE 확인중 "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : Shell" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%~nxA
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_REG_WINLOGON_SHELL.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
		>VARIABLE\TXT2 ECHO explorer.exe
		CALL :RESETREG Shell NULL BACKUP "HKCU_WinNT_Winlogon"
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (Shell)
TITLE 확인중 "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : Shell" 2>Nul
>VARIABLE\TXTX TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell" 2>Nul|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /S VARIABLE\TXTX 2^>Nul') DO (
	IF %%~zA LEQ 4 (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
		>VARIABLE\TXT2 ECHO explorer.exe
		CALL :RESETREG Shell NULL NULL NULL
	) ELSE (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_REG_WINLOGON_SHELL.DB VARIABLE\TXTX 2^>Nul') DO (
			>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
			>VARIABLE\TXT2 ECHO explorer.exe
			CALL :RESETREG Shell NULL BACKUP "HKLM_WinNT_Winlogon"
		)
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon (Shell)
IF /I "%ARCHITECTURE%" == "x64" (
	TITLE 확인중 "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon : Shell" 2>Nul
	>VARIABLE\TXTX TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell" 2>Nul|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2>Nul
	FOR /F "DELIMS=" %%A IN ('DIR /B /S VARIABLE\TXTX 2^>Nul') DO (
		IF %%~zA LEQ 4 (
			>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
			>VARIABLE\TXT2 ECHO explorer.exe
			CALL :RESETREG Shell NULL NULL NULL
		) ELSE (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_REG_WINLOGON_SHELL.DB VARIABLE\TXTX 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
				>VARIABLE\TXT2 ECHO explorer.exe
				CALL :RESETREG Shell NULL BACKUP "HKLM_WinNT_Winlogon(x86)"
			)
		)
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (System)
TITLE 확인중 "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : System" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\System" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
	>VARIABLE\TXT2 ECHO NULL
	CALL :RESETREG System NULL BACKUP "HKLM_WinNT_Winlogon"
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (Userinit)
TITLE 확인중 "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : Userinit" 2>Nul
TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" >Nul 2>Nul
IF %ERRORLEVEL% EQU 1 (
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
	>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
	CALL :RESETREG Userinit NULL NULL NULL
) ELSE (
	FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
		IF /I NOT "%%~A" == "%SYSTEMROOT%\System32\Userinit.exe," (
			>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
			>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
			CALL :RESETREG Userinit NULL BACKUP "HKLM_WinNT_Winlogon"
		)
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon (Userinit)
IF /I "%ARCHITECTURE%" == "x64" (
	TITLE 확인중 "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon : Userinit" 2>Nul
	TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" >Nul 2>Nul
	IF %ERRORLEVEL% EQU 1 (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
		>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
		CALL :RESETREG Userinit NULL NULL NULL
	) ELSE (
		FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			IF /I NOT "%%~A" == "%SYSTEMROOT%\System32\Userinit.exe," (
				IF /I NOT "%%~A" == "Userinit.exe" (
					>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
					>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
					CALL :RESETREG Userinit NULL BACKUP "HKLM_WinNT_Winlogon(x86)"
				)
			)
		)
	)
)
REG.EXE DELETE "HKLM\System\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations /f >Nul 2>Nul
REM :Result
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\SRCH SET /P SRCH=
<VARIABLE\SUCC SET /P SUCC=
<VARIABLE\FAIL SET /P FAIL=
IF !SRCH! EQU 0 (
	ECHO    문제점이 발견되지 않았습니다. & >>"!QLog!" ECHO    문제점이 발견되지 않음
) ELSE (
	ECHO    발견: !SRCH! / 초기화: !SUCC! / 초기화 실패: !FAIL!
	>VARIABLE\XXYY ECHO 1
)
ENDLOCAL
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Task Killing
ECHO ◇ 악성 및 불필요한 프로세스 종료중 ^(화면이 잠시 깜박일 수 있음^) . . .
FOR /F "DELIMS=" %%A IN (DB_EXEC\CHECK\CHK_PROCESSKILL_FAKESYSTEMPROCESS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ MZK CHECK CHK_PROCESSKILL_FAKESYSTEMPROCESS.DB ~~~~~~~~~~" (
		TITLE 확인중 "%%A" 2>Nul
		FOR /F "TOKENS=2 DELIMS=(" %%B IN ('TOOLS\TASKS\TASKKILL.EXE /IM "%%A" 2^>NUL') DO (
			FOR /F "TOKENS=1 DELIMS=)" %%C IN ('ECHO %%B^|TOOLS\GREP\GREP.EXE -Ex "PID [0-9]{1,5}" 2^>Nul') DO (
				TITLE 종료중 "%%A" 2>Nul
				TOOLS\TASKS\TASKKILL.EXE /F /%%C >Nul 2>Nul
				TOOLS\TASKS\TASKKILL.EXE /F /%%C >Nul 2>Nul
			)
		)
		FOR /F "TOKENS=10,11" %%B IN ('TOOLS\TASKS\TASKKILL.EXE /IM "%%A" 2^>NUL') DO (
			IF /I "%%B" == "PID" (
				TITLE 종료중 "%%A" 2>Nul
				SET "STRTMP=%%C"
				SETLOCAL ENABLEDELAYEDEXPANSION
				SET "STRTMP=!STRTMP:.=!"
				TOOLS\TASKS\TASKKILL.EXE /F /%%B !STRTMP! >Nul 2>Nul
				TOOLS\TASKS\TASKKILL.EXE /F /%%B !STRTMP! >Nul 2>Nul
				ENDLOCAL
			)
		)
	)
)
FOR /F "DELIMS=" %%A IN (DB_EXEC\CHECK\CHK_PROCESSKILL_BROWSER.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ MZK CHECK CHK_PROCESSKILL_BROWSER.DB ~~~~~~~~~~" (
		TITLE 종료중 "%%A" 2>Nul
		TOOLS\TASKS\TASKKILL.EXE /F /IM "%%A" >Nul 2>Nul
	)
)
TOOLS\TASKS\TASKKILL.EXE /IM "DOPUS.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "DOPUSRT.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "FLYEXPLORER.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "NEXUSFILE.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "TASKENG.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "TASKHOST.EXE" >Nul 2>Nul
TOOLS\TASKS\TASKKILL.EXE /IM "WININIT.EXE" >Nul 2>Nul
SC.EXE STOP UXSMS >Nul 2>Nul
FOR /F "TOKENS=1,2,5 DELIMS=," %%A IN ('TOOLS\TASKS\TASKLIST.EXE /FO CSV 2^>Nul^|TOOLS\GREP\GREP.EXE -F "." 2^>Nul') DO (
	SETLOCAL ENABLEDELAYEDEXPANSION
	TOOLS\GREP\GREP.EXE -Fixq "%%~nxA" DB_EXEC\CHECK\CHK_TRUSTEDPROCESS.DB >Nul 2>Nul
	IF !ERRORLEVEL! EQU 1 (
		TITLE 종료중 "%%~nxA" 2>Nul
		TOOLS\TASKS\TASKKILL.EXE /F /T /IM "%%~nxA" >Nul 2>Nul
	) ELSE (
		TITLE 보호됨 "%%~nxA" 2>Nul
	)
	ENDLOCAL
)
SC.EXE START UXSMS >Nul 2>Nul
SCHTASKS.EXE /Run /TN "\Microsoft\Windows\TextServicesFramework\MsCtfMonitor" >Nul 2>Nul
SCHTASKS.EXE /Run /TN "\Microsoft\Windows\Multimedia\SystemSoundsService" >Nul 2>Nul
ECHO    완료되었습니다.
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO.

REM * Delete - Temporary & Cache Files #1
ECHO ◇ 임시 파일/폴더 정리중 - 1차 . . .
TITLE ^(정리중^) 잠시만 기다려주세요 ^(시간이 다소 소요될 수 있음^) . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\Temp\" 2^>Nul') DO (
	RD /Q /S "%SYSTEMROOT%\Temp\%%A" >Nul 2>Nul
)
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%TEMP%\" 2^>Nul') DO (
	RD /Q /S "%TEMP%\%%A" >Nul 2>Nul
)
DEL /F /Q /S /A "%SYSTEMROOT%\Temp" >Nul 2>Nul
DEL /F /Q /S /A "%APPDATA%\Temp" >Nul 2>Nul
DEL /F /Q /S /A "%TEMP%" >Nul 2>Nul
ECHO    완료되었습니다.

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO.

REM * Delete Malicious File
ECHO ◇ 악성 및 유해 가능 파일 제거중 . . .
>>"%QLog%" ECHO    ■ 악성 및 유해 가능 파일 제거 :
REM :[%SYSTEMROOT%]\Tasks
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\Tasks\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\Tasks\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\Tasks\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TASKS.DB VARIABLE\TXT2 2^>Nul') DO (
			IF /I "%%~xA" == ".JOB" (
				>>DB_ACTIVE\ACT_REG_TASKS_JOB.DB ECHO %%A
				>>DB_ACTIVE\ACT_REG_TASKS_JOB.DB ECHO %%A.fp
			)
			CALL :DEL_FILE ACTIVESCAN
		)
	)
	IF EXIST "%SYSTEMROOT%\Tasks\%%A" (
		IF /I "%%~xA" == ".JOB" (
			IF %%~zA LEQ 10000 (
				FOR /F %%X IN ('TOOLS\BINASC\BINASC.EXE -a "%SYSTEMROOT%\Tasks\%%A" --wrap 1500 2^>Nul^|TOOLS\GREP\GREP.EXE -f DB_EXEC\ACTIVESCAN\FILE\PATTERN_TASKS_PATHDATA.DB 2^>Nul') DO (
					>>DB_ACTIVE\ACT_REG_TASKS_JOB.DB ECHO %%A
					>>DB_ACTIVE\ACT_REG_TASKS_JOB.DB ECHO %%A.fp
					CALL :DEL_FILE ACTIVESCAN
				)
			)
		)
	)
)
REM :[%SYSTEMROOT%]\System32\Tasks
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Tasks\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Tasks\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System32\Tasks\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS_TREE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TASKS.DB VARIABLE\TXT2 2^>Nul') DO (
			>>DB_ACTIVE\ACT_REG_TASKS_TREE.DB ECHO %%A
			CALL :DEL_FILE ACTIVESCAN
		)
	)
	IF EXIST "%SYSTEMROOT%\System32\Tasks\%%A" (
		FOR /F %%X IN ('TYPE "%SYSTEMROOT%\System32\Tasks\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\FILE\PATTERN_TASKS_PATHDATAX.DB 2^>Nul') DO (
			>>DB_ACTIVE\ACT_REG_TASKS_TREE.DB ECHO %%A
			CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Tasks
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Tasks\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Tasks\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\SysWOW64\Tasks\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS_TREE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Tasks\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TASKS.DB VARIABLE\TXT2 2^>Nul') DO (
			>>DB_ACTIVE\ACT_REG_TASKS_TREE.DB ECHO %%A
			CALL :DEL_FILE ACTIVESCAN
		)
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Tasks\%%A" (
		FOR /F %%X IN ('TYPE "%SYSTEMROOT%\SysWOW64\Tasks\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\FILE\PATTERN_TASKS_PATHDATAX.DB 2^>Nul') DO (
			>>DB_ACTIVE\ACT_REG_TASKS_TREE.DB ECHO %%A
			CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :[%SYSTEMDRIVE%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMDRIVE%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_ROOT.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMDRIVE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMDRIVE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_ROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMDRIVE%\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%SYSTEMDRIVE%\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
	IF EXIST "%SYSTEMDRIVE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_ROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMDRIVE%] (for 1-Step MD5)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMDRIVE%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_ROOT.DB 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMDRIVE%\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%SYSTEMDRIVE%\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%SYSTEMDRIVE%\%%A\%%B" (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%SYSTEMDRIVE%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
			)
		)
	)
)
REM :[%SYSTEMDRIVE%] (ETCs)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\FILEDEL_ROOT_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE 검사중^(DB^) "%SYSTEMDRIVE%%%A" 2>Nul
		IF EXIST "%SYSTEMDRIVE%%%A" (
			>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :[%SYSTEMROOT%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEMROOT.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_SYSTEMROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%SYSTEMROOT%\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
	IF EXIST "%SYSTEMROOT%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEMROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\System
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_SYSTEM.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
)
REM :[%SYSTEMROOT%]\System32
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System32\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%SYSTEMROOT%\System32\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
	IF EXIST "%SYSTEMROOT%\System32\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\SysWOW64
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\SysWOW64\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%SYSTEMROOT%\SysWOW64\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\System32\Drivers
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Drivers\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Drivers\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432_DRIVERS.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System32\Drivers\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Drivers\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_ROOTKIT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Drivers\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_SYSTEM6432_DRIVERS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Drivers\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_ROOTKIT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Drivers
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Drivers\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Drivers\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432_DRIVERS.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\SysWOW64\Drivers\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Drivers\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_ROOTKIT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Drivers\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_SYSTEM6432_DRIVERS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Drivers\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_ROOTKIT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\System32/SysWOW64 (ETCs)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\FILEDEL_SYSTEM6432_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE 검사중^(DB^) "%SYSTEMROOT%\System32%%A" 2>Nul
		IF EXIST "%SYSTEMROOT%\System32%%A" (
			>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE 검사중^(DB^) "%SYSTEMROOT%\SysWOW64%%A" 2>Nul
		IF EXIST "%SYSTEMROOT%\SysWOW64%%A" (
			>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :[%SYSTEMROOT%] (ETCs)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\FILEDEL_SYSTEMROOT_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE 검사중^(DB^) "%SYSTEMROOT%%%A" 2>Nul
		IF EXIST "%SYSTEMROOT%%%A" (
			>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Microsoft\Windows\Start Menu\Programs\StartUp
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\" 2^>Nul') DO (
	TITLE 검사중 "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_STARTUP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_STARTUP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
	IF /I "%%~xA" == ".LNK" (
		IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
			FOR /F "TOKENS=1,* DELIMS==" %%B IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "WorkingDirectory=" 2^>Nul') DO (
				>VARIABLE\TXTX ECHO %%C
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_STARTUP_PATHDATA.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
			)
		)
	)
	IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%APPDATA%]\Microsoft\Windows\Start Menu\Programs\StartUp
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\" 2^>Nul') DO (
	TITLE 검사중 "%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_STARTUP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_STARTUP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
	IF /I "%%~xA" == ".LNK" (
		IF EXIST "%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
			FOR /F "TOKENS=1,* DELIMS==" %%B IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "WorkingDirectory=" 2^>Nul') DO (
				>VARIABLE\TXTX ECHO %%C
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_STARTUP_PATHDATA.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
			)
		)
	)
	IF EXIST "%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%APPDATA%\Microsoft\Windows\Start Menu\Programs\StartUp\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%ALLUSERSPROFILE%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul^|TOOLS\GREP\GREP.EXE -ixvf DB\EXCEPT\EX_FILE_APPDATA_REGEX.DB 2^>Nul') DO (
	TITLE 검사중 "%ALLUSERSPROFILE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%ALLUSERSPROFILE%] (for 1-Step & MD5)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%ALLUSERSPROFILE%\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%ALLUSERSPROFILE%\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%ALLUSERSPROFILE%\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%ALLUSERSPROFILE%\%%A\%%B" (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%ALLUSERSPROFILE%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
			)
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Application Data
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Application Data\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Application Data\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul^|TOOLS\GREP\GREP.EXE -ixvf DB\EXCEPT\EX_FILE_APPDATA_REGEX.DB 2^>Nul') DO (
	TITLE 검사중 "%ALLUSERSPROFILE%\Application Data\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Application Data\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%ALLUSERSPROFILE%\Application Data\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%ALLUSERSPROFILE%\Application Data\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%LOCALAPPDATA%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%LOCALAPPDATA%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%LOCALAPPDATA%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%LOCALAPPDATA%] (for 1-Step & MD5)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%LOCALAPPDATA%\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%LOCALAPPDATA%\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%LOCALAPPDATA%\%%A\%%B" (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%LOCALAPPDATA%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
			)
		)
	)
)
REM :[%LOCALLOWAPPDATA%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALLOWAPPDATA%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%LOCALLOWAPPDATA%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%LOCALLOWAPPDATA%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALLOWAPPDATA%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%LOCALLOWAPPDATA%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%LOCALLOWAPPDATA%] (for 1-Step & MD5)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALLOWAPPDATA%\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKLOCALLOWAPPDATA%\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%LOCALLOWAPPDATA%\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%LOCALLOWAPPDATA%\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%LOCALLOWAPPDATA%\%%A\%%B" (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%LOCALLOWAPPDATA%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
			)
		)
	)
)
REM :[%APPDATA%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%APPDATA%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%APPDATA%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%APPDATA%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%APPDATA%] (for 1-Step & MD5)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKAPPDATA%\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%APPDATA%\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%APPDATA%\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%APPDATA%\%%A\%%B" (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%APPDATA%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
			)
		)
	)
)
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\AppData\Local
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\AppData\Local
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\AppData\LocalLow
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\AppData\LocalLow
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\AppData\Roaming
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\AppData\Roaming
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :Application Data (ETCs)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\FILEDEL_APPDATA_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE 검사중^(DB^) "%ALLUSERSPROFILE%%%A" 2>Nul
		IF EXIST "%ALLUSERSPROFILE%%%A" (
			>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE 검사중^(DB^) "%ALLUSERSPROFILE%\Application Data%%A" 2>Nul
		IF EXIST "%ALLUSERSPROFILE%\Application Data%%A" (
			>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Application Data%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE 검사중^(DB^) "%LOCALAPPDATA%%%A" 2>Nul
		IF EXIST "%LOCALAPPDATA%%%A" (
			>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE 검사중^(DB^) "%LOCALLOWAPPDATA%%%A" 2>Nul
		IF EXIST "%LOCALLOWAPPDATA%%%A" (
			>VARIABLE\TXT1 ECHO %MZKLOCALLOWAPPDATA%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE 검사중^(DB^) "%APPDATA%%%A" 2>Nul
		IF EXIST "%APPDATA%%%A" (
			>VARIABLE\TXT1 ECHO %MZKAPPDATA%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Desktop
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Desktop\" 2^>Nul') DO (
	TITLE 검사중 "%ALLUSERSPROFILE%\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Desktop\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_DESKTOP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%ALLUSERSPROFILE%\Desktop\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%ALLUSERSPROFILE%\Desktop\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%USERPROFILE%]\Desktop
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%USERPROFILE%\Desktop\" 2^>Nul') DO (
	TITLE 검사중 "%USERPROFILE%\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%USERPROFILE%\Desktop\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_DESKTOP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%USERPROFILE%\Desktop\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%USERPROFILE%\Desktop\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\Desktop
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_DESKTOP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\Desktop
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_DESKTOP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%PUBLIC%]\Desktop
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPUBLIC%\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%PUBLIC%\Desktop\" 2^>Nul') DO (
	TITLE 검사중 "%PUBLIC%\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%PUBLIC%\Desktop\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_DESKTOP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%PUBLIC%\Desktop\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%PUBLIC%\Desktop\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%USERPROFILE%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%USERPROFILE%\" 2^>Nul') DO (
	TITLE 검사중 "%USERPROFILE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%USERPROFILE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%USERPROFILE%\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%USERPROFILE%\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
	IF EXIST "%USERPROFILE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%USERPROFILE%]\Documents
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\Documents\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%USERPROFILE%\Documents\" 2^>Nul') DO (
	TITLE 검사중 "%USERPROFILE%\Documents\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%USERPROFILE%\Documents\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_PROFILE_DOCUMENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%USERPROFILE%\Documents\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%USERPROFILE%\Documents\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%PUBLIC%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPUBLIC%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%PUBLIC%\" 2^>Nul') DO (
	TITLE 검사중 "%PUBLIC%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%PUBLIC%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
)
REM :Profiles (ETCs)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\FILEDEL_PROFILE_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE 검사중^(DB^) "%ALLUSERSPROFILE%%%A" 2>Nul
		IF EXIST "%ALLUSERSPROFILE%%%A" (
			>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE 검사중^(DB^) "%USERPROFILE%%%A" 2>Nul
		IF EXIST "%USERPROFILE%%%A" (
			>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE 검사중^(DB^) "%PUBLIC%%%A" 2>Nul
		IF EXIST "%PUBLIC%%%A" (
			>VARIABLE\TXT1 ECHO %MZKPUBLIC%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Templates
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Templates\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Templates\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_TEMPLATES.DB 2^>Nul') DO (
	TITLE 검사중 "%ALLUSERSPROFILE%\Templates\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Templates\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TEMPLATES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%ALLUSERSPROFILE%]\Microsoft\Windows\Templates
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Microsoft\Windows\Templates\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Microsoft\Windows\Templates\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_TEMPLATES.DB 2^>Nul') DO (
	TITLE 검사중 "%ALLUSERSPROFILE%\Microsoft\Windows\Templates\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Microsoft\Windows\Templates\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TEMPLATES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%USERPROFILE%]\Templates
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\Templates\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%USERPROFILE%\Templates\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_TEMPLATES.DB 2^>Nul') DO (
	TITLE 검사중 "%USERPROFILE%\Templates\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%USERPROFILE%\Templates\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TEMPLATES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%APPDATA%]\Microsoft\Windows\Templates
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Windows\Templates\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Microsoft\Windows\Templates\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_TEMPLATES.DB 2^>Nul') DO (
	TITLE 검사중 "%APPDATA%\Microsoft\Windows\Templates\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%APPDATA%\Microsoft\Windows\Templates\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TEMPLATES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%PROGRAMFILES%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPROGRAMFILES%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%PROGRAMFILES%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_PROGRAMFILES.DB 2^>Nul') DO (
	TITLE 검사중 "%PROGRAMFILES%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%PROGRAMFILES%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%PROGRAMFILES%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
	IF EXIST "%PROGRAMFILES%\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%PROGRAMFILES%\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%PROGRAMFILESX86%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPROGRAMFILESX86%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%PROGRAMFILESX86%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_PROGRAMFILES.DB 2^>Nul') DO (
	TITLE 검사중 "%PROGRAMFILESX86%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%PROGRAMFILESX86%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\FILEDEL_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%PROGRAMFILESX86%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
	IF EXIST "%PROGRAMFILESX86%\%%A" (
		FOR /F "TOKENS=1" %%B IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%PROGRAMFILESX86%\%%A" 2^>Nul') DO (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :[%PROGRAMFILES%] (for 1-Step & MD5)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%PROGRAMFILES%\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKPROGRAMFILES%\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%PROGRAMFILES%\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%PROGRAMFILES%\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%PROGRAMFILES%\%%A\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_PROGRAMFILES_1STEP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%PROGRAMFILES%\%%A\%%B" (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%PROGRAMFILES%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
			)
		)
	)
)
REM :[%PROGRAMFILESX86%] (for 1-Step & MD5)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%PROGRAMFILESX86%\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKPROGRAMFILESX86%\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%PROGRAMFILESX86%\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%PROGRAMFILESX86%\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%PROGRAMFILESX86%\%%A\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_PROGRAMFILES_1STEP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%PROGRAMFILESX86%\%%A\%%B" (
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%PROGRAMFILESX86%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
			)
		)
	)
)
REM :[%COMMONPROGRAMFILES%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILES%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILES%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_COMMONPROGRAMFILES.DB 2^>Nul') DO (
	TITLE 검사중 "%COMMONPROGRAMFILES%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILES%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_COMMONPROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%COMMONPROGRAMFILESX86%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILESX86%\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILESX86%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_COMMONPROGRAMFILES.DB 2^>Nul') DO (
	TITLE 검사중 "%COMMONPROGRAMFILESX86%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILESX86%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_COMMONPROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%COMMONPROGRAMFILES%]\Services
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILES%\Services\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILES%\Services\" 2^>Nul') DO (
	TITLE 검사중 "%COMMONPROGRAMFILES%\Services\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILES%\Services\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_COMMONPROGRAMFILES_SERVICES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%COMMONPROGRAMFILES%\Services\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_COMMONPROGRAMFILES_SERVICES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%COMMONPROGRAMFILESX86%]\Services
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILESX86%\Services\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILESX86%\Services\" 2^>Nul') DO (
	TITLE 검사중 "%COMMONPROGRAMFILESX86%\Services\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILESX86%\Services\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_COMMONPROGRAMFILES_SERVICES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%COMMONPROGRAMFILESX86%\Services\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_COMMONPROGRAMFILES_SERVICES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%COMMONPROGRAMFILES%]\System
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILES%\System\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILES%\System\" 2^>Nul') DO (
	TITLE 검사중 "%COMMONPROGRAMFILES%\System\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILES%\System\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_COMMONPROGRAMFILES_SYSTEM.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%COMMONPROGRAMFILES%\System\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_COMMONPROGRAMFILES_SYSTEM.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%COMMONPROGRAMFILESX86%]\System
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILESX86%\System\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILESX86%\System\" 2^>Nul') DO (
	TITLE 검사중 "%COMMONPROGRAMFILESX86%\System\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILESX86%\System\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_COMMONPROGRAMFILES_SYSTEM.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
	)
	IF EXIST "%COMMONPROGRAMFILESX86%\System\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_COMMONPROGRAMFILES_SYSTEM.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :[%PROGRAMFILES%] (ETCs)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\FILEDEL_PROGRAMFILES_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE 검사중^(DB^) "%PROGRAMFILES%%%A" 2>Nul
		IF EXIST "%PROGRAMFILES%%%A" (
			>VARIABLE\TXT1 ECHO %MZKPROGRAMFILES%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
		TITLE 검사중^(DB^) "%PROGRAMFILESX86%%%A" 2>Nul
		IF EXIST "%PROGRAMFILESX86%%%A" (
			>VARIABLE\TXT1 ECHO %MZKPROGRAMFILESX86%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :(Active Scan) [%SYSTEMROOT%] (Hidden)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AH-D "%SYSTEMROOT%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEMROOT.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEMROOT_ONLYHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%] (Super Hidden)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AHS-D "%SYSTEMROOT%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEMROOT.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEMROOT_ONLYSUPERHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\addins
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\addins\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\addins\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\addins\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\addins\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEMROOT_ADDINS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\AppPatch
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\AppPatch\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\AppPatch\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\AppPatch\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\AppPatch\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEMROOT_APPPATCH.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\Fonts
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\Fonts\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\Fonts\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\Fonts\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\Fonts\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_FONTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\Installer
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\Installer\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\Installer\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\Installer\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%SYSTEMROOT%\Installer\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%SYSTEMROOT%\Installer\%%A\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEMROOT_INSTALLER_1STEP.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\System (Super Hidden)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System\
FOR /F "DELIMS=" %%A IN ('DIR /B /AHS-D "%SYSTEMROOT%\System\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM_ONLYSUPERHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\System32 (4 Digit Directory)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\System32\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Eix "[0-9]{4}" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\System32\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%SYSTEMROOT%\System32\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%SYSTEMROOT%\System32\%%A\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_4DIGITS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\SysWOW64 (4 Digit Directory)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\SysWOW64\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Eix "[0-9]{4}" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%SYSTEMROOT%\SysWOW64\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%SYSTEMROOT%\SysWOW64\%%A\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_4DIGITS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\System32 (12 Char Directory)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\System32\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Eix "[0-9A-Z]{12}" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\System32\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%SYSTEMROOT%\System32\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%SYSTEMROOT%\System32\%%A\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_12DIGITS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\SysWOW64 (12 Char Directory)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\SysWOW64\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Eix "[0-9A-Z]{12}" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\%%A\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%SYSTEMROOT%\SysWOW64\%%A\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%SYSTEMROOT%\SysWOW64\%%A\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_12DIGITS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\System32 (Hidden)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\
FOR /F "DELIMS=" %%A IN ('DIR /B /AH-D "%SYSTEMROOT%\System32\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System32\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_ONLYHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\SysWOW64 (Hidden)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\
FOR /F "DELIMS=" %%A IN ('DIR /B /AH-D "%SYSTEMROOT%\SysWOW64\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\SysWOW64\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_ONLYHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\System32 (Super Hidden)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\
FOR /F "DELIMS=" %%A IN ('DIR /B /AHS-D "%SYSTEMROOT%\System32\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System32\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_ONLYSUPERHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\SysWOW64 (Super Hidden)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\
FOR /F "DELIMS=" %%A IN ('DIR /B /AHS-D "%SYSTEMROOT%\SysWOW64\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_SYSTEM6432.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\SysWOW64\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_SYSTEM6432_ONLYSUPERHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%ALLUSERSPROFILE%]\Java (Target)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Java\
IF EXIST "%ALLUSERSPROFILE%\Java\" ATTRIB.EXE -H -S "%ALLUSERSPROFILE%\Java" /S /D >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Java\" 2^>Nul') DO (
	TITLE 검사중 "%ALLUSERSPROFILE%\Java\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Java\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TARGET_JAVA.DB VARIABLE\TXT2 2^>Nul') DO (
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%ALLUSERSPROFILE%\Java" -ot file -actn setowner -ownr "n:Administrators" -silent >Nul 2>Nul
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%ALLUSERSPROFILE%\Java" -ot file -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -silent >Nul 2>Nul
			CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%ALLUSERSPROFILE%]\Application Data\Java (Target)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Application Data\Java\
IF EXIST "%ALLUSERSPROFILE%\Application Data\Java\" ATTRIB.EXE -H -S "%ALLUSERSPROFILE%\Application Data\Java" /S /D >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Application Data\Java\" 2^>Nul') DO (
	TITLE 검사중 "%ALLUSERSPROFILE%\Application Data\Java\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Application Data\Java\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TARGET_JAVA.DB VARIABLE\TXT2 2^>Nul') DO (
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%ALLUSERSPROFILE%\Application Data\Java" -ot file -actn setowner -ownr "n:Administrators" -silent >Nul 2>Nul
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%ALLUSERSPROFILE%\Application Data\Java" -ot file -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -silent >Nul 2>Nul
			CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%COMMONPROGRAMFILES%]\Java (Target)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILES%\Java\
IF EXIST "%COMMONPROGRAMFILES%\Java\" ATTRIB.EXE -H -S "%COMMONPROGRAMFILES%\Java" /S /D >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILES%\Java\" 2^>Nul') DO (
	TITLE 검사중 "%COMMONPROGRAMFILES%\Java\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILES%\Java\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TARGET_JAVA.DB VARIABLE\TXT2 2^>Nul') DO (
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%COMMONPROGRAMFILES%\Java" -ot file -actn setowner -ownr "n:Administrators" -silent >Nul 2>Nul
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%COMMONPROGRAMFILES%\Java" -ot file -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -silent >Nul 2>Nul
			CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%COMMONPROGRAMFILESX86%]\Java (Target)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILESX86%\Java\
IF EXIST "%COMMONPROGRAMFILESX86%\Java\" ATTRIB.EXE -H -S "%COMMONPROGRAMFILESX86%\Java" /S /D >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%COMMONPROGRAMFILESX86%\Java\" 2^>Nul') DO (
	TITLE 검사중 "%COMMONPROGRAMFILESX86%\Java\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILESX86%\Java\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_TARGET_JAVA.DB VARIABLE\TXT2 2^>Nul') DO (
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%COMMONPROGRAMFILESX86%\Java" -ot file -actn setowner -ownr "n:Administrators" -silent >Nul 2>Nul
			TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%COMMONPROGRAMFILESX86%\Java" -ot file -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -silent >Nul 2>Nul
			CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :(Active Scan) [%APPDATA%]\Identities
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Identities\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Identities\" 2^>Nul') DO (
	TITLE 검사중 "%APPDATA%\Identities\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%APPDATA%\Identities\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_APPDATA_IDENTITIES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) [%USERPROFILE%] (Hidden)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AH-D "%USERPROFILE%\" 2^>Nul') DO (
	TITLE 검사중 "%USERPROFILE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%USERPROFILE%\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_PROFILE_ONLYHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) C:\Program Files (x64)\Microsoft.NET
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%\Program Files ^(x64^)\Microsoft.NET\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMDRIVE%\Program Files (x64)\Microsoft.NET\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMDRIVE%\Program Files (x64)\Microsoft.NET\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMDRIVE%\Program Files (x64)\Microsoft.NET\%%A" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\FILE\PATTERN_PROGRAMFILES_X64_MSDOTNET.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
	)
)
REM :(Active Scan) Browser Extensions - Chrome Plus (Searching Only)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /AD "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%LOCALAPPDATA%\MapleStudio\ChromePlus\…생략…\Extensions\%%A" 2>Nul
		FOR /F "DELIMS=" %%C IN ('DIR /B /A-D "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\%%A\%%B\" 2^>Nul') DO (
			IF /I "%%C" == "BACKGROUND.HTML" (
				FOR /F %%X IN ('TYPE "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\%%A\%%B\%%C" 2^>Nul^|TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_CHROME_BACKGROUND.DB 2^>Nul') DO >>DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB ECHO %%A
			)
		)
	)
)
REM :(Active Scan) Browser Extensions - Chromium (Searching Only)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Chromium\User Data\Default\Extensions\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /AD "%LOCALAPPDATA%\Chromium\User Data\Default\Extensions\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%LOCALAPPDATA%\Chromium\…생략…\Extensions\%%A" 2>Nul
		FOR /F "DELIMS=" %%C IN ('DIR /B /A-D "%LOCALAPPDATA%\Chromium\User Data\Default\Extensions\%%A\%%B\" 2^>Nul') DO (
			IF /I "%%C" == "BACKGROUND.HTML" (
				FOR /F %%X IN ('TYPE "%LOCALAPPDATA%\Chromium\User Data\Default\Extensions\%%A\%%B\%%C" 2^>Nul^|TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_CHROME_BACKGROUND.DB 2^>Nul') DO >>DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB ECHO %%A
			)
		)
	)
)
REM :(Active Scan) Browser Extensions - COMODO Dragon (Searching Only)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /AD "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%LOCALAPPDATA%\COMODO\Dragon\…생략…\Extensions\%%A" 2>Nul
		FOR /F "DELIMS=" %%C IN ('DIR /B /A-D "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\%%A\%%B\" 2^>Nul') DO (
			IF /I "%%C" == "BACKGROUND.HTML" (
				FOR /F %%X IN ('TYPE "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\%%A\%%B\%%C" 2^>Nul^|TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_CHROME_BACKGROUND.DB 2^>Nul') DO >>DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB ECHO %%A
			)
		)
	)
)
REM :(Active Scan) Browser Extensions - Google Chrome (Searching Only)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%LOCALAPPDATA%\Google\Chrome\…생략…\Extensions\%%A" 2>Nul
		FOR /F "DELIMS=" %%C IN ('DIR /B /A-D "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\%%A\%%B\" 2^>Nul') DO (
			IF /I "%%C" == "BACKGROUND.HTML" (
				FOR /F %%X IN ('TYPE "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\%%A\%%B\%%C" 2^>Nul^|TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_CHROME_BACKGROUND.DB 2^>Nul') DO >>DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB ECHO %%A
			)
		)
	)
)
REM :(Active Scan) Browser Extensions - Google Chrome SxS (Searching Only)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%LOCALAPPDATA%\Google\Chrome SxS\…생략…\Extensions\%%A" 2>Nul
		FOR /F "DELIMS=" %%C IN ('DIR /B /A-D "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\%%A\%%B\" 2^>Nul') DO (
			IF /I "%%C" == "BACKGROUND.HTML" (
				FOR /F %%X IN ('TYPE "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\%%A\%%B\%%C" 2^>Nul^|TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_CHROME_BACKGROUND.DB 2^>Nul') DO >>DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB ECHO %%A
			)
		)
	)
)
REM :(Active Scan) Browser Extensions - Opera (Searching Only)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\Opera Software\Opera Stable\Extensions\" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('DIR /B /AD "%APPDATA%\Opera Software\Opera Stable\Extensions\%%A\" 2^>Nul') DO (
		TITLE 검사중 "%APPDATA%\Opera Software\Opera Stable\Extensions\%%A" 2>Nul
		FOR /F "DELIMS=" %%C IN ('DIR /B /A-D "%APPDATA%\Opera Software\Opera Stable\Extensions\%%A\%%B\" 2^>Nul') DO (
			IF /I "%%C" == "BACKGROUND.HTML" (
				FOR /F %%X IN ('TYPE "%APPDATA%\Opera Software\Opera Stable\Extensions\%%A\%%B\%%C" 2^>Nul^|TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_CHROME_BACKGROUND.DB 2^>Nul') DO >>DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB ECHO %%A
			)
		)
	)
)
REM :Browser Extensions - Chrome Plus
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Storage\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Storage\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\MapleStudio\ChromePlus\…생략…\Local Storage\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN (VARIABLE\TXT2) DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Chromium
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Chromium\User Data\Default\Local Storage\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%LOCALAPPDATA%\Chromium\User Data\Default\Local Storage\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\Chromium\…생략…\Local Storage\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN (VARIABLE\TXT2) DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_BROWSER_EXTENSIONS_CHROME_LOCALSTORAGE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :Browser Extensions - COMODO Dragon
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Storage\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Storage\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\COMODO\Dragon\…생략…\Local Storage\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN (VARIABLE\TXT2) DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_BROWSER_EXTENSIONS_CHROME_LOCALSTORAGE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Google Chrome
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome\User Data\Default\Local Storage\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Local Storage\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\Google\Chrome\…생략…\Local Storage\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN (VARIABLE\TXT2) DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_BROWSER_EXTENSIONS_CHROME_LOCALSTORAGE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Google Chrome SxS
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Storage\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Storage\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\Google\Chrome SxS\…생략…\Local Storage\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN (VARIABLE\TXT2) DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_BROWSER_EXTENSIONS_CHROME_LOCALSTORAGE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Opera
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Opera Software\Opera Stable\Local Storage\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Opera Software\Opera Stable\Local Storage\" 2^>Nul') DO (
	TITLE 검사중 "%APPDATA%\Opera Software\Opera Stable\Local Storage\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN (VARIABLE\TXT2) DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%APPDATA%\Opera Software\Opera Stable\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_BROWSER_EXTENSIONS_CHROME_LOCALSTORAGE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%APPDATA%\Opera Software\Opera Stable\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE
		)
		IF EXIST "%APPDATA%\Opera Software\Opera Stable\Local Storage\%%A" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_FILE ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Mozilla Firefox
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\Mozilla\Firefox\Profiles\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Mozilla\Firefox\Profiles\%%A\Extensions\
	FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%APPDATA%\Mozilla\Firefox\Profiles\%%A\Extensions\" 2^>Nul') DO (
		TITLE 검사중 "%APPDATA%\Mozilla\Firefox\…생략…\%%A\Extensions\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%APPDATA%\Mozilla\Firefox\Profiles\%%A\Extensions\%%B" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_BROWSER_EXTENSIONS_FIREFOX.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_FILE
		)
	)
)
REM :D: Root (MD5)
IF /I "%DDRV%" == "TRUE" (
	IF /I NOT "%SYSTEMDRIVE%" == "D:" (
		TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
		FOR /F "DELIMS=" %%A IN ('DIR /B /AD "D:\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_ROOT.DB 2^>Nul') DO (
			>VARIABLE\TXT1 ECHO D:\%%A\
			FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "D:\%%A\" 2^>Nul') DO (
				TITLE 검사중 "D:\%%A\%%B" 2>Nul
				>VARIABLE\TXT2 ECHO %%B
				IF EXIST "D:\%%A\%%B" (
					FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "D:\%%A\%%B" 2^>Nul') DO (
						FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\FILE\DEL_MD5.DB 2^>Nul') DO CALL :DEL_FILE
					)
				)
			)
		)
	)
)
REM :Static
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\THREAT\FILE\DEL_STATIC.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ MZK THREAT FILE DEL_STATIC.DB ~~~~~~~~~~" (
		TITLE 검사중^(DB^) "%%A" 2>Nul
		IF EXIST "%%A\" (
			>VARIABLE\TXT1 ECHO %%~dpA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :Result
CALL :P_RESULT RECK CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Malicious Directory
ECHO ◇ 악성 및 유해 가능 폴더 제거중 . . . & >>"%QLog%" ECHO    ■ 악성 및 유해 가능 폴더 제거 :
REM :[%SYSTEMDRIVE%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMDRIVE%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_ROOT.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMDRIVE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMDRIVE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_ROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMDRIVE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_ROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMDRIVE%\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMDRIVE%\%%A\" 2^>Nul') DO (
			TITLE 검사중 "%SYSTEMDRIVE%\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%SYSTEMDRIVE%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_ROOT_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%SYSTEMDRIVE%] (ETCs)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\DIRDEL_ROOT_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE 검사중^(DB^) "%SYSTEMDRIVE%%%A" 2>Nul
		IF EXIST "%SYSTEMDRIVE%%%A\" (
			>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :[%SYSTEMDRIVE%] (for 1-Step)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMDRIVE%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_ROOT.DB 2^>Nul') DO (
	IF /I NOT "%SYSTEMDRIVE%\%%A" == "%SYSTEMROOT%" (
		TITLE 검사중 "%SYSTEMDRIVE%\%%A" 2>Nul
		>VARIABLE\TXT2 ECHO %%A
		IF EXIST "%SYSTEMDRIVE%\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_ROOT_1STEP.DB VARIABLE\TXT2 2^>Nul') DO (
				FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMDRIVE%\%%A\" 2^>Nul') DO (
					>VARIABLE\TXTX ECHO %%B
					FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_ROOT_1STEP_FORFILE.DB VARIABLE\TXTX 2^>Nul') DO (
						FOR /F %%Z IN ('DIR /B /A-D "%SYSTEMDRIVE%\%%A\" 2^>Nul^|TOOLS\GREP\GREP.EXE -c "" 2^>Nul') DO (
							IF %%Z LSS 5 CALL :DEL_DIRT ACTIVESCAN
						)
					)
				)
			)
		)
	)
)
REM :[%SYSTEMROOT%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_SYSTEMROOT.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_SYSTEMROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_SYSTEMROOT.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%] (ETCs)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\DIRDEL_SYSTEMROOT_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE 검사중^(DB^) "%SYSTEMROOT%%%A" 2>Nul
		IF EXIST "%SYSTEMROOT%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_FILE
		)
	)
)
REM :[%SYSTEMROOT%]\System32
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\System32\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System32\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\System32\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :[%SYSTEMROOT%]\SysWOW64
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\SysWOW64\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\SysWOW64\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_SYSTEM6432.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :[%ALLUSERSPROFILE%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%ALLUSERSPROFILE%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%ALLUSERSPROFILE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_ALLUSERSPROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_ADWARE_XYZ.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_ALLUSERSPROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%ALLUSERSPROFILE%\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%ALLUSERSPROFILE%\%%A\" 2^>Nul') DO (
			TITLE 검사중 "%ALLUSERSPROFILE%\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%ALLUSERSPROFILE%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%LOCALAPPDATA%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%LOCALAPPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%LOCALAPPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%LOCALAPPDATA%\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%LOCALAPPDATA%\%%A\" 2^>Nul') DO (
			TITLE 검사중 "%LOCALAPPDATA%\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%LOCALAPPDATA%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%LOCALLOWAPPDATA%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALLOWAPPDATA%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALLOWAPPDATA%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%LOCALLOWAPPDATA%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALLOWAPPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%LOCALLOWAPPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%LOCALLOWAPPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%LOCALLOWAPPDATA%\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%LOCALLOWAPPDATA%\%%A\" 2^>Nul') DO (
			TITLE 검사중 "%LOCALLOWAPPDATA%\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%LOCALLOWAPPDATA%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%APPDATA%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%APPDATA%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%APPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%APPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%APPDATA%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%APPDATA%\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%APPDATA%\%%A\" 2^>Nul') DO (
			TITLE 검사중 "%APPDATA%\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%APPDATA%\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\AppData\Local
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A\" 2^>Nul') DO (
			TITLE 검사중 "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Local\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\AppData\Local
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A\" 2^>Nul') DO (
			TITLE 검사중 "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Local\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\AppData\LocalLow
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A\" 2^>Nul') DO (
			TITLE 검사중 "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\LocalLow\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\AppData\LocalLow
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A\" 2^>Nul') DO (
			TITLE 검사중 "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\LocalLow\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\AppData\Roaming
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A\" 2^>Nul') DO (
			TITLE 검사중 "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%SYSTEMROOT%\System32\Config\SystemProfile\AppData\Roaming\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\AppData\Roaming
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A\" 2^>Nul') DO (
			TITLE 검사중 "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A" "%%B" 2>Nul
			FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\AppData\Roaming\%%A\%%B" 2^>Nul') DO (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_APPDATA_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :[%USERPROFILE%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%USERPROFILE%\" 2^>Nul') DO (
	TITLE 검사중 "%USERPROFILE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%USERPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%USERPROFILE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :[%PUBLIC%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPUBLIC%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%PUBLIC%\" 2^>Nul') DO (
	TITLE 검사중 "%PUBLIC%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%PUBLIC%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%PUBLIC%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROFILE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :[%USERPROFILE%]\AppData
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\AppData\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%USERPROFILE%\AppData\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_APPDATA.DB 2^>Nul') DO (
	TITLE 검사중 "%USERPROFILE%\AppData\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%USERPROFILE%\AppData\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_APPDATA.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
)
REM :[%ALLUSERSPROFILE%]\Start Menu\Programs
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Start Menu\Programs\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%ALLUSERSPROFILE%\Start Menu\Programs\" 2^>Nul') DO (
	TITLE 검사중 "%ALLUSERSPROFILE%\Start Menu\Programs\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%ALLUSERSPROFILE%\Start Menu\Programs\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_STARTMENU_PROGRAMS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
)
REM :[%APPDATA%]\Microsoft\Windows\Start Menu\Programs
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Windows\Start Menu\Programs\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\Microsoft\Windows\Start Menu\Programs\" 2^>Nul') DO (
	TITLE 검사중 "%APPDATA%\Microsoft\Windows\Start Menu\Programs\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%APPDATA%\Microsoft\Windows\Start Menu\Programs\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_STARTMENU_PROGRAMS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
)
REM :Profiles (ETCs)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\DIRDEL_PROFILE_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE 검사중^(DB^) "%ALLUSERSPROFILE%%%A" 2>Nul
		IF EXIST "%ALLUSERSPROFILE%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
		TITLE 검사중^(DB^) "%USERPROFILE%%%A" 2>Nul
		IF EXIST "%USERPROFILE%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
		TITLE 검사중^(DB^) "%PUBLIC%%%A" 2>Nul
		IF EXIST "%PUBLIC%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKPUBLIC%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
	)
)
REM :Browser Extensions - Chrome Plus (Databases)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Databases\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Databases\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\MapleStudio\ChromePlus\…생략…\Databases\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN ('ECHO %%A') DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Databases\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT
		)
		IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
			IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Databases\%%A\" (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :Browser Extensions - Chrome Plus (Extensions)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\MapleStudio\ChromePlus\…생략…\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
		IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Extensions\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Chrome Plus (Local Extension Settings)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Extension Settings\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Extension Settings\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\MapleStudio\ChromePlus\…생략…\Local Extension Settings\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
		IF EXIST "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Local Extension Settings\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Chromium (Databases)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Chromium\User Data\Default\Databases\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Chromium\User Data\Default\Databases\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\Chromium\…생략…\Databases\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN ('ECHO %%A') DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Databases\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT
		)
		IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
			IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Databases\%%A\" (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :Browser Extensions - Chromium (Extensions)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Chromium\User Data\Default\Extensions\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Chromium\User Data\Default\Extensions\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\Chromium\…생략…\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
		IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Extensions\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Chromium (Local Extension Settings)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Chromium\User Data\Default\Local Extension Settings\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Chromium\User Data\Default\Local Extension Settings\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\Chromium\…생략…\Local Extension Settings\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
		IF EXIST "%LOCALAPPDATA%\Chromium\User Data\Default\Local Extension Settings\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Browser Extensions - COMODO Dragon (Databases)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\COMODO\Dragon\User Data\Default\Databases\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Databases\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\COMODO\Dragon\…생략…\Databases\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN ('ECHO %%A') DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Databases\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT
		)
		IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
			IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Databases\%%A\" (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :Browser Extensions - COMODO Dragon (Extensions)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\COMODO\Dragon\…생략…\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB (
		IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Extensions\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Browser Extensions - COMODO Dragon (Local Extension Settings)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Extension Settings\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Extension Settings\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\COMODO\Dragon\…생략…\Local Extension Settings\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :Browser Extensions - Google Chrome (Databases)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome\User Data\Default\Databases\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Databases\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\Google\Chrome\…생략…\Databases\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN ('ECHO %%A') DO (
		>VARIABLE\TXTX ECHO %%B
		IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Databases\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT
		)
		IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Databases\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Google Chrome (Extensions)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\Google\Chrome\…생략…\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :Browser Extensions - Google Chrome (Local Extension Settings)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome\User Data\Default\Local Extension Settings\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Local Extension Settings\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\Google\Chrome\…생략…\Local Extension Settings\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :Browser Extensions - Google Chrome SxS (Databases)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Databases\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Databases\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\Google\Chrome SxS\…생략…\Databases\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "TOKENS=2 DELIMS=_" %%B IN ('ECHO %%A') DO (
		IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Databases\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
		)
		IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Databases\%%A\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Browser Extensions - Google Chrome SxS (Extensions)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\Google\Chrome SxS\…생략…\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :Browser Extensions - Google Chrome SxS (Local Extension Settings)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Extension Settings\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Extension Settings\" 2^>Nul') DO (
	TITLE 검사중 "%LOCALAPPDATA%\Google\Chrome SxS\…생략…\Local Extension Settings\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Local Extension Settings\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :Browser Extensions - Opera
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Opera Software\Opera Stable\Extensions\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\Opera Software\Opera Stable\Extensions\" 2^>Nul') DO (
	TITLE 검사중 "%APPDATA%\Opera Software\Opera Stable\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%APPDATA%\Opera Software\Opera Stable\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%APPDATA%\Opera Software\Opera Stable\Extensions\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :Browser Extensions - Mozilla Firefox
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\Mozilla\Firefox\Profiles\" 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Mozilla\Firefox\Profiles\%%A\Extensions\
	FOR /F "DELIMS=" %%B IN ('DIR /B /AD "%APPDATA%\Mozilla\Firefox\Profiles\%%A\Extensions\" 2^>Nul') DO (
		TITLE 검사중 "%APPDATA%\Mozilla\Firefox\…생략…\%%A\Extensions\%%B" 2>Nul
		>VARIABLE\TXT2 ECHO %%B
		IF EXIST "%APPDATA%\Mozilla\Firefox\Profiles\%%A\Extensions\%%B\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_FIREFOX.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
		)
		IF EXIST "%APPDATA%\Mozilla\Firefox\Profiles\%%A\Extensions\%%B\" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_FIREFOX.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
		)
	)
)
REM :Application Data (ETCs)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\DIRDEL_APPDATA_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE 검사중^(DB^) "%ALLUSERSPROFILE%%%A" 2>Nul
		IF EXIST "%ALLUSERSPROFILE%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
		TITLE 검사중^(DB^) "%ALLUSERSPROFILE%\Application Data%%A" 2>Nul
		IF EXIST "%ALLUSERSPROFILE%\Application Data%%A\" (
			>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Application Data%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
		TITLE 검사중^(DB^) "%LOCALAPPDATA%%%A" 2>Nul
		IF EXIST "%LOCALAPPDATA%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKLOCALAPPDATA%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
		TITLE 검사중^(DB^) "%LOCALLOWAPPDATA%%%A" 2>Nul
		IF EXIST "%LOCALLOWAPPDATA%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKLOCALLOWAPPDATA%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
		TITLE 검사중^(DB^) "%APPDATA%%%A" 2>Nul
		IF EXIST "%APPDATA%\%%A\" (
			>VARIABLE\TXT1 ECHO %MZKAPPDATA%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
	)
)
REM :[%PROGRAMFILES%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPROGRAMFILES%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%PROGRAMFILES%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_PROGRAMFILES.DB 2^>Nul') DO (
	TITLE 검사중 "%PROGRAMFILES%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%PROGRAMFILES%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%PROGRAMFILES%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_ADWARE_XYZ.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%PROGRAMFILES%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%PROGRAMFILES%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%PROGRAMFILES%\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%PROGRAMFILES%\%%A\" 2^>Nul') DO (
			TITLE 검사중 "%PROGRAMFILES%\%%A" "%%B" 2>Nul
			>VARIABLE\TXTX ECHO %%B
			IF EXIST "%PROGRAMFILES%\%%A\" (
				FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%PROGRAMFILES%\%%A\%%B" 2^>Nul') DO (
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
				)
			)
			IF EXIST "%PROGRAMFILES%\%%A\" (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_SCANONLY.DB VARIABLE\TXT2 2^>Nul') DO (
					FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_HYENA_FORFILE.DB VARIABLE\TXTX 2^>Nul') DO (
						FOR /F %%Z IN ('DIR /B /A-D "%PROGRAMFILES%\%%A\" 2^>Nul^|TOOLS\GREP\GREP.EXE -c "" 2^>Nul') DO (
							IF %%Z LSS 5 CALL :DEL_DIRT ACTIVESCAN
						)
					)
				)
			)
		)
	)
)
REM :[%PROGRAMFILESX86%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPROGRAMFILESX86%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%PROGRAMFILESX86%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_PROGRAMFILES.DB 2^>Nul') DO (
	TITLE 검사중 "%PROGRAMFILESX86%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%PROGRAMFILESX86%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%PROGRAMFILESX86%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_ADWARE_XYZ.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%PROGRAMFILESX86%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%PROGRAMFILESX86%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
	IF EXIST "%PROGRAMFILESX86%\%%A\" (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%PROGRAMFILESX86%\%%A\" 2^>Nul') DO (
			TITLE 검사중 "%PROGRAMFILESX86%\%%A" "%%B" 2>Nul
			>VARIABLE\TXTX ECHO %%B
			IF EXIST "%PROGRAMFILESX86%\%%A\" (
				FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "%PROGRAMFILESX86%\%%A\%%B" 2^>Nul') DO (
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
				)
			)
			IF EXIST "%PROGRAMFILESX86%\%%A\" (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_SCANONLY.DB VARIABLE\TXT2 2^>Nul') DO (
					FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_HYENA_FORFILE.DB VARIABLE\TXTX 2^>Nul') DO (
						FOR /F %%Z IN ('DIR /B /A-D "%PROGRAMFILESX86%\%%A\" 2^>Nul^|TOOLS\GREP\GREP.EXE -c "" 2^>Nul') DO (
							IF %%Z LSS 5 CALL :DEL_DIRT ACTIVESCAN
						)
					)
				)
			)
		)
	)
)
REM :[%COMMONPROGRAMFILES%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILES%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%COMMONPROGRAMFILES%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_COMMONPROGRAMFILES.DB 2^>Nul') DO (
	TITLE 검사중 "%COMMONPROGRAMFILES%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILES%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_COMMONPROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%COMMONPROGRAMFILES%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_COMMONPROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :[%COMMONPROGRAMFILESX86%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILESX86%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%COMMONPROGRAMFILESX86%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_COMMONPROGRAMFILES.DB 2^>Nul') DO (
	TITLE 검사중 "%COMMONPROGRAMFILESX86%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%COMMONPROGRAMFILESX86%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\DIRDEL_COMMONPROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT
	)
	IF EXIST "%COMMONPROGRAMFILESX86%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_COMMONPROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :[%PROGRAMFILES%], [%PROGRAMFILESX86%] (ETCs)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\DIRDEL_PROGRAMFILES_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		TITLE 검사중^(DB^) "%PROGRAMFILES%%%A" 2>Nul
		IF EXIST "%PROGRAMFILES%%%A\" (
			>VARIABLE\TXT1 ECHO %MZKPROGRAMFILES%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
		TITLE 검사중^(DB^) "%PROGRAMFILESX86%%%A" 2>Nul
		IF EXIST "%PROGRAMFILESX86%%%A" (
			>VARIABLE\TXT1 ECHO %MZKPROGRAMFILESX86%%%~pA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
	)
)
REM :(Active Scan) [%SYSTEMDRIVE%] (Hidden)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %SYSTEMDRIVE%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AHD "%SYSTEMDRIVE%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_ROOT.DB 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMDRIVE%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMDRIVE%\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_ROOT_ONLYHIDDEN.DB VARIABLE\TXT2 2^>Nul') DO (
			FOR /F %%Y IN ('DIR /B /A-D "%SYSTEMDRIVE%\%%A\" 2^>Nul^|TOOLS\GREP\GREP.EXE -c "" 2^>Nul') DO (
				IF %%Y LSS 5 CALL :DEL_DIRT ACTIVESCAN
			)
		)
	)
)
REM :(Active Scan) [%SYSTEMROOT%]
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\%%A" 2>Nul
	SETLOCAL ENABLEDELAYEDEXPANSION
	ECHO "%%A"|TOOLS\GREP\GREP.EXE -xq "^\(\""\([0-9A-F]\{8\}\)\""\)$" >Nul 2>Nul
	IF !ERRORLEVEL! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%X IN ('DIR /B /A-D "%SYSTEMROOT%\%%A\" 2^>Nul') DO (
			SETLOCAL ENABLEDELAYEDEXPANSION
			ECHO "%%X"|TOOLS\GREP\GREP.EXE -ixq "^\(\""\(SVCHSOT\.EXE\)\""\)$" >Nul 2>Nul
			IF !ERRORLEVEL! EQU 0 (
				ENDLOCAL
				>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_DIRT ACTIVESCAN
			) ELSE (
				ENDLOCAL
			)
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\addins
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\addins\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\addins\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\addins\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\addins\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_SYSTEMROOT_ADDINS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\AppPatch
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\AppPatch\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\AppPatch\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\AppPatch\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\AppPatch\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_SYSTEMROOT_APPPATCH.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\Downloaded Program Files
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\Downloaded Program Files\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\Downloaded Program Files\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\Downloaded Program Files\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\Downloaded Program Files\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_DOWNLOADEDPROGRAMFILES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\MUI
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\MUI\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\MUI\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\MUI\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\MUI\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_SYSTEMROOT_MUI.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :(Active Scan) [%SYSTEMROOT%]\Web
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\Web\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%SYSTEMROOT%\Web\" 2^>Nul') DO (
	TITLE 검사중 "%SYSTEMROOT%\Web\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\Web\%%A\" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_SYSTEMROOT_WEB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
	)
)
REM :(Active Scan) [%COMMONPROGRAMFILES%] (for 1-Step & MD5)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILES%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%COMMONPROGRAMFILES%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_COMMONPROGRAMFILES.DB 2^>Nul') DO (
	TITLE 검사중 "%COMMONPROGRAMFILES%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_COMMONPROGRAMFILES_1STEP.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%COMMONPROGRAMFILES%\%%A\" 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%B
			IF EXIST "%COMMONPROGRAMFILES%\%%A\" (
				FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_COMMONPROGRAMFILES_1STEP_FORFILE.DB VARIABLE\TXTX 2^>Nul') DO (
					FOR /F %%Z IN ('DIR /B /A-D "%COMMONPROGRAMFILES%\%%A\" 2^>Nul^|TOOLS\GREP\GREP.EXE -c "" 2^>Nul') DO (
						IF %%Z LSS 5 CALL :DEL_DIRT ACTIVESCAN
					)
				)
			)
			IF EXIST "%COMMONPROGRAMFILES%\%%A\" (
				FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%COMMONPROGRAMFILES%\%%A\%%B" 2^>Nul') DO (
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\DIRECTORY\DEL_COMMONPROGRAMFILES_1STEP_FORFILE_MD5.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
				)
			)
		)
	)
)
REM :(Active Scan) [%COMMONPROGRAMFILESX86%] (for 1-Step & MD5)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKCOMMONPROGRAMFILESX86%\
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%COMMONPROGRAMFILESX86%\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_COMMONPROGRAMFILES.DB 2^>Nul') DO (
	TITLE 검사중 "%COMMONPROGRAMFILESX86%\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_COMMONPROGRAMFILES_1STEP.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "%COMMONPROGRAMFILESX86%\%%A\" 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%B
			IF EXIST "%COMMONPROGRAMFILESX86%\%%A\" (
				FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_COMMONPROGRAMFILES_1STEP_FORFILE.DB VARIABLE\TXTX 2^>Nul') DO (
					FOR /F %%Z IN ('DIR /B /A-D "%COMMONPROGRAMFILESX86%\%%A\" 2^>Nul^|TOOLS\GREP\GREP.EXE -c "" 2^>Nul') DO (
						IF %%Z LSS 5 CALL :DEL_DIRT ACTIVESCAN
					)
				)
			)
			IF EXIST "%COMMONPROGRAMFILESX86%\%%A\" (
				FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%MD5CHK%.EXE -s -q "%COMMONPROGRAMFILESX86%\%%A\%%B" 2^>Nul') DO (
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\THREAT\DIRECTORY\DEL_COMMONPROGRAMFILES_1STEP_FORFILE_MD5.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
				)
			)
		)
	)
)
REM :(Active Scan) D:\Program Files (for 1-Step & MD5)
IF /I "%DDRV%" == "TRUE" (
	IF /I NOT "%PROGRAMFILES%" == "D:\Program Files" (
		TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
		>VARIABLE\TXT1 ECHO D:\Program Files\
		FOR /F "DELIMS=" %%A IN ('DIR /B /AD "D:\Program Files\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_DIR_PROGRAMFILES.DB 2^>Nul') DO (
			TITLE 검사중 "D:\Program Files\%%A" 2>Nul
			>VARIABLE\TXT2 ECHO %%A
			FOR /F "DELIMS=" %%B IN ('DIR /B /A-D "D:\Program Files\%%A\" 2^>Nul') DO (
				TITLE 검사중 "D:\Program Files\%%A" "%%B" 2>Nul
				>VARIABLE\TXTX ECHO %%B
				IF EXIST "D:\Program Files\%%A\" (
					FOR /F "TOKENS=1" %%C IN ('TOOLS\HASHDEEP\%SHACHK%.EXE -s -q "D:\Program Files\%%A\%%B" 2^>Nul') DO (
						FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%C" DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_HYENA_FORFILE_SHA.DB 2^>Nul') DO CALL :DEL_DIRT ACTIVESCAN
					)
				)
				IF EXIST "D:\Program Files\%%A\" (
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\ACTIVESCAN\DIRECTORY\PATTERN_PROGRAMFILES_1STEP_HYENA_FORFILE.DB VARIABLE\TXTX 2^>Nul') DO (
						FOR /F %%Y IN ('DIR /B /A-D "D:\Program Files\%%A\" 2^>Nul^|TOOLS\GREP\GREP.EXE -c "" 2^>Nul') DO (
							IF %%Y LSS 5 CALL :DEL_DIRT ACTIVESCAN
						)
					)
				)
			)
		)
	)
)
REM :Static
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\THREAT\DIRECTORY\DEL_STATIC.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ MZK THREAT DIRECTORY DEL_STATIC.DB ~~~~~~~~~~" (
		TITLE 검사중^(DB^) "%%A" 2>Nul
		IF EXIST "%%A\" (
			>VARIABLE\TXT1 ECHO %%~dpA
			>VARIABLE\TXT2 ECHO %%~nxA
			CALL :DEL_DIRT
		)
	)
)
REM :Result
CALL :P_RESULT RECK CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Malicious Hosts File Delete
ECHO ◇ 악성 호스트 파일 제거중 . . . & >>"%QLog%" ECHO    ■ 악성 호스트 파일 제거 :
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Drivers\etc\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Drivers\etc\" 2^>Nul^|TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_FILE_DRIVERS_ETC.DB 2^>Nul') DO (
	TITLE 검사중 "%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "%SYSTEMROOT%\System32\Drivers\etc\%%A" (
		>VARIABLE\CHCK ECHO 0
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fif DB_EXEC\CHECK\CHK_HOSTS_STRING.DB "%SYSTEMROOT%\System32\Drivers\etc\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -v "^#" 2^>Nul') DO (
			SETLOCAL ENABLEDELAYEDEXPANSION
			<VARIABLE\CHCK SET /P CHCK=
			IF !CHCK! EQU 0 (
				ENDLOCAL
				>VARIABLE\CHCK ECHO 1
				CALL :DEL_FILE
			) ELSE (
				ENDLOCAL
			)
		)
	)
)
IF NOT EXIST "%SYSTEMROOT%\System32\Drivers\etc\hosts" (
	COPY /Y REPAIR\hosts "%SYSTEMROOT%\System32\Drivers\etc\" >Nul 2>Nul
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset Network DNS Address <#1>
ECHO ◇ 네트워크 DNS 주소 상태 확인중 - 1차 . . . & >>"%QLog%" ECHO    ■ 네트워크 DNS 주소 상태 확인 - 1차 :
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %%A
	FOR /F "TOKENS=1,2 DELIMS=," %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%A\NameServer" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
		IF NOT "%%B" == "" (
			IF NOT "%%C" == "" (
				>VARIABLE\TXT2 ECHO %%B^|%%C
				>VARIABLE\TXTX ECHO %%B,%%C
				IF "%%B" == "%%C" (
					CALL :RESETDNS
				) ELSE (
					>VARIABLE\CHCK ECHO 0
					SETLOCAL ENABLEDELAYEDEXPANSION
					<VARIABLE\CHCK SET /P CHCK=
					IF !CHCK! EQU 0 (
						ENDLOCAL
						FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\NETWORK\DEL_DNS_ADDRESS.DB VARIABLE\TXTX 2^>Nul') DO CALL :RESETDNS
					) ELSE (
						ENDLOCAL
					)
					SETLOCAL ENABLEDELAYEDEXPANSION
					<VARIABLE\CHCK SET /P CHCK=
					IF !CHCK! EQU 0 (
						ENDLOCAL
						FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\NETWORK\PATTERN_DNS_ADDRESS.DB VARIABLE\TXTX 2^>Nul') DO CALL :RESETDNS
					) ELSE (
						ENDLOCAL
					)
				)
			) ELSE (
				>VARIABLE\TXT2 ECHO %%B
				>VARIABLE\CHCK ECHO 0
				SETLOCAL ENABLEDELAYEDEXPANSION
				<VARIABLE\CHCK SET /P CHCK=
				IF !CHCK! EQU 0 (
					ENDLOCAL
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\NETWORK\DEL_DNS_ADDRESS.DB VARIABLE\TXT2 2^>Nul') DO CALL :RESETDNS
				) ELSE (
					ENDLOCAL
				)
				SETLOCAL ENABLEDELAYEDEXPANSION
				<VARIABLE\CHCK SET /P CHCK=
				IF !CHCK! EQU 0 (
					ENDLOCAL
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\NETWORK\PATTERN_DNS_ADDRESS.DB VARIABLE\TXT2 2^>Nul') DO CALL :RESETDNS
				) ELSE (
					ENDLOCAL
				)
			)
		)
	)
)
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\CHCK SET /P CHCK=
IF !CHCK! EQU 0 (
	ENDLOCAL
	ECHO    문제점이 발견되지 않았습니다. & >>"%QLog%" ECHO    문제점이 발견되지 않음
) ELSE (
	ENDLOCAL
	>VARIABLE\XXYY ECHO 1
)
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset WinSock Protocol
ECHO ◇ 소켓 프로토콜 상태 확인중 . . . & >>"%QLog%" ECHO    ■ 소켓 프로토콜 상태 확인 :
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('NETSH.EXE WINSOCK SHOW CATALOG 2^>Nul^|TOOLS\GREP\GREP.EXE -i "^\(Provider Path:\|Provider Path :\|공급자 경로:\|공급자 경로 :\)" 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%~nxA
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\NETWORK\DEL_BAD_WINSOCK_PROTOCOL.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\CHCK ECHO 1
		SETLOCAL ENABLEDELAYEDEXPANSION
		NETSH.EXE WINSOCK RESET >Nul 2>Nul
		IF !ERRORLEVEL! EQU 0 (
			ECHO    비정상 값이 발견되어 초기화를 진행합니다. ^(재부팅 필요^) & >>"!QLog!" ECHO    비정상 값이 발견되어 초기화 진행 ^(재부팅 필요^)
		) ELSE (
			ECHO    비정상 값이 발견되어 초기화를 진행하였으나 오류가 발생했습니다. & >>"!QLog!" ECHO    비정상 값이 발견되어 초기화 진행 ^(실패 - 오류 발생^)
		)
		ENDLOCAL & GOTO RS_WSLSP
	)
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\NETWORK\PATTERN_BAD_WINSOCK_PROTOCOL.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\CHCK ECHO 1
		SETLOCAL ENABLEDELAYEDEXPANSION
		NETSH.EXE WINSOCK RESET >Nul 2>Nul
		IF !ERRORLEVEL! EQU 0 (
			ECHO    비정상 값이 발견되어 초기화를 진행합니다. ^(재부팅 필요^) & >>"!QLog!" ECHO    비정상 값이 발견되어 초기화 진행 ^(재부팅 필요^)
		) ELSE (
			ECHO    비정상 값이 발견되어 초기화를 진행하였으나 오류가 발생했습니다. & >>"!QLog!" ECHO    비정상 값이 발견되어 초기화 진행 ^(실패 - 오류 발생^)
		)
		ENDLOCAL & GOTO RS_WSLSP
	)
)
:RS_WSLSP
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\CHCK SET /P CHCK=
IF !CHCK! EQU 0 (
	ECHO    문제점이 발견되지 않았습니다. & >>"%QLog%" ECHO    문제점이 발견되지 않음
) ELSE (
	>VARIABLE\XXYY ECHO 1
)
ENDLOCAL
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <HKEY_CLASSES_ROOT>
ECHO ◇ 악성 및 유해 가능 ^<HKEY_CLASSES_ROOT^> 레지스트리 제거중 . . . & >>"%QLog%" ECHO    ■ 악성 및 유해 가능 ^<HKEY_CLASSES_ROOT^> 레지스트리 제거 :
REM :HKCR
TITLE 포괄 검사중 "HKCR" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR
SET "STRTMP=HKCR"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -ivxf DB\EXCEPT\EX_REG_HK_PATTERN.DB 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCR\APPID
TITLE 포괄 검사중 "HKCR\APPID" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\APPID
SET "STRTMP=HKCR_APPID"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\APPID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_APPID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_APPID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCR\Wow6432Node\APPID
TITLE 포괄 검사중 "HKCR\Wow6432Node\APPID" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\Wow6432Node\APPID
SET "STRTMP=HKCR_APPID(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\Wow6432Node\APPID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_APPID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_APPID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCR\CLSID
TITLE 포괄 검사중 "HKCR\CLSID" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\CLSID
SET "STRTMP=HKCR_CLSID"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\CLSID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_CLSID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fxf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID_DEFAULTVAL.DB VARIABLE\TXTX 2^>Nul') DO (
			>>DB_ACTIVE\ACT_HK_CLSID.DB ECHO %%A
			CALL :DEL_REGK NULL BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXTX 2^>Nul') DO (
			>>DB_ACTIVE\ACT_HK_CLSID.DB ECHO %%A
			CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCR\Wow6432Node\CLSID
TITLE 포괄 검사중 "HKCR\Wow6432Node\CLSID" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\Wow6432Node\CLSID
SET "STRTMP=HKCR_CLSID(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\Wow6432Node\CLSID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_CLSID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fxf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID_DEFAULTVAL.DB VARIABLE\TXTX 2^>Nul') DO (
			>>DB_ACTIVE\ACT_HK_CLSID.DB ECHO %%A
			CALL :DEL_REGK NULL BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXTX 2^>Nul') DO (
			>>DB_ACTIVE\ACT_HK_CLSID.DB ECHO %%A
			CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCR\Interface
TITLE 포괄 검사중 "HKCR\Interface" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\Interface
SET "STRTMP=HKCR_Interface"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\Interface" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_INTERFACE.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCR\Wow6432Node\Interface
TITLE 포괄 검사중 "HKCR\Wow6432Node\Interface" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\Wow6432Node\Interface
SET "STRTMP=HKCR_Interface(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\Wow6432Node\Interface" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_INTERFACE.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCR\TypeLib
TITLE 포괄 검사중 "HKCR\TypeLib" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\TypeLib
SET "STRTMP=HKCR_TypeLib"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\TypeLib" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_TYPELIB.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCR\Wow6432Node\TypeLib
TITLE 포괄 검사중 "HKCR\Wow6432Node\TypeLib" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCR\Wow6432Node\TypeLib
SET "STRTMP=HKCR_TypeLib(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCR\Wow6432Node\TypeLib" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_TYPELIB.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCR (ETCs)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "TOKENS=1,2 DELIMS=|" %%A IN (DB_EXEC\REGDEL_HKCR_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF NOT "%%B" == "" (
			TITLE 검사중^(DB^) "HKCR\%%A : %%~nxB" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\%%A\%%B" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCR\%%A
				>VARIABLE\TXT2 ECHO %%B
				CALL :DEL_REGV NULL BACKUP RANDOM "HKCR_ETCS"
			)
			TITLE 검사중^(DB^) "HKCR\Wow6432Node\%%A : %%~nxB" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\Wow6432Node\%%A\%%B" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCR\Wow6432Node\%%A
				>VARIABLE\TXT2 ECHO %%B
				CALL :DEL_REGV NULL BACKUP RANDOM "HKCR_ETCS(x86)"
			)
		) ELSE (
			TITLE 검사중^(DB^) "HKCR\%%A" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKCR\%%A" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCR
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_REGK NULL BACKUP "HKCR_ETCS"
			)
			TITLE 검사중^(DB^) "HKCR\Wow6432Node\%%A" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKCR\Wow6432Node\%%A" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCR\Wow6432Node
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_REGK NULL BACKUP "HKCR_ETCS(x86)"
			)
		)
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <HKEY_CURRENT_USER>
ECHO ◇ 악성 및 유해 가능 ^<HKEY_CURRENT_USER^> 레지스트리 제거중 . . . & >>"%QLog%" ECHO    ■ 악성 및 유해 가능 ^<HKEY_CURRENT_USER^> 레지스트리 제거 :
REM :HKCU\Software
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software
SET "STRTMP=HKCU_SW"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCU\Software\Wow6432Node
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node
SET "STRTMP=HKCU_SW(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCU\Software\AppDataLow\Software
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\AppDataLow\Software
SET "STRTMP=HKCU_SW_AppDataLow_SW"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\AppDataLow\Software" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\AppDataLow\Software\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Active Setup\Installed Components
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Active Setup\Installed Components
SET "STRTMP=HKCU_SW_ActiveSetup_InstalledComponents"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Active Setup\Installed Components" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\…생략…\Installed Components\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Active Setup\Installed Components
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Active Setup\Installed Components
SET "STRTMP=HKCU_SW_ActiveSetup_InstalledComponents(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Active Setup\Installed Components" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\…생략…\Installed Components\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer (DownloadUI)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer
SET "STRTMP=HKCU_SW_InternetExplorer_DownloadUI"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Internet Explorer\DownloadUI" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Microsoft\Internet Explorer : DownloadUI" 2>Nul
	>VARIABLE\TXT2 ECHO DownloadUI
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer (DownloadUI)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer
SET "STRTMP=HKCU_SW_InternetExplorer_DownloadUI(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\DownloadUI" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer : DownloadUI" 2>Nul
	>VARIABLE\TXT2 ECHO DownloadUI
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
)
REM :HKCU\Software\Microsoft\Internet Explorer\Approved Extensions (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Approved Extensions
SET "STRTMP=HKCU_SW_InternetExplorer_ApprovedExtensions"
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Internet Explorer\Approved Extensions" -ot reg -actn ace -ace "n:%USERNAME%;p:KEY_SET_VALUE;m:revoke;i:so" -ace "n:%USERNAME%;p:KEY_SET_VALUE;i:so" -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Internet Explorer\Approved Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\…생략…\Approved Extensions : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Internet Explorer\Approved Extensions" -ot reg -actn ace -ace "n:%USERNAME%;p:KEY_SET_VALUE;m:revoke;i:so" -ace "n:%USERNAME%;p:KEY_SET_VALUE;m:deny;i:so" -silent >Nul 2>Nul
REM :HKCU\Software\Microsoft\Internet Explorer\ApprovedExtensionsMigration
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\ApprovedExtensionsMigration
SET "STRTMP=HKCU_SW_InternetExplorer_ApprovedExtensionsMigration"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Internet Explorer\ApprovedExtensionsMigration" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\…생략…\ApprovedExtensionsMigration\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\SearchScopes
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\SearchScopes
SET "STRTMP=HKCU_SW_InternetExplorer_SearchScopes"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Internet Explorer\SearchScopes" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\…생략…\SearchScopes\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_IE_SEARCHSCOPES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\SearchScopes
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\SearchScopes
SET "STRTMP=HKCU_SW_InternetExplorer_SearchScopes(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\SearchScopes" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\…생략…\SearchScopes\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_IE_SEARCHSCOPES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\Toolbar (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Toolbar
SET "STRTMP=HKCU_SW_InternetExplorer_Toolbar"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Internet Explorer\Toolbar" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\…생략…\Toolbar : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar
SET "STRTMP=HKCU_SW_InternetExplorer_Toolbar(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\…생략…\Toolbar : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\Toolbar\WebBrowser (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Toolbar\WebBrowser
SET "STRTMP=HKCU_SW_InternetExplorer_Toolbar_WebBrowser"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Internet Explorer\Toolbar\WebBrowser" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\…생략…\WebBrowser : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar\WebBrowser (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar\WebBrowser
SET "STRTMP=HKCU_SW_InternetExplorer_Toolbar_WebBrowser(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar\WebBrowser" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\…생략…\WebBrowser : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\URLSearchHooks (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\URLSearchHooks
SET "STRTMP=HKCU_SW_InternetExplorer_URLSearchHooks"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Internet Explorer\URLSearchHooks" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\…생략…\URLSearchHooks : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\URLSearchHooks (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\URLSearchHooks
SET "STRTMP=HKCU_SW_InternetExplorer_URLSearchHooks(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\URLSearchHooks" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\…생략…\URLSearchHooks : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache
SET "STRTMP=HKCU_SW_AppManagement_ARPCache"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\…생략…\ARPCache\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_ARPCACHE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Management\ARPCache
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Management\ARPCache
SET "STRTMP=HKCU_SW_AppManagement_ARPCache(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Management\ARPCache" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\…생략…\ARPCache\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_ARPCACHE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\App Paths
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\App Paths
SET "STRTMP=HKCU_SW_AppPaths"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\App Paths" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\…생략…\App Paths\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_APPPATHS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths
SET "STRTMP=HKCU_SW_AppPaths(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\…생략…\ARPCache\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_APPPATHS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MenuOrder\Start Menu2\Programs
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MenuOrder\Start Menu2\Programs
SET "STRTMP=HKCU_SW_Explorer_MenuOrder_StartMenu2_Programs"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\MenuOrder\Start Menu2\Programs" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\…생략…\MenuOrder\Start Menu2\Programs\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\DIRECTORY\DEL_STARTMENU_PROGRAMS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings
SET "STRTMP=HKCU_SW_Ext_Settings"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\…생략…\Ext\Settings\%%A" 2>Nul
	SETLOCAL ENABLEDELAYEDEXPANSION
	TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Settings\%%A\Flags" >Nul 2>Nul
	IF !ERRORLEVEL! NEQ 0 (
		ENDLOCAL
		>VARIABLE\TXT2 ECHO %%A
		>VARIABLE\CHCK ECHO 0
		SETLOCAL ENABLEDELAYEDEXPANSION
		<VARIABLE\CHCK SET /P CHCK=
		IF !CHCK! EQU 0 (
			ENDLOCAL
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
		) ELSE (
			ENDLOCAL
		)
		SETLOCAL ENABLEDELAYEDEXPANSION
		<VARIABLE\CHCK SET /P CHCK=
		IF !CHCK! EQU 0 (
			ENDLOCAL
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		) ELSE (
			ENDLOCAL
		)
		SETLOCAL ENABLEDELAYEDEXPANSION
		<VARIABLE\CHCK SET /P CHCK=
		IF !CHCK! EQU 0 (
			ENDLOCAL
			IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
			)
		) ELSE (
			ENDLOCAL
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\Settings
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\Settings
SET "STRTMP=HKCU_SW_Ext_Settings(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\Settings" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\…생략…\Ext\Settings\%%A" 2>Nul
	SETLOCAL ENABLEDELAYEDEXPANSION
	TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\Settings\%%A\Flags" >Nul 2>Nul
	IF !ERRORLEVEL! NEQ 0 (
		ENDLOCAL
		>VARIABLE\TXT2 ECHO %%A
		>VARIABLE\CHCK ECHO 0
		SETLOCAL ENABLEDELAYEDEXPANSION
		<VARIABLE\CHCK SET /P CHCK=
		IF !CHCK! EQU 0 (
			ENDLOCAL
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
		) ELSE (
			ENDLOCAL
		)
		SETLOCAL ENABLEDELAYEDEXPANSION
		<VARIABLE\CHCK SET /P CHCK=
		IF !CHCK! EQU 0 (
			ENDLOCAL
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		) ELSE (
			ENDLOCAL
		)
		SETLOCAL ENABLEDELAYEDEXPANSION
		<VARIABLE\CHCK SET /P CHCK=
		IF !CHCK! EQU 0 (
			ENDLOCAL
			IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
			)
		) ELSE (
			ENDLOCAL
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats
SET "STRTMP=HKCU_SW_Ext_Stats"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\Ext\Stats" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\…생략…\Ext\Stats\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\Stats
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\Stats
SET "STRTMP=HKCU_SW_Ext_Stats(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\Stats" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\…생략…\Ext\Stats\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings (ProxyOverride)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings
SET "STRTMP=HKCU_SW_InternetSettings"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyOverride" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\…생략…\Internet Settings : ProxyOverride" 2>Nul
	>VARIABLE\TXT2 ECHO ProxyOverride
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_HKCU_PROXYOVERRIDE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
)
REM :HKCU\Software (ETCs)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "TOKENS=1,2 DELIMS=|" %%A IN (DB_EXEC\REGDEL_HKCU_SOFTWARE_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF NOT "%%B" == "" (
			TITLE 검사중^(DB^) "HKCU\Software\%%A : %%~nxB" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\%%A\%%B" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCU\Software\%%A
				>VARIABLE\TXT2 ECHO %%B
				CALL :DEL_REGV NULL BACKUP RANDOM "HKCU_SoftwareETCs"
			)
			TITLE 검사중^(DB^) "HKCU\Software\Wow6432Node\%%A : %%~nxB" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\%%A\%%B" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\%%A
				>VARIABLE\TXT2 ECHO %%B
				CALL :DEL_REGV NULL BACKUP RANDOM "HKCU_SoftwareETCs(x86)"
			)
		) ELSE (
			TITLE 검사중^(DB^) "HKCU\Software\%%A" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKCU\Software\%%A" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCU\Software
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_REGK NULL BACKUP "HKCU_SoftwareETCs"
			)
			TITLE 검사중^(DB^) "HKCU\Software\Wow6432Node\%%A" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKCU\Software\Wow6432Node\%%A" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_REGK NULL BACKUP "HKCU_SoftwareETCs(x86)"
			)
		)
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <HKEY_LOCAL_MACHINE>
ECHO ◇ 악성 및 유해 가능 ^<HKEY_LOCAL_MACHINE^> 레지스트리 제거중 . . . & >>"%QLog%" ECHO    ■ 악성 및 유해 가능 ^<HKEY_LOCAL_MACHINE^> 레지스트리 제거 :
REM :HKLM\Software
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software
SET "STRTMP=HKLM_SW"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node
SET "STRTMP=HKLM_SW(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_SOFTWARE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Classes
TITLE 포괄 검사중 "HKLM\Software\Classes" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Classes
SET "STRTMP=HKLM_SW_Classes"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Classes" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -ivxf DB\EXCEPT\EX_REG_HK_PATTERN.DB 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Classes\APPID
TITLE 포괄 검사중 "HKLM\Software\Classes\APPID" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Classes\APPID
SET "STRTMP=HKLM_SW_Classes_APPID"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Classes\APPID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_APPID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_APPID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Wow6432Node\Classes\APPID
TITLE 포괄 검사중 "HKLM\Software\Wow6432Node\Classes\APPID" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Classes\APPID
SET "STRTMP=HKLM_SW_Classes_APPID(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Classes\APPID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_APPID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_APPID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Classes\CLSID
TITLE 포괄 검사중 "HKLM\Software\Classes\CLSID" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Classes\CLSID
SET "STRTMP=HKLM_SW_Classes_CLSID"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Classes\CLSID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_CLSID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Classes\CLSID
TITLE 포괄 검사중 "HKLM\Software\Wow6432Node\Classes\CLSID" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Classes\CLSID
SET "STRTMP=HKLM_SW_Classes_CLSID(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Classes\CLSID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_CLSID.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Classes\Interface
TITLE 포괄 검사중 "HKLM\Software\Classes\Interface" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Classes\Interface
SET "STRTMP=HKLM_SW_Classes_Interface"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Classes\Interface" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_INTERFACE.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Classes\Interface
TITLE 포괄 검사중 "HKLM\Software\Wow6432Node\Classes\Interface" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Classes\Interface
SET "STRTMP=HKLM_SW_Classes_Interface(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Classes\Interface" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_INTERFACE.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_INTERFACE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Classes\TypeLib
TITLE 포괄 검사중 "HKLM\Software\Classes\TypeLib" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Classes\TypeLib
SET "STRTMP=HKLM_SW_Classes_TypeLib"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Classes\TypeLib" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_TYPELIB.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Classes\TypeLib
TITLE 포괄 검사중 "HKLM\Software\Wow6432Node\Classes\TypeLib" / 상태에 따라 시간이 소요될 수 있음 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Classes\TypeLib
SET "STRTMP=HKLM_SW_Classes_TypeLib(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Classes\TypeLib" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Fivxf DB\EXCEPT\EX_REG_HK_TYPELIB.DB 2^>Nul') DO (
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_TYPELIB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Google\Chrome\Extensions
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Google\Chrome\Extensions
SET "STRTMP=HKLM_SW_GoogleChrome_Extensions"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Google\Chrome\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Google\Chrome\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Google\Chrome\Extensions
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Google\Chrome\Extensions
SET "STRTMP=HKLM_SW_GoogleChrome_Extensions(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Google\Chrome\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\Google\Chrome\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_BROWSER_EXTENSIONS_CHROME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Active Setup\Installed Components
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Active Setup\Installed Components
SET "STRTMP=HKLM_SW_ActiveSetup_InstalledComponents"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Active Setup\Installed Components" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\Installed Components\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Active Setup\Installed Components
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Active Setup\Installed Components
SET "STRTMP=HKLM_SW_ActiveSetup_InstalledComponents(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Active Setup\Installed Components" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\…생략…\Installed Components\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_SOFTWARE_INSTCOMPONENTS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\ApprovedExtensionsMigration
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\ApprovedExtensionsMigration
SET "STRTMP=HKLM_SW_InternetExplorer_ApprovedExtensionsMigration"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Internet Explorer\ApprovedExtensionsMigration" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\ApprovedExtensionsMigration\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\Low Rights\ElevationPolicy
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\Low Rights\ElevationPolicy
SET "STRTMP=HKLM_SW_InternetExplorer_LowRights_ElevationPolicy"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Internet Explorer\Low Rights\ElevationPolicy" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\Low Rights\ElevationPolicy\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Low Rights\ElevationPolicy
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Low Rights\ElevationPolicy
SET "STRTMP=HKLM_SW_InternetExplorer_LowRights_ElevationPolicy(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Low Rights\ElevationPolicy" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\…생략…\Low Rights\ElevationPolicy\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\SearchScopes
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\SearchScopes
SET "STRTMP=HKLM_SW_InternetExplorer_SearchScopes"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Internet Explorer\SearchScopes" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\SearchScopes\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_IE_SEARCHSCOPES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\SearchScopes
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\SearchScopes
SET "STRTMP=HKLM_SW_InternetExplorer_SearchScopes(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\SearchScopes" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\SearchScopes\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_IE_SEARCHSCOPES.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\Toolbar (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\Toolbar
SET "STRTMP=HKLM_SW_InternetExplorer_Toolbar"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Internet Explorer\Toolbar" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\Toolbar : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar
SET "STRTMP=HKLM_SW_InternetExplorer_Toolbar(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Toolbar" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\…생략…\Toolbar : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Tracing
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Tracing
SET "STRTMP=HKLM_SW_Tracing"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Tracing" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Microsoft\Tracing\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HKLM_SOFTWARE_TRACING.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Wow6432Node\Microsoft\Tracing
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Tracing
SET "STRTMP=HKLM_SW_Tracing(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Tracing" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\Microsoft\Tracing\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HKLM_SOFTWARE_TRACING.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache
SET "STRTMP=HKLM_SW_AppManagement_ARPCache"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\App Management\ARPCache\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_ARPCACHE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Management\ARPCache
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Management\ARPCache
SET "STRTMP=HKLM_SW_AppManagement_ARPCache(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Management\ARPCache" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\…생략…\App Management\ARPCache\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_ARPCACHE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\App Paths
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\App Paths
SET "STRTMP=HKLM_SW_AppPaths"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\App Paths" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\App Paths\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_APPPATHS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths
SET "STRTMP=HKLM_SW_AppPaths(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\App Paths" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\…생략…\App Paths\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HK_SOFTWARE_APPPATHS.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks
SET "STRTMP=HKLM_SW_ShellExecuteHooks"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\Explorer\ShellExecuteHooks : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks
SET "STRTMP=HKLM_SW_ShellExecuteHooks(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\…생략…\Explorer\ShellExecuteHooks : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Ext\PreApproved
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Ext\PreApproved
SET "STRTMP=HKLM_SW_Ext_PreApproved"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\Ext\PreApproved" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\Ext\PreApproved\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\PreApproved
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\PreApproved
SET "STRTMP=HKLM_SW_Ext_PreApproved(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Ext\PreApproved" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\…생략…\Ext\PreApproved\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID
SET "STRTMP=HKLM_SW_Policies_Ext_CLSID"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\Policies\Ext\CLSID : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID
SET "STRTMP=HKLM_SW_Policies_Ext_CLSID(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Ext\CLSID" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\…생략…\Policies\Ext\CLSID : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_HK_CLSID.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options (Debugger)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
SET "STRTMP=HKLM_SW_ImageFileExecutionOptions"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%A" == "YOUR IMAGE FILE NAME HERE WITHOUT A PATH" (
		TITLE 검사중 "HKLM\Software\…생략…\Image File Execution Options\%%A" 2>Nul
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%A
		>VARIABLE\TXT2 ECHO Debugger
		>VARIABLE\TXTX ECHO %%A
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HKLM_SOFTWARE_IMGFILEEXECOP.DB VARIABLE\TXTX 2^>Nul') DO (
			FOR /F "DELIMS=" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%A\Debugger" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
				IF EXIST "DB\EXCEPT\DEBUGGER_%%A.DB" (
					>VARIABLE\TXTX ECHO %%~nxY
					FOR /F %%Z IN ('TOOLS\GREP\GREP.EXE -Fixvf "DB\EXCEPT\DEBUGGER_%%A.DB" VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV NULL BACKUP RANDOM "%STRTMP%"
				) ELSE (
					CALL :DEL_REGV NULL BACKUP RANDOM "%STRTMP%"
				)
			)
		)
		FOR /F "DELIMS=" %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%A\Debugger" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%~nxX
			FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HKLM_SOFTWARE_IMGFILEEXECOP.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP RANDOM "%STRTMP%"
		)
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options (Debugger)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
SET "STRTMP=HKLM_SW_ImageFileExecutionOptions(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%A" == "YOUR IMAGE FILE NAME HERE WITHOUT A PATH" (
		TITLE 검사중 "HKLM\Software\Wow6432Node\…생략…\Image File Execution Options\%%A" 2>Nul
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%A
		>VARIABLE\TXT2 ECHO Debugger
		>VARIABLE\TXTX ECHO %%A
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_HKLM_SOFTWARE_IMGFILEEXECOP.DB VARIABLE\TXTX 2^>Nul') DO (
			FOR /F "DELIMS=" %%Y IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%A\Debugger" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
				IF EXIST "DB\EXCEPT\DEBUGGER_%%A.DB" (
					>VARIABLE\TXTX ECHO %%~nxY
					FOR /F %%Z IN ('TOOLS\GREP\GREP.EXE -Fixvf "DB\EXCEPT\DEBUGGER_%%A.DB" VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV NULL BACKUP RANDOM "%STRTMP%"
				) ELSE (
					CALL :DEL_REGV NULL BACKUP RANDOM "%STRTMP%"
				)
			)
		)
		FOR /F "DELIMS=" %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\%%A\Debugger" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			>VARIABLE\TXTX ECHO %%~nxX
			FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HKLM_SOFTWARE_IMGFILEEXECOP.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP RANDOM "%STRTMP%"
		)
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures
SET "STRTMP=HKLM_SW_Schedule_CompatibilityAdapter_Signatures"
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn ace -ace "n:Everyone;p:full" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\Schedule\CompatibilityAdapter\Signatures : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_TASKS_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_REG_TASKS_JOB.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fxf DB_ACTIVE\ACT_REG_TASKS_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn trustee -trst "n1:Everyone;ta:remtrst;w:dacl" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures
SET "STRTMP=HKLM_SW_Schedule_CompatibilityAdapter_Signatures(x86)"
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn ace -ace "n:Everyone;p:full" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\…생략…\Schedule\CompatibilityAdapter\Signatures : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_TASKS_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_REG_TASKS_JOB.DB" (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fxf DB_ACTIVE\ACT_REG_TASKS_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn trustee -trst "n1:Everyone;ta:remtrst;w:dacl" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\CompatibilityAdapter\Signatures" -ot reg -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree
SET "STRTMP=HKLM_SW_Schedule_TaskCache_Tree"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\Schedule\TaskCache\Tree\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%%A\Id" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS_TREE.DB VARIABLE\TXT2 2^>Nul') DO (
				>>DB_ACTIVE\ACT_REG_TASKS_CLSID.DB ECHO %%X
				CALL :DEL_REGK NULL BACKUP "%STRTMP%"
			)
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_REG_TASKS_TREE.DB" (
			FOR /F "DELIMS=" %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%%A\Id" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
				FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fxf DB_ACTIVE\ACT_REG_TASKS_TREE.DB VARIABLE\TXT2 2^>Nul') DO (
					>>DB_ACTIVE\ACT_REG_TASKS_CLSID.DB ECHO %%X
					CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
				)
			)
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree
SET "STRTMP=HKLM_SW_Schedule_TaskCache_Tree(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\…생략…\Schedule\TaskCache\Tree\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%%A\Id" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\FILE\DEL_TASKS_TREE.DB VARIABLE\TXT2 2^>Nul') DO (
				>>DB_ACTIVE\ACT_REG_TASKS_CLSID.DB ECHO %%X
				CALL :DEL_REGK NULL BACKUP "%STRTMP%"
			)
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST "DB_ACTIVE\ACT_REG_TASKS_TREE.DB" (
			FOR /F "DELIMS=" %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tree\%%A\Id" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
				FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fxf DB_ACTIVE\ACT_REG_TASKS_TREE.DB VARIABLE\TXT2 2^>Nul') DO (
					>>DB_ACTIVE\ACT_REG_TASKS_CLSID.DB ECHO %%X
					CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
				)
			)
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Svchost (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Svchost
SET "STRTMP=HKLM_SW_Svchost"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Svchost" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\Svchost : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HKLM_SVCHOST.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Svchost (Value)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Svchost
SET "STRTMP=HKLM_SW_Svchost(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Svchost" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\…생략…\Svchost : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HKLM_SVCHOST.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain
SET "STRTMP=HKLM_SW_Schedule_TaskCache_Plain"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\Schedule\TaskCache\Plain\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "DB_ACTIVE\ACT_REG_TASKS_CLSID.DB" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_REG_TASKS_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain
SET "STRTMP=HKLM_SW_Schedule_TaskCache_Plain(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Plain" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\…생략…\Schedule\TaskCache\Plain\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "DB_ACTIVE\ACT_REG_TASKS_CLSID.DB" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_REG_TASKS_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks
SET "STRTMP=HKLM_SW_Schedule_TaskCache_Tasks"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\…생략…\Schedule\TaskCache\Tasks\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "DB_ACTIVE\ACT_REG_TASKS_CLSID.DB" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_REG_TASKS_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks
SET "STRTMP=HKLM_SW_Schedule_TaskCache_Tasks(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\…생략…\Schedule\TaskCache\Tasks\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	IF EXIST "DB_ACTIVE\ACT_REG_TASKS_CLSID.DB" (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_REG_TASKS_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	)
)
REM :HKLM\Software\Mozilla\Firefox\Extensions
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Mozilla\Firefox\Extensions
SET "STRTMP=HKLM_Mozilla_Firefox_Extensions"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Mozilla\Firefox\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Mozilla\Firefox\Extensions : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_FIREFOX.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_FIREFOX.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Mozilla\Firefox\Extensions
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Mozilla\Firefox\Extensions
SET "STRTMP=HKLM_Mozilla_Firefox_Extensions(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Mozilla\Firefox\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Mozilla\Firefox\Extensions : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\COMBO\DEL_BROWSER_EXTENSIONS_FIREFOX.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_BROWSER_EXTENSIONS_FIREFOX.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Policies\Microsoft\Windows\IPSec\Policy\Local
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Policies\Microsoft\Windows\IPSec\Policy\Local
SET "STRTMP=HKLM_SW_Policies_IPSecLocal"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Policies\Microsoft\Windows\IPSec\Policy\Local" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Policies\…생략…\IPSec\Policy\Local\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F "DELIMS=" %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Policies\Microsoft\Windows\IPSec\Policy\Local\%%A\ipsecName" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
		>VARIABLE\TXTX ECHO %%X
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fxf DB_EXEC\THREAT\REGISTRY\DEL_IPSEC_POLICY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	)
)
REM :HKLM\Software (ETCs)
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "TOKENS=1,2 DELIMS=|" %%A IN (DB_EXEC\REGDEL_HKLM_SOFTWARE_ETCS.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF NOT "%%B" == "" (
			TITLE 검사중^(DB^) "HKLM\Software\%%A : %%~nxB" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\%%A\%%B" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\Software\%%A
				>VARIABLE\TXT2 ECHO %%B
				CALL :DEL_REGV NULL BACKUP RANDOM "HKLM_SoftwareETCs"
			)
			TITLE 검사중^(DB^) "HKLM\Software\Wow6432Node\%%A : %%~nxB" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\%%A\%%B" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\%%A
				>VARIABLE\TXT2 ECHO %%B
				CALL :DEL_REGV NULL BACKUP RANDOM "HKLM_SoftwareETCs(x86)"
			)
		) ELSE (
			TITLE 검사중^(DB^) "HKLM\Software\%%A" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKLM\Software\%%A" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\Software
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_REGK NULL BACKUP "HKLM_SoftwareETCs"
			)
			TITLE 검사중^(DB^) "HKLM\Software\Wow6432Node\%%A" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKLM\Software\Wow6432Node\%%A" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_REGK NULL BACKUP "HKLM_SoftwareETCs(x86)"
			)
		)
	)
)
REM :HKLM\System\CurrentControlSet\Services\EventLog\Application
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\EventLog\Application
SET "STRTMP=HKLM_ServicesEventLogApplication"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\System\CurrentControlSet\Services\EventLog\Application" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\System\CurrentControlSet\Services\EventLog\Application\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_EVENTLOG_APPLICATION.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\System\CurrentControlSet
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "TOKENS=1,2 DELIMS=|" %%A IN (DB_EXEC\REGDEL_HKLM_SYSTEM.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF NOT "%%B" == "" (
			TITLE 검사중^(DB^) "HKLM\System\CurrentControlSet\%%A : %%B" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\%%A\%%B" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\%%A
				>VARIABLE\TXT2 ECHO %%B
				CALL :DEL_REGV NULL BACKUP RANDOM "HKLM_SystemCurrentControlSet"
			)
		) ELSE (
			TITLE 검사중^(DB^) "HKLM\System\CurrentControlSet\%%A" 2>Nul
			FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKLM\System\CurrentControlSet\%%A" 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet
				>VARIABLE\TXT2 ECHO %%A
				CALL :DEL_REGK NULL BACKUP "HKLM_SystemCurrentControlSet"
			)
		)
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <Malicious BHO(Browser Helper Object)>
ECHO ◇ 악성 및 유해 가능 BHO^(Browser Helper Object^) 제거중 . . . & >>"%QLog%" ECHO    ■ 악성 및 유해 가능 BHO^(Browser Helper Object^) 제거 :
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects
SET "STRTMP=HKLM_BrowserHelperObjects"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "Browser Helper Objects : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fxf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID_DEFAULTVAL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects
SET "STRTMP=HKLM_BrowserHelperObjects(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "Browser Helper Objects (x64) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fxf DB_EXEC\THREAT\REGISTRY\DEL_HK_CLSID_DEFAULTVAL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_HK_CLSID.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		CALL :GET_DVAL
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\COMBO\PATTERN_ADWARE_MULTIPLUG.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <Malicious Firewall Rules>
ECHO ◇ 악성 및 유해 가능 방화벽 규칙 제거중 . . . & >>"%QLog%" ECHO    ■ 악성 및 유해 가능 방화벽 규칙 제거 :
REM :HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules
SET "STRTMP=HKLM_FirewallPolicy_FirewallRules"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Eix "\{[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}\}" 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul^|TOOLS\GREP\GREP.EXE -Ei "\|Action=Allow\|" 2^>Nul') DO (
		TITLE 검사중 "HKLM\System\…생략…\FirewallPolicy\FirewallRules : %%A" 2>Nul
		>VARIABLE\TXT2 ECHO %%A
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Ff DB_EXEC\THREAT\NETWORK\DEL_BAD_FIREWALL_RULES.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	)
)
REM :HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List
SET "STRTMP=HKLM_FirewallPolicy_AuthorizedApplications_List"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\AuthorizedApplications\List\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
		TITLE 검사중 "HKLM\System\…생략…\AuthorizedApplications\List : %%A" 2>Nul
		>VARIABLE\TXT2 ECHO %%A
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Ff DB_EXEC\THREAT\NETWORK\DEL_BAD_FIREWALL_AUTHORIZEDAPPLICATIONS_RULES.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Malicious Background Intelligent Transfer Service Job
ECHO ◇ 악성 및 유해 가능 유휴 파일 전송 작업 제거중 . . . & >>"%QLog%" ECHO    ■ 악성 및 유해 가능 유휴 파일 전송 작업 제거 :
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "TOKENS=1,*" %%A IN ('BITSADMIN.EXE /LIST /ALLUSERS 2^>Nul^|TOOLS\GREP\GREP.EXE -Ei "\{[0-9A-Z]{8}-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{4}-[0-9A-Z]{12}\}" 2^>Nul') DO (
	TITLE 검사중 "BITS Job : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%B
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fif DB_EXEC\THREAT\SERVICE\DEL_BITSADMIN_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_BITS NULL "%%A"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\SERVICE\PATTERN_BITSADMIN_JOB.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_BITS ACTIVESCAN "%%A"
	) ELSE (
		ENDLOCAL
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <Malicious Browser Extensions>
ECHO ◇ 악성 및 유해 가능 브라우저 확장 기능 제거중 . . . & >>"%QLog%" ECHO    ■ 악성 및 유해 가능 브라우저 확장 기능 제거 :
REM :HKCU\Software\Microsoft\Internet Explorer\Extensions
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Extensions
SET "STRTMP=HKCU_InternetExplorerExtensions"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Internet Explorer\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Microsoft\Internet Explorer\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKCU\Software\Microsoft\Internet Explorer\Extensions\%%A" 2^>Nul') DO (
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_BROWSER_EXTENSIONS_IE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions
SET "STRTMP=HKCU_InternetExplorerExtensions(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions\%%A" 2^>Nul') DO (
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_BROWSER_EXTENSIONS_IE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\Extensions
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\Extensions
SET "STRTMP=HKLM_InternetExplorerExtensions"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Internet Explorer\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Microsoft\Internet Explorer\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKLM\Software\Microsoft\Internet Explorer\Extensions\%%A" 2^>Nul') DO (
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_BROWSER_EXTENSIONS_IE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions
SET "STRTMP=HKLM_InternetExplorerExtensions(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -v -q check "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Extensions\%%A" 2^>Nul') DO (
		FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_BROWSER_EXTENSIONS_IE.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset Internet Explorer Start & Search Page
ECHO ◇ 웹 브라우저 - 인터넷 익스플로러 악성 시작 및 검색 페이지 제거중 . . . & >>"%QLog%" ECHO    ■ 웹 브라우저 - 인터넷 익스플로러 악성 시작 및 검색 페이지 제거 :
REM :HKCU\Software\Microsoft\Internet Explorer\Main (Default_Page_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Internet Explorer\Main\Default_Page_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Microsoft\Internet Explorer\Main : Default_Page_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Page_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_DefaultPageURL"
		REG.EXE ADD "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Default_Page_URL" /d "http://www.msn.com" /f >Nul 2>Nul
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Default_Page_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Default_Page_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Default_Page_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Page_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_DefaultPageURL(x86)"
		REG.EXE ADD "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main" /v "Default_Page_URL" /d "http://www.msn.com" /f >Nul 2>Nul
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\Main (Default_Search_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Internet Explorer\Main\Default_Search_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Microsoft\Internet Explorer\Main : Default_Search_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Search_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_DefaultSearchURL"
		REG.EXE ADD "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Default_Search_URL" /d "http://www.bing.com" /f >Nul 2>Nul
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Default_Search_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Default_Search_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Default_Search_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Search_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_DefaultSearchURL(x86)"
		REG.EXE ADD "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main" /v "Default_Search_URL" /d "http://www.bing.com" /f >Nul 2>Nul
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\Main (Start Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Internet Explorer\Main\Start Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Microsoft\Internet Explorer\Main : Start Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Start Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_StartPage"
		REG.EXE ADD "HKCU\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /d "http://cyberbureau.police.go.kr/prevention/prevention1.jsp?mid=020301" /f >Nul 2>Nul
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Start Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Start Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Start Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Start Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_StartPage(x86)"
		REG.EXE ADD "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main" /v "Start Page" /d "http://cyberbureau.police.go.kr/prevention/prevention1.jsp?mid=020301" /f >Nul 2>Nul
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\Main (Secondary Start Pages)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Internet Explorer\Main\Secondary Start Pages" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Microsoft\Internet Explorer\Main : Secondary Start Pages" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Secondary Start Pages
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_SecondaryStartPages"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Secondary Start Pages)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Secondary Start Pages" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Secondary Start Pages" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Secondary Start Pages
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_SecondaryStartPages(x86)"
	)
)
REM :HKCU\Software\Microsoft\Internet Explorer\Main (Search Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Internet Explorer\Main\Search Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Microsoft\Internet Explorer\Main : Search Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Search Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_SearchPage"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Search Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Search Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Search Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Search Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKCU_InternetExplorer_SearchPage(x86)"
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\Main (Default_Page_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Internet Explorer\Main\Default_Page_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Microsoft\Internet Explorer\Main : Default_Page_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Page_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_DefaultPageURL"
		REG.EXE ADD "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Default_Page_URL" /d "http://www.msn.com" /f >Nul 2>Nul
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Default_Page_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Default_Page_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Default_Page_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Page_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_DefaultPageURL(x86)"
		REG.EXE ADD "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main" /v "Default_Page_URL" /d "http://www.msn.com" /f >Nul 2>Nul
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\Main (Default_Search_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Internet Explorer\Main\Default_Search_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Microsoft\Internet Explorer\Main : Default_Search_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Search_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_DefaultSearchURL"
		REG.EXE ADD "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Default_Search_URL" /d "http://www.bing.com" /f >Nul 2>Nul
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Default_Search_URL)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Default_Search_URL" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Default_Search_URL" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Default_Search_URL
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_DefaultSearchURL(x86)"
		REG.EXE ADD "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main" /v "Default_Search_URL" /d "http://www.bing.com" /f >Nul 2>Nul
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\Main (Start Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Internet Explorer\Main\Start Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Microsoft\Internet Explorer\Main : Start Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Start Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_StartPage"
		REG.EXE ADD "HKLM\Software\Microsoft\Internet Explorer\Main" /v "Start Page" /d "http://cyberbureau.police.go.kr/prevention/prevention1.jsp?mid=020301" /f >Nul 2>Nul
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Start Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Start Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Start Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Start Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_StartPage(x86)"
		REG.EXE ADD "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main" /v "Start Page" /d "http://cyberbureau.police.go.kr/prevention/prevention1.jsp?mid=020301" /f >Nul 2>Nul
	)
)
REM :HKLM\Software\Microsoft\Internet Explorer\Main (Search Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Internet Explorer\Main\Search Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Microsoft\Internet Explorer\Main : Search Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Search Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_SearchPage"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main (Search Page)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main\Search Page" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main : Search Page" 2>Nul
	>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Internet Explorer\Main
	>VARIABLE\TXT2 ECHO Search Page
	>VARIABLE\TXTX ECHO %%~A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		CALL :DEL_REGV NULL BACKUP NULL "HKLM_InternetExplorer_SearchPage(x86)"
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset Mozilla Firefox Start & Search Page
ECHO ◇ 웹 브라우저 - 모질라 파이어폭스 악성 시작 및 검색 페이지 제거중 . . . & >>"%QLog%" ECHO    ■ 웹 브라우저 - 악성 모질라 파이어폭스 악성 시작 및 검색 페이지 제거 :
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%APPDATA%\Mozilla\Firefox\Profiles\" 2^>Nul') DO (
	SET "STRTMP=%%A"
	IF EXIST "%APPDATA%\Mozilla\Firefox\Profiles\%%A\prefs.js" (
		TITLE 검사중 "%APPDATA%\Mozilla\Firefox\Profiles\%%A\prefs.js" 2>Nul
		>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Mozilla\Firefox\Profiles\%%A\
		>VARIABLE\TXT2 ECHO prefs.js
		SETLOCAL ENABLEDELAYEDEXPANSION
		TOOLS\ICONV\ICONV.EXE -f CP949 "!APPDATA!\Mozilla\Firefox\Profiles\!STRTMP!\prefs.js">"!TEMP!\prefs.js" 2>Nul
		IF !ERRORLEVEL! EQU 0 (
			ENDLOCAL
			IF EXIST "%TEMP%\prefs.js.clone" DEL /A /F /Q "%TEMP%\prefs.js.clone" >Nul 2>Nul
			FOR /F "DELIMS=" %%B IN ('TOOLS\ICONV\ICONV.EXE "%TEMP%\prefs.js" 2^>Nul') DO (
				>VARIABLE\TXTX ECHO %%B
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixvf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO >>"%TEMP%\prefs.js.clone" ECHO %%B
			)
			IF EXIST "%TEMP%\prefs.js" (
				IF EXIST "%TEMP%\prefs.js.clone" (
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixcf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB "%APPDATA%\Mozilla\Firefox\Profiles\%%A\prefs.js" 2^>Nul') DO (
						IF %%X NEQ 0 CALL :DEL_FILE
					)
					IF NOT EXIST "%APPDATA%\Mozilla\Firefox\Profiles\%%A\prefs.js" (
						TOOLS\ICONV\ICONV.EXE -f CP949 "%TEMP%\prefs.js.clone">"%APPDATA%\Mozilla\Firefox\Profiles\%%A\prefs.js" 2>Nul
					)
				)
			)
		) ELSE (
			ENDLOCAL
		)
	)
	IF EXIST "%APPDATA%\Mozilla\Firefox\Profiles\%%A\user.js" (
		TITLE 검사중 "%APPDATA%\Mozilla\Firefox\Profiles\%%A\user.js" 2>Nul
		>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Mozilla\Firefox\Profiles\%%A\
		>VARIABLE\TXT2 ECHO user.js
		SETLOCAL ENABLEDELAYEDEXPANSION
		TOOLS\ICONV\ICONV.EXE -f CP949 "!APPDATA!\Mozilla\Firefox\Profiles\!STRTMP!\user.js">"!TEMP!\user.js" 2>Nul
		IF !ERRORLEVEL! EQU 0 (
			ENDLOCAL
			IF EXIST "%TEMP%\user.js.clone" DEL /A /F /Q "%TEMP%\user.js.clone" >Nul 2>Nul
			FOR /F "DELIMS=" %%B IN ('TOOLS\ICONV\ICONV.EXE "%TEMP%\user.js" 2^>Nul') DO (
				>VARIABLE\TXTX ECHO %%B
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixvf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO >>"%TEMP%\user.js.clone" ECHO %%B
			)
			IF EXIST "%TEMP%\user.js" (
				IF EXIST "%TEMP%\user.js.clone" (
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixcf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB "%APPDATA%\Mozilla\Firefox\Profiles\%%A\user.js" 2^>Nul') DO (
						IF %%X NEQ 0 CALL :DEL_FILE
					)
					IF NOT EXIST "%APPDATA%\Mozilla\Firefox\Profiles\%%A\user.js" (
						TOOLS\ICONV\ICONV.EXE -f CP949 "%TEMP%\user.js.clone">"%APPDATA%\Mozilla\Firefox\Profiles\%%A\user.js" 2>Nul
					)
				)
			)
		) ELSE (
			ENDLOCAL
		)
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset Internet Browser Shortcut Value
ECHO ◇ 초기화 대상 웹 브라우저 바로 가기 확인중 . . . & >>"%QLog%" ECHO    ■ 초기화 대상 웹 브라우저 바로 가기 확인 :
REM :[%SYSTEMROOT%]\System32\Config\SystemProfile\Desktop
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32\Config\SystemProfile\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\*.LNK" 2^>Nul') DO (
	TITLE 확인중 "%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%SYSTEMROOT%\System32\Config\SystemProfile\Desktop\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%SYSTEMROOT%]\SysWOW64\Config\SystemProfile\Desktop
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\*.LNK" 2^>Nul') DO (
	TITLE 확인중 "%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%SYSTEMROOT%\SysWOW64\Config\SystemProfile\Desktop\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%PUBLIC%]\Desktop
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKPUBLIC%\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%PUBLIC%\Desktop\*.LNK" 2^>Nul') DO (
	TITLE 확인중 "%PUBLIC%\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%PUBLIC%\Desktop\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%USERPROFILE%]\Desktop
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKUSERPROFILE%\Desktop\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%USERPROFILE%\Desktop\*.LNK" 2^>Nul') DO (
	TITLE 확인중 "%USERPROFILE%\Desktop\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%USERPROFILE%\Desktop\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Microsoft\Internet Explorer\Quick Launch
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\*.LNK" 2^>Nul') DO (
	TITLE 확인중 "%ALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%ALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%APPDATA%]\Microsoft\Internet Explorer\Quick Launch
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Internet Explorer\Quick Launch\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\*.LNK" 2^>Nul') DO (
	TITLE 확인중 "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%APPDATA%\Microsoft\Internet Explorer\Quick Launch\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.LNK" 2^>Nul') DO (
	TITLE 확인중 "%ALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%ALLUSERSPROFILE%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%APPDATA%]\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\*.LNK" 2^>Nul') DO (
	TITLE 확인중 "%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%APPDATA%\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Microsoft\Windows\Start Menu
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Microsoft\Windows\Start Menu\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\*.LNK" 2^>Nul') DO (
	TITLE 확인중 "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%APPDATA%]\Microsoft\Windows\Start Menu
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Windows\Start Menu\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Microsoft\Windows\Start Menu\*.LNK" 2^>Nul') DO (
	TITLE 확인중 "%APPDATA%\Microsoft\Windows\Start Menu\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%APPDATA%\Microsoft\Windows\Start Menu\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Microsoft\Windows\Start Menu\Programs
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\*.LNK" 2^>Nul') DO (
	TITLE 확인중 "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%APPDATA%]\Microsoft\Windows\Start Menu\Programs
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Windows\Start Menu\Programs\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Microsoft\Windows\Start Menu\Programs\*.LNK" 2^>Nul') DO (
	TITLE 확인중 "%APPDATA%\Microsoft\Windows\Start Menu\Programs\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%APPDATA%\Microsoft\Windows\Start Menu\Programs\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :[%ALLUSERSPROFILE%]\Microsoft\Windows\Start Menu\Programs // Google Chrome
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Chrome\
FOR /F "TOKENS=1,* DELIMS==" %%A IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Chrome\Chrome.lnk" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
	IF NOT "%%B" == "" (
		TITLE 확인중 "%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Chrome\Chrome.lnk" 2>Nul
		>VARIABLE\TXT2 ECHO Chrome.lnk
		FOR /F %%X IN ('ECHO "%%B"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
	)
)
REM :[%APPDATA%]\Microsoft\Windows\Start Menu\Programs // Google Chrome
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Windows\Start Menu\Programs\Chrome\
FOR /F "TOKENS=1,* DELIMS==" %%A IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%APPDATA%\Microsoft\Windows\Start Menu\Programs\Chrome\Chrome.lnk" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
	IF NOT "%%B" == "" (
		TITLE 확인중 "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Chrome\Chrome.lnk" 2>Nul
		>VARIABLE\TXT2 ECHO Chrome.lnk
		FOR /F %%X IN ('ECHO "%%B"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
	)
)
REM :[%APPDATA%]\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO %MZKAPPDATA%\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\
FOR /F "DELIMS=" %%A IN ('DIR /B /A-D "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\*.LNK" 2^>Nul') DO (
	TITLE 확인중 "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%B IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\CHECK\CHK_BROWSER_SHORTCUT.DB VARIABLE\TXT2 2^>Nul') DO (
		FOR /F "TOKENS=1,* DELIMS==" %%C IN ('TOOLS\SHORTCUT\SHORTCUT.EXE /A:Q /F:"%APPDATA%\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\%%A" 2^>Nul^|TOOLS\GREP\GREP.EXE -F "Arguments=" 2^>Nul') DO (
			IF NOT "%%D" == "" (
				FOR /F %%X IN ('ECHO "%%D"^|TOOLS\GREP\GREP.EXE -iv "^.-" 2^>Nul') DO CALL :RESETCUT
			)
		)
	)
)
REM :Result
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\SRCH SET /P SRCH=
<VARIABLE\SUCC SET /P SUCC=
<VARIABLE\FAIL SET /P FAIL=
IF !SRCH! EQU 0 (
	ECHO    문제점이 발견되지 않았습니다.
	>>"!QLog!" ECHO    문제점이 발견되지 않음
) ELSE (
	ECHO    발견: !SRCH! / 초기화: !SUCC! / 초기화 실패: !FAIL!
	>VARIABLE\XXYY ECHO 1
)
ENDLOCAL
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Reset Service & Registry
ECHO ◇ 초기화 대상 서비스 및 레지스트리 확인중 . . . & >>"%QLog%" ECHO    ■ 초기화 대상 서비스 및 레지스트리 확인 :
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
REM :HKCR\exefile\shell\open\command (Default)
TITLE 확인중 "HKCR\exefile\shell\open\command : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\exefile\shell\open\command\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%A" == ""%%1" %%*" (
		>VARIABLE\TXT1 ECHO HKCR\exefile\shell\open\command
		>VARIABLE\TXT2 ECHO "%%1" %%*
		CALL :RESETREG "(Default)" NULL BACKUP "HKCR_EXEFileShell_OpenCommand"
	)
)
REM :HKCR\exefile\shell\runas\command (Default)
TITLE 확인중 "HKCR\exefile\shell\runas\command : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\exefile\shell\runas\command\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%A" == ""%%1" %%*" (
		>VARIABLE\TXT1 ECHO HKCR\exefile\shell\runas\command
		>VARIABLE\TXT2 ECHO "%%1" %%*
		CALL :RESETREG "(Default)" NULL BACKUP "HKCR_EXEFileShell_RunASCommand"
	)
)
REM :HKCR\Unknown\shell\openas\command (Default) // File Scout
TITLE 확인중 "HKCR\Unknown\shell\openas\command : fs_backup" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\Unknown\shell\openas\command\fs_backup" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCR\Unknown\shell\openas\command
	>VARIABLE\TXT2 ECHO %%A
	CALL :RESETREG "(Default)" REG_EXPAND_SZ BACKUP "HKCR_UnknownShell_OpenASCommand"
	REG.EXE DELETE "HKCR\Unknown\shell\openas\command" /v "fs_backup" /f >Nul 2>Nul
)
REM :HKCR\Unknown\shell\openas\command (Default) // File Type Assistant
TITLE 확인중 "HKCR\Unknown\shell\openas\command : tsa_backup" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\Unknown\shell\openas\command\tsa_backup" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCR\Unknown\shell\openas\command
	>VARIABLE\TXT2 ECHO %%A
	CALL :RESETREG "(Default)" REG_EXPAND_SZ BACKUP "HKCR_UnknownShell_OpenASCommand"
	REG.EXE DELETE "HKCR\Unknown\shell\openas\command" /v "tsa_backup" /f >Nul 2>Nul
)
REM :HKCR\Unknown\shell\opendlg\command (Default) // File Scout
TITLE 확인중 "HKCR\Unknown\shell\opendlg\command : fs_backup" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\Unknown\shell\opendlg\command\fs_backup" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCR\Unknown\shell\opendlg\command
	>VARIABLE\TXT2 ECHO %%A
	CALL :RESETREG "(Default)" REG_EXPAND_SZ BACKUP "HKCR_UnknownShell_OpenASCommand"
	REG.EXE DELETE "HKCR\Unknown\shell\opendlg\command" /v "fs_backup" /f >Nul 2>Nul
)
REM :HKCR\Unknown\shell\opendlg\command (Default) // File Type Assistant
TITLE 확인중 "HKCR\Unknown\shell\opendlg\command : tsa_backup" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCR\Unknown\shell\opendlg\command\tsa_backup" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCR\Unknown\shell\opendlg\command
	>VARIABLE\TXT2 ECHO %%A
	CALL :RESETREG "(Default)" REG_EXPAND_SZ BACKUP "HKCR_UnknownShell_OpenASCommand"
	REG.EXE DELETE "HKCR\Unknown\shell\opendlg\command" /v "tsa_backup" /f >Nul 2>Nul
)
REM :HKCU\Control Panel\Desktop (SCRNSAVE.EXE)
TITLE 확인중 "HKCU\Control Panel\Desktop : SCRNSAVE.EXE" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Control Panel\Desktop\SCRNSAVE.EXE" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCU\Control Panel\Desktop
	FOR /F %%X IN ('ECHO "%%A"^|TOOLS\GREP\GREP.EXE -Fie "WINDOWS\IEUPDATE" 2^>Nul') DO (
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "SCRNSAVE.EXE" NULL BACKUP "HKCU_ControlPanelDesktop_ScrnSave"
	)
)
REM :HKCU\Software\Microsoft\Command Processor (AutoRun)
TITLE 확인중 "HKCU\Software\Microsoft\Command Processor : AutoRun" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Command Processor\AutoRun" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F %%X IN ('ECHO "%%A"^|TOOLS\GREP\GREP.EXE -Fie "WINDOWS\IEUPDATE" 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Command Processor
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG AutoRun NULL BACKUP "HKCU_CommandProcessor_AutoRun"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings (DnsCacheEnabled)
TITLE 확인중 "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings : DnsCacheEnabled" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\DnsCacheEnabled" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings
		>VARIABLE\TXT2 ECHO DELETECOMMAND
		CALL :RESETREG DnsCacheEnabled NULL BACKUP "HKCU_InternetSettings_DnsCacheEnabled"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings (DnsCacheTimeout)
TITLE 확인중 "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings : DnsCacheTimeout" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\DnsCacheTimeout" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings
		>VARIABLE\TXT2 ECHO DELETECOMMAND
		CALL :RESETREG DnsCacheTimeout NULL BACKUP "HKCU_InternetSettings_DnsCacheTimeout"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings (ProxyEnable)
TITLE 확인중 "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings : ProxyEnable" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ProxyEnable" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG ProxyEnable REG_DWORD BACKUP "HKCU_InternetSettings_ProxyEnable"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings (ServerInfoTimeOut)
TITLE 확인중 "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings : ServerInfoTimeOut" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings\ServerInfoTimeOut" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings
		>VARIABLE\TXT2 ECHO DELETECOMMAND
		CALL :RESETREG ServerInfoTimeOut NULL BACKUP "HKCU_InternetSettings_ServerInfoTimeOut"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Run (Default)
TITLE 확인중 "HKCU\Software\Microsoft\Windows\CurrentVersion\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_Run"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run (Default)
TITLE 확인중 "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_Run(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce (Default)
TITLE 확인중 "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_RunOnce"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce (Default)
TITLE 확인중 "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_RunOnce(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices (Default)
TITLE 확인중 "HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_RunServices"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices (Default)
TITLE 확인중 "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_RunServices(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce (Default)
TITLE 확인중 "HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_RunServicesOnce"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce (Default)
TITLE 확인중 "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_RunServicesOnce(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoFolderOptions)
TITLE 확인중 "HKCU\Software\…생략…\Policies\Explorer : NoFolderOptions" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoFolderOptions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoFolderOptions REG_DWORD BACKUP "HKCU_PoliciesExplorer"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoFolderOptions)
TITLE 확인중 "HKCU\Software\Wow6432Node\…생략…\Policies\Explorer : NoFolderOptions" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoFolderOptions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoFolderOptions REG_DWORD BACKUP "HKCU_PoliciesExplorer(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoWindowsUpdate)
TITLE 확인중 "HKCU\Software\…생략…\Policies\Explorer : NoWindowsUpdate" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoWindowsUpdate" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoWindowsUpdate REG_DWORD BACKUP "HKCU_PoliciesExplorer"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoWindowsUpdate)
TITLE 확인중 "HKCU\Software\Wow6432Node\…생략…\Policies\Explorer : NoWindowsUpdate" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoWindowsUpdate" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoWindowsUpdate REG_DWORD BACKUP "HKCU_PoliciesExplorer(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run (Default)
TITLE 확인중 "HKCU\Software\…생략…\Policies\Explorer\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_PoliciesExplorerRun"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run (Default)
TITLE 확인중 "HKCU\Software\Wow6432Node\…생략…\Policies\Explorer\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKCU_PoliciesExplorerRun(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System (DisableRegistryTools)
TITLE 확인중 "HKCU\Software\…생략…\Policies\System : DisableRegistryTools" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableRegistryTools" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG DisableRegistryTools REG_DWORD BACKUP "HKCU_PoliciesSystem"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System (DisableRegistryTools)
TITLE 확인중 "HKCU\Software\Wow6432Node\…생략…\Policies\System : DisableRegistryTools" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System\DisableRegistryTools" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG DisableRegistryTools REG_DWORD BACKUP "HKCU_PoliciesSystem(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System (DisableTaskMgr)
TITLE 확인중 "HKCU\Software\…생략…\Policies\System : DisableTaskMgr" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System\DisableTaskMgr" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG DisableTaskMgr REG_DWORD BACKUP "HKCU_PoliciesSystem"
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System (DisableTaskMgr)
TITLE 확인중 "HKCU\Software\Wow6432Node\…생략…\Policies\System : DisableTaskMgr" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System\DisableTaskMgr" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\System
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG DisableTaskMgr REG_DWORD BACKUP "HKCU_PoliciesSystem(x86)"
	)
)
REM :HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows (Load)
TITLE 확인중 "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows : Load" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\Load" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows
	>VARIABLE\TXT2 ECHO NULL
	CALL :RESETREG Load NULL BACKUP "HKCU_WinNT_Windows"
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows (Load)
TITLE 확인중 "HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows : Load" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows\Load" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows
	>VARIABLE\TXT2 ECHO NULL
	CALL :RESETREG Load NULL BACKUP "HKCU_WinNT_Windows(x86)"
)
REM :HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows (Run)
TITLE 확인중 "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows : Run" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows NT\CurrentVersion\Windows
	>VARIABLE\TXT2 ECHO NULL
	CALL :RESETREG Run NULL BACKUP "HKCU_WinNT_Windows"
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows (Run)
TITLE 확인중 "HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows : Run" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Windows
	>VARIABLE\TXT2 ECHO NULL
	CALL :RESETREG Run NULL BACKUP "HKCU_WinNT_Windows(x86)"
)
REM :HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (Shell)
TITLE 확인중 "HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : Shell" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%~nxA
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_REG_WINLOGON_SHELL.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
		>VARIABLE\TXT2 ECHO explorer.exe
		CALL :RESETREG Shell NULL BACKUP "HKCU_WinNT_Winlogon"
	)
)
REM :HKLM\Software\Classes\Unknown\shell\openas\command (Default) // File Scout
TITLE 확인중 "HKLM\Software\Classes\Unknown\shell\openas\command : fs_backup" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Classes\Unknown\shell\openas\command\fs_backup" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKLM\Software\Classes\Unknown\shell\openas\command
	>VARIABLE\TXT2 ECHO %%A
	CALL :RESETREG "(Default)" REG_EXPAND_SZ BACKUP "HKLM_UnknownShellOpenASCommand"
	REG.EXE DELETE "HKLM\Software\Classes\Unknown\shell\openas\command" /v "fs_backup" /f >Nul 2>Nul
)
REM :HKLM\Software\Classes\Unknown\shell\openas\command (Default) // File Type Assistant
TITLE 확인중 "HKLM\Software\Classes\Unknown\shell\openas\command : tsa_backup" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Classes\Unknown\shell\openas\command\tsa_backup" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKLM\Software\Classes\Unknown\shell\openas\command
	>VARIABLE\TXT2 ECHO %%A
	CALL :RESETREG "(Default)" REG_EXPAND_SZ BACKUP "HKLM_UnknownShellOpenASCommand"
	REG.EXE DELETE "HKLM\Software\Classes\Unknown\shell\openas\command" /v "tsa_backup" /f >Nul 2>Nul
)
REM :HKLM\Software\Clients\StartMenuInternet\firefox.exe\shell\open\command (Default)
TITLE 확인중 "HKLM\Software\Clients\StartMenuInternet\firefox.EXE\shell\open\command : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Clients\StartMenuInternet\firefox.exe\shell\open\command\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Clients\StartMenuInternet\firefox.exe\shell\open\command
		>VARIABLE\TXT2 ECHO "%PROGRAMFILESX86%\Mozilla Firefox\firefox.exe"
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_SW_Clients_StartMenuInternet_MozillaFirefox_ShellOpenCommand"
	)
)
REM :HKLM\Software\Clients\StartMenuInternet\Google Chrome\shell\open\command (Default)
TITLE 확인중 "HKLM\Software\Clients\StartMenuInternet\Google Chrome\shell\open\command : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Clients\StartMenuInternet\Google Chrome\shell\open\command\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Clients\StartMenuInternet\Google Chrome\shell\open\command
		>VARIABLE\TXT2 ECHO "%PROGRAMFILESX86%\Google\Chrome\Application\chrome.exe"
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_SW_Clients_StartMenuInternet_GoogleChrome_ShellOpenCommand"
	)
)
REM :HKLM\Software\Clients\StartMenuInternet\iexplore.exe\shell\open\command (Default)
TITLE 확인중 "HKLM\Software\Clients\StartMenuInternet\iexplore.EXE\shell\open\command : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Clients\StartMenuInternet\iexplore.exe\shell\open\command\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\THREAT\REGISTRY\DEL_BROWSER_STARTPAGE.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Clients\StartMenuInternet\iexplore.exe\shell\open\command
		>VARIABLE\TXT2 ECHO %MZKPROGRAMFILES%\Internet Explorer\iexplore.exe
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_SW_Clients_StartMenuInternet_InternetExplorer_ShellOpenCommand"
	)
)
REM :HKLM\Software\Microsoft\Command Processor (AutoRun)
TITLE 확인중 "HKLM\Software\Microsoft\Command Processor : AutoRun" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Command Processor\AutoRun" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F %%X IN ('ECHO "%%A"^|TOOLS\GREP\GREP.EXE -Fie "WINDOWS\IEUPDATE" 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Command Processor
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG AutoRun NULL BACKUP "HKLM_CommandProcessor_AutoRun"
	)
)
REM :HKLM\Software\Microsoft\Security Center (AntiVirusDisableNotify)
TITLE 확인중 "HKLM\Software\Microsoft\Security Center : AntiVirusDisableNotify" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Security Center\AntiVirusDisableNotify" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Security Center
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG AntiVirusDisableNotify REG_DWORD BACKUP "HKLM_SecurityCenter"
	)
)
REM :HKLM\Software\Microsoft\Security Center (FirewallDisableNotify)
TITLE 확인중 "HKLM\Software\Microsoft\Security Center : FirewallDisableNotify" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Security Center\FirewallDisableNotify" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Security Center
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG FirewallDisableNotify REG_DWORD BACKUP "HKLM_SecurityCenter"
	)
)
REM :HKLM\Software\Microsoft\Security Center (UpdatesDisableNotify)
TITLE 확인중 "HKLM\Software\Microsoft\Security Center : UpdatesDisableNotify" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Security Center\UpdatesDisableNotify" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Security Center
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG UpdatesDisableNotify REG_DWORD BACKUP "HKLM_SecurityCenter"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden (Type)
TITLE 확인중 "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden : Type" 2>Nul
TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden\Type" >Nul 2>Nul
IF %ERRORLEVEL% EQU 1 (
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\Folder\Hidden
	>VARIABLE\TXT2 ECHO group
	CALL :RESETREG Type NULL NULL NULL
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Run (Default)
TITLE 확인중 "HKLM\Software\Microsoft\Windows\CurrentVersion\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_Run"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run (Default)
TITLE 확인중 "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_Run(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce (Default)
TITLE 확인중 "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_RunOnce"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce (Default)
TITLE 확인중 "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_RunOnce(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices (Default)
TITLE 확인중 "HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_RunServices"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices (Default)
TITLE 확인중 "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_RunServices(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce (Default)
TITLE 확인중 "HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_RunServicesOnce"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce (Default)
TITLE 확인중 "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_RunServicesOnce(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoFolderOptions)
TITLE 확인중 "HKLM\Software\…생략…\Policies\Explorer : NoFolderOptions" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoFolderOptions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoFolderOptions REG_DWORD BACKUP "HKLM_PoliciesExplorer"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoFolderOptions)
TITLE 확인중 "HKLM\Software\Wow6432Node\…생략…\Policies\Explorer : NoFolderOptions" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoFolderOptions" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoFolderOptions REG_DWORD BACKUP "HKLM_PoliciesExplorer(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoControlPanel)
TITLE 확인중 "HKLM\Software\…생략…\Policies\Explorer : NoControlPanel" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoControlPanel" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoControlPanel REG_DWORD BACKUP "HKLM_PoliciesExplorer"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoControlPanel)
TITLE 확인중 "HKLM\Software\Wow6432Node\…생략…\Policies\Explorer : NoControlPanel" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoControlPanel" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoControlPanel REG_DWORD BACKUP "HKLM_PoliciesExplorer(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoTrayItemsDisplay)
TITLE 확인중 "HKLM\Software\…생략…\Policies\Explorer : NoTrayItemsDisplay" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoTrayItemsDisplay" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoTrayItemsDisplay REG_DWORD BACKUP "HKLM_PoliciesExplorer"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer (NoTrayItemsDisplay)
TITLE 확인중 "HKLM\Software\Wow6432Node\…생략…\Policies\Explorer : NoTrayItemsDisplay" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\NoTrayItemsDisplay" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer
		>VARIABLE\TXT2 ECHO 0
		CALL :RESETREG NoTrayItemsDisplay REG_DWORD BACKUP "HKLM_PoliciesExplorer(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run (Default)
TITLE 확인중 "HKLM\Software\…생략…\Policies\Explorer\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_PoliciesExplorerRun"
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run (Default)
TITLE 확인중 "HKLM\Software\Wow6432Node\…생략…\Policies\Explorer\Run : (Default)" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXTX ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ivf DB\EXCEPT\EX_REG_AUTORUN.DB VARIABLE\TXTX 2^>Nul') DO (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
		>VARIABLE\TXT2 ECHO NULL
		CALL :RESETREG "(Default)" NULL BACKUP "HKLM_PoliciesExplorerRun(x86)"
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (Shell)
TITLE 확인중 "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : Shell" 2>Nul
>VARIABLE\TXTX TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell" 2>Nul|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /S VARIABLE\TXTX 2^>Nul') DO (
	IF %%~zA LEQ 4 (
		>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
		>VARIABLE\TXT2 ECHO explorer.exe
		CALL :RESETREG Shell NULL NULL NULL
	) ELSE (
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_REG_WINLOGON_SHELL.DB VARIABLE\TXTX 2^>Nul') DO (
			>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
			>VARIABLE\TXT2 ECHO explorer.exe
			CALL :RESETREG Shell NULL BACKUP "HKLM_WinNT_Winlogon"
		)
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon (Shell)
IF /I "%ARCHITECTURE%" == "x64" (
	TITLE 확인중 "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon : Shell" 2>Nul
	>VARIABLE\TXTX TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell" 2>Nul|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2>Nul
	FOR /F "DELIMS=" %%A IN ('DIR /B /S VARIABLE\TXTX 2^>Nul') DO (
		IF %%~zA LEQ 4 (
			>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
			>VARIABLE\TXT2 ECHO explorer.exe
			CALL :RESETREG Shell NULL NULL NULL
		) ELSE (
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixvf DB\EXCEPT\EX_REG_WINLOGON_SHELL.DB VARIABLE\TXTX 2^>Nul') DO (
				>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
				>VARIABLE\TXT2 ECHO explorer.exe
				CALL :RESETREG Shell NULL BACKUP "HKLM_WinNT_Winlogon(x86)"
			)
		)
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (System)
TITLE 확인중 "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : System" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\System" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
	>VARIABLE\TXT2 ECHO NULL
	CALL :RESETREG System NULL BACKUP "HKLM_WinNT_Winlogon"
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon (Userinit)
TITLE 확인중 "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon : Userinit" 2>Nul
TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" >Nul 2>Nul
IF %ERRORLEVEL% EQU 1 (
	>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
	>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
	CALL :RESETREG Userinit NULL NULL NULL
) ELSE (
	FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
		IF /I NOT "%%~A" == "%SYSTEMROOT%\System32\Userinit.exe," (
			>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon
			>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
			CALL :RESETREG Userinit NULL BACKUP "HKLM_WinNT_Winlogon"
		)
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon (Userinit)
IF /I "%ARCHITECTURE%" == "x64" (
	TITLE 확인중 "HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon : Userinit" 2>Nul
	TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" >Nul 2>Nul
	IF %ERRORLEVEL% EQU 1 (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
		>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
		CALL :RESETREG Userinit NULL NULL NULL
	) ELSE (
		FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Userinit" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			IF /I NOT "%%~A" == "%SYSTEMROOT%\System32\Userinit.exe," (
				IF /I NOT "%%~A" == "Userinit.exe" (
					>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon
					>VARIABLE\TXT2 ECHO %MZKSYSTEMROOT%\System32\Userinit.exe,
					CALL :RESETREG Userinit NULL BACKUP "HKLM_WinNT_Winlogon(x86)"
				)
			)
		)
	)
)
REM :HKLM\Software\Policies\Google\Update (UpdateDefault)
TITLE 확인중 "HKLM\Software\Policies\Google\Update : UpdateDefault" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Policies\Google\Update\UpdateDefault" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "1" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Policies\Google\Update
		>VARIABLE\TXT2 ECHO 1
		CALL :RESETREG UpdateDefault REG_DWORD BACKUP "HKLM_PoliciesGoogleUpdate"
	)
)
REM :HKLM\Software\Wow6432Node\Policies\Google\Update (UpdateDefault)
TITLE 확인중 "HKLM\Software\Wow6432Node\Policies\Google\Update : UpdateDefault" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Policies\Google\Update\UpdateDefault" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF NOT "%%A" == "1" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Policies\Google\Update
		>VARIABLE\TXT2 ECHO 1
		CALL :RESETREG UpdateDefault REG_DWORD BACKUP "HKLM_PoliciesGoogleUpdate(x86)"
	)
)
REM :HKLM\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings (ProxySettingsPerUser)
TITLE 확인중 "HKLM\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings : ProxySettingsPerUser" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ProxySettingsPerUser" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings
		>VARIABLE\TXT2 ECHO DELETECOMMAND
		CALL :RESETREG ProxySettingsPerUser NULL BACKUP "HKLM_Policies_InternetSettings_ProxySettingsPerUser"
	)
)
REM :HKLM\Software\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings (ProxySettingsPerUser)
TITLE 확인중 "HKLM\Software\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings : ProxySettingsPerUser" 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings\ProxySettingsPerUser" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF "%%A" == "0" (
		>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings
		>VARIABLE\TXT2 ECHO DELETECOMMAND
		CALL :RESETREG ProxySettingsPerUser NULL BACKUP "HKLM_Policies_InternetSettings_ProxySettingsPerUser(x86)"
	)
)
REM :HKLM\System\CurrentControlSet\Services\6to4\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\6to4\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "6TO4SVC.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\6to4\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\6to4svc.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_6to4_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\AeLookupSvc\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\AeLookupSvc\ParametersServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "AELUPSVC.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\AeLookupSvc\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\aelupsvc.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_AeLookupSvc_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\Appinfo\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Appinfo\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "APPINFO.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\Appinfo\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\appinfo.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_Appinfo_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\AppMgmt\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\AppMgmt\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "APPMGMTS.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\AppMgmt\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\appmgmts.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_AppMgmt_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\BITS (Type)
FOR /F "TOKENS=3 DELIMS= " %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\BITS\Type" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%A" == "32" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\BITS
		>VARIABLE\TXT2 ECHO 32
		CALL :RESETREG Type REG_DWORD BACKUP "Services_BITS"
	)
)
REM :HKLM\System\CurrentControlSet\Services\BITS\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\BITS\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "QMGR.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\BITS\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\qmgr.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_BITS_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\Browser\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Browser\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "BROWSER.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\Browser\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\browser.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_Browser_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\dmserver\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\dmserver\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "DMSERVER.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\dmserver\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\dmserver.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_dmserver_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\DsmSvc\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\DsmSvc\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "DEVICESETUPMANAGER.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\DsmSvc\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\DeviceSetupManager.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_DsmSvc_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\FastUserSwitchingCompatibility\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\FastUserSwitchingCompatibility\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "SHSVCS.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\FastUserSwitchingCompatibility\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\shsvcs.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_FastUserSwitchingCompatibility_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\Ias\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Ias\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IAS.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\Ias\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\ias.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_Ias_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\IKEEXT\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\IKEEXT\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IKEEXT.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\IKEEXT\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\ikeext.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_IKEEXT_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\Irmon\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Irmon\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IRMON.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\Irmon\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\irmon.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_Irmon_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\MSiSCSI\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\MSiSCSI\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "ISCSIEXE.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\MSiSCSI\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\iscsiexe.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_MSiSCSI_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\NWCWorkstation\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\NWCWorkstation\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "NWWKS.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\NWCWorkstation\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\nwwks.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_NWCWorkstation_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ip (DllPath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ip\DllPath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IPRTRMGR.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ip
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\iprtrmgr.dll
		CALL :RESETREG DllPath REG_EXPAND_SZ BACKUP "Services_RemoteAccessRouterManagersIp_DllPath"
	)
)
REM :HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipv6 (DllPath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipv6\DllPath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IPRTRMGR.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipv6
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\iprtrmgr.dll
		CALL :RESETREG DllPath REG_EXPAND_SZ BACKUP "Services_RemoteAccessRouterManagersIpv6_DllPath"
	)
)
REM :HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipx (DllPath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipx\DllPath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "IPXRTMGR.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\RemoteAccess\RouterManagers\Ipx
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\ipxrtmgr.dll
		CALL :RESETREG DllPath REG_EXPAND_SZ BACKUP "Services_RemoteAccessRouterManagersIpx_DllPath"
	)
)
REM :HKLM\System\CurrentControlSet\Services\Schedule\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Schedule\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "SCHEDSVC.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\Schedule\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\schedsvc.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_Schedule_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\StiSvc\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\StiSvc\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "WIASERVC.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\StiSvc\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\wiaservc.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_StiSvc_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\SuperProServer (ImagePath)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\SuperProServer\ImagePath" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "SPNSRVNT.EXE" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\SuperProServer
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\spnsrvnt.exe
		CALL :RESETREG ImagePath REG_EXPAND_SZ BACKUP "Services_SuperProServer"
	)
)
REM :HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Winsock (HelperDllName)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Winsock\HelperDllName" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "WSHTCPIP.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Winsock
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\wshtcpip.dll
		CALL :RESETREG HelperDllName REG_EXPAND_SZ BACKUP "Services_Tcpip_ParamsWinsock"
	)
)
REM :HKLM\System\CurrentControlSet\Services\TermService\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\TermService\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "TERMSRV.DLL" (
		IF /I NOT "%%~nxA" == "RDPWRAP.DLL" (
			>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\TermService\Parameters
			>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\termsrv.dll
			CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_TermService_Params"
		)
	)
)
REM :HKLM\System\CurrentControlSet\Services\UxSms\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\UxSms\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "UXSMS.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\UxSms\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\uxsms.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_UxSms_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\Winmgmt\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Winmgmt\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "WMISVC.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\Winmgmt\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\wbem\WMIsvc.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_Winmgmt_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\WmdmPmSN\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\WmdmPmSN\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "MSPMSNSV.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\WmdmPmSN\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\mspmsnsv.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_WmdmPmSN_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\WmdmPmSp\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\WmdmPmSp\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "MSPMSPSV.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\WmdmPmSp\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\mspmspsv.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_WmdmPmSp_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\wuauserv\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\wuauserv\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "WUAUENG.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\wuauserv\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\wuaueng.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_wuauserv_Params"
	)
)
REM :HKLM\System\CurrentControlSet\Services\xmlprov\Parameters (ServiceDll)
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\xmlprov\Parameters\ServiceDll" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	IF /I NOT "%%~nxA" == "XMLPROV.DLL" (
		>VARIABLE\TXT1 ECHO HKLM\System\CurrentControlSet\Services\xmlprov\Parameters
		>VARIABLE\TXT2 ECHO %%SystemRoot%%\System32\xmlprov.dll
		CALL :RESETREG ServiceDll REG_EXPAND_SZ BACKUP "Services_xmlprov_Params"
	)
)
REG.EXE DELETE "HKLM\System\CurrentControlSet\Control\Session Manager" /v PendingFileRenameOperations /f >Nul 2>Nul
REM :Result
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\SRCH SET /P SRCH=
<VARIABLE\SUCC SET /P SUCC=
<VARIABLE\FAIL SET /P FAIL=
IF !SRCH! EQU 0 (
	ECHO    문제점이 발견되지 않았습니다. & >>"!QLog!" ECHO    문제점이 발견되지 않음
) ELSE (
	ECHO    발견: !SRCH! / 초기화: !SUCC! / 초기화 실패: !FAIL!
	>VARIABLE\XXYY ECHO 1
)
ENDLOCAL
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <Program Uninstall>
ECHO ◇ 악성 및 유해 가능 프로그램 설치 정보 레지스트리 제거중 . . . & >>"%QLog%" ECHO    ■ 악성 및 유해 가능 프로그램 설치 정보 레지스트리 제거 :
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall
SET "STRTMP=HKCU_Uninstall"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Microsoft\Windows\CurrentVersion\Uninstall\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\TXTX ECHO %%A^|
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_UNINSTALL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_UNINSTALL.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
SET "STRTMP=HKCU_Uninstall(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\TXTX ECHO %%A^|
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_UNINSTALL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_UNINSTALL.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall
SET "STRTMP=HKLM_Uninstall"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\TXTX ECHO %%A^|
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_UNINSTALL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_UNINSTALL.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
SET "STRTMP=HKLM_Uninstall(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\TXTX ECHO %%A^|
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_UNINSTALL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_UNINSTALL.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Uninstall
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Uninstall
SET "STRTMP=HKU_Uninstall"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Uninstall" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Uninstall\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\TXTX ECHO %%A^|
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_UNINSTALL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_UNINSTALL.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall
SET "STRTMP=HKU_Uninstall(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\%%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\TXTX ECHO %%A^|
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\REGISTRY\DEL_UNINSTALL.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_UNINSTALL.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Registry <Startup>
ECHO ◇ 악성 및 유해 가능 시작 프로그램 레지스트리 제거중 . . . & >>"%QLog%" ECHO    ■ 악성 및 유해 가능 시작 프로그램 레지스트리 제거 :
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Run
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Run
SET "STRTMP=HKCU_SoftwareRun"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "Run (HKCU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
SET "STRTMP=HKCU_SoftwareRun(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "Run (HKCU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce
SET "STRTMP=HKCU_SoftwareRunOnce"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunOnce (HKCU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
SET "STRTMP=HKCU_SoftwareRunOnce(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunOnce (HKCU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices
SET "STRTMP=HKCU_SoftwareRunServices"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunServices (HKCU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
SET "STRTMP=HKCU_SoftwareRunServices(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunServices (HKCU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
SET "STRTMP=HKCU_SoftwareRunServicesOnce"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunServicesOnce (HKCU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
SET "STRTMP=HKCU_SoftwareRunServicesOnce(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunServicesOnce (HKCU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
SET "STRTMP=HKCU_SoftwarePoliciesExplorerRun"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "Policies Run (HKCU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKCU\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
SET "STRTMP=HKCU_SoftwarePoliciesExplorerRun(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "Policies Run (HKCU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Shared Tools\MSConfig\startupreg
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Shared Tools\MSConfig\startupreg
SET "STRTMP=HKLM_SW_MSConfig_StartupReg"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Shared Tools\MSConfig\startupreg" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "Disable Run : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Shared Tools\MSConfig\startupreg\%%A\command" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
			SETLOCAL ENABLEDELAYEDEXPANSION
			<VARIABLE\CHCK SET /P CHCK=
			IF !CHCK! EQU 0 (
				ENDLOCAL
				>VARIABLE\TXTX ECHO %%B
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
			) ELSE (
				ENDLOCAL
			)
			SETLOCAL ENABLEDELAYEDEXPANSION
			<VARIABLE\CHCK SET /P CHCK=
			IF !CHCK! EQU 0 (
				ENDLOCAL
				>VARIABLE\TXTX ECHO %%B
				FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
			) ELSE (
				ENDLOCAL
			)
			SETLOCAL ENABLEDELAYEDEXPANSION
			<VARIABLE\CHCK SET /P CHCK=
			IF !CHCK! EQU 0 (
				ENDLOCAL
				IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
					>VARIABLE\TXTX ECHO "%%~dpnxB"
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
				) ELSE (
					ENDLOCAL
				)
			)
			SETLOCAL ENABLEDELAYEDEXPANSION
			<VARIABLE\CHCK SET /P CHCK=
			IF !CHCK! EQU 0 (
				ENDLOCAL
				IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
					>VARIABLE\TXTX ECHO "%%~dpB"
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGK ACTIVESCAN BACKUP "%STRTMP%"
				)
			) ELSE (
				ENDLOCAL
			)
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Run
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Run
SET "STRTMP=HKLM_SoftwareRun"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "Run (HKLM) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
SET "STRTMP=HKLM_SoftwareRun(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "Run (HKLM x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce
SET "STRTMP=HKLM_SoftwareRunOnce"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunOnce (HKLM) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
SET "STRTMP=HKLM_SoftwareRunOnce(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunOnce (HKLM x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices
SET "STRTMP=HKLM_SoftwareRunServices"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunServices (HKLM) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
SET "STRTMP=HKLM_SoftwareRunServices(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunServices (HKLM x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
SET "STRTMP=HKLM_SoftwareRunServicesOnce"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunServicesOnce (HKLM) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
SET "STRTMP=HKLM_SoftwareRunServicesOnce(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunServicesOnce (HKLM x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
SET "STRTMP=HKLM_SoftwarePoliciesExplorerRun"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "Policies Run (HKLM) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
SET "STRTMP=HKLM_SoftwarePoliciesExplorerRun(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "Policies Run (HKLM x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify
SET "STRTMP=HKLM_WinlogonNotify"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "Notify : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_WINLOGON_NOTIFY.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\TXT1 ECHO HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify
SET "STRTMP=HKLM_WinlogonNotify(x86)"
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\Software\Wow6432Node\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	TITLE 검사중 "Notify (x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_WINLOGON_NOTIFY.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGK NULL BACKUP "%STRTMP%"
)
REM :HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Run
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Run
SET "STRTMP=HKU_SoftwareRun"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "Run (HKU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Run
SET "STRTMP=HKU_SoftwareRun(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "Run (HKU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunOnce
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunOnce
SET "STRTMP=HKU_SoftwareRunOnce"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunOnce (HKU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunOnce
SET "STRTMP=HKU_SoftwareRunOnce(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunOnce (HKU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServices
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServices" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServices\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServices
SET "STRTMP=HKU_SoftwareRunServices"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunServices (HKU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServices
SET "STRTMP=HKU_SoftwareRunServices(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunServices (HKU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce
SET "STRTMP=HKU_SoftwareRunServicesOnce"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunServicesOnce (HKU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\RunServicesOnce
SET "STRTMP=HKU_SoftwareRunServicesOnce(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "RunServicesOnce (HKU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -if DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_RUNONCE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
SET "STRTMP=HKU_SoftwarePoliciesExplorerRun"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "Policies Run (HKU) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
>VARIABLE\RGST ECHO.
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -silent >Nul 2>Nul
TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" -ot reg -actn setprot -op "dacl:np;sacl:np" -actn clear -clr "dacl,sacl" -actn setowner -ownr "n:SYSTEM" -rec yes -silent >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -l -q list "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	FOR /F "DELIMS=" %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run\%%A" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO >>VARIABLE\RGST ECHO %%A¶%%B
)
>VARIABLE\TXT1 ECHO HKU\.Default\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run
SET "STRTMP=HKU_SoftwarePoliciesExplorerRun(x86)"
FOR /F "TOKENS=1,2 DELIMS=¶" %%A IN (VARIABLE\RGST) DO (
	TITLE 검사중 "Policies Run (HKU x86) : %%A" 2>Nul
	>VARIABLE\TXT2 ECHO %%A
	>VARIABLE\CHCK ECHO 0
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\REGDEL_AUTORUN.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV NULL BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_NAME.DB VARIABLE\TXT2 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -ixf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		>VARIABLE\TXTX ECHO %%B
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\REGISTRY\PATTERN_AUTORUN_FILE_CASE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_FILE.DB (
			>VARIABLE\TXTX ECHO "%%~dpnxB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_FILE.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
	SETLOCAL ENABLEDELAYEDEXPANSION
	<VARIABLE\CHCK SET /P CHCK=
	IF !CHCK! EQU 0 (
		ENDLOCAL
		IF EXIST DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB (
			>VARIABLE\TXTX ECHO "%%~dpB"
			FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB VARIABLE\TXTX 2^>Nul') DO CALL :DEL_REGV ACTIVESCAN BACKUP NULL "%STRTMP%"
		)
	) ELSE (
		ENDLOCAL
	)
)
REM :Result
CALL :P_RESULT NULL CHKINFECT
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Repository Salvage Windows Management Instrumentation
ECHO ◇ 관리 도구 리포지토리 복구중 . . .
TITLE ^(복구중^) 잠시만 기다려주세요 . . . 2>Nul
WINMGMT.EXE /SALVAGEREPOSITORY >Nul 2>Nul
ECHO    완료되었습니다.

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO.

REM * Repair Service
<VARIABLE\XXXX SET /P XXXX=
IF %XXXX% EQU 1 (
	ECHO ◇ 악성코드에 의해 비활성화된 서비스 확인중 . . .
	FOR /F "TOKENS=1,2 DELIMS=|" %%A IN (DB_EXEC\REPAIR_SERVICE.DB) DO (
		IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
			TITLE 확인중 "%%A" 2>Nul
			SC.EXE CONFIG "%%A" START= %%B >Nul 2>Nul
		)
	)
	ECHO    완료되었습니다.
	PING.EXE -n 2 0 >Nul 2>Nul
	ECHO.
)

REM * Reset Network DNS Address <#2>
ECHO ◇ 네트워크 DNS 주소 상태 확인중 - 2차 . . . & >>"%QLog%" ECHO    ■ 네트워크 DNS 주소 상태 확인 - 2차 :
TITLE ^(확인중^) 잠시만 기다려주세요 . . . 2>Nul
FOR /F "DELIMS=" %%A IN ('TOOLS\REGTOOL\REGTOOL.EXE -K / -w -k -q list "\HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	>VARIABLE\TXT1 ECHO %%A
	FOR /F "TOKENS=1,2 DELIMS=," %%B IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\%%A\NameServer" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
		IF NOT "%%B" == "" (
			IF NOT "%%C" == "" (
				>VARIABLE\TXT2 ECHO %%B^|%%C
				>VARIABLE\TXTX ECHO %%B,%%C
				IF "%%B" == "%%C" (
					CALL :RESETDNS
				) ELSE (
					>VARIABLE\CHCK ECHO 0
					SETLOCAL ENABLEDELAYEDEXPANSION
					<VARIABLE\CHCK SET /P CHCK=
					IF !CHCK! EQU 0 (
						ENDLOCAL
						FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\NETWORK\DEL_DNS_ADDRESS.DB VARIABLE\TXTX 2^>Nul') DO CALL :RESETDNS
					) ELSE (
						ENDLOCAL
					)
					SETLOCAL ENABLEDELAYEDEXPANSION
					<VARIABLE\CHCK SET /P CHCK=
					IF !CHCK! EQU 0 (
						ENDLOCAL
						FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\NETWORK\PATTERN_DNS_ADDRESS.DB VARIABLE\TXTX 2^>Nul') DO CALL :RESETDNS
					) ELSE (
						ENDLOCAL
					)
				)
			) ELSE (
				>VARIABLE\TXT2 ECHO %%B
				>VARIABLE\CHCK ECHO 0
				SETLOCAL ENABLEDELAYEDEXPANSION
				<VARIABLE\CHCK SET /P CHCK=
				IF !CHCK! EQU 0 (
					ENDLOCAL
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixf DB_EXEC\THREAT\NETWORK\DEL_DNS_ADDRESS.DB VARIABLE\TXT2 2^>Nul') DO CALL :RESETDNS
				) ELSE (
					ENDLOCAL
				)
				SETLOCAL ENABLEDELAYEDEXPANSION
				<VARIABLE\CHCK SET /P CHCK=
				IF !CHCK! EQU 0 (
					ENDLOCAL
					FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -xf DB_EXEC\ACTIVESCAN\NETWORK\PATTERN_DNS_ADDRESS.DB VARIABLE\TXT2 2^>Nul') DO CALL :RESETDNS
				) ELSE (
					ENDLOCAL
				)
			)
		)
	)
)
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\CHCK SET /P CHCK=
IF !CHCK! EQU 0 (
	ECHO    문제점이 발견되지 않았습니다. & >>"%QLog%" ECHO    문제점이 발견되지 않음
) ELSE (
	>VARIABLE\XXYY ECHO 1
)
ENDLOCAL
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Check - Required System Files <#2>
ECHO ◇ 필수 시스템 파일 확인중 - 2차 . . . & >>"%QLog%" ECHO    ■ 필수 시스템 파일 확인 - 2차 :
FOR /F "TOKENS=1,2,3 DELIMS=|" %%A IN (DB_EXEC\CHECK\CHK_SYSTEMFILE.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ LINE ENDED ~~~~~~~~~~" (
		IF EXIST "DB_EXEC\MD5CHK\CHK_MD5_%%A.DB" (
			>VARIABLE\TXT2 ECHO %%A
			TITLE 확인중 "%%A" 2>Nul
			IF %%B EQU 1 (
				>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%
				CALL :CHK_SYSX
			) ELSE (
				IF %%C EQU 1 (
					IF /I "%ARCHITECTURE%" == "x64" (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64
					) ELSE (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32
					)
					CALL :CHK_SYSX
				) ELSE (
					IF /I "%ARCHITECTURE%" == "x64" (
						>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\SysWOW64
						CALL :CHK_SYSX
					)
					>VARIABLE\TXT1 ECHO %MZKSYSTEMROOT%\System32
					CALL :CHK_SYSX
				)
			)
		)
	)
)
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\SRCH SET /P SRCH=
<VARIABLE\FAIL SET /P FAIL=
IF !SRCH! EQU 0 (
	ECHO    문제점이 발견되지 않았습니다. & >>"%QLog%" ECHO    문제점이 발견되지 않음
) ELSE (
	>VARIABLE\XXYY ECHO 1
	IF !FAIL! EQU 1 (
		ECHO. & >>"!QLog!" ECHO.
		ECHO    ⓘ 상세 진단 기록 확인 후 ^<3. 문제 해결^> 문서 ^<문제 13^> 항목 참고 & >>"!QLog!" ECHO    ⓘ ^<3. 문제 해결^> 문서 ^<문제 13^> 항목 참고
	)
)
ENDLOCAL
REM :Reset Value
CALL :RESETVAL

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO. & >>"%QLog%" ECHO.

REM * Delete - Temporary & Cache Files #2
ECHO ◇ 임시 파일/폴더 정리중 - 2차 . . .
TITLE ^(정리중^) 잠시만 기다려주세요 ^(시간이 다소 소요될 수 있음^) . . . 2>Nul
DEL /F /Q /S /A "%SYSTEMROOT%\Temp" >Nul 2>Nul
DEL /F /Q /S /A "%APPDATA%\Temp" >Nul 2>Nul
DEL /F /Q /S /A "%TEMP%" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMDRIVE%\*.TEMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMDRIVE%\*.TMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\*.TEMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\*.TMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\System\*.TEMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\System\*.TMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\System32\*.TMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\System32\*.TEMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\SysWOW64\*.TMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\SysWOW64\*.TEMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\System32\Drivers\*.TEMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\System32\Drivers\*.TMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\SysWOW64\Drivers\*.TEMP" >Nul 2>Nul
DEL /F /Q /A "%SYSTEMROOT%\SysWOW64\Drivers\*.TMP" >Nul 2>Nul
FOR /F "DELIMS=" %%A IN (DB_EXEC\CHECK\CHK_PROCESSKILL_BROWSER.DB) DO (
	IF /I NOT "%%A" == "~~~~~~~~~~ MZK CHECK CHK_PROCESSKILL_BROWSER.DB ~~~~~~~~~~" TOOLS\TASKS\TASKKILL.EXE /F /IM "%%A" >Nul 2>Nul
)
DEL /F /Q /A "%LOCALAPPDATA%\Chromium\User Data\Default\Application Cache\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\Chromium\User Data\Default\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Application Cache\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\COMODO\Dragon\User Data\Default\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Application Cache\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Application Cache\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\Google\Chrome SxS\User Data\Default\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Application Cache\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\MapleStudio\ChromePlus\User Data\Default\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\SwingBrowser\User Data\Default\Application Cache\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\SwingBrowser\User Data\Default\Cache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\Steam\htmlcache\*" >Nul 2>Nul
DEL /F /Q /A "%LOCALAPPDATA%\Opera Software\Opera Stable\Cache\*" >Nul 2>Nul
FOR /F "DELIMS=" %%A IN ('DIR /B /AD "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\" 2^>Nul') DO (
	DEL /F /Q /A "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\%%A\Cache\Entries\*" >Nul 2>Nul
	DEL /F /Q /A "%LOCALAPPDATA%\Mozilla\Firefox\Profiles\%%A\Cache2\Entries\*" >Nul 2>Nul
)
IF EXIST "%SYSTEMROOT%\System32\InetCpl.cpl" (
	RUNDLL32.EXE InetCpl.cpl,ClearMyTracksByProcess 4 >Nul 2>Nul
)
ECHO    완료되었습니다.

TITLE %MZKTITLE% 2>Nul & PING.EXE -n 2 0 >Nul 2>Nul & ECHO.

REM * Reset - Restart DNS Client Service
SETLOCAL ENABLEDELAYEDEXPANSION
SC.EXE STOP DNSCACHE >Nul 2>Nul
IF !ERRORLEVEL! NEQ 1062 (
	IF !ERRORLEVEL! EQU 0 (
		PING.EXE -n 2 0 >Nul 2>Nul
		IPCONFIG.EXE /FLUSHDNS >Nul 2>Nul
		SC.EXE START DNSCACHE >Nul 2>Nul
	)
)
ENDLOCAL

<VARIABLE\XXXX SET /P XXXX=
<VARIABLE\XXYY SET /P XXYY=
IF %XXXX% EQU 0 (
	IF %XXYY% EQU 0 (
		COLOR 2F
	) ELSE (
		COLOR 6F
	)
)

REM * Reset - Count Value (All)
CALL :RESETVAL ALL

TOOLS\SETACL\%ARCHITECTURE%\SETACL.EXE -on "%QFolders%" -ot file -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul

RMDIR "%QRoot%\Files\%RPTDATE%" /Q >Nul 2>Nul
RMDIR "%QRoot%\Folders\%RPTDATE%" /Q >Nul 2>Nul
RMDIR "%QRoot%\Registrys\%RPTDATE%" /Q >Nul 2>Nul

REM * Finished
ECHO =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
ECHO.
ECHO ◆ 검사 완료되었습니다 . . .

COPY /Y "Malware Zero Kit - Virus Zero Season 2.html" "%USERPROFILE%\Desktop\" >Nul 2>Nul

>>"%QLog%" ECHO -- 정보 --
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    Virus Zero Season 2 : http://cafe.naver.com/malzero
>>"%QLog%" ECHO    Batch Script : ViOLeT ^(archguru^)
>>"%QLog%" ECHO.
>>"%QLog%" ECHO    경고 ^! 타 사이트/카페/블로그/토렌트 등에서 배포/개작 및 상업적 이용 절대 금지 ^! ^(발견시 신고 요망^)
>>"%QLog%" ECHO.
>>"%QLog%" ECHO -- E --

IF %VK% EQU 1 START TOOLS\MAGNETOK\MAGNETOK.EXE >Nul 2>Nul

GOTO END

:FAILED
ECHO ⓘ 오류: 실행 권한 없음 ^(관리자 권한으로 실행 필수^)
ECHO.
ECHO → 해결: 실행 파일 선택 후 마우스 오른쪽 버튼을 클릭하여 "관리자 권한으로 실행" 항목 클릭
GOTO END

:NOFILE
ECHO ⓘ 오류: 필수 파일이 존재하지 않거나 압축된 상태로 실행
ECHO.
ECHO → 해결: 동봉되어 있는 ^<3. 문제 해결^> 문서 ^<문제 02^> 항목 참고
GOTO END

:NOSYSF
ECHO ⓘ 오류: 시스템 파일이 존재하지 않음 ^(원인 파일: "%STRTMP%"^) & GOTO END

:FAILEDOS
ECHO ⓘ 오류: 지원하지 않는 운영체제
ECHO.
ECHO → 현재 지원 중인 운영체제: Microsoft Windows Vista, 7, 2008, 8, 2012, 10
GOTO END

:NOVAR
ECHO ⓘ 오류: 필수 환경 변수가 존재하지 않거나 올바르지 않음
ECHO.
ECHO → 해결: 환경 변수 설정 점검
GOTO END

:MALWARE
ECHO ⓘ 오류: 악성코드에 의한 실행 방해
ECHO.
ECHO → 해결: 동봉되어 있는 ^<3. 문제 해결^> 문서 ^<문제 09^> 항목 참고
GOTO END

:REGBLOCK
ECHO ⓘ 오류: 레지스트리 편집 권한 없음
ECHO.
ECHO → 해결: 동봉되어 있는 ^<3. 문제 해결^> 문서 ^<문제 02^> 항목 참고
GOTO END

:NOCOUNT
ECHO ⓘ 오류: 데이터베이스 파일 구성이 일치하지 않음 ^(또는 실행 파일 변조^)
ECHO.
ECHO → 해결: 기존에 압축 해제한 스크립트 파일 및 폴더 전체 삭제 후 새로 압축 해제 및 실행
ECHO          문제가 지속될 경우 ^<3. 문제 해결^> 문서 ^<문제 02^> 항목 참고
GOTO END

:CHK_SYSF
SETLOCAL ENABLEDELAYEDEXPANSION
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF NOT EXIST "!TXT1!\!TXT2!" (
	>VARIABLE\SRCH ECHO 1
	TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
	FOR /F "TOKENS=1,* DELIMS=," %%A IN ('TOOLS\HASHDEEP\!MD5CHK!.EXE -c -s "!TXT1!\*" 2^>Nul') DO (
		TITLE 확인중 "!TXT2!" ^(원본 탐색중^) "%%B" 2>Nul
		FOR /F %%X IN ('TOOLS\GREP\GREP.EXE -Fixe "%%A" DB_EXEC\MD5CHK\CHK_MD5_!TXT2!.DB 2^>Nul') DO (
			REN "!TXT1!\%%~nxB" "!TXT2!" >Nul 2>Nul
			IF EXIST "!TXT1!\!TXT2!" (
				ECHO    "!TXT2!" 파일 복원 ^(위치: "!TXT1!"^) & >>"!QLog!" ECHO    "!TXT2!" 파일 복원 ^(위치: "!TXT1!"^)
			)
		)
	)
	IF NOT EXIST "!TXT1!\!TXT2!" (
		COLOR 4F
		ECHO    "!TXT2!" 파일이 존재하지 않음 ^(위치: "!TXT1!"^) & >>"!QLog!" ECHO    "!TXT2!" 파일이 존재하지 않음 ^(위치: "!TXT1!"^)
	)
)
ENDLOCAL
GOTO :EOF

:CHK_SYSX
SETLOCAL ENABLEDELAYEDEXPANSION
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF EXIST "!TXT1!\!TXT2!" (
	FOR /F "TOKENS=1" %%A IN ('TOOLS\HASHDEEP\!MD5CHK!.EXE -s -q "!TXT1!\!TXT2!" 2^>Nul') DO (
		FOR /F %%X IN ('ECHO %%A^|TOOLS\GREP\GREP.EXE -Fivxf DB_EXEC\MD5CHK\CHK_MD5_!TXT2!.DB 2^>Nul') DO (
			TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
			>VARIABLE\SRCH ECHO 1
			FOR /F "TOKENS=1,* DELIMS=," %%B IN ('TOOLS\HASHDEEP\!MD5CHK!.EXE -c -s "!TXT1!\*" 2^>Nul') DO (
				<VARIABLE\SUCC SET /P SUCC=
				IF !SUCC! EQU 0 (
					TITLE 확인중 "!TXT2!" ^(원본 탐색중^) "%%C" 2>Nul
					FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\MD5CHK\CHK_MD5_!TXT2!.DB 2^>Nul') DO (
						REN "!TXT1!\!TXT2!" "!TXT2!.!TIME::=.!.infected" >Nul 2>Nul
						REN "!TXT1!\%%~nxC" "!TXT2!" >Nul 2>Nul
						IF !ERRORLEVEL! EQU 0 >VARIABLE\SUCC ECHO 1
					)
				)
			)
			<VARIABLE\SUCC SET /P SUCC=
			IF !SUCC! EQU 0 (
				TITLE ^(캐싱중^) 잠시만 기다려주세요 . . . 2>Nul
				FOR /F "TOKENS=1,* DELIMS=," %%B IN ('TOOLS\HASHDEEP\!MD5CHK!.EXE -c -s "!TEMP!\*" 2^>Nul') DO (
					<VARIABLE\SUCC SET /P SUCC=
					IF !SUCC! EQU 0 (
						TITLE 확인중 "!TXT2!" ^(원본 탐색중^) "%%C" 2>Nul
						FOR /F %%Y IN ('TOOLS\GREP\GREP.EXE -Fixe "%%B" DB_EXEC\MD5CHK\CHK_MD5_!TXT2!.DB 2^>Nul') DO (
							REN "!TXT1!\!TXT2!" "!TXT2!.!TIME::=.!.infected" >Nul 2>Nul
							COPY /Y "!TEMP!\%%~nxC" "!TXT1!\!TXT2!" >Nul 2>Nul
							IF !ERRORLEVEL! EQU 0 >VARIABLE\SUCC ECHO 1
						)
					)
				)
			)
			<VARIABLE\SUCC SET /P SUCC=
			IF !SUCC! EQU 1 (
				ECHO    "!TXT2!" 파일 복원 ^(위치: "!TXT1!"^) & >>"!QLog!" ECHO    "!TXT2!" 파일 복원 ^(위치: "!TXT1!"^)
			) ELSE (
				>VARIABLE\FAIL ECHO 1
				ECHO    "!TXT2!" 파일 확인 필요 ^(위치: "!TXT1!"^) & >>"!QLog!" ECHO    "!TXT2!" 파일 확인 필요 ^(위치: "!TXT1!"^) ^[MD5:%%A^]
			)
			>VARIABLE\SUCC ECHO 0
		)
	)
)
ENDLOCAL
GOTO :EOF

:DEL_SVC
SETLOCAL ENABLEDELAYEDEXPANSION
>VARIABLE\CHCK ECHO 1
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
SET "TXT1=!TXT1:"=\"!"
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
SET "TXT2TXT=!TXT2!"
SET "TXT2=!TXT2:"=\"!"
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF "%~1" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~2" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~3" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF /I "%~1" == "ACTIVESCAN" (
	SET ACTIVESCAN=1
) ELSE (
	SET ACTIVESCAN=0
)
IF /I "%~2" == "BACKUP" (
	IF /I NOT "%~3" == "NULL" (
		IF NOT EXIST "!QRegistrys!\Services%~3_!TIME::=.!_!RANDOM!.reg" (
			REG.EXE EXPORT "!TXT1!\!TXT2!" "!QRegistrys!\%~3_!TIME::=.!_!RANDOM!.reg" /y >Nul 2>Nul
		)
	)
)
TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT2!" -ot srv -actn trustee -trst "n1:Everyone;ta:remtrst;w:dacl" -actn ace -ace "n:Everyone;p:full" -ace "n:Administrators;p:full" -silent >Nul 2>Nul
SC.EXE CONFIG "!TXT2!" START= DISABLED >Nul 2>Nul
SC.EXE STOP "!TXT2!" >Nul 2>Nul
IF !ERRORLEVEL! NEQ 1060 (
	IF !ERRORLEVEL! NEQ 0 (
		IF !ERRORLEVEL! NEQ 1062 (
			>VARIABLE\CHCK ECHO 2
		)
	)
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
SC.EXE DELETE "!TXT2!" >Nul 2>Nul
IF !ERRORLEVEL! EQU 0 (
	REG.EXE DELETE "HKLM\System\CurrentControlSet\Services\!TXT2!" /f >Nul 2>Nul
	<VARIABLE\CHCK SET /P CHCK=
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	IF !CHCK! LEQ 1 (
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(격리/제거 성공 ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(격리/제거 성공^)
		)
	) ELSE (
		<VARIABLE\RECK SET /P RECK=
		SET /A RECK+=1
		>VARIABLE\RECK ECHO !RECK!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(격리/제거 성공 - 재부팅 후 제거됨 ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(격리/제거 성공 - 재부팅 후 제거됨^)
		)
	)
) ELSE (
	REG.EXE DELETE "HKLM\System\CurrentControlSet\Services\!TXT2!" /f >Nul 2>Nul
	IF !ERRORLEVEL! EQU 0 (
		<VARIABLE\SUCC SET /P SUCC=
		SET /A SUCC+=1
		>VARIABLE\SUCC ECHO !SUCC!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(격리/제거 성공 ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(격리/제거 성공^)
		)
	) ELSE (
		<VARIABLE\FAIL SET /P FAIL=
		SET /A FAIL+=1
		>VARIABLE\FAIL ECHO !FAIL!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(제거 실패 ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT2TXT!" ^(제거 실패^)
		)
	)
)
ENDLOCAL
GOTO :EOF

:DEL_BITS
SETLOCAL ENABLEDELAYEDEXPANSION
>VARIABLE\CHCK ECHO 1
IF "%~1" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~2" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF /I "%1" == "ACTIVESCAN" (
	SET ACTIVESCAN=1
) ELSE (
	SET ACTIVESCAN=0
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
BITSADMIN.EXE /CANCEL "%~2" >Nul 2>Nul
IF !ERRORLEVEL! EQU 0 (
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	IF !ACTIVESCAN! EQU 1 (
		>>"!QLog!" ECHO    "%~2" ^(제거 성공 ^[Active Scan^]^)
	) ELSE (
		>>"!QLog!" ECHO    "%~2" ^(제거 성공^)
	)
) ELSE (
	<VARIABLE\FAIL SET /P FAIL=
	SET /A FAIL+=1
	>VARIABLE\FAIL ECHO !FAIL!
	IF !ACTIVESCAN! EQU 1 (
		>>"!QLog!" ECHO    "%~2" ^(제거 실패 ^[Active Scan^]^)
	) ELSE (
		>>"!QLog!" ECHO    "%~2" ^(제거 실패^)
	)
)
ENDLOCAL
GOTO :EOF

:DEL_FILE
SETLOCAL ENABLEDELAYEDEXPANSION
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF /I "%1" == "ACTIVESCAN" (
	SET ACTIVESCAN=1
) ELSE (
	SET ACTIVESCAN=0
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!!TXT2!" -ot file -actn setowner -ownr "n:Administrators" -rec obj -silent >Nul 2>Nul
TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!!TXT2!" -ot file -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -actn ace -ace "n:Administrators;p:full" -rec obj -silent >Nul 2>Nul
ATTRIB.EXE -R -H -S "!TXT1!!TXT2!" >Nul 2>Nul
COPY /Y "!TXT1!!TXT2!" "!QFiles!\!TXT2!.!TIME::=.!.vz" >Nul 2>Nul
DEL /F /Q /A "!TXT1!!TXT2!" >Nul 2>Nul
IF NOT EXIST "!TXT1!!TXT2!" (
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	IF !ACTIVESCAN! EQU 1 (
		>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(격리/제거 성공 ^[Active Scan^]^)
	) ELSE (
		>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(격리/제거 성공^)
	)
) ELSE (
	REN "!TXT1!!TXT2!" "!TXT2!.vz" >Nul 2>Nul
	IF NOT EXIST "!TXT1!!TXT2!" (
		<VARIABLE\SUCC SET /P SUCC=
		SET /A SUCC+=1
		>VARIABLE\SUCC ECHO !SUCC!
		<VARIABLE\RECK SET /P RECK=
		SET /A RECK+=1
		>VARIABLE\RECK ECHO !RECK!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(임시 제거 - 재부팅 후 재검사 필요 ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(임시 제거 - 재부팅 후 재검사 필요^)
		)
	) ELSE (
		<VARIABLE\FAIL SET /P FAIL=
		SET /A FAIL+=1
		>VARIABLE\FAIL ECHO !FAIL!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(제거 실패 ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(제거 실패^)
		)
	)
)
>>DB_ACTIVE\ACT_AUTORUN_FILE.DB ECHO "!TXT1!!TXT2!"
ENDLOCAL
GOTO :EOF

:DEL_DIRT
SETLOCAL ENABLEDELAYEDEXPANSION
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF /I "%1" == "ACTIVESCAN" (
	SET ACTIVESCAN=1
) ELSE (
	SET ACTIVESCAN=0
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!!TXT2!" -ot file -actn setowner -ownr "n:Administrators" -rec cont_obj -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul
TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!!TXT2!" -ot file -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -actn ace -ace "n:Administrators;p:full" -rec cont_obj -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul
ATTRIB.EXE -R -H -S "!TXT1!!TXT2!" >Nul 2>Nul
ATTRIB.EXE -R -H -S "!TXT1!!TXT2!\*" /S /D >Nul 2>Nul
XCOPY.EXE "!TXT1!!TXT2!" "!QFolders!\!TXT2!.!TIME::=.!" /S /E /C /I /Q /H /R /Y >Nul 2>Nul
IF !ERRORLEVEL! EQU 0 RMDIR "!TXT1!!TXT2!" /S /Q >Nul 2>Nul
IF NOT EXIST "!TXT1!!TXT2!\" (
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	IF !ACTIVESCAN! EQU 1 (
		>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(격리/제거 성공 ^[Active Scan^]^)
	) ELSE (
		>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(격리/제거 성공^)
	)
) ELSE (
	<VARIABLE\FAIL SET /P FAIL=
	SET /A FAIL+=1
	>VARIABLE\FAIL ECHO !FAIL!
	IF !ACTIVESCAN! EQU 1 (
		>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(제거 실패 ^[Active Scan^]^)
	) ELSE (
		>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(제거 실패^)
	)
)
>>DB_ACTIVE\ACT_AUTORUN_DIRECTORY.DB ECHO "!TXT1!!TXT2!\"
ENDLOCAL
GOTO :EOF

:DEL_REGK
SETLOCAL ENABLEDELAYEDEXPANSION
>VARIABLE\CHCK ECHO 1
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
SET "TXT1TXT=!TXT1!"
SET "TXT1=!TXT1:"=\"!"
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
SET "TXT2TXT=!TXT2!"
SET "TXT2=!TXT2:"=\"!"
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF "%~1" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~2" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~3" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF /I "%~1" == "ACTIVESCAN" (
	SET ACTIVESCAN=1
) ELSE (
	SET ACTIVESCAN=0
)
IF /I "%~2" == "BACKUP" (
	IF /I NOT "%~3" == "NULL" (
		IF NOT EXIST "!QRegistrys!\%~3_!TIME::=.!_!RANDOM!.reg" (
			REG.EXE EXPORT "!TXT1!\!TXT2!" "!QRegistrys!\%~3_!TIME::=.!_!RANDOM!.reg" /y >Nul 2>Nul
		)
	)
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
REG.EXE DELETE "!TXT1!\!TXT2!" /f >Nul 2>Nul
IF !ERRORLEVEL! EQU 0 (
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	IF !ACTIVESCAN! EQU 1 (
		>>"!QLog!" ECHO    "!TXT1TXT!\!TXT2TXT!" ^(격리/제거 성공 ^[Active Scan^]^)
	) ELSE (
		>>"!QLog!" ECHO    "!TXT1TXT!\!TXT2TXT!" ^(격리/제거 성공^)
	)
) ELSE (
	TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!\!TXT2!" -ot reg -actn setowner -ownr "n:Administrators" -rec yes -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul
	TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!\!TXT2!" -ot reg -actn clear -clr "dacl,sacl" -actn setprot -op "dacl:np;sacl:np" -rec yes -actn ace -ace "n:Administrators;p:full" -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul
	REG.EXE DELETE "!TXT1!\!TXT2!" /f >Nul 2>Nul
	IF !ERRORLEVEL! EQU 0 (
		<VARIABLE\SUCC SET /P SUCC=
		SET /A SUCC+=1
		>VARIABLE\SUCC ECHO !SUCC!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT1TXT!\!TXT2TXT!" ^(격리/제거 성공 ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT1TXT!\!TXT2TXT!" ^(격리/제거 성공^)
		)
	) ELSE (
		<VARIABLE\FAIL SET /P FAIL=
		SET /A FAIL+=1
		>VARIABLE\FAIL ECHO !FAIL!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT1TXT!\!TXT2TXT!" ^(제거 실패 ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT1TXT!\!TXT2TXT!" ^(제거 실패^)
		)
	)
)
ENDLOCAL
GOTO :EOF

:DEL_REGV
SETLOCAL ENABLEDELAYEDEXPANSION
>VARIABLE\CHCK ECHO 1
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
SET "TXT1TXT=!TXT1!"
SET "TXT1=!TXT1:"=\"!"
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
SET "TXT2TXT=!TXT2!"
SET "TXT2=!TXT2:"=\"!"
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF "%~1" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~2" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~3" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~4" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF /I "%~1" == "ACTIVESCAN" (
	SET ACTIVESCAN=1
) ELSE (
	SET ACTIVESCAN=0
)
IF /I "%~2" == "BACKUP" (
	IF /I NOT "%~4" == "NULL" (
		IF /I "%~3" == "RANDOM" (
			IF NOT EXIST "!QRegistrys!\%~4_!TIME::=.!_!RANDOM!.reg" (
				REG.EXE EXPORT "!TXT1!" "!QRegistrys!\%~4_!TIME::=.!_!RANDOM!.reg" /y >Nul 2>Nul
			)
		) ELSE (
			IF NOT EXIST "!QRegistrys!\%~4.reg" (
				REG.EXE EXPORT "!TXT1!" "!QRegistrys!\%~4.reg" /y >Nul 2>Nul
			)
		)
	)
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
REG.EXE DELETE "!TXT1!" /v "!TXT2!" /f >Nul 2>Nul
IF !ERRORLEVEL! EQU 0 (
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	IF !ACTIVESCAN! EQU 1 (
		>>"!QLog!" ECHO    "!TXT1TXT! : !TXT2TXT!" ^(격리/제거 성공 ^[Active Scan^]^)
	) ELSE (
		>>"!QLog!" ECHO    "!TXT1TXT! : !TXT2TXT!" ^(격리/제거 성공^)
	)
) ELSE (
	>VARIABLE\DENY ECHO.
	FOR /F "DELIMS=" %%V IN ('TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!" -ot reg -actn list -lst f:tab 2^>Nul^|TOOLS\GREP\GREP.EXE [[:space:]]\{3\}deny[[:space:]]\{3\} 2^>Nul') DO (
		SET "DENY=%%V"
		SET "DENY=!DENY:   =¶!"
		>>VARIABLE\DENY ECHO !DENY!
	)
	FOR /F "TOKENS=1,2 DELIMS=¶" %%V IN (VARIABLE\DENY) DO (
		TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!" -ot reg -actn trustee -trst "n1:%%V;ta:remtrst;w:dacl" -silent >Nul 2>Nul
	)
	REG.EXE DELETE "!TXT1!" /v "!TXT2!" /f >Nul 2>Nul
	IF !ERRORLEVEL! EQU 0 (
		<VARIABLE\SUCC SET /P SUCC=
		SET /A SUCC+=1
		>VARIABLE\SUCC ECHO !SUCC!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT1TXT! : !TXT2TXT!" ^(격리/제거 성공 ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT1TXT! : !TXT2TXT!" ^(격리/제거 성공^)
		)
	) ELSE (
		<VARIABLE\FAIL SET /P FAIL=
		SET /A FAIL+=1
		>VARIABLE\FAIL ECHO !FAIL!
		IF !ACTIVESCAN! EQU 1 (
			>>"!QLog!" ECHO    "!TXT1TXT! : !TXT2TXT!" ^(제거 실패 ^[Active Scan^]^)
		) ELSE (
			>>"!QLog!" ECHO    "!TXT1TXT! : !TXT2TXT!" ^(제거 실패^)
		)
	)
)
ENDLOCAL
GOTO :EOF

:RESETDNS
SETLOCAL ENABLEDELAYEDEXPANSION
>VARIABLE\CHCK ECHO 1
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
SET "TXT1TXT=!TXT1!"
SET "TXT1=!TXT1:"=\"!"
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
REG.EXE ADD "HKLM\System\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\!TXT1!" /v "NameServer" /d "" /f >Nul 2>Nul
IF !ERRORLEVEL! EQU 0 (
	IPCONFIG.EXE /REGISTERDNS >Nul 2>Nul & IPCONFIG.EXE /FLUSHDNS >Nul 2>Nul
	FOR /F "TOKENS=1,2 DELIMS=|" %%V IN ("!TXT2!") DO (
		IF NOT "%%V" == "" (
			IF NOT "%%W" == "" (
				ECHO    비정상 값이 발견되어 초기화 진행 ^[ Pri: %%V, Sec: %%W ^] & >>"!QLog!" ECHO    비정상 값이 발견되어 초기화 진행 ^[ Primary: %%V, Secondary: %%W, !TXT1TXT! ^]
			) ELSE (
				ECHO    비정상 값이 발견되어 초기화 진행 ^[ Pri: %%V ^] & >>"!QLog!" ECHO    비정상 값이 발견되어 초기화 진행 ^[ Primary: %%V, !TXT1TXT! ^]
			)
		)
	)
) ELSE (
	ECHO    비정상 값이 발견되어 초기화를 진행하였으나 오류가 발생했습니다. & >>"!QLog!" ECHO    비정상 값이 발견되어 초기화 진행 ^(실패 - 오류 발생^)
)
ENDLOCAL
GOTO :EOF

:RESETCUT
SETLOCAL ENABLEDELAYEDEXPANSION
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
ATTRIB.EXE -R -H -S "!TXT1!!TXT2!" >Nul 2>Nul
COPY /Y "!TXT1!!TXT2!" "!QFiles!\!TXT2!.!TIME::=.!.vz" >Nul 2>Nul
TOOLS\SHORTCUT\SHORTCUT.EXE /A:E /F:"!TXT1!!TXT2!" /P:"" >Nul 2>Nul
IF !ERRORLEVEL! EQU 0 (
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(초기화 성공^)
) ELSE (
	<VARIABLE\FAIL SET /P FAIL=
	SET /A FAIL+=1
	>VARIABLE\FAIL ECHO !FAIL!
	>>"!QLog!" ECHO    "!TXT1!!TXT2!" ^(초기화 실패^)
)
ENDLOCAL
GOTO :EOF

:RESETREG
SETLOCAL ENABLEDELAYEDEXPANSION
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
SET "TXT1TXT=!TXT1!"
SET "TXT1=!TXT1:"=\"!"
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
SET "TXT2TXT=!TXT2!"
SET "TXT2=!TXT2:"=\"!"
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
IF "%~1" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~2" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~3" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF "%~4" == "" (
	ENDLOCAL
	GOTO :EOF
)
IF /I "%3" == "BACKUP" (
	IF NOT "%~4" == "" (
		IF NOT EXIST "!QRegistrys!\%~4.reg" (
			REG.EXE EXPORT "!TXT1!" "!QRegistrys!\%~4.reg" /y >Nul 2>Nul
		)
	)
)
<VARIABLE\SRCH SET /P SRCH=
SET /A SRCH+=1
>VARIABLE\SRCH ECHO !SRCH!
>VARIABLE\DENY ECHO.
FOR /F "DELIMS=" %%V IN ('TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!" -ot reg -actn list -lst f:tab 2^>Nul^|TOOLS\GREP\GREP.EXE [[:space:]]\{3\}deny[[:space:]]\{3\} 2^>Nul') DO (
	SET "DENY=%%V"
	SET "DENY=!DENY:   =¶!"
	>>VARIABLE\DENY ECHO !DENY!
)
FOR /F "TOKENS=1,2 DELIMS=¶" %%V IN (VARIABLE\DENY) DO (
	TOOLS\SETACL\!ARCHITECTURE!\SETACL.EXE -on "!TXT1!" -ot reg -actn trustee -trst "n1:%%V;ta:remtrst;w:dacl" -actn rstchldrn -rst "dacl,sacl" -silent >Nul 2>Nul
)
IF /I "%~1" == "(Default)" (
	IF /I NOT "!TXT2TXT!" == "NULL" (
		IF /I NOT "%~2" == "NULL" (
			REG.EXE ADD "!TXT1!" /ve /t "%~2" /d "!TXT2!" /f >Nul 2>Nul
		) ELSE (
			IF /I "!TXT2TXT!" == "DELETECOMMAND" (
				REG.EXE DELETE "!TXT1!" /ve /f >Nul 2>Nul
			) ELSE (
				REG.EXE ADD "!TXT1!" /ve /d "!TXT2!" /f >Nul 2>Nul
			)
		)
	) ELSE (
		REG.EXE DELETE "!TXT1!" /ve /f >Nul 2>Nul
	)
) ELSE (
	IF /I NOT "!TXT2TXT!" == "NULL" (
		IF /I NOT "%~2" == "NULL" (
			REG.EXE ADD "!TXT1!" /v "%~1" /t "%~2" /d "!TXT2!" /f >Nul 2>Nul
		) ELSE (
			IF /I "!TXT2TXT!" == "DELETECOMMAND" (
				REG.EXE DELETE "!TXT1!" /v "%~1" /f >Nul 2>Nul
			) ELSE (
				REG.EXE ADD "!TXT1!" /v "%~1" /d "!TXT2!" /f >Nul 2>Nul
			)
		)
	) ELSE (
		REG.EXE ADD "!TXT1!" /v "%~1" /d "" /f >Nul 2>Nul
	)
)
IF !ERRORLEVEL! EQU 0 (
	<VARIABLE\SUCC SET /P SUCC=
	SET /A SUCC+=1
	>VARIABLE\SUCC ECHO !SUCC!
	>>"!QLog!" ECHO    "!TXT1TXT! : %~1" ^(초기화 성공^)
) ELSE (
	<VARIABLE\FAIL SET /P FAIL=
	SET /A FAIL+=1
	>VARIABLE\FAIL ECHO !FAIL!
	>>"!QLog!" ECHO    "!TXT1TXT! : %~1" ^(초기화 실패^)
)
ENDLOCAL
GOTO :EOF

:GET_DVAL
SETLOCAL ENABLEDELAYEDEXPANSION
SET TXT1=
<VARIABLE\TXT1 SET /P TXT1=
SET "TXT1=!TXT1:\=\\!"
SET "TXT1=!TXT1:"=""!"
IF NOT DEFINED TXT1 (
	ENDLOCAL
	GOTO :EOF
)
SET TXT2=
<VARIABLE\TXT2 SET /P TXT2=
SET "TXT2=!TXT2:\=\\!"
SET "TXT2=!TXT2:"=""!"
IF NOT DEFINED TXT2 (
	ENDLOCAL
	GOTO :EOF
)
>VARIABLE\TXTX ECHO.
FOR /F "DELIMS=" %%V IN ('TOOLS\REGTOOL\REGTOOL.EXE -w -q get "\!TXT1!\\!TXT2!\\" 2^>Nul^|TOOLS\ICONV\ICONV.EXE -f UTF-8 -t CP949 2^>Nul') DO (
	ENDLOCAL
	>VARIABLE\TXTX ECHO %%V
	GOTO :EOF
)
ENDLOCAL
GOTO :EOF

:P_RESULT
SETLOCAL ENABLEDELAYEDEXPANSION
<VARIABLE\SRCH SET /P SRCH=
IF !SRCH! EQU 0 (
	ECHO    발견되지 않았습니다. & >>"!QLog!" ECHO    발견되지 않음
) ELSE (
	<VARIABLE\SUCC SET /P SUCC=
	<VARIABLE\FAIL SET /P FAIL=
	IF /I "%~1" == "RECK" (
		<VARIABLE\RECK SET /P RECK=
	)
	IF /I "%~2" == "CHKINFECT" (
		<VARIABLE\XXXX SET /P XXXX=
		IF !XXXX! EQU 0 (
			>VARIABLE\XXXX ECHO 1
			COLOR 4F
		)
	)
	IF /I "%~1" == "RECK" (
		ECHO    발견: !SRCH! / 제거: !SUCC! / 제거 실패: !FAIL! / 재부팅 후 재검사 필요: !RECK!
	) ELSE (
		ECHO    발견: !SRCH! / 제거: !SUCC! / 제거 실패: !FAIL!
	)
)
ENDLOCAL
GOTO :EOF

:RESETVAL
SET NUMTMP=0
SET REGTMP=NULL
SET STRTMP=NULL
>VARIABLE\CHCK ECHO 0
>VARIABLE\DENY ECHO.
>VARIABLE\FAIL ECHO 0
>VARIABLE\RECK ECHO 0
>VARIABLE\RGST ECHO.
>VARIABLE\SRCH ECHO 0
>VARIABLE\SUCC ECHO 0
>VARIABLE\TXT1 ECHO.
>VARIABLE\TXT2 ECHO.
>VARIABLE\TXTX ECHO.
IF /I "%1" == "ALL" (
	>VARIABLE\XXXX ECHO 0
	>VARIABLE\XXYY ECHO 0
)
GOTO :EOF

:END
DEL /F /Q /A DB_ACTIVE\*.DB >Nul 2>Nul & DEL /F /Q /S /A DB_EXEC\*.DB >Nul 2>Nul
ATTRIB.EXE -R -H "DB_EXEC\*" /S /D >Nul 2>Nul

IF /I NOT "%PATHDUMP%" == "NULL" SET "PATH=%PATHDUMP%"

IF %CHKEXPLORER% EQU 1 START %SYSTEMROOT%\EXPLORER.EXE >Nul 2>Nul

ECHO.

REM * Exit
IF %ERRCODE% EQU 0 (
	ECHO ⓘ 상세 진단 리포트를 준비 중입니다. 창을 닫지 마시고 잠시만 기다려주세요 ^(약 5초^) . . .
	PING.EXE -n 5 0 >Nul 2>Nul
	START /MAX "MZK" "%QLog%" >Nul 2>Nul
	IF %AUTOMODE% NEQ 1 (
		ECHO.
		ECHO 종료하려면 아무 키나 누르십시오 . . .
		PAUSE >Nul 2>Nul
	)
	IF %VK% EQU 1 TOOLS\TASKS\TASKKILL.EXE /F /IM "MAGNETOK.EXE" >Nul 2>Nul
) ELSE (
	IF %AUTOMODE% EQU 1 (
		ECHO 약 10초 후에 자동으로 종료됩니다 . . .
		PING.EXE -n 10 0 >Nul 2>Nul
	) ELSE (
		ECHO 종료하려면 아무 키나 누르십시오 . . .
		PAUSE >Nul 2>Nul
	)
	IF %VK% EQU 1 TOOLS\TASKS\TASKKILL.EXE /F /IM "MAGNETOK.EXE" >Nul 2>Nul
)

SET ACTIVESCAN=
SET AUTOMODE=
SET CHKEXPLORER=
SET CURRENTDATE=
SET DATECHK=
SET DDRV=
SET ERRCODE=
SET NUMTMP=
SET OSVER=
SET PATHDUMP=
SET REGTMP=
SET RPTDATE=
SET STRTMP=
SET VK=

SET MZKTITLE=

SET MZKALLUSERSPROFILE=
SET MZKAPPDATA=
SET MZKCOMMONPROGRAMFILES=
SET MZKCOMMONPROGRAMFILESX86=
SET MZKLOCALAPPDATA=
SET MZKLOCALLOWAPPDATA=
SET MZKPROGRAMFILES=
SET MZKPROGRAMFILESX86=
SET MZKPUBLIC=
SET MZKSYSTEMROOT=
SET MZKUSERPROFILE=

SET YNAAA=
SET YNBBB=
SET YNCCC=

COLOR

TOOLS\TASKS\TASKKILL.EXE /F /IM "CMD.EXE" >Nul 2>Nul