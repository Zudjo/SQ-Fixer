function Print-Var {
  param([string]$Var, [string]$FileName, [int]$NumberOfVars)

  Write-Host "File: $FileName | Var number: $NumberOfVars"
  Write-Host "--------------------------------------------------"
  Write-Host $Var
  Write-Host
  Write-Host
}

function Update-Var {
  param([string]$FilePath)

  $Lines = Get-Content -path $FilePath -raw
  Write-Host $Lines
  $Lines = $Lines -replace "(?<!\w)var[^\w]","let "
  Write-Host "---------------------------------------"
  Write-Host $Lines
  Set-Content -path $FilePath -value $Lines
}

function Change-Var {
  param([string]$TargetDirectory)

  # Get all files and loop through them
  $Files = Get-ChildItem -path $TargetDirectory -recurse -file -filter "*.js"
  ForEach ($File in $Files) {

    $NumberOfFiles += 1

    # Get all lines as a string
    $Lines = Get-Content -path $File.FullName -raw

    Update-Var $File.FullName

  }
}
