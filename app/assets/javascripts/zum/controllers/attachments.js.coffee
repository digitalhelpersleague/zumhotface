@zum.controller "zum.AttachmentsCtrl", ["$scope", "Attachment", ($scope, Attachment) ->

  $scope.upload = ->
    if _.any $scope.files
      _.each $scope.files, (file) ->
        upload = new Attachment()
        upload.type = 'Attachment::File'
        upload.file = file
        upload.$save().then ->
          console.log upload
          file.uploaded = "true"
          file.link = upload.link

    #_.each
    #console.log $scope.files
    #formData = new FormData()
    #formData.append "files", $scope.files[0]
    #xhr = new XMLHttpRequest()
    #xhr.open "POST", "/uploads"
    #xhr.send formData
    #return false
]
