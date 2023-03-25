console.log("outings js loaded")

function show_who_content() {
    $('#content-who').show();
    $('#content-when').hide();
    $('#outing-nav-who').addClass("underline");
    $('#outing-nav-when').removeClass("underline");

}

function show_when_content() {
    $('#content-who').hide();
    $('#content-when').show();
    $('#outing-nav-when').addClass("underline");
    $('#outing-nav-who').removeClass("underline");
}

// outings
$(function() {
    $('#outing-nav-who').click(function() {
        console.log("who pressed");
        show_who_content();
    });
});

$(function() {
    $('#outing-nav-when').click(function() {
        console.log("when pressed");
        show_when_content();
    });
});

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

