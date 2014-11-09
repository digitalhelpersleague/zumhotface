@zum.directive "ngZoomPreview", [ ->
  restrict: "A"
  link: (scope, element, attrs) ->
    element.bind "click", ->
      element.toggleClass('preview-fit')
]
