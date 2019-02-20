//= require angular
//= require angular-cookie
//= require chosen
//= require angular-chosen-localytics/dist/angular-chosen
//= require angular-in-viewport
//= require chart.js/dist/Chart
//= require angular-chart.js/angular-chart
//= require ./config
//= require_tree ./controllers
//= require_tree ./directives
//= require_tree ./lib

angular.module("DistodiApp", ["ipCookie", "localytics.directives", "in-viewport", "chart.js"])

.config(["$httpProvider", Config])

.controller("ItemsController", ["$scope", "$http", "$q", "ipCookie", "$window", ItemsController])
.controller("SignInController", ["$scope", SignInController])
.controller("NotificationsController", ["$scope", "$http", NotificationsController])
.controller("NewItemController", ["$scope", NewItemController])
.controller("AccountEditController", ["$scope", "$timeout", "$http", "$q", AccountEditController])
.controller("TopPanelController", ["$scope", TopPanelController])
.controller("NewServiceController", ["$scope", NewServiceController])
.controller("KeyPerformanceIndicatorsController", ["$scope", "$http", KeyPerformanceIndicatorsController])

.directive("file", FileDirective)

;
