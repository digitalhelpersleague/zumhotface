@zum.filter 'humanizeSize', -> (size, precision) ->
  return if !size?
  if !precision? or precision == 0 or precision == null
    precision = 1

  sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB']
  suffix = 0
  if (size < 1024)
    return size + " " + sizes[suffix]

  while( size >= 1024 )
    suffix++
    size = size / 1024
  
  return size.toFixed(precision) + " " + sizes[suffix]
