@zum.factory "Upload", ["$resource", "data", ($resource, data) ->

  Upload = $resource("/uploads/:sid.json", { sid: "@sid" },
    update: { method: 'PUT' }
    save:
      params:
        'X-Progress-ID': "@progress_token"
      method: 'POST'
      transformRequest: (data, getHeaders) ->
        headers = getHeaders()
        headers["Content-Type"] = undefined
        return data if data is undefined
        fd = new FormData()
        angular.forEach data, (value, key) ->
          if value instanceof FileList
            if value.length is 1
              fd.append key, value[0]
            else
              angular.forEach value, (file, index) ->
                fd.append "#{key}[#{index}]#{file}"
                return
          else
            fd.append "upload[#{key}]", value
          return
        fd
  )

  Upload::generate_progress_token = ->
    if not @progress_token
      @progress_token = ""
      i = 0
      while i < 64
        @progress_token += Math.floor(Math.random() * 16).toString(16)
        i++
      @progress_token

  Upload::init = ->
    if @created_at
      @created_at = new Date(@created_at)
    @

  cache = do ->
    if data.uploads?
      _.map(data.uploads, (params) ->
        upload = new Upload(params)
        upload.init()
      )
    #else
      #Upload.query()

  Upload.all = cache

  Upload
]
