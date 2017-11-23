[[ define "main_layout" ]]
<!DOCTYPE html>
<html>
	<head>
		<title>[[.HtmlTitle]]</title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" href="/css/style.css">
		<script src="/js/jquery-3.2.1.js"></script>
		<script src="/js/app.js"></script>
	</head>
	<body>
		<div id="app-container">
			[[ template "logo". ]]
			<h4>Main Page: [[.HtmlTitle]]</h4>
			[[ template "navigation". ]]
			[[ template "login_popup". ]]
			[[ template "table_monitor". ]]
			<!--[[ template "websocket_experiment". ]]-->
		</div>
	</body>
</html>
[[ end ]]

[[ define "login_popup" ]]
<br>
<div id="app-login-popup" class="app-modal">
	<div class="app-modal-content">
		<form class="app-login-form">
			<label><input class="app-username" type="text" placeholder="Username"></label><br>
			<label><input class="app-password" type="password" placeholder="Password"></label><br>
			<label><input class="app-login-btn" type="submit" value="Sign in"></label>
		</form>
		<div class="app-login-alert"></div>
		<br><br>
		<button class="app-close-btn">Close</button>
	</div>
</div>
[[ end ]]

[[ define "navigation" ]]
<div id="app-navbar">
	[[ if .HtmlUserIsLoggedIn ]]
	<button class="app-sign-btn">Logout</button>
	<label class="app-user-fullname">[[.HtmlUserFullName]]</label>
	[[ else ]]
	<button class="app-sign-btn">Login</button>
	[[ end ]]
</div>
[[ end ]]

[[ define "logo" ]]
<div id="app-logo">
	<img src="/img/logo_lintasarta.png" style="width: 150px; height: auto;">
</div>
[[ end ]]

[[ define "table_monitor" ]]
<div id="app-table-box">
	<table class="app-table" border="0" cellspacing="0" cellpadding="10" style="overflow-x: auto;">
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
		<th>Action</th>
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
				[[ end ]]
			</tr>
		[[ end ]]
	</table>
</div>
[[ end ]]

[[ define "websocket_experiment" ]]
<div id="app-experiment">
	<form>
		<p><input class="message" type="text" name=""></p>
	</form>
	<p class="app-msg-box"></p>
	<button class="app-send">Send</button>
</div>
[[ end ]]