import Rails from "@rails/ujs";
import "bootstrap";
import '../scripts/collecting_metrics';
import '../scripts/click-cards';
import "../scripts/event-cards.js";

//= require_tree .

require("jquery")
require("@nathanvda/cocoon")

Rails.start();

var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
})

