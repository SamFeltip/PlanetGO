document.addEventListener('DOMContentLoaded', () => {
  elements = document.getElementsByClassName('day');

  startDaySelector = document.getElementById('start_day');
  endDaySelector = document.getElementById('end_day');
  startHourSelector = document.getElementById('start_hour');
  endHourSelector = document.getElementById('end_hour');
  startMinuteSelector = document.getElementById('start_minute');
  endMinuteSelector = document.getElementById('end_minute');

  for (let index = 0; index < elements.length; index++) {
    elements[index].addEventListener("mousedown", (event) => {
      event.preventDefault();
      startDaySelector.selectedIndex = index;

      firstDay = document.getElementsByClassName('day')[0];
      rect = firstDay.getBoundingClientRect();
      y = event.clientY - rect.top
      totalY = rect.height;

      minutes = (y / totalY) * 1440
      hours = Math.floor(minutes / 60);
      minutes = minutes % 60;
      minutes = Math.floor(minutes / 15)

      startHourSelector.selectedIndex = hours;
      startMinuteSelector.selectedIndex = minutes;

      // Update all select_boxes
      for (x = 0; x <= 6; x++) {
        if (x == startDaySelector.value) {
          $('#selected_box_' + x).css({ "top": y + "px", "bottom": "auto", "display": "block" });
        } else {
          $('#selected_box_' + x).css({ "top": 0, "display": "none" });
        }
      }
    })

    elements[index].addEventListener("mouseup", (event) => {
      event.preventDefault();
      endDaySelector.selectedIndex = index;

      firstDay = document.getElementsByClassName('day')[0];
      rect = firstDay.getBoundingClientRect();
      y = event.clientY - rect.top
      totalY = rect.height;

      minutes = (y / totalY) * 1440
      hours = Math.floor(minutes / 60);
      minutes = minutes % 60;
      minutes = Math.ceil(minutes / 15);
      if (minutes == 4) {
        minutes = 0;
        hours++;
        if (hours == 24) {
          endDaySelector.selectedIndex++;
          hours = 0;
          minutes = 0;
        }
      }

      endHourSelector.selectedIndex = hours;
      endMinuteSelector.selectedIndex = minutes;

      // Check if selecting backwards
      startDay = startDaySelector.value;
      startHour = startHourSelector.value;
      startMinute = startMinuteSelector.value;
      endDay = endDaySelector.value;
      endHour = endHourSelector.value;
      endMinute = endMinuteSelector.value;

      startDayLarger = (parseInt(startDay) > parseInt(endDay));
      startDaySame = (parseInt(startDay) == parseInt(endDay));
      startHourLarger = (parseInt(startHour) > parseInt(endHour));
      startHourSame = (parseInt(startHour) == parseInt(endHour));
      startMinuteLarger = (parseInt(startMinute) > parseInt(endMinute));
      startMinuteSame = (parseInt(startMinute) == parseInt(endMinute));

      // If dragging from bottom right to top left, invert start and end inputs. Not necessary for
      // back end but code that updates divs showing selection requires start to be less than end
      inverted = false;
      if (startDayLarger || (startDaySame && startHourLarger) || (startDaySame && startHourSame && startMinuteLarger)) {
        startDaySelector.value = endDay
        startHourSelector.value = endHour
        startMinuteSelector.value = endMinute
        endDaySelector.value = startDay
        endHourSelector.value = startHour
        endMinuteSelector.value = startMinute

        inverted = true;
        previousTop = $('#selected_box_' + endDaySelector.value).css("top")
        previousTop = previousTop.substring(0, previousTop.length - 2);
      }

      // Update all select_boxes
      for (x = 0; x <= 6; x++) {
        // case for boxes between drag start and drag end. Always fill entire eight of day
        if (x > startDaySelector.value && x < endDaySelector.value) {
          $('#selected_box_' + x).css({ "top": 0, "bottom": 0, "display": "block" });
          // case for box where we started dragging if stopped in a different box. Box will 
          // reach either all the way to the top or all the way to the bottom depending on 
          // which way we are dragging
        } else if (x == startDaySelector.value && x != endDaySelector.value) {
          if (inverted) {
            $('#selected_box_' + x).css({ "top": y + "px", "bottom": 0 + "px", "display": "block" });
          } else {
            $('#selected_box_' + x).css({ "bottom": 0, "display": "block" });
          }
          // case for box where we stop dragging if started in a different box. Same as 
          // previous case but which end reaches the end of the column is inverted depending
          // on direction of drag
        } else if (x == endDaySelector.value && x != startDaySelector.value && !(hours == 0 && minutes == 0)) {
          if (inverted) {
            $('#selected_box_' + x).css({ "top": 0, "bottom": (rect.height - previousTop) + "px", "display": "block" });
          } else {
            $('#selected_box_' + x).css({ "top": 0, "bottom": (rect.height - y) + "px", "display": "block" });
          }
          // case for starting and stopping in the same box. 
        } else if (x == startDaySelector.value && x == endDaySelector.value) {
          if (inverted) {
            $('#selected_box_' + x).css({ "top": y, "bottom": (rect.height - previousTop) + "px", "display": "block" });
          } else {
            $('#selected_box_' + x).css({ "bottom": (rect.height - y) + "px", "display": "block" });
          }
          // hide all other select boxes.
        } else {
          $('#selected_box_' + x).css({ "display": "none" });
        }
      }
    })
  }
})