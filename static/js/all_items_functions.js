// websocket request
const editRequest = "#002-edit-item";
const addRequest = "#003-add-item";
const removeRequest = "#004-remove-item";
const updateRequest = "#005-update-item"

//var ws = new WebSocket('ws://10.24.24.76:8080/ws');
var ws = new WebSocket('ws://localhost:8080/ws');
// if browser support or not support
if (window.WebSocket) {
	console.log("Your web browser is support websocket");
} else {
	console.log("Your web browser doesn't support websocket");
}
ws.onopen = function() {
	console.log("WebSocket connection opened!");
	var greetingCard = "I'm connected with you :), My Platform: " + navigator.platform;
	ws.send(greetingCard);
}
ws.onclose = function() {
	console.log("WebSocket connection closed!");
	console.log("Ready: " + ws.readyState);
	console.log("WebSocket server connection is close... I'll try to reconnecting in 3s ... Or if I always try to reconnecting to websocket server, please clean the cookies and cache in your browser :) -AQX-");
	setTimeout(function() {
		window.location = "/";
	}, 3000);
	setTimeout(function() {
		console.log("Establish WebSocket server connection in 1s ... -AQX-")
		window.location = "/";
	}, 1000);
}
ws.onerror = function(error) {
	console.log(error);
}
// add items handler
function appFormAddItemsHandler() {
	var addItemForm = $("form.app-form-add");

	// Date and time variable
	// using current date and time on "date-of-entry" value when loaded
	var waktuBaru = new Date();	// new date object
	var tahun = waktuBaru.getFullYear(),	// full year (ex: 2017)
		bulan = waktuBaru.getMonth() + 1,		// month (ex: 10)
		tanggal = waktuBaru.getDate()		// date (ex: 01 or 12)
	var jam = waktuBaru.getHours(),
		menit = waktuBaru.getMinutes(),
		detik = waktuBaru.getSeconds();

	if (bulan < 10) {
		bulan = "0" + bulan;
	}

	if (tanggal < 10) {
		tanggal = "0" + tanggal;
	}

	if (jam < 10) {
		jam = "0" + jam;
	}

	if (menit < 10) {
		menit = "0" + menit;
	}

	if (detik < 10) {
		detik = "0" + detik;
	}
	var currentJam = jam + ":" + menit + ":" + detik;
	var currentTanggal = tahun + "-" + bulan + "-" + tanggal; // 

	// set default current date
	$("input.date-of-entry").val(currentTanggal + " " + currentJam);

	// onsubmit
	addItemForm.submit(function(e) {
		e.preventDefault();
		var itemName = $("input.item-name").val();		// item name
		var itemModel = $("input.item-model").val();	// item model or brand
		var itemQuantity = $("input.item-quantity").val();  // item quantity
		var itemLimitation = $("input.item-limitation").val(); // item limitation
		var itemUnit = $("input.item-unit").val();  // item unit, such as "Packs"
		var dateOfEntry = $("input.date-of-entry").val(); // date of entry
		var timePeriod = $("input.time-period").val();  // time period
		var typeofTimePeriod = $("select.select-time-period").val(); // type day, month, or week
		var itemOwner = $("input.item-owner").val(); // item owner
		var itemLocation = $("select.select-location").val(); // item location

		// regular expression --> YYYY-MM-DD hh:mm
		var regularExpressionForDatetime = /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2}):(\d{2})$/;
		var resultFormValidation = regularExpressionForDatetime.test(dateOfEntry);

		// itemExpired is optional value, user could blank this out
		// if value is null or empty, then system will change it with "-" string
		if (!timePeriod) {
			timePeriod = 0;
			typeofTimePeriod = "0";
		}

		var alertBox = $("div#app-alert-add-bar");
		if (!itemName) {
			alertBox.html("<span class='close-alert'>&times;</span><br><p>Item Name is empty or null</p>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else if (!itemModel) {
			alertBox.html("<span class='close-alert'>&times;</span><br><p>Item Model/Brand is empty or null</p>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else if (!itemQuantity || !itemLimitation) {
			alertBox.html("<span class='close-alert'>&times;</span><br><p>Item Quantity or Limitation is empty or null</p>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else if (parseInt(itemQuantity == 0) || parseInt(itemLimitation) == 0) {
			alertBox.html("<span class='close-alert'>&times;</span><br><p>Item Quantity or Limitation couldn't zero</p>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else if (parseInt(itemLimitation) > parseInt(itemQuantity)) {
			alertBox.html("<span class='close-alert'>&times;</span><br><p>Item Quantity couldn't be less than Item Limitation</p>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else if (!itemUnit) {
			alertBox.html("<span class='close-alert'>&times;</span><br><p>Item Unit is empty or null</p>");
			alertBox.hide();
			alertBox.fadeIn(200);			
		} else if (!dateOfEntry) {
			alertBox.html("<span class='close-alert'>&times;</span><br><p>Date of entry is empty or not null</p>");
			alertBox.hide();
			alertBox.fadeIn(200);			
		} else if (!resultFormValidation) {
			alertBox.html("<span class='close-alert'>&times;</span><br><p>Wrong date form validation!</p>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else if (!itemOwner) {
			alertBox.html("<span class='close-alert'>&times;</span><br><p>Item Owner is empty or not null</p>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else if (!itemLocation) {
			alertBox.html("<span class='close-alert'>&times;</span><br><p>Item Location is empty or null</p>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else {
			$.ajax({
				url: "/items",
				method: "POST",
				async: true,
				data: {
					item_name: itemName,	// send item name data
					item_model: itemModel,	// send item model/brand data
					item_quantity: itemQuantity,	// send quantity data
					item_limitation: itemLimitation,	// send item limitation number data
					item_unit: itemUnit,	// send item unit data
					date_of_entry: dateOfEntry,	// send date of entry data (date and time when item was inserted)
					time_period: timePeriod,	// how long the item could be in stagging (if not null)
					typeof_time_period: typeofTimePeriod,	// send type of time period such as Day(s), Week(s), Month(s)
					item_owner: itemOwner,	// send item owner data
					item_location: itemLocation, // send item location
					form_request: "ADD",	// send what kind of request
					its_request: addRequest
				},
				success: function(response) {
					if (response.Message) {
						alert("Session login has timed out :(");
						window.location ="/";
					} else {
						alert("Successful inserting data!");
						ws.send(addRequest);
						window.location = "/";		
					}
				}
			});
			addItemForm[0].reset();
		}
		$("span.close-alert").click(function(e) {
			$("div#app-alert-add-bar").fadeOut(100);
		});
	});
}

// Remove or edit function handler
function appFormRemoveOrEditItemsHandler() {
	// Create table
	var resultTable;
	var searchInput = $("input.app-search");
	getJSONTableDataItems("/json_get_all_items");
	
	searchInput.keyup(function() {
		var selectCategory = $("select.select-searchby");
		var searchValue = $(this).val();
		var categoryValue = selectCategory.val();

		if (searchValue == " " || !searchValue) {
			//console.log("Empty");
			searchValue = "Empty";
		}

		if (searchValue !== "Empty") {
			getJSONSearchItems(searchValue, categoryValue);
		} else {
			getJSONTableDataItems("/json_get_all_items");
		}
	});
}

// get JSON value when event handler is onkeyup
function getJSONSearchItems(searchValue, categoryValue) {
	$.ajax({
		async: true,
		url: "/json_search_items",
		method: "POST",
		data: {
			search_value: searchValue,
			category: categoryValue
		},
		success: function(res) {
			var resultTable;

			if (res[0].item_name !== "Not found") {
				resultTable = "<table class='result-table' cellpadding='10' cellspacing='0' border='0'>";
				resultTable += "  <th>No.</th>";
				resultTable += "  <th>Name</th>";
				resultTable += "  <th>Model/Brand</th>";
				resultTable += "  <th>Quantity</th>";
				resultTable += "  <th>Limitation</th>";
				resultTable += "  <th>Item Unit</th>";
				resultTable += "  <th>Date of Entry</th>";
				resultTable += "  <th>Time Period</th>";
				resultTable += "  <th>Date Expired</th>";
				resultTable += "  <th>Owner</th>";
				resultTable += "  <th>Location</th>";
				resultTable += "  <th>Added by</th>";
				resultTable += "  <th>Status</th>";
				resultTable += "  <th colspan='2'>Action</th>";

				for (var i=0; i<res.length; i++) {
					resultTable += "  <tr>";
					resultTable += "    <td>"+ (i+1) +"</td>";
					resultTable += "    <td>"+ res[i].item_name +"</td>";
					resultTable += "    <td>"+ res[i].item_model +"</td>";
					resultTable += "    <td>"+ res[i].item_quantity +"</td>";
					resultTable += "    <td>"+ res[i].item_limitation +"</td>";
					resultTable += "    <td>"+ res[i].item_unit +"</td>";
					resultTable += "    <td>"+ res[i].date_of_entry +"</td>";
					resultTable += "    <td>"+ res[i].item_time_period +"</td>";
					resultTable += "    <td>"+ res[i].item_expired +"</td>";
					resultTable += "    <td>"+ res[i].item_owner +"</td>";
					resultTable += "    <td>"+ res[i].item_location +"</td>";
					resultTable += "    <td>"+ res[i].added_by +"</td>";
					resultTable += "    <td>"+ res[i].item_status +"</td>";
					resultTable += "    <td><button class='action-button app-edit' value='"+res[i].item_id+"' data-item-name='"+res[i].item_name+"' data-item-model='"+res[i].item_model+"' data-item-quantity='"+res[i].item_quantity+"' data-item-limitation='"+res[i].item_limitation+"' data-item-unit='"+res[i].item_unit+"' data-time-period='"+res[i].item_time_period+"' data-item-owner='"+res[i].item_owner+"' data-item-location='"+res[i].item_location+"' data-date-entry='"+res[i].date_of_entry+"' data-item-expired='"+res[i].item_expired+"' data-added-by='"+res[i].added_by+"' data-item-status='"+res[i].item_status+"'>Edit</button></td>";
							resultTable += "    <td><button class='action-button app-remove' value='"+ res[i].item_id +"' data-item-name='"+res[i].item_name+"' data-item-owner='"+res[i].item_owner+"' data-item-location='"+res[i].item_location+"'>Remove</button></td>";
					resultTable += "  </tr>";
				}

				resultTable += "</table>";
				document.getElementById("remove-result").innerHTML = resultTable;
				$("div#remove-result").hide();
				$("div#remove-result").fadeIn(300);
			} else {
				$("div#remove-result").html("<div class='not-found'><h2>Not results have been found :(</h2></div>");
				$("div#remove-result").hide();
				$("div#remove-result").fadeIn(300);
			}
			// edit data (table) and remove (table)
			editTable();
			removeTable();
			$("div#app-loading-bar").css("display", "none");
		},
		beforeSend: function() {
			$("div#app-loading-bar").css("display", "block");
		},
		error: function(res) {
			if (res.status == 400) {
				alert(res.responseText);
				window.location = "/";
			}
		}
	});
}

function getJSONTableDataItems() {
	$.ajax({
		url: "/json_get_all_items",
		async: true,
		success: function(res) {
			var resultTable;
			resultTable = "<table class='result-table' cellpadding='10' cellspacing='0' border='0'>";
			resultTable += "  <th>No.</th>";
			resultTable += "  <th>Name</th>";
			resultTable += "  <th>Model/Brand</th>";
			resultTable += "  <th>Quantity</th>";
			resultTable += "  <th>Limitation</th>";
			resultTable += "  <th>Item Unit</th>";
			resultTable += "  <th>In</th>";
			resultTable += "  <th>Time Period</th>";
			resultTable += "  <th>Date Expired</th>";
			resultTable += "  <th>Owner</th>";
			resultTable += "  <th>Location</th>";
			resultTable += "  <th>Added by</th>";
			resultTable += "  <th>Status</th>";
			resultTable += "  <th colspan='2'>Action</th>";

			for (var i=0; i<res.length; i++) {
				resultTable += "  <tr>";
				resultTable += "    <td>"+ (i+1) +"</td>";
				resultTable += "    <td>"+ res[i].item_name +"</td>";
				resultTable += "    <td>"+ res[i].item_model +"</td>";
				resultTable += "    <td>"+ res[i].item_quantity +"</td>";
				resultTable += "    <td>"+ res[i].item_limitation +"</td>";
				resultTable += "    <td>"+ res[i].item_unit +"</td>";
				resultTable += "    <td>"+ res[i].date_of_entry +"</td>";
				resultTable += "    <td>"+ res[i].item_time_period +"</td>";
				resultTable += "    <td>"+ res[i].item_expired +"</td>";
				resultTable += "    <td>"+ res[i].item_owner +"</td>";
				resultTable += "    <td>"+ res[i].item_location +"</td>";
				resultTable += "    <td>"+ res[i].added_by +"</td>";
				resultTable += "    <td>"+ res[i].item_status +"</td>";
				resultTable += "    <td><button class='action-button app-edit' value='"+res[i].item_id+"' data-item-name='"+res[i].item_name+"' data-item-model='"+res[i].item_model+"' data-item-quantity='"+res[i].item_quantity+"' data-item-limitation='"+res[i].item_limitation+"' data-item-unit='"+res[i].item_unit+"' data-time-period='"+res[i].item_time_period+"' data-item-owner='"+res[i].item_owner+"' data-item-location='"+res[i].item_location+"' data-date-entry='"+res[i].date_of_entry+"' data-item-expired='"+res[i].item_expired+"' data-added-by='"+res[i].added_by+"' data-item-status='"+res[i].item_status+"'>Edit</button></td>";
				resultTable += "    <td><button class='action-button app-remove' value='"+ res[i].item_id +"' data-item-name='"+res[i].item_name+"' data-item-owner='"+res[i].item_owner+"' data-item-location='"+res[i].item_location+"' data-item-unit="+res[i].item_unit+" data-item-quantity="+res[i].item_quantity+">Remove</button></td>";
				resultTable += "  </tr>";
			}

			resultTable += "</table>";
			document.getElementById("remove-result").innerHTML = resultTable;
			$("div#remove-result").hide();
			$("div#remove-result").fadeIn(300);

			// edit data (table) and remove (table)
			editTable();
			removeTable();
			$("div#app-loading-bar").css("display", "none");
		},
		beforeSend: function() {
			$("div#app-loading-bar").css("display", "block");
		},
		error: function(res) {
			if (res.status == 400) {
				alert(res.responseText);
				window.location = "/";
			}
		}
	});
}

// edit table function
function editTable() {
	// when action button clicked
	// opening popup edit form if edit is clicked
	// opening popup quetion form if remove is clicked
	var editButton = $("button.app-edit");
	
	editButton.click(function() {
		var itemThisId = $(this).val(), // item_id
		itemThisName = $(this).attr("data-item-name"), // item_name
		itemThisModel = $(this).attr("data-item-model"), // item_model
		itemThisQuantity = $(this).attr("data-item-quantity"), // item_quantity
		itemThisLimitation = $(this).attr("data-item-limitation"), // item_limittaion
		itemThisUnit = $(this).attr("data-item-unit"), // item_unit
		itemThisOwner = $(this).attr("data-item-owner"), // item_owner
		itemThisLocation = $(this).attr("data-item-location"); // item_location
		itemThisDateEntry = $(this).attr("data-date-entry"); // date_of_entry
		itemThisTimePeriod = $(this).attr("data-time-period"); // item_time_period
		itemThisExpired = $(this).attr("data-item-expired"); // item_expired
		itemThisAddedBy = $(this).attr("data-added-by"); // added_by
		itemThisStatus = $(this).attr("data-item-status"); // item_status

		// show the modal/popup
		var jqueryGetModal = $("div#prompt-edit-modal");
		var modal = document.getElementById("prompt-edit-modal");
		jqueryGetModal.fadeIn(300);
		window.onclick = function(e) {
			if (e.target == modal) {
			//modal.style.display = "none";
				jqueryGetModal.fadeOut(300);
				$("div#app-edit-alert").fadeOut(300);
			}
		}

		// table content for modal/popup
		var editContent = "<div class='tbl-content-modal edit-box'>";
		editContent += "<label style='font-weight: bold; color: #2980b9; font-size: 15px;'>Edit Items</label><br><br>";
		editContent += "<table class='table-form-edit' cellpadding='8px' cellspacing='0' style='border: solid 1px #ddd;'>";
		editContent += "<tr>";
		editContent += "  <td>ID</td>";
		editContent += "  <input class='edit-id' type='text' value='"+itemThisId+"' style='display: none;'></span>";
		editContent += "  <td><label style='padding-left:10px;'>"+itemThisId+"</label></td>";
		editContent += "</tr>";
		editContent += "<tr>";
		editContent += "  <td>Name</td>";
		editContent += "  <td><input class='edit-table edit-name' type='text' placeholder='Name' value='"+itemThisName+"'></td>";
		editContent += "</tr>";
		editContent += "<tr>";
		editContent += "  <td>Model/Brand</td>";
		editContent += "  <td><input class='edit-table edit-model' type='text' placeholder='Model/Brand' value='"+itemThisModel+"'></td>";
		editContent += "</tr>";
		editContent += "<tr>";
		editContent += "  <td>Quantity</td>";
		editContent += "  <td><input class='edit-table edit-quantity' type='number' placeholder='Quantity' value='"+parseInt(itemThisQuantity)+"' min='1'></td>";
		editContent += "</tr>";
		editContent += "<tr>";
		editContent += "  <td>Limitation</td>";
		editContent += "  <td><input class='edit-table edit-limitation' type='number' placeholder='Limitation' value='"+parseInt(itemThisLimitation)+"' min='1'></td>";
		editContent += "</tr>";
		editContent += "<tr>";
		editContent += "  <td>Item Unit</td>";
		editContent += "  <td><input class='edit-table edit-unit' type='text' placeholder='Item Unit' value='"+itemThisUnit+"'></td>";
		editContent += "</tr>";
		editContent += "<tr>";
		editContent += "  <td>Date of Entry</td>";
		editContent += "  <td><label style='padding-left:10px;'>"+itemThisDateEntry+"</label></td>";
		editContent += "</tr>";
		editContent += "<tr>";
		editContent += "  <td>Time Period</td>";
		// if time period is string, change the value to number
		if (itemThisTimePeriod == "None") {
			itemThisTimePeriod = "0";
		}
		editContent += "  <td><input class='edit-table edit-time-period' type='number' placeholder='Time Period'>";
		editContent += "    <select class='edit-period edit-type-period'>";
		editContent += "       <option value='Day(s)'>Day(s)</option>";
		editContent += "       <option value='Week(s)'>Week(s)</option>";
		editContent += "       <option value='Month(s)'>Month(s)</option>";
		editContent += "    </select>";
		editContent += "   &nbsp;<label style='color: #27ae60; font-weight: bold;'><i>*Current: "+itemThisTimePeriod+"</i></label>";
		editContent += "  </td>";
		editContent += "</tr>";
		editContent += "<tr>";
		editContent += "  <td>Date Expired</td>";
		editContent += "  <td><label style='padding-left:10px;'>"+itemThisExpired+"</label></td>";
		editContent += "</tr>";
		editContent += "<tr>";
		editContent += "  <td>Owner</td>";
		editContent += "  <td><input class='edit-table edit-owner' type='text' placeholder='Owner' value='"+itemThisOwner+"'></td>";
		editContent += "</tr>";
		editContent += "<tr>";
		editContent += "  <td>Location</td>";
		editContent += "  <td>";
		editContent += "    <select class='edit-location'>";
		editContent += "       <option value=''>-- Location --</option>";
		editContent += "       <option value='Staging Lt.1'>Staging Lt.1</option>";
		editContent += "       <option value='Staging Lt.3'>Staging Lt.3</option>";
		editContent += "       <option value='Gudang Bawah Tangga'>Gudang Bawah Tangga</option>";
		editContent += "    </select>";
		editContent += "   &nbsp;<label style='color: #27ae60; font-weight: bold;'><i>*Current: "+itemThisLocation+"</i></label>";
		editContent += "  </td>";
		editContent += "</tr>";
		editContent += "<tr>";
		editContent += "  <td>Added by</td>";
		editContent += "  <td><label style='padding-left:10px;'>"+itemThisAddedBy+"</label></td>";
		editContent += "</tr>";
		editContent += "<tr>";
		editContent += "  <td>Status</td>";
		editContent += "  <td><label style='padding-left:10px;'>"+itemThisStatus+"</label></td>";
		editContent += "</tr>";
		editContent += "</table>";
		editContent += "</div>";
		editContent += "<div id='edit-btn-box' style='text-align: center;'>";
		editContent += "   <br><br><button class='remove-prompt-action edit-update'>Update</button> <button class='remove-prompt-action cancel-update'>Cancel</button>";
		editContent += "</div>";

		$("div.edit-modal-content").html(editContent);
		$("input[placeholder='Name']").focus();
		$("button.cancel-update").click(function() {
			jqueryGetModal.fadeOut(200);
		});

		// get the value from edit modal
		$("button.edit-update").click(function() {
			//console.log("test");
			// get the current value
			var editId = $("input.edit-id").val();
			var editedName = $("input.edit-name").val();
			var editedModel = $("input.edit-model").val();
			var editedQuantity = $("input.edit-quantity").val();
			var editedLimitation = $("input.edit-limitation").val();
			var editedUnit = $("input.edit-unit").val();
			var editedTimePeriod = $("input.edit-time-period").val();
			var editedTypePeriod = $("select.edit-type-period").val();
			var editedOwner = $("input.edit-owner").val();
			var editedLocation = $("select.edit-location").val();

			if (editedTimePeriod == 0 || !editedTimePeriod) {
				editedTimePeriod = 0;
				editedTypePeriod = "0";
			}

			// check if value is not empty
			var editAlertModal = document.getElementById("app-edit-alert");
			var jqueryGetAlertEditModal = $("div#app-edit-alert");
			// if item name is empty
			if (!editedName) {
				editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><p>Name is empty!</p>";
				jqueryGetAlertEditModal.hide();
				jqueryGetAlertEditModal.fadeIn(200);
			} else if (!editedModel) {
				editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><p>Model/Brand is empty!</p>";
				jqueryGetAlertEditModal.hide();
				jqueryGetAlertEditModal.fadeIn(200);
			} else if (!editedQuantity) {
				editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><p>Item Quantity is empty!</p>";
				jqueryGetAlertEditModal.hide();
				jqueryGetAlertEditModal.fadeIn(200);
			} else if (!editedLimitation) {
				editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><p>Item Limitation is empty!</p>";
				jqueryGetAlertEditModal.hide();
				jqueryGetAlertEditModal.fadeIn(200);
			} else if (parseInt(editedLimitation) > parseInt(editedQuantity)) {
				editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><p>Item quantity couldn't be less than item limitation!</p>";
				jqueryGetAlertEditModal.hide();
				jqueryGetAlertEditModal.fadeIn(200);
			} else if (!editedUnit) {
				editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><p>Item unit is empty!</p>";
				jqueryGetAlertEditModal.hide();
				jqueryGetAlertEditModal.fadeIn(200);
			} else if (!editedOwner) {
				editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><p>Item owner is empty!</p>";
				jqueryGetAlertEditModal.hide();
				jqueryGetAlertEditModal.fadeIn(200);
			} else if (!editedLocation) {
				editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><p>Location is empty!</p>";
				jqueryGetAlertEditModal.hide();
				jqueryGetAlertEditModal.fadeIn(200);
			} else {
				console.log("I get this:"); 
				console.log(editId, editedName, editedModel, editedQuantity, editedLimitation, editedUnit, editedTimePeriod, editedTypePeriod, editedOwner, editedLocation);
				$.ajax({
					url: "/json_update_item",
					async: true,
					method: "POST",
					data: {
						item_id: editId,
						item_name: editedName,
						item_model: editedModel,
						item_quantity: editedQuantity,
						item_limitation: editedLimitation,
						item_unit: editedUnit,
						date_of_entry: itemThisDateEntry,
						time_period: editedTimePeriod,
						type_period: editedTypePeriod,
						item_owner: editedOwner,
						item_location: editedLocation,
						its_request: editRequest
					},
					success: function(res) {
						console.log(res);
						var editButtonBox = document.getElementById("edit-btn-box");

						editButtonBox.style.display = "none";
						jqueryGetAlertEditModal.fadeOut(200);
						$("div.tbl-content-modal").html("<p style='padding: 10px; font-weight: bold; color: #3498db;'>"+res.message+" Please wait ...</p>");
						setTimeout(function() {
							jqueryGetModal.fadeOut(200);
						}, 3000);
						getJSONTableDataItems("/json_get_all_items");
						window.onclick = function(e) {
							if (e.target == modal) {
								jqueryGetModal.css("display", "block");
							}
						}
						ws.send(editRequest);
					}
				});
			}

			// on close alert clicked
			$("span.close-alert").click(function() {
				jqueryGetAlertEditModal.fadeOut(200);
			});
		});
	});
}

// remove table function
function removeTable() {
	var removeButton = $("button.app-remove");
	removeButton.click(function() {
		var btnValue = $(this).val();
		var btnItemNameAttr = $(this).attr("data-item-name");
		var btnItemOwnerAttr = $(this).attr("data-item-owner");
		var btnItemLocation = $(this).attr("data-item-location");
		var btnItemUnit = $(this).attr("data-item-unit");
		var btnItemQuantity = $(this).attr("data-item-quantity");

		// show modal / popup
		var jqueryGetModal = $("div#prompt-remove-alert");
		var modal = document.getElementById("prompt-remove-alert");
		jqueryGetModal.fadeIn(300);

		// show the prompt
		var modalContent = "<div class='tbl-content-modal'><label style='font-weight: bold; color: #c0392b;'>Are you sure want to remove this item?</label><br><br>";
			modalContent += "<table class='tbl-remove' cellpadding='10px' cellspacing='0' style='border: solid 1px #ddd;'>";
			modalContent += "<tr>";
			modalContent += "  <td>ID</td>";
			modalContent += "  <td>"+btnValue+"</td>";
			modalContent += "</tr><tr>";
			modalContent += "  <td>Name</td>";
			modalContent += "  <td>"+btnItemNameAttr+"</td>";
			modalContent += "</tr><tr>";
			modalContent += "  <td>Owner</td>";
			modalContent += "  <td>"+btnItemOwnerAttr+"</td>";
			modalContent += "</tr><tr>";
			modalContent += "  <td>Location</td>";
			modalContent += "  <td>"+btnItemLocation+"</td>";
			modalContent += "</tr>";
			modalContent += "</table><br><br>";
			modalContent += "<div class='remove-box-btn' style='text-align: center;'>";
			modalContent += "<button class='remove-prompt-action remove-yes'>Yes</button>&nbsp;<button class='remove-prompt-action remove-no'>No</button>";
			modalContent += "</div>";
			modalContent += "</div>";

			$("div.remove-modal-content").html(modalContent);

			window.onclick = function(e) {
				if (e.target == modal) {
					//modal.style.display = "none";
					jqueryGetModal.fadeOut(300);
				}
			}
			$("button.remove-no").click(function() {
				jqueryGetModal.fadeOut(300);
			});

			// when yes button clicked, it will send ajax request with post method
			// send the item_id that has selected
			// proccessing in the server and if success, it will send feedback such as json
			// message
			$("button.remove-yes").click(function() {
				console.log(btnValue);
				$.ajax({
				url: "/json_remove_item",
				async: true,
				method: "POST",
				data: {
					//UpdateHistory(history_code, history_by, history_notes, item_unit, item_quantity, item_name, item_id, item_location string)
					item_id: btnValue,
					item_unit: btnItemUnit,
					item_quantity: btnItemQuantity,
					item_name: btnItemNameAttr,
					item_location: btnItemLocation,
					its_request: removeRequest
				},
				success: function(res) {
					console.log(res);
					// if success, show 
					if (res.redirect) {
						$("div.tbl-content-modal").html("<p style='padding: 10px; font-weight: bold; color: #3498db;'>"+res.message+" Please wait ... </p>");
						ws.send(removeRequest);
						setTimeout(function() {
							jqueryGetModal.fadeOut(300);
						}, 3000);
						getJSONTableDataItems("/json_get_all_items");
						window.onclick = function(e) {
							if (e.target == modal) {
								jqueryGetModal.css("display", "block");
							}
						}
					}
				}
			});
		});
	});
}
