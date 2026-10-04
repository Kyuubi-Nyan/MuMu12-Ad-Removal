@echo off
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0MuMuDesktopAdBlock.ps1" -Mode Status
echo.
pause