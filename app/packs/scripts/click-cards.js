var event_cards = document.querySelectorAll(".click-card");

for (const element of event_cards) {
    element.addEventListener("click", function () {
        window.location.href = `${element.id.replace('_', "s/")}`;
    });
}
//
// var outing_cards = document.querySelectorAll(".outing-card");
//
// for(const element of outing_cards) {
//     element.addEventListener("click", function() {
//        window.location.href = `outings/${element.id.substring(7)}`;
//     });
// }