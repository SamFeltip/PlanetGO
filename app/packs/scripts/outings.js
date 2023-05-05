$('.reject-event-button').click(function () {
    $(this).closest('.event-card').hide();
});

// when outing-nav-who-link is clicked, show the who tab
$('#outing-nav-who').click(function () {
    console.log('outing-nav-who-link clicked');
    $('#content-where').addClass('d-none');
    $('#content-who-and-when').removeClass('d-none');

    $('#content-when').addClass('d-none');
    $('#content-who').removeClass('d-none');

    $('.outing-nav-item').removeClass('underline');
    $('#outing-nav-who').addClass('underline');
});

// when outing-nav-when-link is clicked, show the when tab
$('#outing-nav-when').click(function () {
    console.log('outing-nav-when-link clicked');
    $('#content-where').addClass('d-none');
    $('#content-who-and-when').removeClass('d-none');

    $('#content-who').addClass('d-none');
    $('#content-when').removeClass('d-none');

    $('.outing-nav-item').removeClass('underline');
    $('#outing-nav-when').addClass('underline');
});

// when outing-nav-where-link is clicked, show the where tab
$('#outing-nav-where').click(function () {
    console.log('outing-nav-where-link clicked');
    $('#content-where').removeClass('d-none');
    $('#content-who-and-when').addClass('d-none');
    $('.outing-nav-item').removeClass('underline');
    $('#outing-nav-where').addClass('underline');
});

// when date of outing is updated, change date of outing on page
document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('.edit_outing').forEach((element) => {
        element.addEventListener('ajax:success', (event) => {
            document.querySelectorAll('.outing-date').forEach((element) => {
                element.innerHTML = event['detail'][0]['start_date']
            });
        });
    });
});