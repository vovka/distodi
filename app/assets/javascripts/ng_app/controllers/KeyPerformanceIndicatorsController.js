var KeyPerformanceIndicatorsController = function ($scope, $http) {
  this.$http = $http;
  this.$scope = $scope;
  var controller = this;

  $scope.onClick = function (points, evt) {
    console.log(points, evt);
  };

  $scope.onDateChange = function () {
    console.log(arguments);
    console.log($scope);
    controller.refresh();
  }
}

KeyPerformanceIndicatorsController.prototype.init = function (options) {
  var controller = this;
  for (key in options) {
    this[key] = options[key];
  }
  this.$scope.fromDate = new Date(this.fromDate);
  this.$scope.toDate = new Date(this.toDate);
  this.refresh();
};

KeyPerformanceIndicatorsController.prototype.refresh = function () {
  this.$http.get("/" + this.locale + "/items/" + this.itemId + "/charts.json?from_date=" + this.$scope.fromDate.toISOString() + "&to_date=" + this.$scope.toDate.toISOString())
    .then(
      function success(response) {
        for (chart in response.data) {
          this.$scope[chart] = response.data[chart];
        }
      }.bind(this),
      function failure(response) { console.log("Sorry, couldn't load charts"); }
    );
};
