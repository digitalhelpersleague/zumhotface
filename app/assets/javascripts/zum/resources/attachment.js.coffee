@zum.factory "Attachment", ["$resource", ($resource) ->
  Attachment = $resource("/attachments/:id.json", { id: "@id" },
    update: {method: 'PUT'}
    save:
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
            fd.append "attachment[#{key}]", value
          return
        fd
  )

  Attachment
]
