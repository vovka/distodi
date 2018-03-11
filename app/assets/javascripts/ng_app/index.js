//= require angular
//= require angular-cookie
//= require chosen
//= require angular-chosen-localytics/dist/angular-chosen
//= require angular-in-viewport
//= require ./config
//= require_tree ./controllers
//= require_tree ./directives

angular.module("DistodiApp", ["ipCookie", "localytics.directives", "in-viewport"])

.config(["$httpProvider", Config])

.controller("ItemsController", ["$scope", "$http", "$q", "ipCookie", "$window", ItemsController])
.controller("SignInController", ["$scope", SignInController])
.controller("NotificationsController", ["$scope", "$http", NotificationsController])
.controller("NewItemController", ["$scope", NewItemController])
.controller("AccountEditController", ["$scope", "$timeout", "$http", "$q", AccountEditController])
.controller("TopPanelController", ["$scope", TopPanelController])
.controller("NewServiceController", ["$scope", NewServiceController])

.directive("file", FileDirective)

;
