[[ define "items_layout" ]]

[[ template "script". ]]
[[ template "loading_bar". ]]
<div id="app-ajax-items">
	<h3>Goods Dashboard</h3>
	<span style="text-align: justify;"><i style="font-size: 90%;">You could add, edit or remove (only Administrator privilege) goods in here, Please choose one of navigation options below.</i></span>

	[[ template "side_navigation". ]]
	<div id="app-form-wrapper">
		[[ template "add_box". ]]
		[[ template "remove_box". ]]
	</div>
</div>

[[ end ]]

[[ define "script" ]]
<script>
$(function() {
	var addButton = $("button.item-add");
	var removeButton = $("button.item-remove");
	var menuButton = $("button.menu-button");
	var addBox = $("div#app-add-content");
	var removeBox = $("div#app-remove-content");
	var hashUrl = window.location.hash;
	var getOptionFromHash = hashUrl.substring(22);

	console.log(getOptionFromHash);

	removeBox.css("display", "block");

	// onload if current url has a hash url
	switch(getOptionFromHash) {
		case "add":
			addBox.css("display", "block");
			removeBox.css("display", "none");
			$("title").text("Adding Goods - Simple StockApps");
			$("input[placeholder='Item Name']").focus();
		break;
	}

	// when addbutton click
	addButton.click(function() {
		var stateObj = { page: "items#add" };
		history.pushState(stateObj, "page", "/navbar?#navigate_link=/items#add");
		addBox.css("display", "block");
		removeBox.css("display", "none");
		$("title").text("Adding Goods - Simple StockApps");
		$("input[placeholder='Item Name']").focus();
	});
	// when removebutton click
	removeButton.click(function() {
		var stateObj = { page: "items" };
		history.pushState(stateObj, "page", "/navbar?#navigate_link=/items");
		removeBox.css("display", "block");
		addBox.css("display", "none");
		$("title").text("Removing Goods - Simple StockApps");
	});

	// handling request from form add items
	appFormAddItemsHandler();
	appFormRemoveOrEditItemsHandler();
});
</script>
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