@echo off
set scriptpath=%~dp0
del %scriptpath%params.txt
@REM Input to powershell script is done via file to avoid loosing some special characters.
for %%x in (%*) do (
    echo %%~x >> %scriptpath%docker.params
)
powershell.exe -Command %scriptpath%docker-helper.ps1
