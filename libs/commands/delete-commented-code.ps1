# CONSTANTS
# __________________________________________________
if ($Extensions[0] -eq "all") {
  $Extensions = @("html", "cs", "php", "c", "cpp", "js", "css", "cshtml", "asp", "aspx")
}

# VARIABLES
# __________________________________________________
$GLOBAL:NumberCommentsTot = 0
$GLOBAL:Feedback = "Affected comments per file`n`n"

# FUNCTIONS
# __________________________________________________
function Save-Log {
  param([string]$Comment, [int]$NumberCommentsFile, [string]$FileName)
  $S = ""

  # If it's the first fix of the scan, print separator
  if ($GLOBAL:NumberCommentsTot -eq 0) {
    $S += "**********************************************************************`n"
  }

  # If it's the first fix of the file, print the file name
  if ($NumberCommentsFile -eq 0) {
    $S += "--------------------------------------------------`n"
    $S += "$FileName`n"
    $S += "--------------------------------------------------`n`n`n"
  }

  $S += "Comment number: $GLOBAL:NumberCommentsTot`n"
  $S += "------------------------------`n"
  $S += "$Comment`n`n"

  Out-File -FilePath ".\logs\delete-commented-code.log" -InputObject $S -Append -Encoding "utf8"
}

function Get-Feedback {
  param([int]$NumberCheckedFiles, [int]$NumberAffectedFiles)

  if ($NumberAffectedFiles) {
    $S = "**********************************************************************`n"
    $S += "Delete commented code`n"
    $S += "**********************************************************************`n"
    $S += "  Total comments deleted: $GLOBAL:NumberCommentsTot`n"
    $S += "  Total files checked: $NumberCheckedFiles`n"
    $S += "  Total files affected: $NumberAffectedFiles`n`n`n"
    $S += $GLOBAL:Feedback + "`n`n"
  } else {
    $S = "Nothing found for commented code."
  }

  return $S
}

function Is-Commented-Code {
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

function Manage-File {
  param($File)

  $NumberCommentsFile = 0
  $RegexMLC = $null
  $Extension = $File.Extension.Substring(1)

  if ($Extension -match "^c$|^cpp$|^cs$|^js$|^php$|^css$") {
    . ".\libs\extensions\c\regexComment.ps1"
  } else {
    . ".\libs\extensions\$Extension\regexComment.ps1"
  }

  # Get all lines as a string
  $Lines = Get-Content -path $File.FullName -raw

  # Get everything that is a comment
  $Comments = (Select-String -Pattern $RegexILC -InputObject $Lines -AllMatches).Matches

  # If extension has multiline comment add matches to comments
  if ($RegexMLC) {
    $Comments += (Select-String -Pattern $RegexMLC -InputObject $Lines -AllMatches).Matches
  }

  ForEach ($Comment in $Comments) {

    # Check if it's code or helpful info
    if (Is-Commented-Code $Comment) {
      Save-Log $Comment $NumberOfCommentsTot $File.FullName

      Delete-Comment $File.FullName $Comment

      # If it's commented code:
      # increment the counter, print the feedback and delete the comment
      $NumberCommentsFile += 1
      $GLOBAL:NumberCommentsTot += 1

    }
  }

  if ($NumberCommentsFile) {
    $GLOBAL:Feedback += "  $NumberCommentsFile | " + $File.FullName + "`n"
    return $true
  }

  return $false

}
