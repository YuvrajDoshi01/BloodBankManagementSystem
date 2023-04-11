const deleteForm = document.getElementById('delete-form');
const donorIdInput = document.getElementById('donor-id');

deleteForm.addEventListener('submit', e => {
    e.preventDefault();
    const donorId = donorIdInput.value;
    if (confirm('Are you sure you want to delete this donor?')) {
        fetch(`/donors/delete/${donorId}`, {
            method: 'DELETE'
        }).then(() => {
            window.location.href = '/donors';
        }).catch(err => {
            console.error(err);
        });
    }
});
