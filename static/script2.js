// Function to fetch donor data from the API
function getDonors() {
    fetch('/donors')
      .then(function (response) {
        return response.json();
      })
      .then(function (data) {
        populateTable(data);
      });
  }
  
  // Function to populate the donor table with data
  function populateTable(data) {
    // Get the donor table element
    var donorTable = document.getElementById('donor-table');
  
    // Create a table row for each donor
    data.forEach(function (donor) {
      // Create a new table row element
      var row = donorTable.insertRow(-1);
  
      // Add a cell for the donor name
      var nameCell = row.insertCell(0);
      nameCell.innerHTML = donor['name'];
  
      // Add a cell for the donor phone number
      var phoneCell = row.insertCell(1);
      phoneCell.innerHTML = donor['phone'];
  
      // Add a cell for the donor email address
      var emailCell = row.insertCell(2);
      emailCell.innerHTML = donor['email'];
  
      // Add a cell for the blood type
      var bloodTypeCell = row.insertCell(3);
      bloodTypeCell.innerHTML = donor['blood_type'];
  
      // Add a cell for the donation date
      var donationDateCell = row.insertCell(4);
      donationDateCell.innerHTML = donor['donation_date'];
  
      // Add a cell for the expiry date
      var expiryDateCell = row.insertCell(5);
      expiryDateCell.innerHTML = donor['expiry_date'];
    });
  }
  
  // Call the getDonors() function when the page loads
  window.onload = function () {
    getDonors();
  };
  