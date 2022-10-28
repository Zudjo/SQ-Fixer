# C:\Users\g.ziu\Desktop\Giorgio\testing\comment-remover
Clear-Host

# Constants
# $TargetDir = "C:\Users\g.ziu\Desktop\projects\primaton\versions\og\Primaton_TEST"
$TargetDir = "C:\xampp\htdocs\test\contrib\themes\primaton-theme\client"
# $TargetDir = ".\testt\"

# Lc: Line comment
# Mc: MultiLine comment
# Lcc: Line commented code
# Mcc: Multiline commented code
$RegexLc = '\s*<!--.*?-->\s*'
$RegexMcStart = '<!--'
# $RegexMcStart = '\s*<!--.*'
$RegexMcEnd = '-->'
# $RegexMcEnd = '.*-->\s*'
$RegexHTML = '(?<tag><\/?[a-zA-Z]+\s*(?<attr>\s*[a-zA-Z]+=".*"\s*)*?\s*>)'
# $RegexHTML = '(?<tag><[a-zA-Z]+?.*\/>).*?\k<tag>?'
# <[a-zA-Z]*?(\s*?(?<attr>[a-zA-Z:]*?=".*?")\s*?)*?\/?>
# $RegexHtmlLcc = '^\s*(<!--.*(<(?<tag>[a-zA-Z]+).*>).*(<\/(\k<tag>)>).*-->)\s*$'
# $RegexHtmlMcc = '(?<tag><\/?[a-zA-Z]+\s*(?<attr>\s*[a-zA-Z]+=".*"\s*)*\s*>)'

$CommentCounter = 0

# Functions
function Check-Line {
  param([string]$Line)
  # First of all we check if the line is a comment
  # then we check if it is commented code or a 'real'(useful) comment

  if ($Line -match $RegexLc) {
    return 1
  }

  if ($Line -match $RegexMcStart) {
    return 2
  }

  if ($Line -match $RegexMcEnd) {
    return 3
  }

  return 0

}

function Check-Comment {
  param([string]$Comment, [bool]$Multiline)

  if ($Multiline -eq $false) {
    if ($Comment -match $RegexHTML) {

      return $true
    }
  } elseif ($Comment -match $RegexHTML) {

    return $true
  }
  return $false
}

function Delete-Comment {
  param([string]$FilePath, [string]$Comment)

  $Lines = Get-Content -path $FilePath -raw
  $Lines = $Lines.replace($Comment, "")
  Set-Content -path $FilePath -value $Lines

}

function Clean-Comment {
  # This function removes from the string-to-be-removed
  # the pieces out of the comment but in the same line
  param([string]$Comment)
  Write-Host $Comment
  $Gino = $Comment.ToString()
  Write-Host $Gino
  $Cleaned = Select-String -inputObject $Gino -pattern '<!--(\n?.*?\n?)*?-->'

  Write-Host "Cleaned:`r`n$Cleaned"

  return $Cleaned
}

# ------------------------------
# Main - start
# ------------------------------

$Files = Get-ChildItem -path $TargetDir -recurse -file -filter *.html

ForEach ($File in $Files) {
  # Write-Host "File: $File"
  $Lines = Get-Content -path $File.FullName
  $McFlag = $false
  ForEach ($Line in $Lines) {
    # if ($Line.length -gt 50000) {
    #   Write-Host "This line is too big to process ("$Line.length" lines)"
    #   $Line
    #   break
    # }


    $CommentType = Check-Line $Line
    # Write-Host "CommentType: $CommentType"

    if ($McFlag -eq $true) {
      $McLines += "$Line`r`n"
    }

    if ($McFlag -eq $true -and $CommentType -eq 2) {
      $McLines += "$Line`r`n"
      $McFlag = $false
      if (Check-Comment $McLines $true) {
        $CommentCounter += 1
        $Cleaned = ([regex]'(?s)(<!--.*?-->)').Match($McLines).Groups[1].Value
        if ($args[0] -eq "delete") {
          Delete-Comment $File.FullName $Cleaned
        }
        # Clean-Comment $Line
        Write-Host "File: $File"
        Write-Host "Comment number: $CommentCounter"
        Write-Host "--------------------------------------------------"
        Write-Host "Deleted comment:`r`n$Cleaned"
        Write-Host
        Write-Host
    }}

    if ($CommentType -eq 1) {
      if (Check-Comment $Line $false) {
        $CommentCounter += 1
        $Cleaned = ([regex]'(?s)(<!--.*?-->)').Match($Line).Groups[1].Value
        if ($args[0] -eq "delete") {
          Delete-Comment $File.FullName $Cleaned
        }

        # Clean-Comment $Line

        Write-Host "File: $File"
        Write-Host "--------------------------------------------------"
        Write-Host "Deleted comment:`r`n$Cleaned"
        Write-Host
        Write-Host
        # $Cleaned = Select-String -inputObject $Gino -pattern '(?s)<!--.*?-->'
      }

    } elseif ($CommentType -eq 2) {
      $McFlag = $true
      $McLines = "$Line`r`n"

    } elseif ($CommentType -eq 3) {
      $McFlag = $false
      if (Check-Comment $McLines $true) {
        $CommentCounter += 1
        $Cleaned = ([regex]'(?s)(<!--.*?-->)').Match($McLines).Groups[1].Value
        if ($args[0] -eq "delete") {
          Delete-Comment $File.FullName $Cleaned
        }
        # Clean-Comment $Line
        Write-Host "File: $File"
        Write-Host "Comment number: $CommentCounter"
        Write-Host "--------------------------------------------------"
        Write-Host "Deleted comment:`r`n$Cleaned"
        Write-Host
        Write-Host
        # $Cleaned = $McLines | Select-String -pattern '(?s)<!--.*?-->'


      }
    }

  }
}

Write-Host
Write-Host
Write-Host "Total: $CommentCounter"

# ------------------------------
# Main - end
# ------------------------------
