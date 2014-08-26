@zum.directive "zxcvbn", ->
  scope:
    zxcvbn: '=',
  link: (scope, element, attributes) ->
    element.bind "input", (changeEvent) ->
      scope.$apply ->
        scope.zxcvbn = if $(element).val() then zxcvbn($(element).val()) else null
