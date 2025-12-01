@echo off
powershell -NoProfile -Command "Get-Item '%~dp0Awake-Stop.ps1' | Unblock-File"
powershell -ExecutionPolicy Bypass -File "%~dp0Awake-Stop.ps1"
