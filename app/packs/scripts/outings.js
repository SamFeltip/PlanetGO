console.log("outings js loaded")

// outings
$(function() {
    $('#outing-nav-who').click(function() {
        console.log("who pressed");
        $('#content-who').show();
        $('#content-when').hide();
        $("#outing-nav-who").addClass("underline");
        $("#outing-nav-when").removeClass("underline");
    });
});

$(function() {
    $('#outing-nav-when').click(function() {
        console.log("when pressed");
        $('#content-who').hide();
        $('#content-when').show();
        $("#outing-nav-when").addClass("underline");
        $("#outing-nav-who").removeClass("underline");

    });
});

// var filter = $(this).is(':checked');
// $.ajax({
//     url: '/outings/filter',
//     type: 'GET',
//     data: { filter: filter },
//     success: function(data) {
//         $('#outings').html(data);
//     }
// });
