var elements = document.querySelectorAll(".card-hover");

for (const element of elements) {
    element.addEventListener("click", function () {
        const header = element.querySelector(".card-header");

        const interest_urls = {
            Basic: "/pricings/basic/register_interests/new",
            Premium: "/pricings/premium/register_interests/new",
            "Premium+": "/pricings/premium_plus/register_interests/new",
        };

        window.location.href = interest_urls[header.innerText];
    });
}
