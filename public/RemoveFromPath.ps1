<#PSScriptInfo
.VERSION 1.0.0
.AUTHOR https://github.com/zainab7681051
.PROJECTURI https://github.com/zainab7681051/MyCustomPSModules
.TAGS powershell-modules modules custom-modules commandline cli powershell
#>

using namespace System.Collections.Generic
using namespace Security.Principal 

<#
.SYNOPSIS
  Invoke-RemoveFromPath - removes path from enviroment variable

.DESCRIPTION
  Remove the provided path from the current User enviroment Path variable or the system variable 

.PARAMETER Path
  The path to remove from the enviroment variable

.PARAMETER Command
  The command to remove its path from the enviroment variable

.PARAMETER AllUser
  Turn this on to remove the path from enviroment variable for all users

.INPUTS
  None

.OUTPUTS
  None

.NOTES
  Version: 1.0.0
  Author: https://github.com/zainab7681051

.Link
 https://github.com/zainab7681051/MyCustomPSModules
#>

function Invoke-RemoveFromPath {
  [CmdletBinding(SupportsShouldProcess)]
  param(
  [string][Alias('p')] $Path, 
  [string][Alias('c')] $Command,
  [switch][Alias('au')] $AllUsers
  )

  $identity = [WindowsIdentity]::GetCurrent()
  $principal = [WindowsPrincipal] $identity
  $adminRole = [WindowsBuiltInRole]::Administrator

  if (-not ($principal.IsInRole($adminRole))) {
      return Write-Error "Must run this script as Administrator."
  }

  function RemoveFromPath{
    param(
    [string] $PathToRemove,
    [string] $Target
    )

    [List[string]] $envPath = [Environment]::GetEnvironmentVariable("Path", $Target) -split ';'
    
    if ($envPath.Remove($PathToRemove)) {
        [Environment]::SetEnvironmentVariable("Path", $($envPath -join ';'), $Target)

        Write-Host -Foreground "Green" "Removed the following path from enviroment variable PATH: $PathToRemove"
    } else {
        Write-Error "The provided path does not exist in $(if($Target -eq "User"){"the current User"} else{"system"}) PATH"
    }
  }
  
  if($Command -and $Path){
    return Write-Error "Must only provide one paramter: either command or path" 
  }
  
  [string] $pathToRemove = ""

  if($Command){
    try{
      $CommandSource = (Get-Command $Command -ErrorActions Stop).Source -split "\\"
    }
    catch{
      return Write-Error "No command "$Command" was found"
    }
    $pathToRemove = $CommandSource[0 .. ($CommandSource.Count - 2)] -join "\"
  }
  elseif($Path){
    if($Path -cmatch ".exe") {
      $CommandSource = $Path -split "\\"
      $pathToRemove = $CommandSource[0 .. ($CommandSource.Count - 2)] -join "\"
     }
    else {
      $pathToRemove = $Path
    }
  }
  else{
    return Write-Error "No command or path was provided to remove"
  }

  if($AllUsers){
    Write-Host -Foreground "Yellow" "Attempting to remove path for All Users..."
    return RemoveFromPath -PathToRemove $pathToRemove -Target "Machine"
  }

  Write-Host -Foreground "Yellow" "Attempting to remove path fUserent User only..."
  return RemoveFromPath -PathToRemove $pathToRemove -Target "User"
}

