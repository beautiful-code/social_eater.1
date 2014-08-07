$(function () {

    $('.edit-item').focusout( function (event) {
        setTimeout(function () {
            if (!event.delegateTarget.contains(document.activeElement)) {
               $(event.delegateTarget).closest('form').submit();
               $(event.delegateTarget).closest('form').find('.progress-spin').removeClass('hidden');
            }
        }, 0);
    })


    $('.edit-item').closest('form').bind('ajax:complete', function() {
        $(this).find('.progress-spin').addClass('hidden');
    });


    $('document').ajaxError(function() {
        alert('Error saving the item...');
        $( ".updated-item-progress" ).text( "Error submitting details." );
    });


})
