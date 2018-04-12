var ItemsController = function($scope, $http, $q, ipCookie, $window) {
  this.$http = $http;
  this.$q = $q;
  this.$window = $window;

  $scope.currentStep = ipCookie('DistodiApp') || 0;
  $scope.postStepCallback = function() {
    ipCookie('DistodiApp', $scope.currentStep, { path: "/" });
  };
};



ItemsController.prototype.clickedAllCheckbox = function() {
  this.checkboxes.changedAll();
  this._showServiceActions(this.checkboxes.isAnyChecked());
  this.showDetails = undefined;
};

ItemsController.prototype.changedCheckbox = function(i) {
  this.checkboxes.changed(i);
  this._showServiceActions(this.checkboxes.isAnyChecked());
  this.showDetails = undefined;
};

ItemsController.prototype.clickedView = function(locale) {
  if (this.serviceActions.view) {
    var selectedIndexes = this.checkboxes.selectedIndexes(),
        id = this._getIdsByIndexes(selectedIndexes)[0];
    this.$window.location.href = "/" + locale + "/services/" + id;
  }
};

ItemsController.prototype.clickedDelete = function(locale) {
  if (this.serviceActions.delete) {
    var selectedIndexes = this.checkboxes.selectedIndexes(),
        ids = this._getIdsByIndexes(selectedIndexes);
    if (confirm("Do you really want to delete the services?")) {
      var promises = [];
      for (var i in ids)
        promises.push( this.$http.delete("/" + locale + "/services/" + ids[i]) );
      this.$q.all(promises).then(function(response) { document.location.reload() });
    }
  }
};

ItemsController.prototype.clickedToggleTransfer = function(index) {
  this.showTransfer[index] = !this.showTransfer[index];
};

ItemsController.prototype._getIdsByIndexes = function(indexes) {
  var result = [];
  for (var i in indexes)
    result.push(this.ids[ indexes[i] ]);
  return result;
};

ItemsController.prototype._showServiceActions = function(status) {
  if (status) {
    var selectedIndexes = this.checkboxes.selectedIndexes();
    this.serviceActions.delete = this._doHavePermissions(selectedIndexes, "delete");
    this.serviceActions.view = selectedIndexes.length === 1;
  }
  this.serviceActions.show = (status && (this.serviceActions.delete || this.serviceActions.view));
};

ItemsController.prototype._doHavePermissions = function(indexes, permission) {
  for (var i = 0; i < indexes.length; i++)
    if (!this.permissions[ indexes[i] ][permission])
      return false;
  return true;
};

ItemsController.prototype.checkboxes = [];
ItemsController.prototype.checkboxes.all = false;
ItemsController.prototype.checkboxes.areAllChecked = function() {
  for (var i = 0; i < this.length; i++)
    if (this[i]) {
      if (i === this.length - 1)
        return true;
    } else
      return false;
};
ItemsController.prototype.checkboxes.isAnyChecked = function() {
  for (var i = 0; i < this.length; i++)
    if (this[i])
      return true;
    else
      if (i === this.length - 1)
        return false;
};
ItemsController.prototype.checkboxes.changed = function(i) {
  this.all = this.isAnyChecked();
};
ItemsController.prototype.checkboxes.changedAll = function() {
  for (var i = 0; i < this.length; i++)
    this[i] = this.all;
};
ItemsController.prototype.checkboxes.selectedIndexes = function() {
  var result = [];
  for (var i = 0; i < this.length; i++)
    if (this[i])
      result.push(i);
  return result;
};
ItemsController.prototype.serviceActions = { show: false };
ItemsController.prototype.showTransfer = [];
