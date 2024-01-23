# Specify the GitHub repository URL and files to download
Write-Output "This is a message."


# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$releaseUrl = "https://github.com/refa3211/nextdns/files/14027656/nextdns_1.41.0_windows_amd64_2.zip"  # Replace with the actual release URL
# $zipFilePath = "$env:TEMP\nextdns.zip"
# $extractPath = "$env:TEMP\nextdns"

$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\nextdns" } else { "$env:TEMP\nextdns" }

try {
    Invoke-WebRequest -Uri $releaseUrl -OutFile "$FilePath.zip"

}
catch {
    Write-Error "Failed to download files from GitHub. $_"
    exit 1
}

# Unzip the contents to the specified path
Expand-Archive -Path "$FilePath.zip" -DestinationPath $FilePath -Force

# Clean up: Optionally, you can remove the ZIP file after extraction
Remove-Item -Path "$FilePath.zip"

try {
    # Self-elevate the script if require
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
            $CommandLine = Invoke-RestMethod https://raw.githubusercontent.com/refa3211/nextdns/main/get.ps1 | Invoke-Expression
            Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
            Exit
        }
    }

    [System.Security.Principal.WindowsBuiltInRole]::Administrator
    & $env:TEMP\nextdns\nextdns.exe install -profile 159376 -auto-activate -report-client-info
    
}
catch {
    Write-Error "error running the nextdns $_"
}

# Check the status of the service
Get-Service nextdns
