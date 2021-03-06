# Replace Rails' confirmation dialog with a translatable Bootstrap modal dialog.
# Requires jQuery 1.7, Bootstrap, and i18n-js (https://github.com/fnando/i18n-js)
# Translation strings used: confirm.title, confirm.ok, confirm.cancel
#$ ->
#  $.rails.confirm = (message) ->
#    $("#confirm_dialog > .modal-body").html("<p><i class='icon-warning-sign'></i> " + message + '</p>')
#    false
#  if $('[data-confirm]')
#    $('body').append("<div class='modal hide' id='confirm_dialog'><div class='modal-header'><a class='close' data-dismiss='modal'>×</a><h3>" + "Confirm title" + "</h3></div><div class='modal-body'></div><div class='modal-footer'><a class='btn btn-primary'></a><a href='#' data-dismiss='modal' class='btn'>" + "No" + "</a></div></div>")
#    $('[data-confirm]').each ->
#      link_elem = $(this)
#      link_elem.click (e) ->
#        e.preventDefault()
#        confirm = $('#confirm_dialog > .modal-footer > .btn-primary')
#        new_confirm = link_elem.clone()
#        new_confirm.removeAttr('data-confirm id')
#        new_confirm.attr('class', 'btn btn-primary')
#        new_confirm.html("Yes")
#        confirm.replaceWith(new_confirm)
#        $('#confirm_dialog').modal()