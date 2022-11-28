# COSTANTS
# __________________________________________________
$CommentsExtensions = @("html", "cs", "php", "c", "cpp", "js", "css", "cshtml", "asp", "aspx")
$Commands = @("all", "delete-commented-code", "add-alt-attribute", "change-vars-to-lets", "delete-client-statics")
$Commands2 = @("add-alt-attribute", "change-vars-to-lets", "delete-client-statics")
$Commands3 = @("all", "delete-commented-code")

# FUNCTIONS
# __________________________________________________

function Check-Arguments {
  param([array]$Arguments)

  if (($Arguments[0] -eq $null) -or (-not (Is-Command $Arguments[0]))) {
    return "`n  Insert a valid command.`n"
  }

  if (($Arguments[1] -eq $null) -or (-not (Is-Path $Arguments[1]))) {
    return "`n  Insert a valid path as first parameter.`n"
  }

  if (($Commands2.contains($Arguments[0])) -and ($Arguments[2] -ne $null)) {
    return "`n  Too many arguments for this command.`n"
  }

  if (($Commands3.contains($Arguments[0])) -and (($Arguments[2] -eq $null) -or (-not (Is-Extension $Arguments[2])))) {
    return "`n  Insert a valid array of extensions as second parameter.`n"
  }

  return $true

}

function Is-Command {
  param([string]$Argument)

  if ($Commands.contains($Argument)) {
    return $true
  }
  return $false
}

function Is-Path {
  param([string]$Argument)

  if (Test-Path $Argument) {
    return $true
  }
  return $false
}

function Is-Extension {
  param([array]$Argument)

  if ($Argument[0] -eq "all") {
    return $true
  }

  foreach ($Extension in $Argument) {
    if (-not $CommentsExtensions.contains($Extension)) {
      return $false
    }
  }
  return $true
}

function Run-All {
  param([string]$Path, [array]$Extensions)

  $Commands = Get-ChildItem -path ".\libs\commands" -file

  foreach ($Command in $Commands) {
    Run-Command $Command.Name $Path $Extensions
  }
}
