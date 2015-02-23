@zum.controller "zum.MainCtrl", ["$scope", "data", "$location", ($scope, data, $location) ->
  $scope.current_user = data.current_user
  $scope.location = $location
]
