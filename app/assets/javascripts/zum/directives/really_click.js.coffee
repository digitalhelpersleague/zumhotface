@zum.directive "ngReallyClick", [ ->
  restrict: "A"
  link: (scope, element, attrs) ->
    element.bind "click", ->
      message = attrs.ngReallyMessage
      scope.$apply attrs.ngReallyClick  if message and confirm(message)
]
