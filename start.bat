@echo off
powershell -NoProfile -Command "Get-Item '%~dp0*.bat' | Unblock-File"
powershell -NoProfile -Command "Get-Item '%~dp0*.ps1' | Unblock-File"
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0Awake-Start.ps1"

