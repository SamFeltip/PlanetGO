document.querySelectorAll(".clickable").forEach((element) => {
    element.addEventListener("click", (event) => {
        route_name = event.target.attributes.route_name.value;
        metric = event.target.attributes.metric.value;
        document.getElementById("pageSelected").value = route_name;
        document.getElementById("metricSelected").value = metric;
    });
});