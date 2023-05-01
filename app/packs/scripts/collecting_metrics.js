document.addEventListener("DOMContentLoaded", () => {
  // These values can be null, better than putting false data in db
  var pageVisitedFrom;
  var CSRFToken;
  var location;
  var interactions;
  resetValues();

  // Bind listener to the visibilitychange event instead of unload, find out more at:
  // https://developer.mozilla.org/en-US/docs/Web/API/Navigator/sendBeacon#sending_analytics_at_the_end_of_a_session
  document.addEventListener("visibilitychange", () => {
    if (document.visibilityState === "hidden") {
      let metrics = new FormData();
      metrics.append("time_enter", pageVisitedFrom);
      metrics.append("time_exit", Date.now());
      metrics.append("route", window.location.pathname.replace(/\d+/, "#"));
      metrics.append("is_logged_in", false);
      metrics.append("number_interactions", interactions);
      metrics.append("authenticity_token", CSRFToken);
      if (location) {
        metrics.append("latitude", location.coords.latitude);
        metrics.append("longitude", location.coords.longitude);
      }
      navigator.sendBeacon("/metrics", metrics);
      resetValues();
    }
  });

  document.addEventListener("click", () => {
    interactions++;
  });

  function resetValues() {
    pageVisitedFrom = Date.now();
    CSRFToken = document
      .querySelector("meta[name='csrf-token']")
      .getAttribute("content");
    location = null;
    interactions = 0;

    getLocation();
  }

  function getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(getPosition);
    }
  }

  function getPosition(position) {
    location = position;
  }
});
