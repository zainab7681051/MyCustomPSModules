# MyCustomPSModules
Collection of my custom powershell module scripts for daily use

# installation
clone this repo in one of the directory paths in $env:PSModulePath
```powershell
# I suggest cloning this repo in "C:\Users\<your-user-name>\Documents\PowerShell\Modules"
git clone https://github.com/zainab7681051/MyCustomPSModules
```
if you clone this repo anywhere else you must enter the repo directory and import the module file manually in order to use the custom functions
```powershell
Import-Module .\MyCustomPSModules.psm1
```
# usage
Modules can be used in the format of "Invoke-<ModuleScriptName>" 
```powershell
Invoke-AddToPath path\to\program\dir -AllUsers
```
To get a list of the module functions use the following command:
```powershell
Get-MyCustomModules
```
Make sure to use the "Get-Help" (or just "help") to get more information on each command
```powershell
help Invoke-RemoveFromPath
```
