var NewItemController = function ($scope) {
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
};
