Clear-Host
# IMPORTS
# __________________________________________________
. ".\lib.ps1"

# COSTANTS
# __________________________________________________
# $TargetDir = "C:\xampp\htdocs\test\contrib\themes\primaton-theme\client"
$TargetDir = ".\test"

# VARIABLES
# __________________________________________________

# MAIN
# __________________________________________________

# Get all files and loop through them
$Files = Get-ChildItem -path $TargetDir -recurse -file -filter *.html
ForEach ($File in $Files) {
  # Get all lines and loop through them
  $Lines = Get-Content -path $File.FullName -raw

  $abba = (Select-String -Pattern $RegexILC -InputObject $Lines -AllMatches).Matches

  ForEach ($gino in $abba) {
    if (Check-Comment $gino) {
      Write-Host "-----------------------------------------------------------------"
      Write-Host $gino
    }
  }

  #
  # ForEach ($Line in $Lines) {
  #
  #   # Check if the line has an inline, opening or closing comment
  #   # $LineStatus = Check-Line $Line
  #
  #   Manage-Line $Line $LineStatus
  # }
}
