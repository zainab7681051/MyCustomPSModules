# MyCustomPSModules
Collection of my custom powershell module scripts for daily use

# installation
clone this repo in one of the directory paths in $env:PSModulePath
```powershell
    git clone https://github.com/zainab7681051/MyCustomPSModules
```
if you clone this repo anywhere else you must import the module file manually in order to use the custom functions
```powershell
    Import-Module .\MyCustomPSModules.psm1
```
# usage
Modules can be used in the format of "Invoke-<ModuleScriptName>" 
```powershell
    Invoke-AddToPath path\to\program\dir -AllUsers
```
To see which module functions are available use the following command:
```powershell
    Get-MyCustomModules
```
