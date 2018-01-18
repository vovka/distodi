//= require angular
//= require angular-tour
//= require angular-tour/dist/angular-tour-tpls.min
//= require angular-cookie
//= require chosen
//= require angular-chosen-localytics/dist/angular-chosen
//= require angular-inview
//= require ./config
//= require_tree ./controllers
//= require_tree ./directives

angular.module("DistodiApp", ['angular-tour', 'ipCookie', "localytics.directives"])
angular.module("DistodiApp", ['angular-tour', 'ipCookie', 'angular-inview'])

.config(["$httpProvider", Config])

.controller("ItemsController", ["$scope", "$http", "$q", 'ipCookie', ItemsController])
.controller("SignInController", ["$scope", SignInController])
.controller("NotificationsController", ["$scope", "$http", NotificationsController])
.controller("NewItemController", ["$scope", NewItemController])
.controller("AccountEditController", ["$scope", "$timeout", "$http", "$q", AccountEditController])
.controller("TopPanelController", ["$scope", TopPanelController])
.controller("NewServiceController", ["$scope", NewServiceController])

.directive('file', FileDirective);
