@zum.factory "Key", ["$resource", "data", ($resource, data) ->

  Key = $resource("/keys/:sid.json", { sid: "@sid" },
    update: {method: 'PUT'}
  )

  Key::init = ->
    if @created_at
      @created_at = new Date(@created_at)
    @

  cache = do ->
    if data.keys?
      _.map(data.keys, (params) ->
        key = new Key(params)
        key.init()
      )
    else
      Key.query()

  Key.all = cache

  Key
]
