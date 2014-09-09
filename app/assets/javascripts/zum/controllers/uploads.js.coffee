@zum.controller "zum.UploadsCtrl", ["$scope", "Upload", "$http", "$timeout", ($scope, Upload, $http, $timeout) ->

  $scope.uploads = Upload.all

  $scope.total_size = (files) ->
    sum = 0
    _.each files, (file) ->
      sum += file.size
    sum

  $scope.destroy = (upload) ->
    upload.$delete()
    index = $scope.uploads.indexOf upload
    $scope.uploads.splice index, 1

  get_upload_progress = (progress_token, object) ->
    console.log object
    $http.get('/progress', { headers: { 'X-Progress-ID': progress_token } }).then (response) ->
      object.progress ||= {}
      object.progress.state = response.data.state
      object.progress.requests ||= 0
      object.progress.requests += 1

      if response.data.size and response.data.received
        object.progress.value = Math.round(response.data.received / response.data.size * 1000)/10
      else if response.data.state == "done"
        object.progress.value = 100

      if response.data.state == "done" or response.data.state == "error"
        return
      if object.progress.requests > 5 and !object.progress.value
        return

      $timeout (->
        get_upload_progress(progress_token, object)
      ), 800

  $scope.upload = ->
    if _.any $scope.files
      _.each $scope.files, (file) ->
        upload = new Upload()
        upload.file = file
        upload.generate_progress_token()
        upload.$save().then ->
          # success callback
          file.url = upload.url
          $scope.uploaded = true
        , (error) ->
          # error callback
          file.error = error.data.error
        get_upload_progress(upload.progress_token, file)
      return

    if !!$scope.link
      upload = new Upload()
      upload.link = $scope.link

    if !!$scope.code
      upload = new Upload()
      upload.code = $scope.code
      if $scope.lang
        upload.lang = $scope.lang

    if upload
      upload.generate_progress_token()
      upload.$save().then ->
        # success callback
        $scope.url = upload.url
        $scope.uploaded = true
      , (error) ->
        # error callback
        upload.error = error.data.error
      get_upload_progress(upload)
]
