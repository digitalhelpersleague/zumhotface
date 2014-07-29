@zum.filter 'trimHttp', -> (text) ->
  text.replace(/https?:\/\//, "")
