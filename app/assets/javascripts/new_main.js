$(document).ready(function() {
	$('.btn_menu').click(function(){
		$('.menu ul').slideToggle();
	});
	$("#owl-example").owlCarousel({
		items: 1.63,
		navigationText: false,
		autoPlay: true,
		itemsDesktopSmall : [900,2.5],
		itemsTablet: [600,1.2], //2 items between 600 and 0;
		itemsMobile : false // itemsMobile disabled - inherit from itemsTablet option
	});
	$("#owl-example_mobile_items").owlCarousel({
		navigationText: false,
		items : 10, //10 items above 1000px browser width
		itemsDesktop : [1000,6], //5 items between 1000px and 901px
		itemsDesktopSmall : [900,4], // betweem 900px and 601px
		itemsTablet: [600,2.7], //2 items between 600 and 0;
		itemsMobile : false // itemsMobile disabled - inherit from itemsTablet option
	});
	$('.btn_menu').click(function(){
		$(this).toggleClass('active');
		$('.menu_mobile').toggleClass('active');
	});
});
