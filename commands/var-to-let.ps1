function Print-Var {
  param([string]$Var, [string]$FileName, [int]$NumberOfVars)
  $s = ""

  $s += "File: $FileName | Var number: $NumberOfVars"
  $s += "--------------------------------------------------"
  $s += "$Var"
  $s += "`n`n"


  Out-File -FilePath "var-to-let.log" -InputObject $s -Append
}

function Update-Var {
  param([string]$FilePath)

  $Lines = Get-Content -path $FilePath -raw
  # $Comments = (Select-String -Pattern $RegexILC -InputObject $Lines -AllMatches).Matches

  $Lines = $Lines -replace "(?<!\w)var[^\w]","let "
  # Write-Host "---------------------------------------"
  # Write-Host $Lines
  Set-Content -path $FilePath -value $Lines
}

function Change-Var {
  param([string]$TargetDirectory)

  # Get all files and loop through them
  $Files = Get-ChildItem -path $TargetDirectory -recurse -file -filter "*.js"
  ForEach ($File in $Files) {
    If (Check-Black-List $File.Name) {
      Continue
    }

    $NumberOfFiles += 1

    # Get all lines as a string
    $Lines = Get-Content -path $File.FullName -raw

    Update-Var $File.FullName
    Print-Var $Lines $File.FullName 0
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
