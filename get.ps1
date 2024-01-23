# Specify the GitHub repository URL and files to download
Write-Output "This is a message."

$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$releaseUrl = "https://github.com/refa3211/nextdns/files/14027656/nextdns_1.41.0_windows_amd64_2.zip"  # Replace with the actual release URL
$zipFilePath = "$env:TEMP\nextdns.zip"
$extractPath = "$env:TEMP\nextdns"

try {
    # Download both the zip file and the configuration file
    Invoke-WebRequest -Uri $releaseUrl -OutFile $zipFilePath
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/refa3211/nextdns/main/config" -OutFile "$extractPath\config"
}
catch {
    Write-Error "Failed to download files from GitHub. $_"
    exit 1
}

# Unzip the contents to the specified path
Expand-Archive -Path $zipFilePath -DestinationPath $extractPath -Force

# Clean up: Optionally, you can remove the ZIP file after extraction
Remove-Item -Path $zipFilePath

# Set the current location to the extraction path
Set-Location $extractPath

# Install the service and start it
& .\nextdns.exe install -config .\config
Start-Service nextdns

# Check the status of the service
Get-Service nextdns
