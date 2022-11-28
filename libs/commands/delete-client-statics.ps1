# CONSTANTS
# __________________________________________________
$Extensions = @("html", "map")

# VARIABLES
# __________________________________________________
$GLOBAL:DeletedFilesTotal = 0
$GLOBAL:Feedback = "Deleted files`n`n"

# FUNCTIONS
# __________________________________________________
function Get-Feedback {
  param([int]$NumberCheckedFiles, [int]$NumberAffectedFiles)

  $S = "**********************************************************************`n"
  $S += "Delete client statics`n"
  $S += "**********************************************************************`n"
  $S += "  Total files checked: $NumberCheckedFiles`n"
  $S += "  Total files affected: $NumberAffectedFiles`n`n`n"
  $S += $GLOBAL:Feedback + "`n`n"

  return $S
}

function Save-Log {
  param([string]$FilePath)

  $S = ""

  # If it's the first fix of the scan, print separator
  if ($GLOBAL:DeletedFilesTotal -eq 0) {
    $S += "**********************************************************************`n`n"
  }

  $S += "$FilePath`n"

  Out-File -FilePath ".\logs\delete-client-statics.log" -InputObject $S -Append -Encoding "utf8"
}

function Delete-File {
  param([string]$FilePath)

  Remove-Item -path $FilePath
}

function Manage-File {
  param($File)

  Save-Log $File.FullName

  Delete-File $File.FullName

  $GLOBAL:DeletedFilesTotal += 1

  $GLOBAL:Feedback += "  " + $File.FullName + "`n"

  return $true
}
