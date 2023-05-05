let click_cards = document.querySelectorAll(".click-card");

for (const element of click_cards) {
    element.addEventListener("click", function () {
        window.location.href = `${element.getAttribute("data-url")}`;
    });
}
