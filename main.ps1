Clear-Host
# IMPORTS
# __________________________________________________
. ".\lib.ps1"

# COSTANTS
# __________________________________________________
# $TargetDir = "C:\xampp\htdocs\test\contrib\themes\primaton-theme\client"
$TargetDirectory = ".\test"
$TargetExtension = "html"

# VARIABLES
# __________________________________________________

# MAIN
# __________________________________________________

Remove-Comments $TargetDirectory $TargetExtension
