[[ define "items_layout" ]]

[[ template "script". ]]
[[ template "style". ]]

<div id="app-ajax-items">
	<h3>Items Management</h3>
	<span><i style="font-size: 90%;">You could add, remove (Administrator privilege), or request items (Operator privilege).</i></span>

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

		// when addbutton click
		addButton.click(function() {
			var stateObj = { foo: "bar" };
			history.pushState(stateObj, "page", "/navbar?#navigate_link=/items#add");
			addBox.css("display", "block");
			removeBox.css("display", "none");
			$("title").text("Adding Item - Simple StockApps");
			$("input[placeholder='Item Name']").focus();
		});
		// when removebutton click
		removeButton.click(function() {
			var stateObj = { foo: "bar" };
			history.pushState(stateObj, "page", "/navbar?#navigate_link=/items#remove");
			removeBox.css("display", "block");
			addBox.css("display", "none");
			$("title").text("Removingi Item - Simple StockApps");
		});
	});
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
		box-shadow: 1px 5px 10px #888888;
		background-color: #D8D8D8;
	}
	div#app-side-nav ul {
		list-style-type: none;
		margin: 0;
		padding: 0;
		width: 200px;
		background-color: #D8D8D8;
	}
	div#app-side-nav ul a {
		text-decoration: none;
		display: block;
		color: #2c3e50;
		padding: 11px;
		font-weight: 500;
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

	/* Add Items Content Style */
	div#app-add-content input[type="text"] {
		outline: none;
		border: none;
		border-bottom: solid 1px #1abc9c;
		padding: 10px;
		width: 300px;
	}
	div#app-add-content input[type="date"] {
		padding: 10px;
		border: none;
		width: 300px;
		outline: none;
		border-bottom: solid 1px #1abc9c;
	}
	div#app-add-content input[type="submit"] {
		border: none;
		padding: 5px;
		width: 300px;
		background-color: #c0392b;
		color: #F2F2F2;
		border-radius: 5px;
	}
	div#app-add-content input[type="submit"]:hover {
		cursor: pointer;
		background-color: #27ae60;
	}
	.row:after {
		content: "";
		display: table;
		clear: both;
	}
	/* end of Add Items Content style */
</style>
[[ end ]]

[[ define "add_box" ]]
<!-- Add item content -->
<div id="app-add-content">
	<form class="app-form-add">
		<div class=".row">
			<input type="text" placeholder="Item Name">
		</div>
		<div class=".row">
			<input type="text" placeholder="Model/Brand">
		</div>
		<div class=".row">
			<input type="text" placeholder="Quantity">
		</div>
		<div class=".row">
			<input type="text" placeholder="Item Unit">
		</div><br>
		<div class=".row">
			<div class=".row">
				<label style="font-size: 90%; padding: 10px; color: #2980b9;">Date of Entry</label>
			</div>
			<div class=".row">
				<input type="date" >
			</div>
		</div><br>
		<div class=".row">
			<div class=".row">
				<label style="font-size: 90%; padding: 10px; color: #2980b9;">Expired Date</label>
			</div>
			<div class=".row">
				<input type="date">
			</div>
		</div>
		<div class=".row">
			<input type="text" placeholder="Owner">
		</div><br>
		<div class=".row">
			<input type="submit" value="Submit Data">
		</div>
	</form>
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

[[ define "side_navigation" ]]
<br><br>
<div id="app-side-nav">
	<ul>
		<li><a class="item-add" href="javascript:void(0)">Add</a></li>
		<li><a class="item-remove" href="javascript:void(0)">Remove</a></li>
		<li><a class="request-item" href="javascript:void(0)">Request</a></li>
	</ul>
</div>
[[ end ]]