$(document).ready(function() {
  // Setup AJAX requests to include CSRF tokens
  function setCSRFToken() {
    $.ajaxSetup({
      headers: {
        'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
      }
    });
  }

  // Fetch and display the food menu list
  function fetchFoodMenus() {
    setCSRFToken(); // Ensure CSRF token is set for this request
    $.ajax({
      url: '/food_menu_items',
      type: 'GET',
      dataType: 'json',
      success: function(data) {
        var tableBody = $('#foodMenuTable tbody');
        tableBody.empty(); // Clear existing items
        data.forEach(function(item) {
          var row = `<tr>
            <td>${item.dish_name}</td>
            <td>${item.dish_description}</td>
            <td>${item.category}</td>
            <td>${item.dish_type}</td>
            <td>${item.allergens}</td>
            <td>${item.price}</td>
            <td>
              <button class="btn btn-sm btn-primary edit-btn" data-id="${item.id}" data-bs-toggle="modal" data-bs-target="#editModal" >Edit</button>
              <button class="btn btn-sm btn-danger delete-btn" data-id="${item.id}">Delete</button>
            </td>
          </tr>`;
          tableBody.append(row);
        });
      },
      error: function(xhr, status, error) {
        console.error("Error fetching food menus: ", error);
      }
    });
  }

  // Download CSV
  $('#downloadCsv').click(function() {
    window.location.href = '/food_menu_items/generate_csv_data';
  });

  // Import CSV
  $('#submitCsv').click(function() {
    var formData = new FormData();
    formData.append('csv_file', $('#csvFileInput')[0].files[0]);
    setCSRFToken(); // Ensure CSRF token is set for this request
    $.ajax({
      url: '/food_menu_items/import_csv',
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function(response) {
        alert("CSV Import initiated successfully.");
        $('#importCSVModal').modal('hide');
        refreshCsvTracker(); // Refresh CSV tracker table after import
      },
      error: function(xhr, status, error) {
        alert("Error importing CSV: " + error);
      }
    });
  });

  // Edit Food Menu
  $('#submitEditForm').click(function() {
    var formData = new FormData();
    formData.append('dish_name', $('#dish_name').val()); // Get the value
    formData.append('dish_description', $('#dish_description').val()); // Get the value
    formData.append('category', $('#category').val()); // Get the value
    formData.append('dish_type', $('#dish_type').val()); // Get the value
    formData.append('allergens', $('#allergens').val()); // Get the value
    formData.append('price', $('#price').val()); // Get the value

    setCSRFToken(); // Ensure CSRF token is set for this request
    $.ajax({
      url: '/food_menu_items/import_csv', // Change this URL to your desired endpoint
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function(response) {
        alert("CSV Import initiated successfully.");
        $('#editModal').modal('hide'); // Close the edit modal
        refreshCsvTracker(); // Refresh CSV tracker table after import
      },
      error: function(xhr, status, error) {
        alert("Error importing CSV: " + error);
      }
    });
  });

  $('#submitEditForm').click(function() {
    var itemId = $(this).data('id'); 
  
    var formData = new FormData();
    formData.append('dish_name', $('#dish_name').val());
    formData.append('dish_description', $('#dish_description').val()); 
    formData.append('category', $('#category').val()); 
    formData.append('dish_type', $('#dish_type').val());
    formData.append('allergens', $('#allergens').val());
    formData.append('price', $('#price').val());
  
    setCSRFToken();
    debugger;
    $.ajax({
      url: '/food_menu_items/' + itemId ,
      type: 'POST',
      data: formData,
      processData: false,
      contentType: false,
      success: function(response) {
        alert("Edit Form updated successfully.");
        $('#editModal').modal('hide');
        refreshCsvTracker();
      },
      error: function(xhr, status, error) {
        alert("Error importing CSV: " + error);
      }
    });
  });
  


  // Refresh CSV import tracker
  function refreshCsvTracker() {
    setCSRFToken(); // Ensure CSRF token is set for this request
    $.ajax({
      url: '/csv_import_tracker',
      type: 'GET',
      dataType: 'json',
      success: function(data) {
        var tableBody = $('#csvTrackerTable tbody');
        tableBody.empty();
        data.forEach(function(item) {
          var row = `<tr>
            <td>${item.created_at}</td>
            <td>${item.status}</td>
            <td>${item.error_messages.length}</td>
          </tr>`;
          tableBody.append(row);
        });
      },
      error: function(xhr, status, error) {
        console.error("Error refreshing CSV tracker: ", error);
      }
    });
  }

  // Initial fetches
  fetchFoodMenus();
  setInterval(refreshCsvTracker, 3000); // Refresh tracker every 3 seconds
});
