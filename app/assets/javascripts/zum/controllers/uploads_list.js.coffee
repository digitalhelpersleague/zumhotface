@zum.controller "zum.UploadsListCtrl", ["$scope", "Upload", ($scope, Upload) ->

  $scope.uploads = Upload.all()

  $scope.destroy = (upload) ->
    upload.$delete().then ->
      $scope.uploads = _.without $scope.uploads, upload

  $scope.filter = ->
    unless $scope.q
      $scope.uploads = Upload.all()
      return
    $scope.uploads = _.filter Upload.all(), (upload) ->
      upload.name.toLowerCase().indexOf($scope.q.toLowerCase()) > -1
    return false

]
