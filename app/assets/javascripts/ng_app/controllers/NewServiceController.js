var NewServiceController = function ($scope) {
  var controller = this;

  $scope.imagePreview = [];
  $scope.newPhotoAttached = [];
  $scope.uploadValues = [];
  $scope.$watch("controller.images", function(){
    $scope.imagePreview.length = controller.images.length;
    $scope.newPhotoAttached.length = controller.images.length;
    $scope.uploadValues.length = controller.images.length;
  });

  $scope.deleteImage = function ($event, i) {
    controller.images[i] = " ";
    this.imagePreview[i] = " ";
    this.newPhotoAttached[i] = false;
    $event.currentTarget.previousElementSibling.value = null
  };

  $scope.changedCompany = function (options) {
    this.showInviteCompany = false;
    switch (this.company) {
      case options.myself:
        break;
      case options.other:
        this.showInviteCompany = true;
        break;
      default:
        break;
    }
  };

  $scope.changedServiceKind = function (options) {
    if (options.withText.indexOf(parseInt(this.serviceKind)) !== -1) {
      this.showServiceKindText = true;
    } else {
      this.showServiceKindText = false;
    }
  };
};
