<#PSScriptInfo
.VERSION 1.0.0
.AUTHOR https://github.com/zainab7681051
.PROJECTURI https://github.com/zainab7681051/MyCustomPSModules
.TAGS powershell-modules modules custom-modules commandline cli powershell
#>

using namespace System.Collections.Generic

<#
.SYNOPSIS
  Invoke-GetFromPath - gets the path from enviroment variable Path

.DESCRIPTION
  gets the path of the provided command from enviroment variable Path

.PARAMETER Command
  The command to get its path from the enviroment variable Path

.NOTES
  Version: 1.0.0
  Author: https://github.com/zainab7681051

.Link
  https://github.com/zainab7681051/MyCustomPSModules
#>
function Invoke-GetFromPath{

  [CmdletBinding()]
  param([string]$Command)
  
  if(-not $Command){
    return Write-Error "[Error] No Command was provided`n"
  }
  
  $cmnd = $Command.Trim()
  Write-Host -Foreground "Yellow" "[Warning] Attempting to get the path of '$cmnd' `n"

  $commandSource = (Get-Command $cmnd -ErrorAction SilentlyContinue).Source -split "\\"
  if(-not $commandSource){
    return Write-Error "[Error] No command '$cmnd' was found`n"
  }

  Write-Host -Foreground "Yellow" "[Warning] Checking if the path of '$cmnd' exists in enviroment variable Path`n"
  $path = $commandSource[0 .. ($commandSource.Count - 2)] -join "\"
  
    [List[string]] $userEnvPath = [Environment]::GetEnvironmentVariable("Path", "User") -split ';'

  if($userEnvPath -ccontains $path){
    Write-Host -Foreground "Green" "[Success] the provided command exists in User enviroment variable Path"
    Write-Host -Foreground "Cyan" -NoNewline "Command: "
    Write-Host $cmnd
    Write-Host -Foreground "Cyan" -NoNewline "Path [User]: "
    Write-Host $path
    Write-Host 
    return
  }
  Write-Host -Foreground "Green" "[Success] the provided command exists in System enviroment variable Path"
  Write-Host -Foreground "Cyan" -NoNewline "Command: "
  Write-Host $cmnd
  Write-Host -Foreground "Cyan" -NoNewline "Path [System]: "
  Write-Host $path
  Write-Host
}
