@echo off
cd /d "%~dp0"
echo Starting Star Guard...
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0run.ps1"
echo.
echo Game launcher finished.
pause
