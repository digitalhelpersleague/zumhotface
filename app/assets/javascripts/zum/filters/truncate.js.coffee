@zum.filter 'truncate', -> (text, length=17, keep_extension=true) ->
  if text and text.length > length
    truncated = text.substring 0, length
    truncated = truncated + "..."if truncated.length < text.length-8
    truncated = truncated + text.substring Math.max(text.length-8, length), text.length if keep_extension
    truncated
  else text
