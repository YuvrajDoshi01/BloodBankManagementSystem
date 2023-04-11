function getDonors() {
    let blood_group = document.getElementById('blood_group').value;
    let url = '/donors/blood_group/' + blood_group;
    fetch(url)
        .then(response => response.json())
        .then(data => {
            console.log(data);
            let table = document.getElementById('donors_table');
            table.innerHTML = '<tr><th>ID</th><th>Name</th><th>Phone</th><th>Email</th><th>Blood Type</th><th>Donation Date</th></tr>';
            data.forEach(donor => {
                let row = table.insertRow();
                row.innerHTML = '<td>' + donor.id + '</td><td>' + donor.name + '</td><td>' + donor.phone + '</td><td>' + donor.email + '</td><td>' + donor.blood_type + '</td><td>' + donor.donation_date + '</td>';
            });
        })
        .catch(error => {
            console.error('Error:', error);
        });
}
