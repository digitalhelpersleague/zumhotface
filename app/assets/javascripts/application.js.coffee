#= require jquery
#= require jquery_ujs
#
#= require bootstrap-sass-official/bootstrap/transition
#= require bootstrap-sass-official/bootstrap/alert
#= require bootstrap-sass-official/bootstrap/collapse
#= require bootstrap-sass-official/bootstrap/button
#= require bootstrap-sass-official/bootstrap/modal
#
#= require lodash
#= require moment
#
#= require angular
#= require angular-animate
#= require angular-resource
#= require angular-sanitize
#= require angular-moment
#= require vendor/bindonce
#
#= require ng-rails-csrf
#
#= require_self
#= require_tree .

@zum = angular.module 'zum', ['ngResource', 'ng-rails-csrf', 'ngSanitize', 'angularMoment', 'ngAnimate', 'pasvaz.bindonce']
@zum.value 'data', window.gon

$ ->
  $('.alert-dismissible[role="alert"]').delay(12000).fadeOut('slow')
