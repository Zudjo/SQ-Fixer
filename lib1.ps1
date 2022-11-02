# COSTANTS
# __________________________________________________
# ILC: InLine Comment
# MLC: MultiLine Comment
$RegexILC = '(?smx)<!--.*?-->'
$RegexMLCOpening = '<!--(?!.*-->).*'
$RegexMLCClosing = '^(?!<!--.*).*-->$'
$RegexHTML = '(?<tag><\/?[a-zA-Z]+\s*(?<attr>\s*[a-zA-Z]+=".*"\s*)*?\s*>)'

# VARIABLES
# __________________________________________________
$Global:MLCFlag = $false
$Global:MLCLines = ""
$Global:CommentCounter = 0

function Print-Fixed-Comment {
  param([string]$Line, [string]$Fixed)

  Write-Host "-----------------------------------------------------------------"
  Write-Host "Comment number: $Global:CommentCounter"
  Write-Host "Original:`n`n$Line`n"
  Write-Host "Fixed:`n`n$Fixed`n"
  Write-Host "-----------------------------------------------------------------"
}

function Check-Line {
  param([string]$Line)

  # Write-Host $Line
  # Write-Host "__________________________________________________"
  # Write-Host (Select-String $RegexMLCOpening -InputObject $Line -AllMatches).Matches.Count
  # Write-Host (Select-String $RegexMLCClosing -InputObject $Line -AllMatches).Matches.Count
  # Write-Host (Select-String $RegexILC -InputObject $Line -AllMatches).Matches.Count
  # Check for multiple inline comments
  if ((Select-String $RegexMLCOpening -InputObject $Line -AllMatches).Matches.Count +
    (Select-String $RegexMLCClosing -InputObject $Line -AllMatches).Matches.Count +
    (Select-String $RegexILC -InputObject $Line -AllMatches).Matches.Count -ge 2) {
      return 4
    }

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
  param([string]$Comment)

  $InfoMatch = Select-String -inputObject $Comment -pattern $RegexILC -allMatches
  $Cleaned = ""

  Foreach ($Match in $InfoMatch.matches) {
    $Cleaned += "$Match`n"

  }

  return $Cleaned
}

function Delete-Comment {
  param([string]$FilePath, [string]$Comment)

  $Lines = Get-Content -path $FilePath -raw
  $Lines = $Lines.replace($Comment, "")
  Set-Content -path $FilePath -value $Lines
}

function Manage-Line {
  param([string]$Line, [int]$LineStatus)

  # Based on the line status we take an action
  Switch ($LineStatus) {

    # No comment, or uncommented line, or inside a multiline comment
    0 {
      # Check if we are currently inside a multiline comment
      if ($Global:MLCFlag) {
        $Global:MLCLines += "$Line`n"
      }

      break;
    }

    # Inline comment
    1 {

      # Check if the comment is code or useful info
      if (Check-Comment $Line) {
        $Global:CommentCounter += 1
        Print-Fixed-Comment $Line (Clean-Comment $Line)
      }
      break;
    }

    # Opening comment
    2 {
      $Global:MLCFlag = $true
      $Global:MLCLines = "$Line`n"

      break;
    }

    # Closing comment
    3 {
      $Global:MLCFlag = $false
      $Global:MLCLines += $Line

      if (Check-Comment $Global:MLCLines) {
        $Global:CommentCounter += 1
        Print-Fixed-Comment $Global:MLCLines (Clean-Comment $Global:MLCLines)
      }

      break;
    }

    # Multiple inline comments
    4 {
      $Comments = (Select-String $RegexMLCClosing -InputObject $Line).Matches
      $Comments += (Select-String $RegexILC -InputObject $Line -AllMatches).Matches
      $Comments += (Select-String $RegexMLCOpening -InputObject $Line).Matches

      Foreach ($Comment in $Comments) {
        # Write-Host $Comment
        if (Check-Comment $Comment) {
          Manage-Line $Comment (Check-Line $Comment)
        }
      }

      break;
    }

    default {
      Write-Host "Something unexpected happened."
      break;
    }
  }
}
