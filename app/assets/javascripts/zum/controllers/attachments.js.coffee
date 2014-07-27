@zum.controller "zum.AttachmentsCtrl", ["$scope", "Attachment", ($scope, Attachment) ->
  
  $scope.link = $scope.files = $scope.code = null

  $scope.ready = $scope.link || $scope.files || $scope.code

]
