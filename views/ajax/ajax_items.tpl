[[ define "items_layout" ]]

[[ template "script". ]]
[[ template "style". ]]

<div id="app-ajax-items">
	<h3>Items Management</h3>
	<span><i style="font-size: 90%;">You could add or remove item(s) in the item table using navigation option link below. Make sure that you have an Administrator Privilege to be could to do this.</i></span>

	[[ template "side_navigation". ]]
	<div id="app-form-wrapper">
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
		})

		// when addbutton click
		addButton.click(function() {
			var stateObj = { foo: "bar" };
			history.pushState(stateObj, "page", "/navbar?#navigate_link=/items#add");
			addBox.css("display", "block");
			removeBox.css("display", "none");
			$("title").text("Adding Item - Simple StockApps");
		});
		// when removebutton click
		removeButton.click(function() {
			var stateObj = { foo: "bar" };
			history.pushState(stateObj, "page", "/navbar?#navigate_link=/items#remove");
			removeBox.css("display", "block");
			addBox.css("display", "none");
			$("title").text("Removing Item - Simple StockApps");
		});
	});
</script>
[[ end ]]

[[ define "side_navigation" ]]
<br><br>
<div id="app-side-nav">
	<ul>
		<li><a class="item-add" href="javascript:void(0)">Add Item</a></li>
		<li><a class="item-remove" href="javascript:void(0)">Remove Item</a></li>
	</ul>
</div>
[[ end ]]

[[ define "style" ]]
<style>
	/* Vertical navigation style */
	div#app-side-nav {
		position: absolute;
		left: 10px;
	}
	div#app-side-nav ul {
		list-style-type: none;
		margin: 0;
		padding: 0;
		width: 200px;
		background-color: #FFFFFF;
	}
	div#app-side-nav ul li {
		border-bottom: solid 1px #95a5a6;
	}
	div#app-side-nav ul a {
		text-decoration: none;
		display: block;
		color: #000000;
		padding: 10px;
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
	}
	div#app-remove-content {
		display: none;
	}
	/* end of wrapepr style */
</style>
[[ end ]]

[[ define "add_box" ]]
<!-- Add item content -->
<div id="app-add-content">
	<label>Item Name</label>
	<input type="text"><br>
	<label>Model/Brand</label>
	<input type="text"><br>
	<label>Quantity</label>
	<input type="text"><br>
	<label>Item Unit</label>
	<input type="text"><br>
	<label>Date of Entry</label>
	<input type="text"><br>
	<label>Expired</label>
	<input type="text"><br>
	<label>Owner<label>
	<input type="text"><br>
	<input type="submit" value="Submit Data">
</div>
<!-- -->
[[ end ]]

[[ define "remove_box" ]]
<!-- Remove item content -->
<div id="app-remove-content">
	<h1>Remove!</h1>
</div>
<!-- -->
[[ end ]]