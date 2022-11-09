$RegexILC = '(?s)<!--.*?-->' # ILC: InLine Comment
$RegexIsCode = '(?s)(<\s*(?<tag>\s*\w+\/?\s*)(\s*\w+=".*?"\s*)*\s*>)(<\/(\k<tag>)>)?'
