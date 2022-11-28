# CONSTANTS
# __________________________________________________
$Extensions = @("html", "cshtml", "php")

# VARIABLES
# __________________________________________________
$GLOBAL:NumberImgTagsTotal = 0
$GLOBAL:Feedback = "Fixed 'img' tags per file`n`n"

# FUNCTIONS
# __________________________________________________
function Save-Log {
  param([string]$ImgTag, [string]$FileName, [int]$NumberImgTags)

  $S = ""

  # If it's the first fix of the scan, print separator
  if ($GLOBAL:NumberImgTagsTotal -eq 0) {
    $S += "**********************************************************************`n"
  }

  # If it's the first fix of the file, print the file name
  if ($NumberImgTags -eq 0) {
    $S += "--------------------------------------------------`n"
    $S += "$FileName`n"
    $S += "--------------------------------------------------`n`n`n"
  }

  $S += "ImgTag number: $NumberImgTags`n"
  $S += "----------------`n"
  $S += "$ImgTag`n`n"

  Out-File -FilePath ".\logs\add-alt-attribute.log" -InputObject $S -Append -Encoding "utf8"
}

function Fix-ImgTag {
  param([string]$Lines, [string]$ImgTag)

  $OldImgTag = $ImgTag
  $ImgTag = $ImgTag -replace "/>", ">"
  $ImgTag = $ImgTag -replace "(?<=[`"`'])>", " >"
  $Updated = $ImgTag -replace "(?<![\?`"`'])>", " alt=`"`" />"

  return $Lines.replace($OldImgTag, $Updated)
}

function Get-Feedback {
  param([int]$NumberCheckedFiles, [int]$NumberAffectedFiles)

  $S = "**********************************************************************`n"
  $S += "Add alt attribute`n"
  $S += "**********************************************************************`n"
  $S += "  Total img tags fixed: $GLOBAL:NumberImgTagsTotal`n"
  $S += "  Total files checked: $NumberCheckedFiles`n"
  $S += "  Total files affected: $NumberAffectedFiles`n`n"

  if ($NumberAffectedFiles) {
    $S += "$GLOBAL:Feedback`n`n"
  }

  return $S
}

function Manage-File {
  param($File)

  # Initialize counter
  $NumberImgTagsFile = 0

  # Get all lines of file as a string
  $Lines = Get-Content -path $File.FullName -raw

  # Get every match of an img tag without the attribute alt
  $ImgTags = Get-Matches $Lines "<ima?ge?\s(?!.*alt=`".*?`").*?[^\?]>"

  # Loop through every match
  ForEach ($ImgTag in $ImgTags) {

    # Fix the img tag adding alt
    $Lines = Fix-ImgTag $Lines $ImgTag

    # Save feedback in the logs
    Save-Log $ImgTag $File.Name $NumberImgTagsFile

    # Increment the counters
    $NumberImgTagsFile += 1
    $GLOBAL:NumberImgTagsTotal += 1
  }

  # Overwrite file with fixes
  Set-Content -path $File.FullName -value $Lines

  # Check if the file had img tags fixed
  # if so, increment the counter and update feedback
  if ($NumberImgTagsFile) {
    $NumberAffectedFiles += 1
    $GLOBAL:Feedback += "  $NumberImgTagsFile | " + $File.FullName + "`n"
    return $true
  }
  return $false
}
