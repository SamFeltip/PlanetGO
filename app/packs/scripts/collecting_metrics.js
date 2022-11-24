document.addEventListener('DOMContentLoaded', () => {
  var pageVisitedFrom;
  var CSRFToken;
  var location;
  var interactions;

  resetValues();

  // Bind listener to the visibilitychange event instead of unload, find out more at:
  // https://developer.mozilla.org/en-US/docs/Web/API/Navigator/sendBeacon#sending_analytics_at_the_end_of_a_session
  document.addEventListener('visibilitychange', () => {
    if (document.visibilityState === 'hidden') {
      let metrics = new FormData();
      metrics.append('time_enter', pageVisitedFrom);
      metrics.append('time_exit', Date.now());
      metrics.append('route', window.location.pathname);
      if (location) {
        metrics.append('latitude', location.coords.latitude);
        metrics.append('longitude', location.coords.longitude);
      }
      metrics.append('is_logged_in', false)
      metrics.append('number_interactions', interactions)
      metrics.append('pricing_selected', 0)
      metrics.append('authenticity_token', CSRFToken);

      console.log(metrics);
      // navigator.sendBeacon is the easist way to send a request to the server when a page is unloading.
      // The browser will keep this request alive even if the page that started the request is unloaded already.
      // sendBeacon() will use POST method, and you cannot change this.
      navigator.sendBeacon('/metrics', metrics);
      resetValues();


      // fetch with keepalive true behaves the same as navigator.sendBeacon,
      // but allows you to customise headers / method easily.
      // fetch('/metrics', {
      //   method: 'POST',
      //   keepalive: true,
      //   credentials: 'same-origin',
      //   headers: {
      //     'x-csrf-token': CSRFToken
      //   },
      //   body: metrics
      // });

      // Both sendBeacon and fetch + keepalive got a 64kb payload limit. This is across all requests from the same page.
    }
  })

  document.addEventListener('click', () => {
    interactions++;
  })

  function resetValues() {
    pageVisitedFrom = Date.now();
    CSRFToken = document.querySelector("meta[name='csrf-token']").getAttribute('content');
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
    location = position
  }
});
