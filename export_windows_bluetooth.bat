@echo off
:: Check if the script is running with administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process cmd -ArgumentList '/c %~fnx0 %*' -Verb RunAs"
    exit /b
)

:: Use psexec to run regedit with system privileges
.\psexec -s -i regedit /e "%~dp0bluetooth.info" HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\BTHPORT\Parameters\Keys

:: Notify the user that the export is complete
echo Registry export complete!
pause
