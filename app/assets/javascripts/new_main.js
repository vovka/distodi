$(document).ready(function() {
  $('.btn_menu').click(function() {
    $('.menu ul').slideToggle();
  });
  $("#owl-example").owlCarousel({
    items: 1.63,
    itemsDesktop: [1199,1.63],
    navigationText: false,
    autoPlay: true,
    itemsDesktopSmall: [900, 1.7],
    itemsTablet: [600, 1.2], //2 items between 600 and 0;
    itemsMobile: false // itemsMobile disabled - inherit from itemsTablet option
  });
  $("#owl-example_mobile_items").owlCarousel({
    navigationText: false,
    items: 14.5, //10 items above 1000px browser width
    itemsDesktop: [1515, 12], //5 items between 1000px and 901px
    itemsDesktopSmall: [1240, 8], // betweem 900px and 601px
    itemsTablet: [800, 4.7],
    itemsTabletSmall: [550, 3.8],
    itemsMobile: [390, 2.8], //2 items between 600 and 0;
  });

  $('.btn_menu').click(function() {
    $(this).toggleClass('active');
    $('.menu_mobile').toggleClass('active');
  });

  var inputs = document.querySelectorAll('.inputfile');
  Array.prototype.forEach.call(inputs, function(input) {
    var label = input.nextElementSibling,
      labelVal = label.innerHTML;

    input.addEventListener('change', function(e) {
      var fileName = '';
      if (this.files && this.files.length > 1)
        fileName = (this.getAttribute('data-multiple-caption') || '').replace('{count}', this.files.length);
      else
        fileName = e.target.value.split('\\').pop();

      if (fileName)
        label.querySelector('span').innerHTML = fileName;
      else
        label.innerHTML = labelVal;
    });
  });
});
