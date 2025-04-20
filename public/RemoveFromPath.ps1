<#
.DESCRIPTION
  remove the provided path to the current User enviroment Path variable or the system variable (requires admin priviliage)
.PARAMETER pathToAdd
  the path to add to the enviroment variable
.PARAMETER AllUser
  turn this on to add path to system enviroment variable

#>

using namespace System.Collections.Generic

function Start-RemoveFromPath {
  param(
  [string][Alias('p')] $Path, 
  [string][Alias('c')] $Command
  [switch][Alias('au')] $AllUsers
  )

  $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
  $principal = [Security.Principal.WindowsPrincipal] $identity
  $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

  if (-not ($principal.IsInRole($adminRole))) {
      return Write-Error "Must run this script as Administrator."
  }

  function RemoveFromPath{
    param(
    [string] $PathToRemove,
    [string] $Target
    )

    [List[string]] $envPath = [Environment]::GetEnvironmentVariable("Path", $Target) -split ';'
    
    if ($envPath.Remove($pathToRemove)) {
        [Environment]::SetEnvironmentVariable("Path", $envPath, "Machine")
        Write-Host "Removed the following path from enviroment variable PATH: $pathToAdd"
    } else {
        return Write-Error "The provided path does not exist in $(if($Target -eq "User"){"the current User"} else{"system"}) PATH"
    }
  }
  
  if($Command -and $Path){
    return Write-Error "Must only provide one paramter: either command or path" 
  }
  
  [string]$pathToRemove = ""

  if($Command){
    try{
      $CommandSource = (Get-Command $Command -ErrorActions Stop).Source -split "\\"
    }
    catch{
      return Write-Error "No command "$Command" was found"
    }
    $pathToRemove = $CommandSource[0 .. ($CommandSource.Count - 2)] -join "\"
  }

  else if($Path){
    if($Path -match ".exe") {
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

  Write-Host -Foreground "Yellow" "Attempting to remove path for current User only..."
  return RemoveFromPath -PathToRemove $pathToRemove -Target "User"
}

