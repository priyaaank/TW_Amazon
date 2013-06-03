$(document).ready(function () {
    $('#email_notification_select_all_yes').change(function () {
        if (this.checked) {
            selectAll();
        } else {
            unSelectAll();
        }
    });
});
function unSelectAll() {
    $("option:selected").removeAttr("selected");
    $('input[type=checkbox]').each(function() {
        if (this.id==='email_notification_item_won'||this.id ==='email_notification_item_outbid') {
        }else{
            this.checked = false;
        }
    });
}
function selectAll() {
    $('input:checkbox').prop('checked', true);
}
