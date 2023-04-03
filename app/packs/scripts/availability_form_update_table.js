document.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('#new_availability').forEach((element) => {
    element.addEventListener('ajax:success', (event) => {
      location.reload()
    })
  });

  document.querySelectorAll('.delete-availability').forEach((element) => {
    element.addEventListener('ajax:success', (event) => {
      location.reload()
    })
  });
});
