var SignInController = function($scope) {
  this.$scope = $scope;
  $scope.type = "password";
};

SignInController.prototype.showPassword = function() {
  this.$scope.type = "text";
};

SignInController.prototype.hidePassword = function() {
  this.$scope.type = "password";
};