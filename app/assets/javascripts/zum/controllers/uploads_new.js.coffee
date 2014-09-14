@zum.controller "zum.UploadsNewCtrl", ["$scope", "Upload", "$http", "$timeout", ($scope, Upload, $http, $timeout) ->

  $scope.total_size = (uploads) ->
    sum = 0
    _.each uploads, (upload) ->
      sum += upload.size
    sum

  $scope.$watchCollection 'files', (files) ->
    return unless _.any files
    $scope.uploads ||= []
    if _.isArray(files) or (files instanceof FileList)
      _.each files, (params) -> append_upload(params)
    else
      append_upload(files)

  $scope.remove_upload = (target) ->
    $scope.uploads = _.without $scope.uploads, target

  $scope.submit_uploads = ->
    if _.any $scope.upload
      append_upload $scope.upload
      $scope.upload = null
    if _.any $scope.uploads
      _.each $scope.uploads, (upload) ->
        $scope.perform_upload(upload)

  $scope.perform_upload = (upload) ->
    if !upload.uploading and !upload.sid
      upload.generate_progress_token()
      upload.uploading = true
      upload.$save().then ->
        return
      , (error) ->
        upload.error = error.data.error
      get_upload_progress(upload)

  append_upload = (new_upload) ->
    $scope.uploads ||= []
    if new_upload instanceof File
      upload = new Upload(file: new_upload)
    else
      upload = new Upload(new_upload)
    upload.init()
    $scope.uploads.push(upload)

  get_upload_progress = (upload) ->
    upload.progress = {} unless upload.progress
    if upload.progress.synced_at
      time_passed = new Date() - upload.progress.synced_at
      if upload.progress.speed and upload.progress.total
        upload.progress.value =
          Math.min(
            Math.round(
              (upload.progress.uploaded + (time_passed * upload.progress.speed)) / upload.progress.total * 1000
            ) / 10
          , 100)

      if time_passed < 1000
        $timeout (->
          get_upload_progress(upload)
        ), 50
        return

    $http.get('/progress', { headers: { 'X-Progress-ID': upload.progress_token } }).then (response) ->

      upload.progress = {} unless upload.progress
      upload.progress.state = response.data.state
      upload.progress.requests ||= 0
      upload.progress.requests += 1
      upload.progress.synced_at = new Date()

      if response.data.size and response.data.received
        upload.progress.total ||= response.data.size
        if time_passed
          upload.progress.speed = (response.data.received - upload.progress.uploaded) / time_passed
        upload.progress.uploaded = response.data.received
        progress = Math.round(response.data.received / response.data.size * 1000) / 10
        if !upload.progress.value or progress > upload.progress.value
          upload.progress.value = progress
      else if response.data.state == "done"
        upload.progress.value = 100

      if response.data.state == "done"
        return

      if response.data.state == "error" or (upload.progress.requests > 5 and !upload.progress.value)
        upload.error = 'Unknown error'
        return

      $timeout (->
        get_upload_progress(upload)
      ), 50

]
