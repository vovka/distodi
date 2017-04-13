$(document).ready(function() {
	$('.btn_menu').click(function(){
		$('.menu ul').slideToggle();
	
	});
	$("#owl-example").owlCarousel({
		items: 1.63,
		
		navigationText: false,
    autoPlay: true,
    rewindNav: true,
    
    
	});


$('#mix-wrapper').mixItUp();



});
