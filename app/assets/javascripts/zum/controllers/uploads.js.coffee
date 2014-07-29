@zum.controller "zum.UploadsCtrl", ["$scope", "Upload", ($scope, Upload) ->

  $scope.uploads = Upload.all

  $scope.destroy = (upload) ->
    upload.$delete()
    index = $scope.uploads.indexOf upload
    $scope.uploads.splice index, 1

  $scope.upload = ->
    if _.any $scope.files
      _.each $scope.files, (file) ->
        upload = new Upload()
        upload.type = 'Upload::File'
        upload.file = file
        upload.$save().then ->
          file.uploaded = "true"
          file.url = upload.url
        $scope.uploaded = true
]
