var AccountEditController = function($scope, $timeout, $http, $q) {
  this.$http = $http
  this.$q = $q;
  var controller = this;

  this.setProfile = function (data) {
    $scope.country = data.country_short;
    $scope.city = data.city;
    $scope.formattedAddress = data.address;
    $scope.postalCode = data.postal_code;
  };

  $scope.changedPostalCode = function() {
    if (this.addressesHintsPromise) {
      $timeout.cancel(this.addressesHintsPromise)
    }
    var self = this;
    this.addressesHintsPromise = $timeout(function() {
      controller.initAddressesHint(self);
    }, 1000);
  };

  $scope.addressSelected = function(i) {
    controller.selectedAddress(this.$parent, this.address);
  };

  $scope.clickedBlank = function () {
    this.addresses = [];
  };
};

AccountEditController.prototype.initAddressesHint = function($scope) {
  if ($scope.postalCode !== "") {
    this.$http.get("/addresses?q=" + $scope.postalCode).then(
      function success(response) { $scope.addresses = response.data.map(function(i) { return i.data }); },
      function failure() {}
    );
  }
};

AccountEditController.prototype.selectedAddress = function($scope, address) {
  new AddressMap($scope, address).setValues();
  $scope.addresses = [];
};



var AddressMap = function($scope, address) {
  this.$scope = $scope;
  this.address = address;
}

AddressMap.prototype.setValues = function() {
  this.$scope.formattedAddress = this.address.formatted_address;
  var country = this.address.address_components.find(function (i) {
    return JSON.stringify(i["types"]) === JSON.stringify(["country", "political"]);
  });
  var postalCode = this.address.address_components.find(function (i) {
    return JSON.stringify(i["types"]) === JSON.stringify(["postal_code"]);
  });
  var city = this.address.address_components.find(function (i) {
    return JSON.stringify(i["types"]) === JSON.stringify(["locality", "political"]);
  });
  this.$scope.country = country.short_name;
  this.$scope.city = city.long_name;
  this.$scope.postalCode = postalCode.long_name;
};
