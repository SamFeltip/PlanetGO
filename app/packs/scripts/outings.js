//when reject-event-button is pressed, hide the event card
$(document).on('click', '.reject-event-button', function() {
    console.log('reject-event-button clicked');
    $(this).closest('.event-card').hide();
});
