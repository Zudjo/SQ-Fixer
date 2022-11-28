# VARIABLES
# __________________________________________________

# FUNCTIONS
# __________________________________________________

function Get-Files {
  param([string]$Path, [string]$Extension)

  $Files = Get-ChildItem -path $Path -recurse -file -filter "*.$Extension"

  if (-not $Files) {
    return
  }

  return $Files
}

function Get-Matches {
  param([string]$Lines, [string]$Regex)

  # Return every match of regex
  return (Select-String -Pattern $Regex -InputObject $Lines -AllMatches).Matches
}

function Run-Command {
  param([string]$Command, [string]$Path, [array]$Extensions)

  # Import command data
  . ".\libs\commands\$Command"

  # Get all files under path for each extension
  $Files = @()
  foreach ($Extension in $Extensions) {
    $Files += Get-Files $Path $Extension
  }

  # Set counters
  $NumberCheckedFiles = 0
  $NumberAffectedFiles = 0

  # Loop through each file
  foreach ($File in $Files) {

    if (Manage-File $File) {
      $NumberAffectedFiles += 1
    }

    # Increment counter
    $NumberCheckedFiles += 1
  }

  return Get-Feedback $NumberCheckedFiles $NumberAffectedFiles

}
