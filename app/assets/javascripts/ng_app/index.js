//= require angular
//= require ./config
//= require_tree ./controllers

angular
.module("DistodiApp", [])
.config(Config)
.controller("ItemsController", ItemsController)
;
