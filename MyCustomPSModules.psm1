<#PSScriptInfo
.VERSION 1.0.0
.AUTHOR https://github.com/zainab7681051
.PROJECTURI https://github.com/zainab7681051/MyCustomPSModules
.TAGS powershell-modules modules custom-modules commandline cli powershell
#>
using namespace System.Collections.Generic

# getting all public ps1 scripts from public dir
function GetAllPublicScripts{
  try{
    $publicScripts = @(Get-ChildItem -Path ".\public" -Filter *.ps1 -Recurse -ErrorAction Stop)
    return $publicScripts
  } catch {
    Write-Host -ForegroundColor "Red" "[Error] Error Occured when getting public scripts from Public directory: $_"
  }
}

<#
.DESCRIPTION
  Get-MyCustomModules displays all the defined custom-modules  

.NOTES
  Version: 1.0.0
  Author: https://github.com/zainab7681051

.Link
  https://github.com/zainab7681051/MyCustomPSModules
#>
function Get-MyCustomModules {
  $Files = GetAllPublicScripts
  
  Write-Host -ForegroundColor "Cyan" "`n=== Available Custom Commands ===" 
  Write-Host -ForegroundColor "DarkGray" "Scanning installed modules..." 
  
  $validCount = 0
  $missingCount = 0

  foreach ($file in $Files.BaseName) {
    $commandName = "Invoke-$($file)"
    
    try {
      Write-Host -ForegroundColor "Green" -NoNewline "  ✔ [$commandName]" 
      Write-Host  -ForegroundColor "DarkGray" " - Ready to use"
      $validCount++
    }
    catch {
      Write-Host -ForegroundColor "Red" -NoNewline "  ✖ [$commandName]" 
      Write-Host -ForegroundColor "DarkGray" " - Not properly installed" 
      $missingCount++
    }
  }

  Write-Host -ForegroundColor "Cyan" "`n=== Summary ===" 
  Write-Host -ForegroundColor "Yellow" ("  Total Modules: {0}" -f $Files.Count)   
  Write-Host -ForegroundColor "Green" ("  Available:     {0}" -f $validCount) 
  Write-Host -ForegroundColor "Red" ("  Missing:       {0}" -f $missingCount) 
  
  if ($missingCount -gt 0) {
    Write-Host -ForegroundColor "Yellow" "`n⚠ Some modules failed to load. Check installation and try again." 
  }
  
  Write-Host -ForegroundColor "DarkCyan" "`nUse 'List-MyCustomModules' to see available commands at any time`n" 
}

Export-ModuleMember -Function Get-MyCustomModules


$Files = GetAllPublicScripts

foreach ($file in $Files.FullName) {
  try {
    $resolvedPath = Resolve-Path -Path $file -Relative -ErrorAction Stop
    # executing script in current scope to make its functions available
    . $resolvedPath  # dot-sourcing brings functions into module scope
        
    # extracting base filename without extension for function name generation
    $fileName = [System.IO.Path]::GetFileName($file) -split ".ps1", 2
    try {
      # automatically exporting the matching invoke-* function from loaded script
      Export-ModuleMember -Function "Invoke-$($fileName[0])" -ErrorAction Stop
    }
    catch {
      Write-Host -ForegroundColor "Red" "[Error] Failed to import script file $([System.IO.Path]::GetFileName($file)): $_"
    }
  } catch {
    Write-Host -ForegroundColor "Red" "[Error] Failed to import script file $([System.IO.Path]::GetFileName($file)): $_"
  }
}
