$(document).ready( function() {
    $(".bid_form").live("ajax:complete", function(event,xhr,status){
        $('#bid_amount').val('');
        $(this).removeAttr('disabled');
    });
});