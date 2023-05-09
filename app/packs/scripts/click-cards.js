function run_click_cards(){
    let click_cards = document.querySelectorAll(".click-card");

    for (const click_card of click_cards) {
        let clickables = click_card.querySelectorAll(".clickable");
        let click_card_url = click_card.getAttribute("data-url")

        for (const clickable of clickables) {
            // if there is a body, add event listener to first click card body element
            if (clickable) {
                clickable.addEventListener("click", function () {
                    window.location.href = `${click_card_url}`;
                });
            }

        }
    }

}

run_click_cards;