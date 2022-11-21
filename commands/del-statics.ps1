
# Main
function Del-Statics {
  param([string]$TargetDirectory)

  $Directories = Get-ChildItem -path $TargetDirectory -recurse -attributes D

  Foreach ($Directory in $Directories) {
    If ($Directory.Name -eq "client") {
      If (Test-Path -path ($Directory.FullName + "\docs")) {
        $Path = $Directory.FullName + "\docs"
      } elseif (Test-Path -path ($Directory.FullName + "\dist")) {
        $Path = $Directory.FullName + "\dist"
      } else {
        Write-Host "'client' exists but neither '\docs' or '\dist' do"
      }
      break
    }
  }

  $Files = Get-ChildItem -path $Path -recurse -file -filter "*.html"
  $Files += Get-ChildItem -path $Path -recurse -file -filter "*.map"

  Foreach ($File in $Files) {
    Remove-Item $File.FullName
  }

  If ($Files.length) {
    Write-Host "Files deleted"
  } else {
    Write-Host "'client' doesn't exist or 0 files were found"
  }

}
