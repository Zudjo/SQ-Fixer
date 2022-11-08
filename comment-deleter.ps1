# COSTANTS
# __________________________________________________
# ILC: InLine Comment
$RegexILC = '(?smx)<!--.*?-->'
$RegexIsCode = '(?s)(<\s*(?<tag>\s*\w+\/?\s*)(\s*\w+=".*?"\s*)*\s*>)(<\/(\k<tag>)>)?'

$Comments = []

# VARIABLES
# __________________________________________________

function Print-Comment {
  param([string]$Comment, [string]$FileName, [int]$NumberOfComments)

  Write-Host "File: $FileName | Comment number: $NumberOfComments"
  Write-Host "--------------------------------------------------"
  Write-Host $Comment
  Write-Host
  Write-Host
}

function Check-Comment {
  param([string]$Comment)

  if ($Comment -match $RegexIsCode) {
    return $true
  }
  return $false
}

function Delete-Comment {
  param([string]$FilePath, [string]$Comment)

  $Lines = Get-Content -path $FilePath -raw
  $Lines = $Lines.replace($Comment, "")
  Set-Content -path $FilePath -value $Lines
}

function Collect-Comments {
  param([string]$TargetDirectory, [string]$TargetExtension)

  $NumberOfComments = 0

  # Get all files and loop through them
  $Files = Get-ChildItem -path $TargetDirectory -recurse -file -filter "*.$TargetExtension"
  ForEach ($File in $Files) {

    # Get all lines as a string
    $Lines = Get-Content -path $File.FullName -raw

    # Get everything that is a comment
    $Comments = (Select-String -Pattern $RegexILC -InputObject $Lines -AllMatches).Matches

    ForEach ($Comment in $Comments) {

      # Check if it's code or helpful info
      if (Check-Comment $Comment) {

        # If it's commented code:
        # increment the counter, print the feedback and delete the comment
        $NumberOfComments += 1
        Print-Comment $Comment $File.Name $NumberOfComments

        # Prompt the user for confirmation
        if ((Read-Host -prompt "Are you sure you want to delete these comments? (Y to confirm)") -eq "Y") {
          Delete-Comment $File.FullName $Comment
          Write-Host "Comments deleted."
        } else {
          Write-Host "Deletion not executed."
        }
      }
    }

  }


}