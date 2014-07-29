@zum.directive "fileread", ->
  scope:
    fileread: '=',
  link: (scope, element, attributes) ->
    element.bind("change", (changeEvent) ->
      scope.$apply ->
        scope.fileread = changeEvent.target.files
    )
