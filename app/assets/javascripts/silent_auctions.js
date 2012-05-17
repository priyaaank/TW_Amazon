$(document).ready( function() {
    // to open auction photos in light box
    $('a.gallery').colorbox();

    $(".bid_form").live("ajax:complete", function(event,xhr,status){
        $('#bid_amount').val('');
        $(this).removeAttr('disabled');
    });
});