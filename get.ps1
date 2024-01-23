# Specify the GitHub repository URL and files to download
$releaseUrl = "https://github.com/refa3211/nextdns/files/14027656/nextdns_1.41.0_windows_amd64_2.zip"  # Replace with the actual release URL

# Determine the appropriate directory based on admin privileges
$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\nextdns" } else { "$env:TEMP\nextdns" }

try {
    # Download the zip file
    Invoke-WebRequest -Uri $releaseUrl -OutFile "$FilePath.zip"
}
catch {
    Write-Error "Failed to download the ZIP file from GitHub. $_"
    exit 1
}

try {
    # Unzip the contents to the specified path
    Expand-Archive -Path "$FilePath.zip" -DestinationPath $FilePath -Force

    # Clean up: Optionally, you can remove the ZIP file after extraction
    Remove-Item -Path "$FilePath.zip" -Force

    # Self-elevate the script if required
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        $ScriptPath = $MyInvocation.MyCommand.Definition
        $CommandLine = "& `"$ScriptPath`" $args"
        Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$ScriptPath`" $args"
        Exit
    }

    # Check if the current session is elevated
    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
        Write-Error "The script is not running with administrator privileges."
        Exit
    }

    # Run the command with elevated permissions
    & "$FilePath\nextdns.exe" install -profile 159376 -auto-activate -report-client-info
}
catch {
    Write-Error "Error running nextdns: $_"
}

# Optionally, you can add more cleanup or further actions here
