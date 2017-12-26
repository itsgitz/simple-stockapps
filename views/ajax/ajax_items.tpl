[[ define "items_layout" ]]

[[ template "script". ]]
[[ template "style". ]]
[[ template "loading_bar". ]]
<div id="app-ajax-items">
	<h3>Items Dashboard</h3>
	<span style="text-align: justify;"><i style="font-size: 90%;">You could add or remove (Administrator privilege) items, Please choose one of navigation options below.</i></span>

	[[ template "side_navigation". ]]
	<div id="app-form-wrapper">
		[[ template "welcome_box". ]]
		[[ template "add_box". ]]
		[[ template "remove_box". ]]
	</div>
</div>

[[ end ]]

[[ define "script" ]]
<script>
$(document).ready(function() {
	var sideNavBar = $("div#app-side-nav ul li a");
	var addButton = $("a.item-add");
	var removeButton = $("a.item-remove");
	var addBox = $("div#app-add-content");
	var removeBox = $("div#app-remove-content");
	var hashUrl = window.location.hash;
	var getOptionFromHash = hashUrl.substring(22);

	// onload if current url has a hash url
	switch(getOptionFromHash) {
		case "add":
			addBox.css("display", "block");
			removeBox.css("display", "none");
			$("title").text("Adding Item - Simple StockApps");
			$("input[placeholder='Item Name']").focus();
		break;
		case "remove":
			removeBox.css("display", "block");
			addBox.css("display", "none");
			$("title").text("Removing Item - Simple StockApps");
		break;
	}

	// prevent default from clicked links		
	sideNavBar.click(function(e) {
		e.preventDefault();
	});

	// hide welcome-box when loaded
	if (getOptionFromHash) {
		$("div#app-welcome-box").css("display", "none");
	}

	$("div#app-side-nav ul li a").click(function() {
		$("div#app-welcome-box").css("display", "none");
	});

	// when addbutton click
	addButton.click(function() {
		var stateObj = { page: "items#add" };
		history.pushState(stateObj, "page", "/navbar?#navigate_link=/items#add");
		addBox.css("display", "block");
		removeBox.css("display", "none");
		$("title").text("Adding Item - Simple StockApps");
		$("input[placeholder='Item Name']").focus();
	});
	// when removebutton click
	removeButton.click(function() {
		var stateObj = { page: "items#remove" };
		history.pushState(stateObj, "page", "/navbar?#navigate_link=/items#remove");
		removeBox.css("display", "block");
		addBox.css("display", "none");
		$("title").text("Removing Item - Simple StockApps");
	});

	// handling request from form add items
	appFormAddItemsHandler();
	appFormRemoveOrEditItemsHandler();
});



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
		menit = waktuBaru.getMinutes();

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
	var currentJam = jam + ":" + menit;
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
		var regularExpressionForDatetime = /^(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2})$/;
		var resultFormValidation = regularExpressionForDatetime.test(dateOfEntry);

		// itemExpired is optional value, user could blank this out
		// if value is null or empty, then system will change it with "-" string
		if (!timePeriod) {
			timePeriod = 0;
			typeofTimePeriod = "0";
		}

		var alertBox = $("div#app-alert-add-bar");
		if (!itemName) {
			alertBox.html("<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Item Name is empty or null</div><br>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else if (!itemModel) {
			alertBox.html("<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Item Model/Brand is empty or null</div><br>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else if (!itemQuantity || !itemLimitation) {
			alertBox.html("<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Item Quantity or Limitation is empty or null</div><br>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else if (parseInt(itemQuantity == 0) || parseInt(itemLimitation) == 0) {
			alertBox.html("<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Item Quantity or Limitation couldn't zero</div><br>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else if (parseInt(itemLimitation) > parseInt(itemQuantity)) {
			alertBox.html("<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Item Quantity couldn't be less than Item Limitation</div><br>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else if (!itemUnit) {
			alertBox.html("<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Item Unit is empty or null</div><br>");
			alertBox.hide();
			alertBox.fadeIn(200);			
		} else if (!dateOfEntry) {
			alertBox.html("<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Date of entry is empty or not null</div><br>");
			alertBox.hide();
			alertBox.fadeIn(200);			
		} else if (!resultFormValidation) {
			alertBox.html("<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Wrong date form validation!</div><br>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else if (!itemOwner) {
			alertBox.html("<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Item Owner is empty or not null</div><br>");
			alertBox.hide();
			alertBox.fadeIn(200);
		} else if (!itemLocation) {
			alertBox.html("<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Item Location is empty or null</div><br>");
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
					form_request: "ADD"	// send what kind of request
				},
				success: function(response) {
					if (response.Message) {
						alert("Session login has timed out :(");
						window.location ="/";
					} else {
						alert("Successful inserting data!");
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

	searchInput.keyup(function() {
		var selectCategory = $("select.select-searchby");
		var searchValue = $(this).val();
		var categoryValue = selectCategory.val();

		if (searchValue == " " || !searchValue) {
			//console.log("Empty");
			searchValue = "Empty";
		}

		if (searchValue !== "Empty") {
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
						$("div#remove-result").html("<div class='not-found'><h2>Not Found :(</h2></div>");
						$("div#remove-result").hide();
						$("div#remove-result").fadeIn(300);
					}
					var editButton = $("button.app-edit");
					var removeButton = $("button.app-remove");

					// when action button clicked
					// opening popup edit form if edit is clicked
					// opening popup quetion form if remove is clicked
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

						editContent += "  <td><input class='edit-table edit-time-period' type='number' placeholder='Time Period' value='"+parseInt(itemThisTimePeriod)+"'>";
						editContent += "    <select class='edit-period edit-type-period'>";
						editContent += "       <option value='Day(s)'>Day(s)</option>";
						editContent += "       <option value='Week(s)'>Week(s)</option>";
						editContent += "       <option value='Month(s)'>Month(s)</option>";
						editContent += "    </select>";
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
						editContent += "       <option value='DC TBS 1st Floor'>DC TBS 1st Floor</option>";
						editContent += "       <option value='DC TBS 2nd Floor'>DC TBS 2nd Floor</option>";
						editContent += "       <option value='DC TBS 3rd Floor'>DC TBS 3rd Floor</option>";
						editContent += "    </select>";
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
						editContent += "<div style='text-align: center;'>";
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

							// check if value is not empty
							var editAlertModal = document.getElementById("app-edit-alert");
							var jqueryGetEditModal = $("div#app-edit-alert");
							// if item name is empty
							if (!editedName) {
								editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Name is empty!</div>";
								jqueryGetEditModal.hide();
								jqueryGetEditModal.fadeIn(200);
							} else if (!editedModel) {
								editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Model/Brand is empty!</div>";
								jqueryGetEditModal.hide();
								jqueryGetEditModal.fadeIn(200);
							} else if (!editedQuantity) {
								editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Item Quantity is empty!</div>";
								jqueryGetEditModal.hide();
								jqueryGetEditModal.fadeIn(200);
							} else if (!editedLimitation) {
								editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Item Limitation is empty!</div>";
								jqueryGetEditModal.hide();
								jqueryGetEditModal.fadeIn(200);
							} else if (parseInt(editedLimitation) > parseInt(editedQuantity)) {
								editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Item quantity couldn't be less than item limitation!</div>";
								jqueryGetEditModal.hide();
								jqueryGetEditModal.fadeIn(200);
							} else if (!editedUnit) {
								editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Item unit is empty!</div>";
								jqueryGetEditModal.hide();
								jqueryGetEditModal.fadeIn(200);
							} else if (!editedOwner) {
								editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Item owner is empty!</div>";
								jqueryGetEditModal.hide();
								jqueryGetEditModal.fadeIn(200);
							} else if (!editedLocation) {
								editAlertModal.innerHTML = "<span class='close-alert'>&times;</span><br><div style='text-align: center;'>Location is empty!</div>";
								jqueryGetEditModal.hide();
								jqueryGetEditModal.fadeIn(200);
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
										time_period: editedTimePeriod,
										type_period: editedTypePeriod,
										item_owner: editedOwner,
										item_location: editedLocation
									},
									success: function(res) {
										console.log("Successful update data");
									}
								});
							}

							// on close alert clicked
							$("span.close-alert").click(function() {
								jqueryGetEditModal.fadeOut(200);
							});
						});
					});

					removeButton.click(function() {
						var btnValue = $(this).val();
						var btnItemNameAttr = $(this).attr("data-item-name");
						var btnItemOwnerAttr = $(this).attr("data-item-owner");
						var btnItemLocation = $(this).attr("data-item-location");

						// show modal / popup
						var jqueryGetModal = $("div#prompt-remove-alert");
						var modal = document.getElementById("prompt-remove-alert");
						jqueryGetModal.fadeIn(300);

						// show the prompt
						var modalContent = "<div class='tbl-content-modal'><label style='font-weight: bold; color: #c0392b;'>Are you sure want to remove this item?</label><br><br>";
						modalContent += "<table cellpadding='10px' cellspacing='0' style='border: solid 1px #ddd;'>";
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
									item_id: btnValue
								},
								success: function(res) {
									console.log(res);
									// if success, show 
									if (res.redirect) {
										$("div.tbl-content-modal").html("<p style='padding: 10px; font-weight: bold; color: #3498db;'>"+res.message+" Please wait ... </p>");
										setTimeout(function() {
											jqueryGetModal.fadeOut(300);
										}, 3000);
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
		} else {
			$("div#remove-result").html("<div class='not-found'><h2>Searching items ...</h2></div>");
		}
	});
}

</script>
[[ end ]]

[[ define "style" ]]
<style>
	.close-alert {
		font-size: 28px; float: right;
		padding: 15px;
	}
	.close-alert:hover {
		cursor: pointer;
	}
	div#app-ajax-items {
		padding: 20px;
		width: 100%;
		position: absolute;
		left: 0;
		right: 0;
		display: table;
	}
	.clear {
		clear:both;
	}
	/* Vertical navigation style */
	div#app-side-nav {
		position: fixed;
		z-index: 1;
		left: 0;
		display: table-cell;
		padding-top: 25px;
		position: absolute;
		left: 10px;
		height: 100%;
		border-radius: 5px;
		overflow-x: hidden;
	}
	div#app-side-nav ul {
		list-style-type: none;
		margin: 0;
		padding: 0;
		width: 200px;
	}
	div#app-side-nav ul a {
		text-decoration: none;
		display: block;
		color: #2c3e50;
		padding: 11px;
		font-weight: 500;
		font-size: 90%;
	}
	div#app-side-nav ul a:hover {
		background-color: #D8D8D8;
	}
	/* end of vertical navigation style */

	/* form wrapper style */
	div#app-form-wrapper {
		display: table;
		margin-left: 210px;
		padding: 0px 10px;
	}
	div#app-add-content {
		display: none;
		padding-top: 20px;
		padding-left: 10px;
		padding-bottom: 25px;
		position: absolute;
		left: 225px;
		right: 10px;
		overflow-x: auto;
	}
	/* end of wrapepr style */

	/* Add Items Content Style */
	div#app-add-content input[type="text"] {
		outline: none;
		border: none;
		border-bottom: solid 1px #95a5a6;
		padding: 10px;
		width: 100%;
	}
	div#app-add-content input[type="submit"] {
		border: none;
		padding: 5px;
		width: 100%;
		background-color: #c0392b;
		color: #F2F2F2;
		border-radius: 5px;
	}
	div#app-add-content input[type="submit"]:hover {
		cursor: pointer;
		background-color: #27ae60;
	}
	div#app-add-content input[type="number"] {
		border: none;
		padding: 10px;
		padding-left: 10px;
		border-bottom: solid 1px #95a5a6;
		outline: none;
	}
	div#app-add-content input[type="number"].item-quantity {
		width: 100%;
	}
	div#app-add-content input[type="number"].item-limitation {
		width: 100%;
	}
	div#app-add-content input[type="number"].time-period {
		width: 100%;
		background-color: none;
		padding: 10px;
	}

	select {
		-webkit-appearance:none;
		-o-appearance: none;
		-moz-appearance: none;
		-ms-appearance: none;
		appearance: none;
	}
	/* CAUTION: IE hackery ahead */
	select::-ms-expand { 
	    display: none; /* remove default arrow on ie10 and ie11 */
	}
	select.select-time-period {
		border: none;
		outline: none;
		padding: 10px;
		border-bottom: solid 1px #95a5a6;
		width: 100%;
	}
	select.select-location {
		border: none;
		outline: none;
		padding: 10px;
		border-bottom: solid 1px #95a5a6;
		width: 100%;
	}
	select.select-time-period:hover {
		cursor: pointer;
	}
	select.select-location:hover {
		cursor: pointer;
	}
	.row:after {
		content: "";
		display: table;
		clear: both;
	}
	.arrow-right {
		  width: 0; 
		  height: 0; 
		  border-top: 5px solid transparent;
		  border-bottom: 5px solid transparent;
		  border-left: 5px solid gray;
		  float: right;
	}
	/* label note */
	label.app-input-note {
		font-size: 80%;
		padding-left: 15px;
		color: red;
	}
	/* end of Add Items Content style */

	/* Alert style */
	div#app-alert-add-bar {
		position: fixed;
		top: 0;
		left: 20%;
		right: 20%;
		background-color: #2c3e50;
		color: #FFFFFF;
		padding: 2px;
		display: none;
		border-bottom-left-radius: 5px;
		border-bottom-right-radius: 5px;
	}
	span.app-close {
		color: #FFFFFF;
		float: right;
		font-size: 28px;
		font-weight: bold;
	}
	/* End of alert style */

	/* Welcome box style */
	div#app-welcome-box {
		padding-top: 20px;
		padding-left: 50px;
		color: #34495e;
	}
	/* end of welcome box */

	/* Remove box */
	div#app-remove-content {
		display: none;
		padding-top: 0px;
		position: absolute;
		left: 225px;
		right: 10px;
		overflow: hidden;
	}
	div#app-search-form-box ul {
		list-style-type: none;
		margin: 0;
		padding: 0;
	}
	div#app-search-form-box ul li {
		display: inline;
		padding: 2px;
		float: left;
	}
	div#app-search-form-box {
		padding-left: 15px;
		padding-top: 10px;
		display: inline;
		float: left;
		width: 100%;
		border-bottom: solid 1px #95a5a6;
	}
	input.app-search {
		background-image: url(/img/searchicon.png);
		background-size: 12px;
		background-position: 7px 7px;
		background-repeat: no-repeat;
		width: 350px;
		padding-left: 40px;
		padding-top: 5px;
		padding-bottom: 5px;
		font-size: 12px;
		border: solid 1px #95a5a6;
		margin-bottom: 12px;
		border-radius: 5px;
		outline: none;
	}
	select.select-searchby {
		padding: 4px;
		border-radius: 5px;
		border: solid 1px #95a5a6;
		color: #95a5a6;
		text-align: center;
	}
	select.select-searchby:hover {
		cursor: pointer;
	}

	div#remove-result {
		overflow-x: auto;
		padding: 10px;
	}
	div#remove-result .result-table {
		text-align: center;
		font-size: 80%;
		border: solid 1px #ddd;
	}
	tr:nth-child(even) {
		background-color: #F2F2F2;
	}
	div.remove-welcome-box {
		color: #2c3e50;
		padding-top: 20px;
		padding-left: 25px;
		padding: 35px;
	}
	.not-found {
		color: #2c3e50;
		padding-top: 20px;
		padding-left: 25px;
		padding: 35px;
	}

	/* action button */
	button.action-button {
		border: solid 1px #FFFFFF;
		padding: 5px;
		padding-left: 15px;
		padding-right: 15px;
		color: #FFFFFF;
		border-radius: 5px;
	}
	button.app-remove {
		background-color: #c0392b;
	}
	button.app-edit {
		background-color: #2980b9;
	}
	button.app-remove:hover {
		background-color: #FFFFFF;
		border: solid 1px #c0392b;
		color: #c0392b;
	}
	button.app-edit:hover {
		background-color: #FFFFFF;
		border: solid 1px #2980b9;
		color: #2980b9;
	}
	button.action-button:hover {
		cursor: pointer;
	}
	div#app-loading-bar {
		display: none;
		position: fixed;
		top: 0;
		left: 0;
		right: 0;
		background-color: #34495e;
		padding: 2px;
	}
	div#prompt-edit-modal {
		display: none;
		position: fixed;
		z-index: 1;
		left: 0;
		top: 0;
		width: 100%;
		height: 100%;
		overflow: auto;
		background-color: rgb(0,0,0);
		background-color: rgba(0,0,0,0.4);	
	}
	div#prompt-remove-alert {
		display: none;
		position: fixed;
		z-index: 1;
		left: 0;
		top: 0;
		width: 100%;
		height: 100%;
		overflow: auto;
		background-color: rgb(0,0,0);
		background-color: rgba(0,0,0,0.4); 
	}
	div.remove-modal-content {
		background-color: #FEFEFE;
		margin: 15% auto;
		padding: 20px;
		border: solid 1px #888;
		width: 70%;
		border-radius: 5px;
		box-shadow: 1px 2px 2px #888888;
	}
	div.edit-modal-content {
		background-color: #FEFEFE;
		margin: 5% auto;
		padding: 20px;
		border: solid 1px #888;
		width: 70%;
		border-radius: 5px;
		box-shadow: 1px 2px 2px #888888;
	}
	div.tbl-content-modal {
		overflow-x: auto;
	}
	div.tbl-content-modal table {
		width: 100%;
	}
	button.remove-prompt-action {
		border: none;
		color: #FFFFFF;
		padding-top: 8px;
		padding-bottom: 8px;
		padding-left: 25px;
		padding-right: 25px;
		border-radius: 2px;
		font-weight: 700;
	}
	button.remove-prompt-action:hover {
		cursor: pointer;
	}
	button.remove-yes {
		background-color: #27ae60;
	}
	button.remove-no {
		background-color: #e74c3c;
	}
	button.edit-update {
		background-color: #27ae60;
	}
	button.cancel-update {
		background-color: #e74c3c;
	}
	/* end of remove box */

	/* Edit Modal Content */

	input.edit-table[type="text"], input.edit-table[type="number"] {
		border: none;
		border-bottom: solid 1px #95a5a6;
		padding: 10px;
		outline: none;
		width: 300px;
	}
	input.edit-time-period[type='number'] {
		width: 200px;
	}
	table.table-form-edit tr:nth-child(even) {
		background-color: #FFFFFF;
	}
	table.table-form-add tr:nth-child(even) {
		background-color: #FFFFFF;
	}
	input.edit-table {
		font-size: 90%;
	}
	select.edit-period {
		border: none;
		border-bottom: solid 1px #95a5a6;
		padding: 9px;
		width: 100px;
		outline: none;
	}
	select.edit-location {
		border: none;
		border-bottom: solid 1px #95a5a6;
		padding: 9px;
		width: 300px;
		outline: none;
	}
	select.edit-location:hover, .edit-period:hover {
		cursor: pointer;
	}
	div.edit-box {
		font-size: 80%;
	}
	div#app-edit-alert {
		display: none;
		position: fixed;
		z-index: 1;
		top: 0;
		left: 35%;
		right: 35%;
		background-color: #e74c3c;
		color: #FFFFFF;
		border-radius: 3px;
	}
	/* end of edit modal content */

	@media only screen and (max-width: 550px) {
		div#app-side-nav {
			display: none;
		}
		div#app-form-wrapper {
			margin: 0%;
		}
		div#app-add-content {
			position: absolute;
			left: 10px;
			right: 10px;
		}
		div#app-welcome-box {
			padding: 0;
		}
	}
</style>
[[ end ]]

<!-- Just Welcome :D -->
[[ define "welcome_box" ]]
<div id="app-welcome-box">
	<h2>Please select the menu :)</h2>
</div>
[[ end ]]

[[ define "loading_bar" ]]
<div id="app-loading-bar"></div>
[[ end ]]

[[ define "add_box" ]]
<!-- Add item content -->
<div id="app-add-content">
	<div id="app-alert-add-bar"></div>
	<form class="app-form-add">
		<table class='table-form-add' cellpadding='8px' cellspacing='0'>
			<tr>
				<td><input class="item-name" type="text" placeholder="Item Name"></td>
			</tr>
			<tr>
				<td><input class="item-model" type="text" placeholder="Model/Brand"></td>
			</tr>
			<tr>
				<td><input class="item-quantity" type="number" placeholder="Quantity" min="1">&nbsp;<input class="item-limitation" type="number" placeholder="Limitation" min="1"></td>
			</tr>
			<tr>
				<td><input class="item-unit" type="text" placeholder="Item Unit"></td>
			</tr>
			<tr>
				<td><label style="font-size: 90%; padding: 5px; color: #2980b9;">Date of Entry</label></td>
			</tr>
			<tr>
				<td><input class="date-of-entry" type="text" placeholder="YYYY-MM-DD hh:mm"></td>
			</tr>
			<tr>
				<td>
					<input class="time-period" type="number" placeholder="Time Period">
					<select class="select-time-period">
						<option value="Day(s)">Day(s)</option>
						<option value="Week(s)">Week(s)</option>
						<option value="Month(s)">Month(s)</option>
					</select>
				</td>
			</tr>
			<tr>
				<td><input class="item-owner" type="text" placeholder="Owner"><td>
			</tr>
			<tr>
				<td>
					<select class="select-location">
						<option value="" selected="">-- Location --</option>
						<option value="DC TBS 1st Floor">DC TBS 1st Floor</option>
						<option value="DC TBS 2nd Floor">DC TBS 2nd Floor</option>
						<option value="DC TBS 3rd Floor"> DC TBS 3rd Floor</option>
					</select>
				</td>
			</tr>
			<tr>
				<td><input type="submit" value="Submit Data"></td>
			</tr>
		</table>
		<br>
	</form>
</div><br><br>
<!-- -->
[[ end ]]

[[ define "remove_box" ]]
<!-- Remove item content -->
<div id="app-remove-content">
	<div id="app-search-form-box" class="row">
		<ul>
			<li>
				<input class="app-search" type="text" placeholder="Search for ...">
			</li>
			<li>
				<select class="select-searchby">
					<option value="item_name">Name</option>
					<option value="item_model">Model</option>
					<option value="date_of_entry">Date &amp; Times</option>
					<option value="item_unit">Item Unit</option>
					<option value="item_owner">Owner</option>
					<option value="added_by">Added by</option>
				</select>
			</li>
		</ul>
	</div><br><br><br>
	<div id="remove-result" class="row">
		<div class="remove-welcome-box">
			<h2>The results are here ...</h2>
		</div>
	</div>
	<br><br><br><br>
	[[ template "edit_modal". ]]
	[[ template "remove_modal". ]]
</div>
<!-- -->
[[ end ]]

[[ define "edit_modal" ]]
<div id="prompt-edit-modal">
	<div id="app-edit-alert"></div>
	<div class="edit-modal-content"></div>
</div>
[[ end ]]

[[ define "remove_modal" ]]
<div id="prompt-remove-alert">
	<div class="remove-modal-content"></div>
</div>
[[ end ]]


[[ define "side_navigation" ]]
<br><br>
<div id="app-side-nav">
	<ul>
		<li>
			<a class="item-add" href="javascript:void(0)">
				Add <div class="arrow-right"></div>
			</a>
		</li>
		<li>
			<a class="item-remove" href="javascript:void(0)">
				Edit or Remove <div class="arrow-right"></div>
			</a>
		</li>
	</ul>
</div>
[[ end ]]