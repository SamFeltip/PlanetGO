import Rails from "@rails/ujs";
import "bootstrap";
import '../scripts/collecting_metrics';
import '../scripts/hover-cards';

//= require_tree .

require("jquery")
require("@nathanvda/cocoon")

Rails.start();
console.log("application loaded.");

var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
})

