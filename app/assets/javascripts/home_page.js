//= require rails-ujs
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

  // Edit Food Menu modal when its open, input all the value
  $(document).on('click', '.edit-btn', function() {
    var itemId = $(this).attr('data-id'); // Get the item ID
    var row = $(this).closest('tr'); // Find the closest table row to the clicked edit button

    // Fetch current values from the row
    var dishName = row.find('td:nth-child(1)').text();
    var dishDescription = row.find('td:nth-child(2)').text();
    var category = row.find('td:nth-child(3)').text();
    var dishType = row.find('td:nth-child(4)').text();
    var allergens = row.find('td:nth-child(5)').text();
    var price = row.find('td:nth-child(6)').text();

    // Populate the modal fields with the current values
    $('#dish_name').val(dishName);
    $('#dish_description').val(dishDescription);
    $('#category').val(category);
    $('#dish_type').val(dishType);
    $('#allergens').val(allergens);
    $('#price').val(price);

    // Store the ID in the submit button for later
    $('#submitEditForm').data('id', itemId);
  });


  // Submit the edit form
  $('#submitEditForm').click(function() {
    var itemId = $(this).data('id'); // Retrieve the stored item ID

    var formData = {
      'food_menu_item' : {
        'dish_name': $('#dish_name').val(),
        'dish_description': $('#dish_description').val(),
        'category': $('#category').val(),
        'dish_type': $('#dish_type').val(),
        'allergens': $('#allergens').val(),
        'price': $('#price').val()
      },
      '_method': 'PUT'
    };

    setCSRFToken();
    $.ajax({
        url: '/food_menu_items/' + itemId, // Ensure this is the correct route for updating
        type: 'POST', // Use POST here because of how Rails handles PATCH/PUT requests
        data: formData,
        success: function(response) {
          $('#editModal').modal('hide');  
          alert("Food item updated successfully.");
          fetchFoodMenus(); // Refresh the food menus list
        },
        error: function(xhr, status, error) {
            alert("Error updating food item: " + error);
        }
    });
  });

  // Submit the create Form
  $('#submitAddForm').click(function() {
    var formData = {
      'food_menu_item' : {
        'dish_name': $('#new_dish_name').val(),
        'dish_description': $('#new_dish_description').val(),
        'category': $('#new_category').val(),
        'dish_type': $('#new_dish_type').val(),
        'allergens': $('#new_allergens').val(),
        'price': $('#new_price').val()
      }
    };
    $.ajax({
      url: '/food_menu_items',
      type: 'POST',
      data: formData,
      success: function(response) {
        $('#addModal').modal('hide');
        // Clear the form Input values
        $('#new_dish_name').val('');
        $('#new_dish_description').val('');
        $('#new_category').val('')
        $('#new_dish_type').val('');
        $('#new_allergens').val('');
        $('#new_price').val('');

        // Refresh the list to show the newly added item
        fetchFoodMenus(); 
      },
      error: function(xhr, status, error) {
        alert("Error adding new food menu item: " + error);
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
        if (data[0].status == 'Completed') {
          fetchFoodMenus();
        }
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

  // Delete food menu item
  $(document).on('click', '.delete-btn', function() {
    if (!confirm('Are you sure you want to delete this item?')) return;
    
    var itemId = $(this).attr('data-id'); // Get the item ID
    debugger
    setCSRFToken();
    $.ajax({
        url: '/food_menu_items/' + itemId,
        type: 'DELETE',
        success: function(result) {
            alert("Food item deleted successfully.");
            fetchFoodMenus(); // Refresh the food menus list
        },
        error: function(xhr, status, error) {
            alert("Error deleting food item: " + error);
        }
    });
  });
});
