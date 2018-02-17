var TopPanelController = function ($scope) {
  this.$scope = $scope;
};

TopPanelController.prototype.clickedToggleMoremenu = function(e) {
  if (this.$scope.$root.activePopup === "settings") {
    this.$scope.$root.activePopup = null;
  } else {
    this.$scope.$root.activePopup = "settings";
  }
  e.stopPropagation();
};

TopPanelController.prototype.clickedBlank = function() {
  this.$scope.$root.activePopup = null;
};

TopPanelController.prototype.showMoremenu = false;
