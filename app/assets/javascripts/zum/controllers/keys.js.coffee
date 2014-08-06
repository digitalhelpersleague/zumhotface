@zum.controller "zum.KeysCtrl", ["$scope", "Key", ($scope, Key) ->

  $scope.keys = Key.all

  $scope.destroy = (key) ->
    key.$delete()
    index = $scope.keys.indexOf key
    $scope.keys.splice index, 1

  #$scope.key = ->
    #if _.any $scope.files
      #_.each $scope.files, (file) ->
        #key = new Key()
        #key.file = file
        #key.$save().then ->
          #file.url = key.url
          #$scope.keyed = true
      #return

    #if !!$scope.link
      #key = new Key()
      #key.link = $scope.link

    #if !!$scope.code
      #key = new Key()
      #key.code = $scope.code

    #if key
      #key.$save().then ->
        #$scope.url = key.url
        #$scope.keyed = true

]
