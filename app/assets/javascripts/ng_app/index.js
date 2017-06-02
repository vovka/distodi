//= require angular
//= require ./config
//= require_tree ./controllers

angular
.module("DistodiApp", [])
.config(["$httpProvider", Config])
.controller("ItemsController", ["$scope", "$http", "$q", ItemsController])
;
