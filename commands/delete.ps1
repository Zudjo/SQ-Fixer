# COSTANTS
# __________________________________________________

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

  if (($Comment -match $RegexIsCode) -and (-not ($Comment -match "(?m)^\s*\*\s"))) {
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

function Delete-Comments {
  param([string]$TargetDirectory, [string]$TargetExtension)

  Disclaim-For-Deletion

  if (-not (Ask-Confirm)) {
    Write-Host "`nDeletion refused.`n"
    exit
  } else {
    Clear-Host
  }

  $NumberOfCommentsTotal = 0
  $NumberOfCommentsFile = 0
  $NumberOfFiles = 0
  $RegexMLC = $null
  $Feedback = "`n  Affected comments per file:`n"

  if ($TargetExtension -match "c|cpp|cs|js|php|css") {
    . ".\extensions\c\regexComment.ps1"
  } else {
    . ".\extensions\$TargetExtension\regexComment.ps1"
  }

  # Get all files and loop through them
  $Files = Get-ChildItem -path $TargetDirectory -recurse -file -filter "*.$TargetExtension"
  ForEach ($File in $Files) {
    $NumberOfFiles += 1

    # Get all lines as a string
    $Lines = Get-Content -path $File.FullName -raw

    # Reset comments
    $Comments = $null

    # Get everything that is a comment
    $Comments = (Select-String -Pattern $RegexILC -InputObject $Lines -AllMatches).Matches

    if ($RegexMLC) {
      $Comments += (Select-String -Pattern $RegexMLC -InputObject $Lines -AllMatches).Matches
    }

    ForEach ($Comment in $Comments) {

      # Check if it's code or helpful info
      if (Check-Comment $Comment) {

        # If it's commented code:
        # increment the counter, print the feedback and delete the comment
        $NumberOfCommentsFile += 1
        $NumberOfCommentsTotal += 1
        Print-Comment $Comment $File.Name $NumberOfCommentsTotal
        # Delete-Comment $File.FullName $Comment
      }
    }

    if ($NumberOfCommentsFile) {
      $Feedback += "  $NumberOfCommentsFile | " + $File.FullName + "`n"
    }

    $NumberOfCommentsFile = 0
  }

  Write-Host "  These comments have been deleted.
  Total comments deleted: $NumberOfCommentsTotal
  Total files checked: $NumberOfFiles"
  Write-Host $Feedback

}

function Ask-Confirm {
  # Prompt the user for confirmation
  if ((Read-Host -prompt "Are you sure you want proceed? (Y to confirm)") -eq "Y") {
    return $true
  }
  return $false
}

function Disclaim-For-Deletion {
  Write-Host "
  This command will delete every commented code,
  for each file of the specified extension
  and under the specified directory and all its sub-directories.

  Please note that UNDESIRED DELITIONS MAY HAPPEN,
  therefore we suggest to run this command on a copy first
  and check that everything works as expected before modifying distributions.
  "
}
