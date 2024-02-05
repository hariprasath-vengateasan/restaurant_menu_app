// Initialize tooltips
$(document).ready(function() {
  // console.log($);
  // debugger;
  $('[data-bs-toggle="tooltip"]').tooltip();
});

// Refresh table function
$('#refreshCSVTable').click(function() {
  // You can reload or update your table data here
  // Example: Reload the table data from the server
  // $('#yourTableId').DataTable().ajax.reload();
  alert('Table refreshed');
});

// Error count popup
$('.error-count-link').click(function(e) {
  e.preventDefault();
  const errorCount = $(this).data('error-count');
  const errorMessages = ['Error 1 message', 'Error 2 message', 'Error 3 message']; // Replace with your actual error messages

  let errorPopupContent = '<ul>';
  for (let i = 0; i < errorCount; i++) {
    errorPopupContent += `<li>${errorMessages[i]}</li>`;
  }
  errorPopupContent += '</ul>';

  // Display error messages in a Bootstrap modal or custom popup
  // Example: $('#errorPopup').modal('show');
  alert(errorPopupContent);
});

// Signout
$(document).ready(function() {
  $('#signOutButton').click(function(e) {
    var confirmSignOut = confirm("Are you sure you want to sign out?");
    if (!confirmSignOut) {
      // Prevent the default action (the sign-out process) if the user cancels
      e.preventDefault();
    }
  });
});