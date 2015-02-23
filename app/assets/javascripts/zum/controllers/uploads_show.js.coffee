@zum.controller 'zum.UploadsShowCtrl', ['$scope', '$anchorScroll', ($scope, $anchorScroll) ->

  $scope.$on '$locationChangeSuccess', ->
    line = $scope.location.path().substring(1)
    angular.element('.highlight > pre > span').removeClass('hll')
    angular.element('#'+line).addClass('hll')
]
