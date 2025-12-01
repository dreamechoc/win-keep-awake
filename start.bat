@echo off
powershell -NoProfile -Command "Get-Item '%~dp0Awake-Start.ps1' | Unblock-File"
powershell -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0Awake-Start.ps1"
