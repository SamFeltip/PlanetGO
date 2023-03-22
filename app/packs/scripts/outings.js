console.log("outings js loaded")

// outings
$(function() {
    $('#filter_outings').change(function() {
        console.log("filter button pressed");
        // var filter = $(this).is(':checked');
        // $.ajax({
        //     url: '/outings/filter',
        //     type: 'GET',
        //     data: { filter: filter },
        //     success: function(data) {
        //         $('#outings').html(data);
        //     }
        // });
    });
});
