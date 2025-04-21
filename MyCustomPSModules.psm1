function getAllFunctions{
  try{
    $publicFunctions = @(Get-ChildItem -Path ".\public" -Filter *.ps1 -Recurse -ErrorAction Stop)
    return $publicFunctions
  } catch {
    Write-Error "Error Occured when getting public modules from Public directory"
  }
}

function importAllFunctions{
  $Files = getAllFunctions

  foreach ($file in $Files.FullName) {
    try {
      Import-Module $file
    } catch {
      Write-Error "Failed to import function $($file.Name): $_"
    }
  }
}

function List-MyCustomModules{
  [string[]]$Files = getAllFunctions

  foreach($file in $Files.BaseName){
    Write-Host "Start-$($file)"
  }
}

# IMPORTING ALL FUNCTIONS (MODULES) FROM PUBLIC DIRECTORY
importAllFunctions

# EXPORTING ALL PUBLIC FUNCTIONS
Export-ModuleMember -Function $publicFunctions.BaseName, List-MyCustomModules
