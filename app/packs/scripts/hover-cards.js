console.log("hello world");
// Select the card-hover elements
var elements = document.querySelectorAll('.card-hover');

// Iterate over each element
for (const element of elements) {
    console.log("iterating on elements")
    // Add a click event listener to the element
    element.addEventListener('click', function() {
        // Handle the click event
        console.log("clicked!")
        // Select the element with the class 'my-class' that is inside the div element
        const header = element.querySelector('.card-header');

        const interest_urls = {
            "Basic": "/pricings/basic/register_interests/new",
            "Premium": "http://0.0.0.0:3000/pricings/premium/register_interests/new",
            "Premium+": "http://0.0.0.0:3000/pricings/premium_plus/register_interests/new"
        }

        // Print the text within the element
        console.log(header.innerText);

        window.location.href = interest_urls[header.innerText];
    });
}