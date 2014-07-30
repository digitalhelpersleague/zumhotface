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
        upload.file = file
        upload.$save().then ->
          file.url = upload.url
          $scope.uploaded = true
      return

    if !!$scope.link
      upload = new Upload()
      upload.link = $scope.link

    if !!$scope.code
      upload = new Upload()
      upload.code = $scope.code

    if upload
      upload.$save().then ->
        $scope.url = upload.url
        $scope.uploaded = true

]
