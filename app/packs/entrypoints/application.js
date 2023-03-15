import Rails from "@rails/ujs";
import "bootstrap";
import '../scripts/collecting_metrics';
import "../scripts/outings";
import '../scripts/jquery.jvectormap.js';
import '../scripts/jquery-jvectormap-world-merc';
import '../scripts/hover-cards';
import Chart from 'chart.js/auto';


//= require_tree .

require("jquery")
require("@nathanvda/cocoon")

Rails.start();
console.log("application loaded.");

var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
})

window.onload = () => {
  if (window.location.pathname === "/metrics") {
    // Setup the chart
    var ctx = document.getElementById('myChart').getContext('2d');
    var myChart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: JSON.parse(ctx.canvas.dataset.labels),
        datasets: JSON.parse(ctx.canvas.dataset.data)
      },
    });
  }
}



