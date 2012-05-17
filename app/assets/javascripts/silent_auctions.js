$(document).ready( function() {
    // to open auction photos in light box
    $('a.gallery').fancybox();

    //have dynamic character count for description
    $("#description").charCount({
        allowed: 500,
        warning: 20,
        counterText: 'Characters left: '
    });

    $(".bid_form").live("ajax:complete", function(event,xhr,status){
        $('#bid_amount').val('');
        $(this).removeAttr('disabled');
    });
});