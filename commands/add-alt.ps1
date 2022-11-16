function Print-ImgTag {
  param([string]$ImgTag, [string]$FileName, [int]$NumberOfImgTags)
  $S = ""

  $S += "File: $FileName | ImgTag number: $NumberOfImgTags"
  $S += "--------------------------------------------------"
  $S += $ImgTag
  $S +=
  $S +=
}

function Update-ImgTag {
  param([string]$FilePath, [string]$ImgTag)

  $Lines = Get-Content -path $FilePath -raw

  $OldImgTag = $ImgTag
  $ImgTag = $ImgTag -replace "/>", ">"
  $ImgTag = $ImgTag -replace "(?<=[`"`'])>", " >"
  $Updated = $ImgTag -replace "(?<![\?`"`'])>", " alt=`"`" />"

  $Lines = $Lines.replace($OldImgTag, $Updated)
  Set-Content -path $FilePath -value $Lines
}

function Add-Alt {
  param([string]$TargetDirectory)

  # Get all files and loop through them
  try {
    $Files = Get-ChildItem -path $TargetDirectory -recurse -file -filter "*.*htm*"
    $Files += Get-ChildItem -path $TargetDirectory -recurse -file -filter "*.php"
  } catch {}
  ForEach ($File in $Files) {

    $NumberOfFiles += 1

    # Get all lines as a string
    $Lines = Get-Content -path $File.FullName -raw

    # Reset comments
    $ImgTags = $null

    # Get everything that is an img tag
    $ImgTags = (Select-String -Pattern "<ima?ge?\s(?!.*alt=`".*?`").*?[^\?]>" -InputObject $Lines -AllMatches).Matches

    ForEach ($ImgTag in $ImgTags) {

      # increment the counter, print the feedback and update the tag
      $NumberOfImgTagsFile += 1
      $NumberOfImgTagsTotal += 1
      Print-ImgTag $ImgTag $File.Name $NumberOfImgTagsTotal
      Update-ImgTag $File.FullName $ImgTag
    }

    if ($NumberOfImgTagsFile) {
      $Feedback += "  $NumberOfImgTagsFile | " + $File.FullName + "`n"
    }

    $NumberOfImgTagsFile = 0
  }
}
