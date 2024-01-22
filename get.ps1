# Specify the GitHub repository URL and files to download


$ErrorActionPreference = "Stop"
# Enable TLSv1.2 for compatibility with older clients
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12

$DownloadURL = 'https://raw.githubusercontent.com/refa3211/nextdns/main/nextdns.exe'


$isAdmin = [bool]([Security.Principal.WindowsIdentity]::GetCurrent().Groups -match 'S-1-5-32-544')
$FilePath = if ($isAdmin) { "$env:SystemRoot\Temp\nextdns.exe" } else { "$env:TEMP\nextdns.cmd" }

try {
    $response = Invoke-WebRequest -Uri $DownloadURL -UseBasicParsing

}
catch {
    
}

$ScriptArgs = "$args "
$content = $response
Set-Content -Path $FilePath -Value $content

# Start-Process $FilePath $ScriptArgs -Wait

$FilePaths = @("$env:TEMP\nextdns.exe", "$env:SystemRoot\Temp\nextdns.exe")
foreach ($FilePath in $FilePaths) { Get-Item $FilePath | Remove-Item }
