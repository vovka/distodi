var file = new FileReader();

var FileDirective = function() {
  return {
    scope: {
      file: '='
    },

    link: function(scope, el, attrs) {
      el.bind('change', function(event) {
        var files = event.target.files;
        if (files && files[0]) {
          file.onload = function (e) {
            var i = event.currentTarget.dataset.index;
            scope.$parent.newPhotoAttached[i] = true;
            scope.$parent.imagePreview[i] = e.target.result;
            scope.$apply();
          };
          file.readAsDataURL(files[0]);
        }
      });
    }
  };
};
