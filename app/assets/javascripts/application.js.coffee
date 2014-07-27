#= require jquery
#= require jquery_ujs
#####=#  require turbolinks
#= require bootstrap-sass-official
#= require lodash
#= require moment
#
#= require angular
#= require angular-animate
#= require angular-resource
#= require angular-sanitize
#= require angular-moment
#
#= require jquery-file-upload/jquery.fileupload
#= require jquery-file-upload/jquery.fileupload-angular
#= require jquery-file-upload/jquery.iframe-transport
#
#= require ng-rails-csrf 
#
#= require_self
#= require_tree .

@zum = angular.module 'zum', ['ngResource', 'ng-rails-csrf', 'ngSanitize', 'angularMoment', 'ngAnimate', 'blueimp.fileupload']
