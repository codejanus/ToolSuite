@ECHO OFF

PUSHD "%~dp0"

IF NOT EXIST "DB\CHECK\MZK" (
	ECHO 압축 파일을 올바르게 해제 후 실행해주시기 바랍니다.
	ECHO.
	PAUSE
	EXIT /B
)

CALL MZK VK