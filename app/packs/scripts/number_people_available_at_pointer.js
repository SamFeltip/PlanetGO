function attachListenerToMultiPeopleCalendar() {
  document.querySelector('.calendar-container').addEventListener("click", (e) => {
    var x = e.clientX,
      y = e.clientY,
      stack = [];

    var rect = e.currentTarget.getBoundingClientRect();
    var elementX = e.clientX - rect.left; //x position within the element.
    var elementY = e.clientY - rect.top;  //y position within the element.

    var allElements = document.querySelectorAll('.card.bg-success');
    var len = allElements.length;

    for (var i = 0; i < len; i++) {
      var elm = allElements[i];
      var rect = elm.getBoundingClientRect();

      if (y >= rect.top && y <= rect.bottom && x >= rect.left && x <= rect.right) {
        stack.push(elm);
      }
    }

    // place the number of people container relative to calendar container
    document.querySelector('.number-people-available').style.display = "block";
    document.querySelector('.number-people-available').textContent = stack.length;
    document.querySelector('.number-people-available').style.top = (elementY + 20) + "px";
    document.querySelector('.number-people-available').style.left = (elementX + 20) + "px";
  });
}  
