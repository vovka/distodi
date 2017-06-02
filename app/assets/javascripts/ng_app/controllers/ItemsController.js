var ItemsController = function($scope, $http, $q) {
  this.$http = $http;
  this.$q = $q;
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

ItemsController.prototype.clickedView = function(i) {
  if (undefined !== i || this.serviceActions.view) {
    if (i === undefined)
      i = this.checkboxes.selectedIndexes()[0];
    if (this.showDetails === undefined || this.showDetails !== i)
      this.showDetails = i;
    else
      if (this.showDetails === i)
        this.showDetails = undefined;
  }
};

ItemsController.prototype.clickedDelete = function(i) {
  if (this.serviceActions.delete) {
    var selectedIndexes = this.checkboxes.selectedIndexes(),
        ids = this._getIdsByIndexes(selectedIndexes);
    if (confirm("Do you really want to delete the services?")) {
      var promises = [];
      for (var i in ids)
        promises.push( this.$http.delete("/services/" + ids[i]) );
      this.$q.all(promises).then(function(response) { document.location.reload() });
    }
  }
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
// ItemsController.prototype.checkboxes.isNoneChecked = function() {
//   return !this.isAnyChecked();
// };
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
