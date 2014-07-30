@zum.filter 'trimHttp', -> (text) ->
  return if !text
  text.replace(/https?:\/\//, "")
