// Add an event listener to the form submission
document.addEventListener('DOMContentLoaded', () => {
    const form = document.querySelector('form');
    form.addEventListener('submit', (event) => {
      event.preventDefault();
      const formData = new FormData(form);
      const json = JSON.stringify(Object.fromEntries(formData.entries()));
      fetch('/donor', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: json
      })
      .then(response => {
        if (response.ok) {
          window.location.href = '/donors';
        } else {
          alert('There was an error submitting the form. Please try again.');
        }
      })
      .catch(error => {
        console.log(error);
        alert('There was a network error. Please check your connection and try again.');
      });
    });
    
});
