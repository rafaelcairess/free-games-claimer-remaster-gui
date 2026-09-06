@echo off
setlocal
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0installer\Start-ClaimerControl.ps1" -Action source
if errorlevel 1 pause
