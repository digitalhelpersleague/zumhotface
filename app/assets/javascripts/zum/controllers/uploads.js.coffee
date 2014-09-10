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
    #TODO: smooth progress raising
    # get real progress every second
    # count current progress based on avg speed
    
    object.progress ||= {}

    if object.progress.synced_at
      time_passed = new Date() - object.progress.synced_at
      console.log time_passed

      if object.progress.speed and object.progress.total
        object.progress.value = Math.min((object.progress.uploaded + time_passed * object.progress.speed) / object.progress.total, 100)

      if time_passed < 1000
        console.log object.progress
        $timeout (->
          get_upload_progress(progress_token, object)
        ), 50
        return

    $http.get('/progress', { headers: { 'X-Progress-ID': progress_token } }).then (response) ->
      
      console.log "get"
      #console.log response

      object.progress.state = response.data.state
      object.progress.requests ||= 0
      object.progress.requests += 1

      object.progress.synced_at = new Date()

      if response.data.size and response.data.received
        object.progress.total ||= response.data.size
        if time_passed
          object.progress.speed = (response.data.received - object.progress.uploaded) / time_passed
        object.progress.uploaded = response.data.received
        progress = Math.round(response.data.received / response.data.size * 1000) / 10
        if !object.progress.value or progress > object.progress.value
          object.progress.value = progress
      else if response.data.state == "done"
        object.progress.value = 100

      if response.data.state == "done" or response.data.state == "error"
        console.log object.progress
        return
      if object.progress.requests > 5 and !object.progress.value
        console.log object.progress
        return

      console.log object.progress

      $timeout (->
        get_upload_progress(progress_token, object)
      ), 50

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
