@zum.directive "fileread", ->
  (scope, element, attributes) ->
    element.bind("change", (changeEvent) ->
      scope.$apply ->
        scope[attributes.fileread] = changeEvent.target.files
    )
