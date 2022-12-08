import Rails from "@rails/ujs";
import "bootstrap";
import '../scripts/collecting_metrics';
import '../scripts/jquery.jvectormap.js';
import '../scripts/jquery-jvectormap-world-merc';

import Chart from 'chart.js/auto';

Rails.start();

window.onload = () => {
  if (window.location.pathname == "/metrics") {
    // Setup the chart
    var ctx = document.getElementById('myChart').getContext('2d');
    var myChart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: JSON.parse(ctx.canvas.dataset.labels),
        datasets:
          JSON.parse(ctx.canvas.dataset.data)
      },
    });
  }
}