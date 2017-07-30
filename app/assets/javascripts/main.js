function myFunction() {
    $('.field_decline_btn').click(
        function(event){
            $(event.currentTarget.parentElement).find('.field_decline').addClass('active');
            $(event.currentTarget).hide();
        }
    )
}