[[ define "items_layout" ]]

[[ template "script". ]]
[[ template "style". ]]

<div id="app-ajax-items">
	<h3>Items Management</h3>
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

		if (itemQuantity == 0 || itemQuantity <= itemLimitation) {
			alert("item quantity and limitation couldn't be 0, or item quantity couldn't be less than item limitation");
		}

		if (itemName && itemModel && itemQuantity > 0 && itemLimitation > 0 && itemQuantity > itemLimitation && itemUnit && dateOfEntry && itemOwner && itemLocation) {
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
						alert("Successfuly inserting data!");
						window.location = "/";	
					}
				}
			});
			addItemForm[0].reset();
		} else {
			alert("It looks like there was empty or wrong value at the one of form :(");
		}
	});
}

</script>
[[ end ]]

[[ define "style" ]]
<style>
	/* Vertical navigation style */
	div#app-side-nav {
		padding-top: 25px;
		position: absolute;
		left: 10px;
		height: 100%;
		border-radius: 5px;
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
		position: absolute;
		left: 220px;
		padding: 15px;
	}
	div#app-add-content {
		display: none;
		padding-left: 45px;
	}
	div#app-remove-content {
		display: none;
	}
	/* end of wrapepr style */

	/* Add Items Content Style */
	div#app-add-content input[type="text"] {
		outline: none;
		border: none;
		border-bottom: solid 1px #1abc9c;
		padding: 10px;
		width: 350px;
	}
	div#app-add-content input[type="submit"] {
		border: none;
		padding: 5px;
		width: 350px;
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
		width: 174px;
		border-bottom: solid 1px #1abc9c;
		outline: none;
	}
	div#app-add-content input[type="number"].time-period {
		width: 150px;
		background-color: none;
		padding: 9px;
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
		padding: 9px;
		border-bottom: solid 1px #1abc9c;
		width: 196px;
	}
	select.select-location {
		border: none;
		outline: none;
		padding: 9px;
		border-bottom: solid 1px #1abc9c;
		width: 350px;
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

	/* Media query when screen resolution > 1280px */
	/*@media only screen and (min-width: 1600px) {
		/* Add Items Content Style */
	/*	div#app-add-content input[type="text"] {
			width: 500px;
		}
		div#app-add-content input[type="submit"] {
			width: 500px;
		}
		div#app-add-content input[type="number"] {
			width: 500px;
		}
		div#app-add-content input[type="number"].time-period {
			width: 350px;
		}
		select.select-time-period {
			width: 148px;
		}
		select.select-time-period:hover {
			cursor: pointer;
		}
	}*/
</style>
[[ end ]]

<!-- Just Welcome :D -->
[[ define "welcome_box" ]]
<div id="app-welcome-box">
	<h1>Please select the menu :)</h1>
</div>
[[ end ]]

[[ define "add_box" ]]
<!-- Add item content -->
<div id="app-add-content">
	<form class="app-form-add">
		<div class="row">
			<input class="item-name" type="text" placeholder="Item Name" required="">
			<label class="app-input-note"> <i>*Example: Cat-6A UTP Cable</i></label>
		</div><br>
		<div class="row">
			<input class="item-model" type="text" placeholder="Model/Brand" required=""> <label class="app-input-note"><i>*Example: AMP Connect</i></label>
		</div><br>
		<div class="row">
			<input class="item-quantity" type="number" placeholder="Quantity" min="1" required="">&nbsp;<input class="item-limitation" type="number" placeholder="Limitation" min="1" required="">
		</div><br>
		<div class="row">
			<input class="item-unit" type="text" placeholder="Item Unit" required=""> <label class="app-input-note"><i>*Example: Roll, Packs, etc.</i></label>
		</div><br>
		<div class="row">
			<div class="row">
				<label style="font-size: 90%; padding: 10px; color: #2980b9;">Date of Entry</label>
			</div>
			<div class="row">
				<input class="date-of-entry" type="text" placeholder="YYYY-MM-DD hh:mm" required=""> <label class="app-input-note"><i>*Example: 2017-08-10 16:00 (Use 24 Hours Format)</i></label>
			</div>
		</div><br>
		<div class="row">
			<input class="time-period" type="number" placeholder="Time Period">
			<select class="select-time-period">
				<option value="Day(s)">Day(s)</option>
				<option value="Month(s)">Month(s)</option>
				<option value="Week(s)">Week(s)</option>
			</select> <label class="app-input-note"><i style="color: blue;">Optional or you could blank this out</i></label>
		</div><br>
		<div class="row">
			<input class="item-owner" type="text" placeholder="Owner" required="">
		</div><br>
		<div class="row">
			<select class="select-location" required="">
				<option value="" selected="">-- Location --</option>
				<option value="DC TBS 1st Floor">DC TBS 1st Floor</option>
				<option value="DC TBS 2nd Floor">DC TBS 2nd Floor</option>
				<option value="DC TBS 3rd Floor"> DC TBS 3rd Floor</option>
			</select>
		</div> <br>
		<div class="row">
			<input type="submit" value="Submit Data">
		</div>
	</form>
</div><br><br>
<!-- -->
[[ end ]]

[[ define "remove_box" ]]
<!-- Remove item content -->
<div id="app-remove-content">
	<h1>Remove!</h1>
</div>
<!-- -->
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
				Remove <div class="arrow-right"></div>
			</a>
		</li>
	</ul>
</div>
[[ end ]]