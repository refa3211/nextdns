# Specify the GitHub repository URL and files to download
echo "this is "

$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# $DownloadURL = 'https://raw.githubusercontent.com/refa3211/nextdns/main/nextdns.exe'
$configfile = "https://raw.githubusercontent.com/refa3211/nextdns/main/config"

$releaseUrl = "https://github.com/refa3211/nextdns/files/14027656/nextdns_1.41.0_windows_amd64_2.zip"  # Replace with the actual release URL
$zipFilePath = "$env:TEMP\nextdns.zip"


$extractPath = "$env:TEMP\nextdns"


try {
    Invoke-WebRequest -Uri $releaseUrl -OutFile $zipFilePath
}
catch {
    Write-Error "Failed to download files from GitHub. $_"
    exit 1
}

# Unzip the contents to the specified path
Expand-Archive -Path $zipFilePath -DestinationPath $extractPath -Force

# Clean up: Optionally, you can remove the ZIP file after extraction
Remove-Item -Path $zipFilePath

$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:TEMP\nextdns\nextdns.exe" } else { "$env:SystemRoot\Temp\nextdns\nextdns.exe" }
Start-Process "$extractPath\nextdns.exe" -ArgumentList "install -config config"
# Assuming you want to remove the executable files, uncomment the following line
# foreach ($FilePath in $FilePaths) { Remove-Item -Path $FilePath -Force }

Get-Service nextdns