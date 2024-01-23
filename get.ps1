# Specify the GitHub repository URL and files to download
$releaseUrl = "https://github.com/refa3211/nextdns/files/14027656/nextdns_1.41.0_windows_amd64_2.zip"  # Replace with the actual release URL


$FilePath = "$env:TEMP\nextdns"
function installcer {

    try {
        Invoke-WebRequest -Uri "https://nextdns.io/ca" -OutFile "$FilePath\cer.cer"
        $params = @{
            CertPath = "$FilePath\cer.cer"
            CertStoreLocation = 'Cert:\CurrentUser\Root'
        }
        Import-Certificate @params
        
    }
    catch {
        Write-Output "Failed to install cert"
    }
    
}


# Download the zip file
try {
    Invoke-WebRequest -Uri $releaseUrl -OutFile "$FilePath.zip"
} catch {
    Write-Error "Failed to download the ZIP file from GitHub. $_"
    exit 1
}

# Unzip the contents to the specified path
try {
    Expand-Archive -Path "$FilePath.zip" -DestinationPath $FilePath -Force
    Remove-Item -Path "$FilePath.zip" -Force  # Clean up the ZIP file
} catch {
    Write-Error "Error extracting the ZIP file: $_"
    exit 1
}

# Run the command with elevated permissions
try {
    Start-Process -FilePath "$FilePath\nextdns.exe" -ArgumentList "install -profile 159376 -auto-activate -report-client-info" -Verb RunAs
    installcer
} catch {
    Write-Error "Error running nextdns: $_"
    exit 1
}
