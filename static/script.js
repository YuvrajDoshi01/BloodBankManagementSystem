// Get the form element
const form = document.querySelector('form');

// Listen for form submission
form.addEventListener('submit', (event) => {
  // Prevent the default form submission behavior
  event.preventDefault();
  
  // Get the form data
  const formData = new FormData(form);
  
  // Convert the form data to a JSON object
  const json = JSON.stringify(Object.fromEntries(formData.entries()));
  console.log(json);
  // Send the form data to the server using a fetch request
  fetch('/donation', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: json
  })
  .then(response => {
    if (response.ok) {
      // If the response is successful, redirect to the blood_units page
      window.location.href = '/blood_units';
    } else {
      // If the response is not successful, display an error message
      alert('There was an error submitting the form. Please try again.');
    }
  })
  .catch(error => {
    // If there is a network error, display an error message
    console.log(error);
    alert('There was a network error. Please check your connection and try again.');
  });
});
