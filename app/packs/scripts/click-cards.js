let click_cards = document.querySelectorAll(".click-card");

for (const click_card of click_cards) {
    let click_card_body = click_card.querySelector(".body");
    let click_card_header = click_card.querySelector(".header");
    let click_card_url = click_card.getAttribute("data-url")

    // if there is a body, add event listener to first click card body element
    if (click_card_body) {
        click_card_body.addEventListener("click", function () {
            window.location.href = `${click_card_url}`;
        });
    }

    if (click_card_header) {
        click_card_header.addEventListener("click", function () {
            window.location.href = `${click_card_url}`;
        });
    }
}