Clear-Host
# IMPORTS
# __________________________________________________

# COSTANTS
# __________________________________________________
$Extensions = @("html", "cs", "php", "c", "cpp", "js", "css", "cshtml", "asp", "aspx")

# VARIABLES
# __________________________________________________

# FUNCTIONS
# __________________________________________________
function Set-TargetExtension {
  Write-Host
  For ($i = 1; $i -le $Extensions.Length; ++$i) {
    Write-Host "  $i. "$Extensions[$i-1]
  }
  Write-Host "`n  0. Exit`n"

  $Choice = Read-Host -prompt "Choose the file extension to check"

  if ([int]$Choice -le 0) {
    exit
  } else {
    if ([int]$Choice -le $Extensions.Length) {
      Clear-Host
      return $Extensions[$Choice-1]
    } else {
      Clear-Host
      Write-Host "`nSelect a valid option from the list`n"
      Set-TargetExtension
    }
  }
}

function Set-TargetDirectory {
  $Path = Read-Host -prompt "`nInsert path to check"

  if (Test-Path $Path){
    Clear-Host
    return $Path
  } else {
    Clear-Host
    Write-Host "`nThe inserted path doesn't exists.`n"
    Set-TargetDirectory
  }
}

# MAIN
# __________________________________________________

switch ($args[0]) {
  "delete" {
    . ".\commands\delete.ps1"
    $TargetDirectory = Set-TargetDirectory
    $TargetExtension = Set-TargetExtension
    Out-File -FilePath ".\logs\delete.log" -InputObject "++++++++++++++++++++" -Append -Encoding "utf8"
    Delete-Comments $TargetDirectory $TargetExtension
    break
  }

  "add-alt" {
    . ".\commands\add-alt.ps1"
    $TargetDirectory = Set-TargetDirectory
    Out-File -FilePath ".\logs\add-alt.log" -InputObject "++++++++++++++++++++" -Append -Encoding "utf8"
    Add-Alt $TargetDirectory
    break
  }

  "var-to-let" {
    . ".\commands\var-to-let.ps1"
    $TargetDirectory = Set-TargetDirectory
    Out-File -FilePath ".\logs\var-to-let.log" -InputObject "++++++++++++++++++++" -Append -Encoding "utf8"
    Change-Var $TargetDirectory
    break
  }

  "del-statics" {
    . ".\commands\del-statics.ps1"
    $TargetDirectory = Set-TargetDirectory
    Del-statics $TargetDirectory
    break
  }

  "all" {
    . ".\commands\delete.ps1"
    $TargetDirectory = Set-TargetDirectory
    Out-File -FilePath ".\logs\delete.log" -InputObject "++++++++++++++++++++" -Append -Encoding "utf8"
    ForEach ($Extension in $Extensions) {
      Delete-Comments $TargetDirectory $Extension $false
    }
    Write-Host "`n`n`n"
    . ".\commands\add-alt.ps1"
    Out-File -FilePath ".\logs\add-alt.log" -InputObject "++++++++++++++++++++" -Append -Encoding "utf8"
    Add-Alt $TargetDirectory
    . ".\commands\var-to-let.ps1"
    Out-File -FilePath ".\logs\var-to-let.log" -InputObject "++++++++++++++++++++" -Append -Encoding "utf8"
    Change-Var $TargetDirectory
    break
  }

  Default {
    Write-Host "`n  Insert a valid command.`n"
    break
  }
}
