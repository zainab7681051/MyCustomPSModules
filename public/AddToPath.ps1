<#
.DESCRIPTION
  adds the provided path to the current User enviroment Path variable or the system variable (requires admin priviliage)
.PARAMETER pathToAdd
  the path to add to the enviroment variable
.PARAMETER AllUser
  turn this on to add path to system enviroment variable
#>

function Start-AddToPath {
  param(
  [string][Alias('p')] $pathToAdd, 
  [switch][Alias('au')] $AllUser
  )

  function addForCurrentUser {
    $currentUserPath = [Environment]::GetEnvironmentVariable("Path", "User") -split ';'
    
    if ($currentUserPath -notcontains $pathToAdd) {
        # Append the new directory to the existing PATH
        $newUserPath = ($currentUserPath + $pathToAdd) -join ';'
        
        [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
        
        # update the current session's PATH
        $env:Path += ";$pathToAdd"
        Write-Host "Added to user PATH: $pathToAdd"
    } else {
        Write-Host "Directory already exists in user PATH."
    }
  }

  function addForAllUsers{
    $identity = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = [Security.Principal.WindowsPrincipal] $identity
    $adminRole = [Security.Principal.WindowsBuiltInRole]::Administrator

    if (-not ($principal.IsInRole($adminRole))) {
        Write-Error "Must run this script as Administrator to modify the system PATH."
        exit 1
    }

    $currentSystemPath = [Environment]::GetEnvironmentVariable("Path", "Machine") -split ';'
    
    if ($currentSystemPath -notcontains $pathToAdd) {
        $newSystemPath = ($currentSystemPath + $pathToAdd) -join ';'
        
        [Environment]::SetEnvironmentVariable("Path", $newSystemPath, "Machine")
        
        $env:Path += ";$pathToAdd"
        Write-Host "Added to system PATH: $pathToAdd"
    } else {
        Write-Host "Directory already exists in system PATH."
    }
  }
  
  if(-not $pathToAdd) {
    Write-Error "No Path to add was provided"
    exit 1
  }

  if($AllUser){
   return addForAllUsers 
  }

  return addForCurrentUser
}
