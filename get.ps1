# Specify the GitHub repository URL and files to download
$repositoryUrl = 'https://github.com/YourUsername/YourRepository'
$file1 = 'file1.txt'
$file2 = 'file2.txt'
$batchFile = 'yourScript.bat'

# Specify the download directory
$downloadDirectory = 'C:\Path\To\Download'

# Create the download directory if it doesn't exist
if (-not (Test-Path $downloadDirectory)) {
    New-Item -ItemType Directory -Path $downloadDirectory | Out-Null
}

# Download the files from GitHub
Invoke-WebRequest -Uri "$repositoryUrl/raw/main/$file1" -OutFile "$downloadDirectory\$file1"
Invoke-WebRequest -Uri "$repositoryUrl/raw/main/$file2" -OutFile "$downloadDirectory\$file2"

# Execute the batch file
Start-Process -FilePath "$downloadDirectory\$batchFile" -Wait
