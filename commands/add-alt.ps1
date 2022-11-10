function Print-ImgTag {
  param([string]$ImgTag, [string]$FileName, [int]$NumberOfImgTags)

  Write-Host "File: $FileName | ImgTag number: $NumberOfImgTags"
  Write-Host "--------------------------------------------------"
  Write-Host $ImgTag
  Write-Host
  Write-Host
}

function Update-ImgTag {
  param([string]$FilePath, [string]$ImgTag)

  $Lines = Get-Content -path $FilePath -raw

  $ImgTag = $ImgTag.Replace("/>", ">")
  $Updated = $ImgTag.Replace(">", " alt=`"`"/>")

  $Lines = $Lines.replace($ImgTag, $Updated)
  Set-Content -path $FilePath -value $Lines
}

function Add-Alt {
  param([string]$TargetDirectory)

  # Get all files and loop through them
  $Files = Get-ChildItem -path $TargetDirectory -recurse -file -filter "*.*htm*"
  ForEach ($File in $Files) {

    $NumberOfFiles += 1

    # Get all lines as a string
    $Lines = Get-Content -path $File.FullName -raw

    # Reset comments
    $ImgTags = $null

    # Get everything that is a comment
    $ImgTags = (Select-String -Pattern "<ima?ge?(?!.*alt=`".*?`").*?>" -InputObject $Lines -AllMatches).Matches

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