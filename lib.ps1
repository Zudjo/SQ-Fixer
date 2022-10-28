# COSTANTS
# __________________________________________________

# ILC: InLine Comment
# MLC: MultiLine Comment
$RegexILC = '(?smx)<!--.*?-->'
$RegexMLCOpening = '<!--'
$RegexMLCClosing = '-->'
$RegexHTML = '(?<tag><\/?[a-zA-Z]+\s*(?<attr>\s*[a-zA-Z]+=".*"\s*)*?\s*>)'

function Check-Line {
  param([string]$Line)

  if ($Line -match $RegexILC) {
    return 1
  }

  if ($Line -match $RegexMLCOpening) {
    return 2
  }

  if ($Line -match $RegexMLCClosing) {
    return 3
  }

  return 0
}

function Check-Comment {
  param([string]$Comment)

  if ($Comment -match $RegexHTML) {
    return $true
  }
  return $false
}

function Clean-Comment {
  param([string]$FilePath, [string]$Comment)

  $Cleaned = Select-String -inputObject $Comment -pattern $RegexILC

  return $Cleaned.matches[0]
}

function Delete-Comment {
  param([string]$FilePath, [string]$Comment)

  $Lines = Get-Content -path $FilePath -raw
  $Lines = $Lines.replace($Comment, "")
  Set-Content -path $FilePath -value $Lines
}
