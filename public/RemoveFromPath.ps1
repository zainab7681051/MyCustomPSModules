<#PSScriptInfo
.VERSION 1.0.0
.AUTHOR https://github.com/zainab7681051
.PROJECTURI https://github.com/zainab7681051/MyCustomPSModules
.TAGS powershell-modules modules custom-modules commandline cli powershell
#>

using namespace System.Collections.Generic
<#
.SYNOPSIS
  Invoke-RemoveFromPath - removes path from enviroment variable

.DESCRIPTION
  Removes the provided path from the current User enviroment Path variable or the system variable and updates the "$env:Path" for the current powershell session 

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

  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = [Security.Principal.WindowsPrincipal] $identity
  $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

  if (-not ($principal.IsInRole($adminRole))) {
      return Write-Host -Foreground "Red" "Must run this script as Administrator."
  }

  function RemoveFromPath{
    param(
    [string] $PathToRemove,
    [string] $Target
    )

    [List[string]] $envPath = [Environment]::GetEnvironmentVariable("Path", $Target) -split ';'

    if ($envPath.Remove($PathToRemove)) {
        [Environment]::SetEnvironmentVariable("Path", $($envPath -join ';'), $Target)
        
        # update for current powershell session
        $env:Path = $envPath -join ';'

        Write-Host -Foreground "Green" "[Success] Removed the following path from enviroment variable PATH:" 
        Write-Host $PathToRemove
    } else {
        Write-Host -Foreground "Red" "[Error] The provided path does not exist in $(if($Target -eq "User"){"the current User"} else{"system"}) PATH"
    }
  }
  
  if($Command -and $Path){
    Write-Host -Foreground "Red" "[Error] Must only provide one paramter: either command or path" 
    return
  }
  
  [string] $pathToRemove = ""

  if($Command){
      $CommandSource = (Get-Command $Command -ErrorAction SilentlyContinue).Source -split "\\"
      if(-not $CommandSource)
      {
        return Write-Host -Foreground "Red" "No command "$Command" was found"
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
    return Write-Host -Foreground "Red" "No command or path was provided to remove"
  }

  if($AllUsers){
    Write-Host -Foreground "Yellow" "[Warning] Attempting to remove path for All Users...`n"
    return RemoveFromPath -PathToRemove $pathToRemove -Target "Machine"
  }

  Write-Host -Foreground "Yellow" "[Warning] Attempting to remove path for current User only...`n"
  return RemoveFromPath -PathToRemove $pathToRemove -Target "User"
}

