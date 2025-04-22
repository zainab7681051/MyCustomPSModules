<#PSScriptInfo
.VERSION 1.0.0
.AUTHOR https://github.com/zainab7681051
.PROJECTURI https://github.com/zainab7681051/MyCustomPSModules
.TAGS powershell-modules modules custom-modules commandline cli powershell
#>
using namespace System.Collections.Generic

# getting all public ps1 scripts from public dir
function Get-AllPublicScripts{
  try{
    $publicScripts = @(Get-ChildItem -Path ".\public" -Filter *.ps1 -Recurse -ErrorAction Stop)
    return $publicScripts
  } catch {
    Write-Error "Error Occured when getting public scripts from Public directory: $_"
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
  $Files = Get-AllPublicScripts
  
  Write-Host "`n=== Available Custom Commands ===" -ForegroundColor Cyan
  Write-Host "Scanning installed modules..." -ForegroundColor DarkGray
  
  $validCount = 0
  $missingCount = 0

  foreach ($file in $Files.BaseName) {
    $commandName = "Invoke-$($file)"
    
    try {
      Write-Host "  ✔ [$commandName]" -ForegroundColor Green -NoNewline
      Write-Host " - Ready to use" -ForegroundColor DarkGray
      $validCount++
    }
    catch {
      Write-Host "  ✖ [$commandName]" -ForegroundColor Red -NoNewline
      Write-Host " - Not properly installed" -ForegroundColor DarkGray
      $missingCount++
    }
  }

  Write-Host "`n=== Summary ===" -ForegroundColor Cyan
  Write-Host ("  Total Modules: {0}" -f $Files.Count) -ForegroundColor Yellow
  Write-Host ("  Available:     {0}" -f $validCount) -ForegroundColor Green
  Write-Host ("  Missing:       {0}" -f $missingCount) -ForegroundColor Red
  
  if ($missingCount -gt 0) {
    Write-Host "`n⚠ Some modules failed to load. Check installation and try again." -ForegroundColor Yellow
  }
  
  Write-Host "`nUse 'List-MyCustomModules' to see available commands at any time`n" -ForegroundColor DarkCyan
}
Export-ModuleMember -Function Get-MyCustomModules


$Files = Get-AllPublicScripts

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
      Write-Error "Failed to import script file $([System.IO.Path]::GetFileName($file)): $_"
    }
  } catch {
    Write-Error "Failed to import script file $([System.IO.Path]::GetFileName($file)): $_"
  }
}
