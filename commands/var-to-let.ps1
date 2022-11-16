function Write-Log {
  param([string]$FileName)
  $s = ""

  $s += "Modified file: $FileName"
  $s += "`n`n"

  Out-File -FilePath ".\logs\var-to-let.log" -InputObject $s -Append
}

function Update-Var {
  param([string]$FilePath)

  $Lines = Get-Content -path $FilePath -raw
  $Lines = $Lines -replace "(?<!\w)var[^\w]","let "
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
    Write-Log $File.FullName
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
