# nextdns

install
```
  irm https://raw.githubusercontent.com/refa3211/nextdns/main/get.ps1 | iex
```

### uninstall
for uninstall open Powershell
and paste that in
```CMD
irm https://raw.githubusercontent.com/refa3211/nextdns/main/uninstaller.ps1 | iex
```



# NextDNS Uninstaller

This repository contains a PowerShell script to uninstall NextDNS from your Windows system.

## How to Use

1. **Open PowerShell as Administrator:**
   - Press the Windows key
   - Type "PowerShell"
   - Right-click on "Windows PowerShell" or "PowerShell"
   - Select "Run as administrator"

2. **Copy the Uninstaller Command:**
   Copy the following command:

   ```powershell
   Invoke-Expression (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/yourusername/yourrepository/main/uninstall_nextdns.ps1" -UseBasicParsing).Content
