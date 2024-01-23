# Specify the GitHub repository URL and files to download


$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

# $DownloadURL = 'https://raw.githubusercontent.com/refa3211/nextdns/main/nextdns.exe'
$configfile = "https://raw.githubusercontent.com/refa3211/nextdns/main/config"

$releaseUrl = "https://github.com/nextdns/nextdns/releases/download/v1.41.0/nextdns_1.41.0_windows_amd64.zip"  # Replace with the actual release URL
$zipFilePath = "$env:SystemRoot\Temp\nextdns.zip" 

$extractPath = "$env:SystemRoot\Temp\nextdns" 


try {
    Invoke-WebRequest -Uri $configfile -OutFile "$extractPath\config"
    Invoke-WebRequest -Uri $releaseUrl -OutFile $zipFilePath

}
catch {
    
}

# Unzip the contents to the specified path
Expand-Archive -Path $zipFilePath -DestinationPath $extractPath

# Clean up: Optionally, you can remove the ZIP file after extraction
Remove-Item -Path $zipFilePath



$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\nextdns\nextdns.exe" } else { "$env:TEMP\nextdns\nextdns.exe" }


Set-Content -Path $FilePath -Value $response

# Start-Process $FilePath $ScriptArgs -Wait

$FilePaths = @("$env:TEMP\nextdns\nextdns.exe", "$env:SystemRoot\Temp\nextdns\nextdns.exe")
# foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }
