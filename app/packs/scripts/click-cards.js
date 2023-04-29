var event_cards = document.querySelectorAll(".click-card");

for (const element of event_cards) {
    element.addEventListener("click", function () {
        window.location.href = `${element.id.replace('_', "s/")}`;
    });
}