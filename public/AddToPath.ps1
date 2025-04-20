<#
.DESCRIPTION
  adds the provided path to the current User enviroment Path variable or the system variable (requires admin priviliage)
.PARAMETER Path
  the path to add to the enviroment variable
.PARAMETER AllUser
  turn this on to add path to system enviroment variable
#>

function Start-AddToPath {
  param(
  [string][Alias('p')] $Path, 
  [switch][Alias('au')] $AllUser
  )

  function addForCurrentUser {
    $currentUserPath = [Environment]::GetEnvironmentVariable("Path", "User") -split ';'
    
    if ($currentUserPath -notcontains $Path) {
        # Append the new directory to the existing PATH
        $newUserPath = ($currentUserPath + $Path) -join ';'
        
        [Environment]::SetEnvironmentVariable("Path", $newUserPath, "User")
        
        # update the current session's PATH
        $env:Path += ";$Path"
        Write-Host "Added to user PATH: $Path"
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
    
    if ($currentSystemPath -notcontains $Path) {
        $newSystemPath = ($currentSystemPath + $Path) -join ';'
        
        [Environment]::SetEnvironmentVariable("Path", $newSystemPath, "Machine")
        
        $env:Path += ";$Path"
        Write-Host "Added to system PATH: $Path"
    } else {
        Write-Host "Directory already exists in system PATH."
    }
  }
  
  if(-not $Path) {
    Write-Error "No Path to add was provided"
    exit 1
  }

  if($AllUser){
   return addForAllUsers 
  }

  return addForCurrentUser
}
