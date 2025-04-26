# MyCustomPSModules
Collection of my custom PowerShell module scripts for daily use.

# Installation
Choose one of the following installation methods based on your needs:

## Automatic Installation (Recommended)
**For automatic module import in all PowerShell sessions:**  
1. Clone this repository into one of the directories listed in your `$env:PSModulePath`.  
   *(Check your current module paths with `$env:PSModulePath -split ';'`)*

```powershell
# Example: Clone to the user-specific modules directory
git clone https://github.com/zainab7681051/MyCustomPSModules "$HOME\Documents\PowerShell\Modules\MyCustomPSModules"
```

2. After cloning, PowerShell will automatically detect the module in future sessions. To use it immediately:  
```powershell
Import-Module MyCustomPSModules  # Only needed once per session
```

---

## Manual Installation (Advanced)
**If you cloned the repository to a directory *not* in `$env:PSModulePath`:**  

### Option 1: Manually Import Each Session
Use the module temporarily in the current PowerShell session:
```powershell
# Replace with the full path to your .psm1 file
Import-Module -Path "C:\Your\Custom\Path\MyCustomPSModules\MyCustomPSModules.psm1"
```

### Option 2: Add to PSModulePath for Auto-Import
1. **Add your module directory to PowerShell's module search path** (replace `C:\Your\Custom\Path` with your actual path):  
```powershell
# Temporary (current session only):
$env:PSModulePath += ";C:\Your\Custom\Path\MyCustomPSModules"

# Permanent (add to your profile):
[Environment]::SetEnvironmentVariable(
  'PSModulePath',
  "$env:PSModulePath;C:\Your\Custom\Path\MyCustomPSModules",
  'User'
)
```

2. **Verify and use the module:**  
```powershell
Import-Module MyCustomPSModules  # Load for the current session
Get-Module MyCustomPSModules    # Confirm it's loaded
```

---

# Usage
- **Call a function:**  
```powershell
Invoke-AddToPath "C:\Your\Directory" -AllUsers
```

- **List all available functions:**  
```powershell
Get-MyCustomModules
```

- **Get help for a specific function:**  
```powershell
help Invoke-RemoveFromPath  # Or: Get-Help Invoke-RemoveFromPath -Detailed
```
