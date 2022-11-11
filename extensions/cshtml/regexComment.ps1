$RegexILC = '(?s)@\*.*?\*@' # ILC: InLine Comment
$RegexIsCode = '(?sm)(((<\s*(?<tag>\s*\w+\/?\s*)(\s*\w+=".*?"\s*)*\s*>)(<\/(\k<tag>)>)?)|({.*})|(;\s*$)|(\(.*\)))'
