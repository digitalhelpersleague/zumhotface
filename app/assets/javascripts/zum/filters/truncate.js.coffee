@zum.filter 'truncate', -> (text, length, by_words=true) ->
  if text and text.length > length
    truncated = text.substring 0, length
    truncated = truncated.substring(0, truncated.lastIndexOf(' ')) if by_words
    truncated = truncated + "..." unless truncated[truncated.length-1] is '.'
    truncated
  else text
