Clear-Host
# IMPORTS
# __________________________________________________
. ".\libs\main-lib.ps1"

# VARIABLES
# __________________________________________________

# MAIN
# __________________________________________________

# Check if signature is ok
# If not, print feedback and interrupt
$Check = Check-Arguments $args
if ($Check -ne $true) {
  Write-Host $Check
  exit
}

# Import commands funcions
. ".\libs\commands-lib.ps1"

# Check if command is "all"
if ($args[0] -eq "all") {
  Run-All $args[1] $args[2]
} else {
  Run-Command $args[0] $args[1] $args[2]
}
