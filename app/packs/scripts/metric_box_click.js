document.querySelectorAll(".clickable").forEach((element) => {
    element.addEventListener("click", (event) => {
        event.preventDefault();

        route_name = event.target.attributes.route_name.value;
        metric = event.target.attributes.metric.value;
        document.getElementById("pageSelected").value = route_name;
        document.getElementById("metricSelected").value = metric;
    });
});

document.querySelectorAll(".metric_tab_button").forEach((element) => {
    element.addEventListener("click", (event) => {
        tabName = event.target.innerText;

        document.querySelectorAll('.metric_tab').forEach((element) => {
            element.classList.add('hidden');
        })

        tab = document.getElementById(tabName + '_tab');
        console.log(tabName + "_tab");
        tab.classList.remove('hidden');
    });
});
