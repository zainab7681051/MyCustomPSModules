<#PSScriptInfo
.VERSION 1.0.0
.AUTHOR https://github.com/zainab7681051
.PROJECTURI https://github.com/zainab7681051/MyCustomPSModules
.TAGS powershell-modules modules custom-modules commandline cli powershell
#>

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
  Write-Error "Invoke-GetFromPath has nothing to do, for now..."
}
