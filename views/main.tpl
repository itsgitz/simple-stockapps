[[ define "main_layout" ]]
<!DOCTYPE html>
<html>
	<head>
		<title>[[.HtmlTitle]]</title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" href="/css/style.css">
		<link rel="icon" href="/img/lintasarta_icon.jpg" type="image/gif">
		<script src="/js/jquery-3.2.1.js"></script>
		<script src="/js/app.js"></script>
	</head>
	<body>
		<div id="app-container">
			[[ template "navigation". ]]
			[[ template "login_popup". ]]
			[[ template "table_monitor". ]]
		</div>
	</body>
</html>
[[ end ]]

[[ define "login_popup" ]]
<br>
<div id="app-login-popup" class="app-modal">
	<div class="app-modal-content">
		<h2 class="app-login-header">Sign in to StockApps</h2>
		<div class="app-login-alert"></div>
		<form class="app-login-form">
			<label><input class="app-username input-text" type="text" placeholder="Username"></label><br>
			<label><input class="app-password input-text" type="password" placeholder="Password"></label><br><br>
			<label><input class="app-login-btn" type="submit" value="Sign in"></label>
		</form>
		<br>
		<button class="app-close-btn">Close</button>
	</div>
</div>
[[ end ]]

[[ define "table_monitor" ]]
<div id="app-table-box">
	<table class="app-table" border="0" cellspacing="0" cellpadding="10">
		<th>No.</th>
		<th>Name</th>
		<th>Model/Brand</th>
		<th>Quantity</th>
		<th>Item Unit</th>
		<th>Date of Entry</th>
		<tH>Time Period</tH>
		<th>Expired</th>
		<th>Owner</th>
		<th>Status</th>
		[[ if .HtmlUserIsLoggedIn ]]
		<th colspan="2">Action</th>
		[[ end ]]

		[[ range $index, $value := .HtmlTableValueFromItems ]]
			<tr>
				<td>[[tambah $index]]</td>
				<td>[[$value.Item_name]]</td>
				<td>[[$value.Item_model]]</td>
				<td>[[$value.Item_quantity]]</td>
				<td>[[$value.Item_unit]]</td>
				<td>[[$value.Date_of_entry]]</td>
				<td>[[$value.Item_time_period]]</td>
				<td>[[$value.Item_expired]]</td>
				<td>[[$value.Item_owner]]</td>
				<td>[[$value.Item_status]]</td>
				[[ if $.HtmlUserIsLoggedIn ]]
				<td><a href="/pick_up/[[$value.Item_id]]">Pick Up</a></td>
				<td><a href="/edit/[[$value.Item_id]]">Edit</a></td>
				[[ end ]]
			</tr>
		[[ end ]]
	</table>
</div>
[[ end ]]