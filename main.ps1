Clear-Host
# IMPORTS
# __________________________________________________

# COSTANTS
# __________________________________________________

# VARIABLES
# __________________________________________________

# FUNCTIONS
# __________________________________________________
function Set-TargetExtension {
  $Extensions = @("html", "cs", "php", "c", "cpp", "js")

  Write-Host
  For ($i = 1; $i -le $Extensions.Length; ++$i) {
    Write-Host "  $i. "$Extensions[$i-1]
  }
  Write-Host "`n  0. Exit`n"

  $Choice = Read-Host -prompt "Choose the file extension to check"

  if ([int]$Choice -le 0) {
    exit
  } else {
    if ([int]$Choice -le $Extensions.Length) {
      Clear-Host
      return $Extensions[$Choice-1]
    } else {
      Clear-Host
      Write-Host "`nSelect a valid option from the list`n"
      Set-TargetExtension
    }
  }
}

function Set-TargetDirectory {
  $Path = Read-Host -prompt "`nInsert path to check"

  if (Test-Path $Path){
    Clear-Host
    return $Path
  } else {
    Clear-Host
    Write-Host "`nThe inserted path doesn't exists.`n"
    Set-TargetDirectory
  }
}

# MAIN
# __________________________________________________

switch ($args[0]) {
  "delete" {
    . ".\commands\delete.ps1"
    $TargetDirectory = Set-TargetDirectory
    $TargetExtension = Set-TargetExtension
    Delete-Comments $TargetDirectory $TargetExtension
  }

  "add-alt" {
    . ".\commands\add-alt.ps1"
    $TargetDirectory = Set-TargetDirectory
    Add-Alt $TargetDirectory
  }

  Default {
    Write-Host "`n  Insert a valid command.`n"
  }
}
