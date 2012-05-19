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

    //display overlay when form is submitting
    $(".upload_btn").on('click', function(event){
        $("#upload-overlay").show();
    });

    // file upload style
   $('.inner_fields input[type=file]').each(function(){
       $(this).addClass('file-input');
        $(this).parent().append($('<div class="fakefile" />').append($('<span class="btn btn-mini fakefile-btn">Choose File</span>')).append($('<input type="text" class="filename" disabled="disabled" value="no file selected" />').attr('id',$(this).attr('id')+'__fake')));

        $(this).on('change', function() {
            $('#'+$(this).attr('id')+'__fake').val($(this).val().replace(/C:\\fakepath\\/i, ''));
        });
    });

    $('form').on('nested:fieldAdded', function() {
        bindInputEvent();
        toggleAddImageBtn();
    });

    $('form').on('nested:fieldRemoved', function() {
        toggleAddImageBtn();
    });
});

function bindInputEvent() {
    $('.inner_fields input[type=file]').each(function(){
        $(this).on('change', function() {
            $('#'+$(this).attr('id')+'__fake').val($(this).val().replace(/C:\\fakepath\\/i, ''));
        });
    });
}

function toggleAddImageBtn(){
    var maxInput = 5;
    var visibleInput = 0;

    $('.fields').each(function(){
        if ($(this).css('display') != 'none'){
            visibleInput++;
        }
    });

    if(visibleInput >= (maxInput + 1)){
        $('form a.add_nested_fields').hide();
    } else {
        $('form a.add_nested_fields').show();
    }
}