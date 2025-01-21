@echo off
cd /D %~dp0
echo Loading Script...
powershell.exe -ExecutionPolicy Bypass -Command "Start-Process PowerShell -WindowStyle Hidden -Verb RunAs -ArgumentList \""-ExecutionPolicy Bypass -Command `\""cd '%~dp0'; & .\WindowD.ps1`\""\""   "