# Specify the GitHub repository URL and files to download
Write-Output "This is a message."


# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

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

try {
    & $env:TEMP\nextdns\nextdns.exe install -config $env:TEMP\nextdns\config
    
}
catch {
    Write-Error "error running the nextdns $_"
}



# Check the status of the service
Get-Service nextdns
