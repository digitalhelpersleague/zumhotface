@zum.directive "ngFileread", ->
  restrict: "A"
  scope:
    ngFileread: '=',
  link: (scope, element, attributes) ->
    element.bind("change", (changeEvent) ->
      scope.$apply ->
        scope.ngFileread = changeEvent.target.files
    )
