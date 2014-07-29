@zum.controller "zum.UploadsCtrl", ["$scope", "Upload", ($scope, Upload) ->

  $scope.uploads = Upload.all

  $scope.upload = ->
    if _.any $scope.files
      _.each $scope.files, (file) ->
        upload = new Upload()
        upload.type = 'Upload::File'
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
