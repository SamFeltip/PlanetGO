console.log("outings js loaded")

// when #outing-footer-next is clicked, check if content-who or when is visible
// if who is visible, show when
$(function() {
    $('#outing-footer-next').click(function() {
        console.log("next pressed");
        if ($('#content-who').is(":visible")) {
            show_when_content();
        }
    });
});

// the same but who and when are reversed, and it inspects #outing-footer-prev
$(function() {
    $('#outing-footer-prev').click(function() {
        console.log("prev pressed");
        if ($('#content-when').is(":visible")) {
            show_who_content();
        }
    });
});

