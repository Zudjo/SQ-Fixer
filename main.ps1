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
      return $Extensions[$Choice-1]
    } else {
      Clear-Host
      Write-Host "Please, select a valid option from the list"
      Set-TargetExtension
    }
  }
}

# MAIN
# __________________________________________________

switch ($args[0]) {
  "delete" {
    . ".\commands\delete.ps1"
    # $TargetDirectory = "C:\Users\g.ziu\Desktop\ws_sites\primaton\versions\v1\test\contrib\themes\primaton-theme"
    $TargetDirectory = ".\test"
    $TargetExtension = Set-TargetExtension
    Delete-Comments $TargetDirectory $TargetExtension
  }
  Default {
    Write-Host "Please insert a valid command."
  }
}
