[[ define "items_layout" ]]

[[ template "script". ]]
[[ template "style". ]]
[[ template "loading_bar". ]]
<div id="app-ajax-items">
	<h3>Items Dashboard</h3>
	<span style="text-align: justify;"><i style="font-size: 90%;">You could add, edit or remove items in here, Please choose one of navigation options below.</i></span>

	[[ template "side_navigation". ]]
	<div id="app-form-wrapper">
		[[ template "welcome_box". ]]
		[[ template "add_box". ]]
		[[ template "remove_box". ]]
	</div>
</div>

[[ end ]]

[[ define "script" ]]
<script src="/js/all_items_functions.js"></script>
<script>
$(function() {
	var addButton = $("button.item-add");
	var removeButton = $("button.item-remove");
	var menuButton = $("button.menu-button");
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
			$("title").text("Edit or Removing Item - Simple StockApps");
		break;
	}

	// hide welcome-box when loaded
	if (getOptionFromHash) {
		$("div#app-welcome-box").css("display", "none");
	}

	menuButton.click(function() {
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
	/* Sub navigation style */
	div#app-sidenav {
		padding: 5px;
		padding-top: 10px;
		padding-left: : 30px;
		width: 75%;
		border-radius: 3px;
		display: inline;
	}
	button.menu-button {
		border: none;
		border-bottom: solid 3px #3498db;
		color: #3498db;
		background-color: #FFFFFF;
		padding: 10px;
		outline: none;
	}
	button.menu-button:hover {
		cursor: pointer;
	}
	/* end of vertical navigation style */

	/* form wrapper style */
	div#app-form-wrapper {
		display: table;
	}
	div#app-add-content {
		display: none;
		padding-left: 10px;
		padding-bottom: 25px;
		position: absolute;
		top: 200px;
		left: 20px;
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
	label.label-input {
		color: #2980b9;
		padding-right: 25px;
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
		padding-bottom: 5px;
		padding-left: 10px;
		display: none;
		border-bottom-left-radius: 5px;
		border-bottom-right-radius: 5px;
		text-align: center;
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
		padding-left: 10px;
		color: #34495e;
	}
	/* end of welcome box */

	/* Remove box */
	div#app-remove-content {
		display: none;
		padding-top: 0px;
		position: absolute;
		top: 200px;
		left: 10px;
		right: 10px;
		overflow: hidden;
	}
	table.tbl-remove {
		font-size: 80%;
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
		padding-top: 0px;
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
		margin: 150px auto;
		padding: 20px;
		border: solid 1px #888;
		width: 70%;
		border-radius: 5px;
		box-shadow: 1px 2px 2px #888888;
	}
	div.edit-modal-content {
		background-color: #FEFEFE;
		margin: 50px auto;
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
	table.table-form-add {
		font-size: 80%;
		width: 750px;
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
		padding-bottom: 5px;
		padding-left: 10px;
	}
	/* end of edit modal content */

	@media only screen and (max-width: 550px) {
		div#app-form-wrapper {
			margin: 0%;
		}
		div#app-add-content {
			position: absolute;
			top: 250px;
			left: 10px;
			right: 10px;
		}
		div#app-welcome-box {
			padding: 0;
		}
		div#app-remove-content {
			position: absolute;
			top: 250px;
			left: 10px;
			right: 10px;
		}
		input.app-search {
			width: 100%;
		}
		table.table-form-add {
			width: 100%;
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
				<td><label class="label-input">Name</label></td>
				<td><input class="item-name" type="text" placeholder="Item Name"></td>
			</tr>
			<tr>
				<td><label class="label-input">Model/Brand</label></td>
				<td><input class="item-model" type="text" placeholder="Model/Brand"></td>
			</tr>
			<tr>
				<td><label class="label-input">Quantity</label></td>
				<td><input class="item-quantity" type="number" placeholder="Quantity" min="1"></td>
			</tr>
			<tr>
				<td><label class="label-input">Limitation</label></td>
				<td><input class="item-limitation" type="number" placeholder="Limitation" min="1"></td>
			</tr>
			<tr>
				<td><label class="label-input">Item Unit</label></td>
				<td><input class="item-unit" type="text" placeholder="Item Unit"></td>
			</tr>
			<tr>
				<td><label class="label-input">Date of Entry</label></td>
				<td><input class="date-of-entry" type="text" placeholder="YYYY-MM-DD hh:mm"></td>
			</tr>
			<tr>
				<td><label class="label-input">Time Period</label></td>
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
				<td><label class="label-input">Owner</label></td>
				<td><input class="item-owner" type="text" placeholder="Owner"><td>
			</tr>
			<tr>
				<td><label class="label-input">Location</label></td>
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
				<td colspan="2"><input type="submit" value="Submit Data"></td>
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
<br><br><br>
<div id="app-side-nav">
	<button class="item-add menu-button" href="javascript:void(0)">Add</button>&nbsp;
	<button class="item-remove menu-button" href="javascript:void(0)">Edit or Remove</button>
</div>
[[ end ]]