# COSTANTS
# __________________________________________________

# FUNCTIONS
# __________________________________________________

function Manage-Line {
  param([int]LineStatus)

  # Based on the line status we take an action
  Switch ($LineStatus) {

    # No comment, nothing to do here
    0 {break;}

    # Inline comment
    1 {

      # Check if the comment is code or useful info
      if (Check-Comment $Line) {
        $Cleaned = Clean-Comment $File.FullName $Line
      }
      break;
    }

    # Opening comment
    2 {
      break;
    }

    # Closing comment
    3 {
      break;
    }

    # Multiple inline comments
    4 {
      Write-Host "bruh $Line"
      break;
    }

    default {
      Write-Host "Something unexpected happened."
      break;
    }
  }
}
