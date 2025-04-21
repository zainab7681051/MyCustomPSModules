$publicFunctions = @(Get-ChildItem -Path ".\public" -Filter *.ps1 -Recurse -ErrorAction SilentlyContinue)

foreach ($file in $publicFunctions) {
  try {
    . $file.FullName  # DOT-SOURCING
  } catch {
    Write-Error "Failed to import function $($file.Name): $_"
  }
}

# EXPORTING ALL PUBLIC FUNCTIONS
Export-ModuleMember -Function $publicFunctions.BaseName

function List-MyCustomModules{

}
