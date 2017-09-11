//= require angular
//= require angular-tour
//= require angular-tour/dist/angular-tour-tpls.min
//= require angular-cookie
//= require ./config
//= require_tree ./controllers

var distodiApp = angular.module("DistodiApp", ['angular-tour', 'ipCookie']);

distodiApp.config(["$httpProvider", Config])
.controller("ItemsController", ["$scope", "$http", "$q", 'ipCookie', ItemsController]);

distodiApp.controller("NotificationsController", ["$scope", "$http", NotificationsController]);