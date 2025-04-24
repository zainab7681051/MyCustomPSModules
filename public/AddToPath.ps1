<#PSScriptInfo
.VERSION 1.0.0
.AUTHOR https://github.com/zainab7681051
.PROJECTURI https://github.com/zainab7681051/MyCustomPSModules
.TAGS powershell-modules modules custom-modules commandline cli powershell
#>

using namespace System.Collections.Generic
<#
.SYNOPSIS
  Invoke-AddToPath - adds path to enviroment variable

.DESCRIPTION
  Adds the provided path to the current User enviroment Path variable or the system variable 

.PARAMETER Path
  The path to add to the enviroment variable

.PARAMETER AllUser
  Turn this on to add path to the system enviroment variable for all users

.INPUTS
  None

.OUTPUTS
  None

.NOTES
  Version: 1.0.0
  Author: https://github.com/zainab7681051

.LINK
 https://github.com/zainab7681051/MyCustomPSModules
#>
function Invoke-AddToPath {
  [CmdletBinding(SupportsShouldProcess)]
  param(
  [string][Alias('p')] $Path, 
  [switch][Alias('au')] $AllUser
  )

  function AddToPath{
    param(
    [string] $PathToAdd,
    [string] $Target
    )

   [List[string]] $envPAth = [Environment]::GetEnvironmentVariable("Path", $Target) -split ';'
    
    if ($envPAth -cnotcontains $PathToAdd) {
        $envPAth.Add($PathToAdd) | Out-Null
        
        [Environment]::SetEnvironmentVariable("Path", ($envPath -join ';'), $Target)
        
        # update for current powershell session
        $env:Path += ";$PathToAdd"
        Write-Host -Foreground "Green" "Added the following path to enviroment variable PATH: $PathToAdd"
    } else {
        Write-Error "The provided path already exists in the $(if($Target -eq "User"){"current User"} else{"system"}) PATH."
    }
  }
  
  if(-not $Path) {
    return Write-Error "No Path was provided to add"
  }
  
  # cleaning the path by removing the leaf and extracting the parent directory
  [string] $pathToAdd=""
  if($Path -cmatch ".exe") {
    $parentDir = $Path -split "\\"
    $pathToAdd = $parentDir[0 .. ($parentDir.Count - 2)] -join "\"
  }
  else {
    $pathToAdd = $Path
  }

  if($AllUser){
    #checking for admin privliges
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

    if (-not ($principal.IsInRole($adminRole))) {
        return Write-Error "Must run this script as Administrator to modify the system PATH."
    }

    Write-Host -Foreground "Yellow" "Attemping to add to system enviroment variable for all users..."
    return AddToPath -PathToAdd $pathToAdd -Target "Machine"
  }
  
  # adding path for current user by default
  Write-Host -Foreground "Yellow" "Attemping to add to user enviroment variable for the current user..."
  return AddToPath -PathToAdd $pathToAdd -Target "User"
}

