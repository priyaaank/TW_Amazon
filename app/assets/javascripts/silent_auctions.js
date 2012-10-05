$(document).ready( function() {
	
	if (document.getElementById("user_region"))
	{
		document.getElementById("user_region").onchange = function() 
		//{ alert("Hey!"); }
		{ document.forms[0].submit(); }
	}

	if (document.getElementById("user_email_on"))
	{
		document.getElementById("user_email_on").onchange = function() 
		//{ alert("Hey!"); }
		{ document.forms[1].submit(); }
	}

	if (document.getElementById("user_email_off"))
	{
		document.getElementById("user_email_off").onchange = function() 
		//{ alert("Hey!"); }
		{ document.forms[1].submit(); }
	}

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
    $(".form_action_btn").on('click', function(event){
        $("#submit-overlay").show();
    });

    // file upload style
   $('.inner_fields input[type=file]').each(function(){
       $(this).addClass('file-input');
       $(this).parent().append($('<div class="fakefile" />').append($('<span class="btn btn-mini fakefile-btn">Choose File</span>')).append($('<input type="text" class="filename" disabled="disabled" value="no file selected" />').attr('id',$(this).attr('id')+'__fake')));

       // change fake text to selected filename, check valid filename
       bindInputEvent($(this));
    });
    toggleAddImageBtn();

    // prevent adding more than 5 images
    $('form').on('nested:fieldAdded', function() {
        $('.inner_fields input[type=file]').each(function(){
            bindInputEvent($(this));
        });
        toggleAddImageBtn();
    });

    // re-enable adding more image if input is remove
    $('form').on('nested:fieldRemoved', function() {
        toggleAddImageBtn();
    });
});

function bindInputEvent(fileInput) {
    fileInput.on('change', function() {
        var parent = fileInput.closest('.controls');
        parent.children('.help-inline').remove();
        if(uniqueFileNameUpload(fileInput)){
            $('#'+fileInput.attr('id')+'__fake').val(fileInput.val().replace(/C:\\fakepath\\/i, ''));
        } else {
            fileInput.closest('.controls').append('<span class="help-inline error">Duplicate filename not allowed</span>');
            fileInput.val('');
            $('#'+fileInput.attr('id')+'__fake').val('no file selected');
        }
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

function uniqueFileNameUpload(fileInput){
    var currentFileName = fileInput.val();
    var valid = true;

    $('.inner_fields input[type=file]').each(function(){
        if ($(this).val() == currentFileName && $(this).attr('id') != fileInput.attr('id')) {
            valid = false;
        }
    });
    return valid;
}
