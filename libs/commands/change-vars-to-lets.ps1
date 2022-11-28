# CONSTANTS
# __________________________________________________
$Extensions = @("js", "ts")

# VARIABLES
# __________________________________________________
$GLOBAL:NumberVarsTot = 0
$GLOBAL:Feedback = "Affected 'var's per file`n`n"

# FUNCTIONS
# __________________________________________________
function Save-Log {
  param([string]$FilePath, [int]$NumberVarsFile)
  $S = ""

  # If it's the first fix of the scan, print separator
  if ($GLOBAL:NumberVarsTot -eq 0) {
    $S += "**********************************************************************`n"
  }

  $S += "$NumberVarsFile | $FilePath`n"

  Out-File -FilePath ".\logs\change-vars-to-lets.log" -InputObject $S -Append -Encoding "utf8"
}

function Get-Feedback {
  param([int]$NumberCheckedFiles, [int]$NumberAffectedFiles)

  $S = "**********************************************************************`n"
  $S += "Change vars to lets`n"
  $S += "**********************************************************************`n"
  $S += "  Total 'var's deleted: $GLOBAL:NumberVarsTot`n"
  $S += "  Total files checked: $NumberCheckedFiles`n"
  $S += "  Total files affected: $NumberAffectedFiles`n`n`n"

  if ($GLOBAL:NumberVarsTot) {
    $S += "$GLOBAL:Feedback`n`n"
  }

  return $S
}

function Check-Black-List {
  param([string]$String)
  $BlackList = @("jquery", "angular", "modernizr")

  ForEach ($Black in $BlackList) {
    If ($String -match $Black) {
      return $true
    }
  }
  return $false
}

function Fix-Vars {
  param([string]$Lines)
  $RegexVarLet = "(?<!\w)var[^\w]"

  if ($Lines -match $RegexVarLet) {
    return $Lines -replace $RegexVarLet,"let "
  }
  return $false
}

function Manage-File {
  param($File)

  # Check if file is in blacklist
  If (Check-Black-List $File.Name) {
    Continue
  }

  # Initialize counter
  $NumberVarsFile = 0

  # Get all lines of file as a string
  $Lines = Get-Content -path $File.FullName -raw

  # Get number of 'var' matches
  $NumberVarsFile = (Select-String -inputObject $Lines -pattern "(?<!\w)var[^\w]" -allMatches).matches.count

  if ($NumberVarsFile) {
    # Fix 'var's
    $Lines = Fix-vars $Lines

    # Overwrite file with fixes
    Set-Content -path $File.FullName -value $Lines

    # Save feedback in the logs
    Save-Log $File.Name $NumberVarsFile

    # Update feedback
    $GLOBAL:Feedback += "  $NumberVarsFile | " + $File.FullName + "`n"

    # Increment counter
    $GLOBAL:NumberVarsTot += $NumberVarsFile

    return $true
  }

  return $false
}
