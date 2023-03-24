import '../scripts/jquery.jvectormap.js';
import '../scripts/jquery-jvectormap-world-merc';
import '../scripts/metric_box_click.js'
import Chart from 'chart.js/auto';

window.onload = () => {
    // Setup the chart
    var ctx = document.getElementById('myChart').getContext('2d');
    var myChart = new Chart(ctx, {
      type: 'line',
      data: {
        labels: JSON.parse(ctx.canvas.dataset.labels),
        datasets: JSON.parse(ctx.canvas.dataset.data)
      },
    });

    var click_data = $('#world-map').data("value");
    $('#world-map').vectorMap({map: 'world_merc',
      series: {
        regions: [{
          values: click_data,
          scale: ['#C8EEFF', '#0071A4'],
          normalizeFunction: 'polynomial'
        }]
      },
      zoomOnScroll: false,
      onRegionTipShow: function(e, el, code){
        el.html(el.html()+' (Visits - '+(click_data[code] ? click_data[code] : 0)+')');
      }
    });
  }

