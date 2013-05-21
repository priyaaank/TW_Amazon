
$(document).ready(function() {
                             var showNotify = function () {
                                                          var checkVal = $('input:radio:checked').val();
  if (checkVal === "true") {
                           $('#email-notify').show();
} else if (checkVal === "false") {
                                 $('#email-notify').hide();
  unSelectAll();
}
};
$('input:radio').change(showNotify);
showNotify();
$('#email_notification_select_all_yes').change(function () {
  if(this.checked){
                  selectAll();
} else {
unSelectAll();
}
});
});
function unSelectAll(){
                      $("option:selected").removeAttr("selected");
$('input:checkbox').prop('checked', false);
}
function selectAll(){
                    $('input:checkbox').prop('checked', true);
}
