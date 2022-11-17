function Save-Log {
  param([string]$FilePath)

  Out-File -FilePath ".\logs\var-to-let.log" -InputObject "Modified file: $FilePath`n`n" -Append -Encoding "utf8"
}

function Update-Var {
  param([string]$Lines, [string]$FilePath)
  $RegexVarLet = "(?<!\w)var[^\w]"

  if ($Lines -match $RegexVarLet) {
    $Lines = $Lines -replace $RegexVarLet,"let "
    Set-Content -path $FilePath -value $Lines
    return $true
  }
  return $false
}

function Change-Var {
  param([string]$TargetDirectory)
  $NumberOfModifiedFiles = 0
  $NumberOfVarsTotal = 0
  $Feedback = "Affected 'var's per file`n`n"

  # Get all files and loop through them
  $Files = Get-ChildItem -path $TargetDirectory -recurse -file -filter "*.js"
  ForEach ($File in $Files) {
    If (Check-Black-List $File.Name) {
      Continue
    }

    $FilePath = $File.FullName
    $NumberOfFiles += 1

    # Get all lines as a string
    $Lines = Get-Content -path $FilePath -raw

    if (Update-Var $Lines $FilePath) {
      $NumberOfVars = [regex]::matches($Lines, "(?<!\w)var[^\w]").count
      $Feedback += "  $NumberOfVars | " + $FilePath + "`n"
      $NumberOfModifiedFiles += 1
      $NumberOfVarsTotal += $NumberOfVars
      Save-Log $FilePath
    }
  }

  if ($NumberOfVarsTotal) {
    $S = "  Total 'var's deleted: $NumberOfVarsTotal`n"
    $S += "  Total files checked: $NumberOfFiles`n`n"
    $S += "$Feedback`n`n`n`n"
    Write-Host $S
  } else {
    Write-Host "'var's not found"
  }
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
