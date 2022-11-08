Clear-Host
# IMPORTS
# __________________________________________________

# COSTANTS
# __________________________________________________

# VARIABLES
# __________________________________________________

# MAIN
# __________________________________________________

switch ($args[0]) {
  "delete" {
    . ".\comment-deleter.ps1"
    $TargetDirectory = ".\test"
    $TargetExtension = "html"
    Delete-Comments $TargetDirectory $TargetExtension
  }
  Default {
    Write-Host "Please insert a valid command."
  }
}
