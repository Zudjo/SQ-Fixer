Clear-Host
# IMPORTS
# __________________________________________________
. "./lib.ps1"

# COSTANTS
# __________________________________________________
# $TargetDir = "C:\xampp\htdocs\test\contrib\themes\primaton-theme\client"
$TargetDir = ".\test"

# VARIABLES
# __________________________________________________
$CommentCounter = 0

# MAIN
# __________________________________________________

# Get all files and loop through them
$Files = Get-ChildItem -path $TargetDir -recurse -file -filter *.html
ForEach ($File in $Files) {

  # Get all lines and loop through them
  $Lines = Get-Content -path $File.FullName

  ForEach ($Line in $Lines) {

    # Check if the line has an inline, opening or closing comment
    $LineStatus = Check-Line $Line

    # Based on the line status we take an action
    Switch ($LineStatus) {

      # No comment, nothing to do here
      0 {break;}

      # Inline comment
      1 {

        # Check if the comment is code or useful info
        if (Check-Comment $Line) {
          $Cleaned = Clean-Comment $File.FullName $Line
          Write-Host
          Write-Host
          Write-Host "-----------------------------------------------------------------"
          Write-Host "Original:`n$Line"
          Write-Host "Cleaned:`n$Cleaned"
          Write-Host "-----------------------------------------------------------------"
          Write-Host
          Write-Host
        }
        break;
      }

      # Opening comment
      2 {
        break;
      }

      # Closing comment
      3 {
        break;
      }

      default {
        Write-Host "Something unexpected happened."
        break;
      }
    }
  }
}
