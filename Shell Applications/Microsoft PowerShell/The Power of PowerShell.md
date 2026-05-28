PowerShell excels at both system administration and working with other Windows technologies. Below is a practical, example-driven guide covering exactly how to accomplish common tasks in those two areas.

---

## 1. Host System Administration & Security

Most of these commands require **elevated privileges** (Run as Administrator). Check with:
```powershell
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
```

### Service Management
```powershell
# List all services
Get-Service

# Stop/Start/Restart a service
Stop-Service -Name Spooler -Force
Start-Service -Name Spooler
Restart-Service -Name Spooler

# Set startup type (Automatic, Manual, Disabled)
Set-Service -Name Spooler -StartupType Automatic

# Create a new service (requires sc.exe or New-Service)
New-Service -Name "MyService" -BinaryPathName "C:\MyApp\app.exe" -DisplayName "My Custom Service" -StartupType Manual
```

### Process Management
```powershell
# List processes with high CPU
Get-Process | Sort-Object CPU -Descending | Select-Object -First 10

# Stop a process by name or ID
Stop-Process -Name notepad -Force
Stop-Process -Id 1234 -Force

# Start a process and wait for exit
$proc = Start-Process -FilePath "notepad.exe" -ArgumentList "C:\file.txt" -PassThru
$proc.WaitForExit()
```

### Local Users & Groups
```powershell
# Create a local user (requires SecureString password)
$password = Read-Host -AsSecureString
New-LocalUser -Name "JohnDoe" -Password $password -FullName "John Doe" -Description "Test user"

# Add user to local group (e.g., Administrators)
Add-LocalGroupMember -Group "Administrators" -Member "JohnDoe"

# Check group membership
Get-LocalGroupMember -Group "Administrators"
```

### File & Folder Permissions (ACLs)
```powershell
# Get current ACL
$acl = Get-Acl -Path "C:\SensitiveData"

# Create a new access rule (FullControl for user JohnDoe)
$permission = "DOMAIN\JohnDoe", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow"
$rule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission
$acl.SetAccessRule($rule)
Set-Acl -Path "C:\SensitiveData" -AclObject $acl

# Remove inherited permissions and convert to explicit
$acl.SetAccessRuleProtection($true, $false)
Set-Acl -Path "C:\SensitiveData" -AclObject $acl
```

### Windows Firewall Rules
```powershell
# Enable a firewall rule by name
Enable-NetFirewallRule -DisplayName "World Wide Web Services (HTTP Traffic-In)"

# Create a new inbound rule to allow TCP port 8080
New-NetFirewallRule -DisplayName "Allow 8080" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow

# Block outbound traffic for a specific program
New-NetFirewallRule -DisplayName "Block App Out" -Direction Outbound -Program "C:\App\blockme.exe" -Action Block
```

### Windows Defender Antivirus
```powershell
# Get protection status
Get-MpComputerStatus

# Run a quick scan
Start-MpScan -ScanType QuickScan

# Update signatures
Update-MpSignature

# Add an exclusion path
Add-MpPreference -ExclusionPath "C:\MyTools"
```

### Security Auditing & Logs
```powershell
# Enable auditing on a folder for failed access (requires auditpol set first)
auditpol /set /subcategory:"File System" /success:enable /failure:enable
$path = "C:\AuditedFolder"
$acl = Get-Acl $path -Audit
$rule = New-Object System.Security.AccessControl.FileSystemAuditRule("Everyone","FullControl","ContainerInherit,ObjectInherit","None","Failure")
$acl.AddAuditRule($rule)
Set-Acl $path -AclObject $acl

# Query security event log for failed logons (Event ID 4625)
Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} -MaxEvents 20
```

### Scheduled Tasks
```powershell
# Create a scheduled task that runs daily
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\Scripts\backup.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At 3am
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
Register-ScheduledTask -TaskName "Daily Backup" -Action $action -Trigger $trigger -Principal $principal
```

---

## 2. Interoperating with Windows Applications

PowerShell can drive almost any Windows application via COM, .NET, direct executable calls, or UI Automation.

### Running External Programs & Scripts
```powershell
# Simple call, output appears in console
& "C:\Tools\myapp.exe" -arg1 -arg2

# Capture output
$output = & ping.exe localhost

# Use Start-Process for more control (hidden, wait, alternate creds)
Start-Process -FilePath "msiexec.exe" -ArgumentList "/i C:\package.msi /qn" -Wait -NoNewWindow
```

### COM Automation (Office applications, Internet Explorer, etc.)

**Excel:**
```powershell
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false  # Background
$workbook = $excel.Workbooks.Open("C:\report.xlsx")
$sheet = $workbook.Worksheets.Item(1)
$cellValue = $sheet.Cells.Item(1,1).Text
$sheet.Cells.Item(2,1).Value2 = "Hello from PowerShell"
$workbook.SaveAs("C:\report_updated.xlsx")
$workbook.Close()
$excel.Quit()
[System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
```

**Word:**
```powershell
$word = New-Object -ComObject Word.Application
$doc = $word.Documents.Open("C:\doc.docx")
$doc.Content.Find.Execute("FindThis")  # Simple find
$doc.Save()
$doc.Close()
$word.Quit()
```

**Outlook (send an email):**
```powershell
$outlook = New-Object -ComObject Outlook.Application
$mail = $outlook.CreateItem(0)
$mail.Subject = "Test"
$mail.Body = "Body text"
$mail.To = "someone@example.com"
$mail.Attachments.Add("C:\file.pdf")
$mail.Send()
```

### Using .NET Libraries Directly
PowerShell can load any .NET assembly. This is extremely powerful for Windows interoperability.
```powershell
# Load Windows Forms for a simple message box
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.MessageBox]::Show("Hello!", "Title")

# Access Win32 API via P/Invoke (example: Lock Workstation)
$signature = @"
[DllImport("user32.dll")]
public static extern bool LockWorkStation();
"@
$type = Add-Type -MemberDefinition $signature -Name "Win32Lock" -Namespace Win32Functions -PassThru
$type::LockWorkStation()
```

### Interacting with Windows Registry
```powershell
# Read a key
$val = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion" -Name "ProgramFilesDir"

# Create/Modify a value
Set-ItemProperty -Path "HKCU:\Software\MyApp" -Name "Setting" -Value "Enabled"

# Check existence
Test-Path "HKCU:\Software\MyApp"
```

### WMI / CIM (for deep system and application info)
```powershell
# List installed software via CIM (more modern)
Get-CimInstance -ClassName Win32_Product | Select-Object Name, Version  # slow, triggers reconfiguration
# Better/faster:
Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, DisplayVersion

# Query running processes with WMI
Get-WmiObject -Class Win32_Process | Where-Object { $_.Name -eq "notepad.exe" }

# Stop a process remotely using CIM
Invoke-CimMethod -Query "SELECT * FROM Win32_Process WHERE Name='notepad.exe'" -MethodName Terminate
```

### UI Automation (Last resort for legacy apps without API)
Use the `UIAutomation` .NET library to click buttons, read text, etc.
```powershell
Add-Type -AssemblyName UIAutomationClient
$automation = [System.Windows.Automation.AutomationElement]
# Example: Find Notepad's edit window (very simplified, requires window handle)
$notepad = $automation::RootElement.FindFirst([System.Windows.Automation.TreeScope]::Children,
    (New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::NameProperty, "Untitled - Notepad")))
$edit = $notepad.FindFirst([System.Windows.Automation.TreeScope]::Descendants,
    (New-Object System.Windows.Automation.PropertyCondition([System.Windows.Automation.AutomationElement]::ControlTypeProperty, [System.Windows.Automation.ControlType]::Edit)))
$edit.GetCurrentPattern([System.Windows.Automation.ValuePattern]::Pattern).SetValue("Hello")
```
(For simpler keystroke automation, `[System.Windows.Forms.SendKeys]::SendWait` can be used, but UI Automation is more reliable.)

### Call Signed PowerShell Scripts as “Applications”
Make PowerShell scripts behave like standalone executables by creating shortcuts or batch wrappers:
```cmd
@powershell.exe -ExecutionPolicy Bypass -File "\\server\share\script.ps1" %*
```

---

These examples give you the exact commands and patterns needed to administer a Windows host and to make PowerShell work with other Windows applications seamlessly. For any specific task, you can often combine these building blocks: e.g., query the registry, feed the result to a COM object, and write back a security ACL. Let me know if you’d like a deeper dive into any particular scenario.