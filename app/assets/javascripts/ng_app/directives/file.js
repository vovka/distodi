var FileDirective = function() {
  return {
    scope: {
      file: '='
    },

    link: function(scope, el, attrs) {
      el.bind('change', function(event) {
        var files = event.target.files;
        if (files && files[0]) {
          var reader = new FileReader();
          reader.onload = function (e) {
            scope.$parent.newPhoto = true;
            scope.$parent.imagePreview = e.target.result;
            scope.$apply();
          };
          reader.readAsDataURL(files[0]);
        }
      });
    }
  };
};
