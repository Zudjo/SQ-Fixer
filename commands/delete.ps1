# COSTANTS
# __________________________________________________

# VARIABLES
# __________________________________________________

function Save-Log {
  param([string]$Comment, [int]$NumberOfComments)
  $S = ""

  $S += "Comment number: $NumberOfComments`n"
  $S += "------------------------------`n"
  $S += "$Comment`n`n"

  Out-File -FilePath ".\logs\delete.log" -InputObject $S -Append -Encoding "utf8"
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
  param([string]$TargetDirectory, [string]$TargetExtension, [bool]$Disclaimer)

  if ($Disclaimer) {
    Disclaim-For-Deletion
    if (-not (Ask-Confirm)) {
      Write-Host "`nDeletion refused.`n"
      exit
    } else {
      Clear-Host
    }
  }

  $Feedback = "Affected comments per file`n`n"
  $NumberOfCommentsTotal = 0
  $NumberOfCommentsFile = 0
  $NumberOfFiles = 0
  $RegexMLC = $null

  if ($TargetExtension -match "^c$|^cpp$|^cs$|^js$|^php$|^css$") {
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

    if ($Comments.Length -gt 0) {
      $S = "" + $File.FullName + "`n____________________________________________________________`n"
      Out-File -FilePath ".\logs\delete.log" -InputObject $S -Append -Encoding "utf8"
    }

    ForEach ($Comment in $Comments) {

      # Check if it's code or helpful info
      if (Check-Comment $Comment) {

        # If it's commented code:
        # increment the counter, print the feedback and delete the comment
        $NumberOfCommentsFile += 1
        $NumberOfCommentsTotal += 1

        Save-Log $Comment $NumberOfCommentsTotal
        Delete-Comment $File.FullName $Comment
      }
    }

    if ($NumberOfCommentsFile) {
      $Feedback += "  $NumberOfCommentsFile | " + $File.FullName + "`n"
    }

    $NumberOfCommentsFile = 0
  }

  if ($NumberOfCommentsTotal) {
    $S = "-------`n$TargetExtension`n-------`n"
    $S += "  Total comments deleted: $NumberOfCommentsTotal`n"
    $S += "  Total files checked: $NumberOfFiles`n`n"
    $S += "$Feedback`n`n`n`n"
    Write-Host $S
  } else {
    Write-Host "Nothing found for $TargetExtension"
  }

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
