@zum.factory "Attachment", ["$resource", ($resource) ->
  Attachment = $resource("/attachments/:id.json", { id: "@id" },
    update: {method: 'PUT'}
  )

  Attachment
]
