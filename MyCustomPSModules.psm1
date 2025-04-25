<#PSScriptInfo
.VERSION 1.0.0
.AUTHOR https://github.com/zainab7681051
.PROJECTURI https://github.com/zainab7681051/MyCustomPSModules
.TAGS powershell-modules modules custom-modules commandline cli powershell
#>

using namespace System.Collections.Generic

# getting all public ps1 scripts from public dir
# returns List[string] or $null
function GetAllPublicScripts{
  $moduleRoot = $PSScriptRoot
  $publicDir = Join-Path -Path $moduleRoot -ChildPath 'public'

  try{
    [List[string]] $publicScripts = Get-ChildItem -Path $publicDir -Filter *.ps1 -ErrorAction Stop

    if($publicScripts.Count -eq 0){
      return Write-Host -ForegroundColor "Red" "[Error] Error Occured when getting public scripts from Public directory:`n  No powershell scripts (.ps1 files) were found"
    }

    return $publicScripts

  } catch {
    Write-Host -ForegroundColor "Red" "[Error] Error Occured when getting public scripts from Public directory:`n  $_"
    return $null
  }
}

$missingModules = [List[string]]::new() 
$validModules = [List[string]]::new()  
$allModules = [List[string]]::new()  

[List[string]] $Files = GetAllPublicScripts
if(-not (($null -eq $Files) -or ($Files.Count -eq 0))){

  foreach ($file in $Files) {
        
    # extracting base filename without extension for function name generation
    $fileName = [System.IO.Path]::GetFileName($file) -split ".ps1", 2
    $command = "Invoke-$($fileName[0])"
  
    $allModules.Add($command)
  
    $resolvedPath = Resolve-Path -Path $file -Relative -ErrorAction SilentlyContinue
    if(-not $resolvedPath){
      $missingModules.Add($command) | Out-Null
      continue
    }
  
    # executing script in current scope to make its functions available
    . $resolvedPath  # dot-sourcing brings functions into module scope
  
    # automatically exporting the matching invoke-* function from loaded script
    Export-ModuleMember -Function $command 
  
    $validModules.Add($command) | Out-Null
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
  
  Write-Host -ForegroundColor "Cyan" "`n=== Available Custom Commands ===" 
  Write-Host -ForegroundColor "DarkGray" "Scanning installed modules..." 
  
  if($allModules.Count -eq 0){
    return Write-Host -ForegroundColor "Red" "`n [Error] No modules are available : Make sure the directory containing the modules exist and re-import MyCustomPSModules in a new Powrshell session"
  }
  foreach ($mod in $allModules) {
    if($missingModules -ccontains $mod){
      Write-Host -ForegroundColor "Red" -NoNewline "  ✖ [$mod]" 
      Write-Host -ForegroundColor "DarkGray" " - Not properly installed" 
    }
    else{
      Write-Host -ForegroundColor "Green" -NoNewline "  ✔ [$mod]" 
      Write-Host  -ForegroundColor "DarkGray" " - Ready to use"
    }
  }

  Write-Host -ForegroundColor "Cyan" "`n=== Summary ===" 
  Write-Host -ForegroundColor "Yellow" ("  Total Modules: {0}" -f $allModules.Count)   
  Write-Host -ForegroundColor "Green" ("  Available:     {0}" -f $validModules.Count) 
  Write-Host -ForegroundColor "Red" ("  Missing:       {0}" -f $missingModules.Count) 
  
  if ($missingModules.Count -gt 0) {
    Write-Host -ForegroundColor "Yellow" "`n [Warning] Some modules failed to load. Check installation and try again." 
  }
  
  Write-Host -ForegroundColor "DarkCyan" "`n [Note] Use the 'help' or 'Get-Help' command for more info on each module`n" 
}

Export-ModuleMember -Function Get-MyCustomModules
