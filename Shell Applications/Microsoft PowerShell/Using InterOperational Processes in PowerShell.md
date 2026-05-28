Below is a precise, production-ready guide to accomplishing **Host System Administration & Security** and **Interoperating with Windows Applications** in PowerShell. Commands are validated for Windows PowerShell 5.1 and PowerShell 7.x, with version-specific notes where relevant.

---
## 🔐 PART 1: Host System Administration & Security

### 1. Foundational Security Configuration
```powershell
# Execution Policy (scope-based convenience, NOT a security boundary)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Enable comprehensive PowerShell logging (requires Admin)
$regBase = "HKLM:\Software\Policies\Microsoft\Windows\PowerShell"
New-Item -Path "$regBase\ScriptBlockLogging" -Force | Out-Null
Set-ItemProperty -Path "$regBase\ScriptBlockLogging" -Name EnableScriptBlockLogging -Value 1
Set-ItemProperty -Path "$regBase\ScriptBlockLogging" -Name EnableScriptBlockInvocationLogging -Value 1

New-Item -Path "$regBase\Transcription" -Force | Out-Null
Set-ItemProperty -Path "$regBase\Transcription" -Name EnableTranscripting -Value 1
Set-ItemProperty -Path "$regBase\Transcription" -Name OutputDirectory -Value "C:\PSLogs"
Set-ItemProperty -Path "$regBase\Transcription" -Name EnableInvocationHeader -Value 1
```
> 🔍 **Note**: For true enforcement, pair with **AppLocker** or **Windows Defender Application Control (WDAC)**. Execution policy only prevents accidental script runs.

### 2. Secure Credential & Secret Handling
```powershell
# Prompt securely
$cred = Get-Credential

# Store in Windows Credential Manager (recommended over encrypted files)
Install-Module -Name CredentialManager -Scope CurrentUser -Force
New-StoredCredential -Target "MyAppCred" -UserName "admin" -Password "P@ssw0rd!" -Persist LocalMachine

# Retrieve later
$stored = Get-StoredCredential -Target "MyAppCred"
```

### 3. Core Host Administration
```powershell
# Services
Get-Service -Name "WinRM" | Set-Service -StartupType Automatic -Status Running

# Local Users & Groups (Win10/11, Server 2016+)
New-LocalUser -Name "svc_backup" -NoPassword -FullName "Backup Service" -Description "Least-privilege backup account"
Add-LocalGroupMember -Group "Backup Operators" -Member "svc_backup"

# Firewall
New-NetFirewallRule -DisplayName "Allow RDP from CorpNet" -Direction Inbound -Protocol TCP -LocalPort 3389 -RemoteAddress "10.0.0.0/8" -Action Allow

# Event Logs (PowerShell operational & security)
Get-WinEvent -LogName "Microsoft-Windows-PowerShell/Operational" -MaxEvents 20 | Format-Table TimeCreated, Id, Message -AutoSize
```

### 4. Secure Remoting & Delegation
```powershell
# Enable PS Remoting (WinRM)
Enable-PSRemoting -Force -SkipNetworkProfileCheck

# Prefer SSH remoting in PS7+ (more secure, cross-platform)
# Install OpenSSH Server, then:
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "$env:ProgramFiles\PowerShell\7\pwsh.exe" -Force

# Just Enough Administration (JEA) endpoint example
New-PSRoleCapabilityFile -Path "C:\JEA\BackupRole.psrc" -VisibleCmdlets "Get-Service","Restart-Service" -VisibleFunctions "Backup-Data"
New-PSSessionConfigurationFile -Path "C:\JEA\BackupEndpoint.pssc" -RoleDefinitions @{ 'DOMAIN\BackupAdmins' = @{ RoleCapabilities = 'BackupRole' } }
Register-PSSessionConfiguration -Name "BackupEndpoint" -Path "C:\JEA\BackupEndpoint.pssc" -Force
```

---
## 🔗 PART 2: Interoperating with Windows Applications

### 1. Native Executables & Exit Code Handling
```powershell
# Synchronous execution with exit code check
& "C:\Program Files\7-Zip\7z.exe" x "C:\temp\archive.zip" -o"C:\temp\extracted" -y
if ($LASTEXITCODE -ne 0) { throw "7-Zip failed with code $LASTEXITCODE" }

# Capture stdout/stderr separately (PS5.1/7)
$result = & "ping.exe" "127.0.0.1" 2>&1
$stdout = $result | Where-Object { $_ -is [string] -or $_ -is [System.Management.Automation.InformationRecord] }
$stderr = $result | Where-Object { $_ -is [System.Management.Automation.ErrorRecord] }
```
> 💡 PS7+ improves native app handling: automatic pipeline binding, `$PSNativeCommandUseErrorActionPreference`, and cleaner error streaming.

### 2. COM Automation (Office, Shell, etc.)
```powershell
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$wb = $excel.Workbooks.Add()
$ws = $wb.Worksheets.Item(1)
$ws.Cells.Item(1,1).Value2 = "Generated $(Get-Date -Format 'yyyy-MM-dd')"
$wb.SaveAs("C:\temp\report.xlsx")
$excel.Quit()

# Critical: Release COM to prevent orphaned processes
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($ws) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($wb) | Out-Null
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
[GC]::Collect(); [GC]::WaitForPendingFinalizers()
```

### 3. .NET Framework/Core Interop
```powershell
# Load assemblies & call static methods
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show("Deployment complete", "Status", "OK", "Information")

# File/Process interop
[System.IO.File]::WriteAllLines("C:\temp\log.txt", @("Line1","Line2"))
[System.Diagnostics.Process]::Start("notepad.exe", "C:\temp\log.txt")
```

### 4. WMI/CIM for System & Legacy Apps
```powershell
# CIM (modern, WS-Man, preferred over WMI)
Get-CimInstance -ClassName Win32_Product | Where-Object Name -like "*Visual*" | Select-Object Name, Version, InstallDate

# Launch process via CIM
Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{ CommandLine = "calc.exe" }
```

### 5. Registry & Configuration Interop
```powershell
$path = "HKCU:\Software\MyOrg\MyApp"
if (-not (Test-Path $path)) { New-Item -Path $path -Force | Out-Null }
Set-ItemProperty -Path $path -Name "LastRun" -Value (Get-Date -Format "o")
Set-ItemProperty -Path $path -Name "Mode" -Value "Production" -Type String
```

### 6. Scheduled Tasks & Background Execution
```powershell
$action  = New-ScheduledTaskAction -Execute "pwsh.exe" -Argument "-NoProfile -File C:\scripts\sync.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At "3:00AM"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
Register-ScheduledTask -TaskName "NightlySync" -Action $action -Trigger $trigger -Settings $settings -User "SYSTEM" -RunLevel Highest -Force
```

### 7. GUI/Installer Interop via `Start-Process`
```powershell
# MSI silent install with wait & log
Start-Process -FilePath "msiexec.exe" `
  -ArgumentList "/i `"C:\temp\app.msi`" /qn /norestart /l*v `"C:\temp\install.log`"" `
  -Wait -NoNewWindow -PassThru | Select-Object ExitCode

# Open associated app for a file
Start-Process -FilePath "C:\temp\report.pdf"
```

---
## 🛡️ Best Practices & Version Notes

| Area | Recommendation |
|------|----------------|
| **Security** | Execution policy ≠ security. Enforce with WDAC/AppLocker, enable ScriptBlock/Transcription logging, use JEA for delegation. |
| **Credentials** | Never hardcode. Use `CredentialManager`, Windows DPAPI, or Azure Key Vault. |
| **COM** | Always release objects + force GC. Orphaned COM processes are a common leak source. |
| **Native Apps** | Use `&` for console apps needing pipeline; `Start-Process` for GUI/MSI/wait scenarios. Check `$LASTEXITCODE`, not `$?`. |
| **PS Version** | PS7+ has superior native executable handling, SSH remoting, and cross-platform CIM. PS5.1 remains default on Windows for legacy COM/GPO compatibility. |
| **Error Handling** | Wrap interop calls in `try/catch`, use `-ErrorAction Stop`, and log `$Error[0].Exception.InnerException` when available. |

---
## 📚 Official References
- [PowerShell Security Best Practices](https://learn.microsoft.com/en-us/powershell/scripting/learn/security/security-best-practices)
- [Just Enough Administration (JEA)](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/jea/overview)
- [Running Native Executables](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_native_commands)
- [COM Interop in PowerShell](https://learn.microsoft.com/en-us/powershell/scripting/samples/creating-.net-and-com-objects--new-object-)
- [CIM vs WMI](https://learn.microsoft.com/en-us/powershell/scripting/learn/remoting/cim-and-wmi)

If you're targeting a specific host role (e.g., domain controller, RDSH, kiosk, or dev workstation) or need hardened GPO-backed deployment scripts, let me know and I'll tailor the configuration to your environment.