@zum.controller "zum.UploadsListCtrl", ["$scope", "Upload", ($scope, Upload) ->

  $scope.uploads = Upload.all()

  $scope.destroy = (upload) ->
    upload.$delete().then ->
      $scope.uploads = _.without $scope.uploads, upload

]
