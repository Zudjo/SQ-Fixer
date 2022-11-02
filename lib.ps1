# COSTANTS
# __________________________________________________
# ILC: InLine Comment
$RegexILC = '(?smx)<!--.*?-->'
$RegexIsCode = '(?<tag><\/?[a-zA-Z]+\s*(?<attr>\s*[a-zA-Z]+=".*"\s*)*?\s*>)'

# VARIABLES
# __________________________________________________

function Print-Comment {
  param([string]$Comment, [string]$FileName)

  Write-Host "File: $FileName"
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

function Remove-Comments {
  param([string]$TargetDirectory, [string]$TargetExtension)

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
        Print-Comment $Comment $File.Name
      }
    }

  }


}
