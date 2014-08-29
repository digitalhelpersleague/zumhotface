@zum.controller "zum.AccountCtrl", ["$scope", "$http", ($scope, $http) ->

  $scope.generate_api_key = ->
    $http.put("/users/generate_api_key").success( (response) ->
      $scope.current_user.api_key = response.api_key
    ).error( (response) ->
      console.log response
    )

  $scope.destroy_api_key = ->
    $http.delete("/users/destroy_api_key").success( (response) ->
      $scope.current_user.api_key = response.api_key
    ).error( (response) ->
      console.log response
    )

]
