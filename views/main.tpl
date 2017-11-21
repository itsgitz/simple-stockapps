[[ define "main_layout" ]]
<!DOCTYPE html>
<html>
	<head>
		<title>[[.HtmlTitle]]</title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<style>
			* { box-sizing: border-box; }
			/* Login popup style */
			div#app-login-popup {
				visibility: hidden;
			}
			/* end of login popup style */
			/* Table button style */
			td.app-action-table-data {
				display: none;
			}
			/* end of table data header */
		</style>
		<!--<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>-->
		<script src="/js/jquery-3.2.1.js"></script>
		<script>
			// jQuery.3.2.1
			$(document).ready(function() {
				// login popup box function
				appLoginHandler();
				// table handler function
				appTableHandler();
			});

			// Login popup box function
			function appLoginHandler() {
				// login form variable element
				var loginForm = $("form.app-login-form");
				// login popup box
				var loginPopupBox = $("div#app-login-popup");
				// login button and close button
				var signButton = $("button.app-sign-btn");
				var signText = signButton.text();
				var closeButton = $("button.app-close-btn");

				// show login popup when sign button clicked
				signButton.click(function() {
					loginPopupBox.css("visibility", "visible");
				});
				// close login popup
				closeButton.click(function() {
					loginPopupBox.css("visibility", "hidden");
				});

				// if user has logged in, then sign button changes to logout button
				// ajax will send request to AppLogout Handler
				if (signText == "Logout") {
					signButton.click(function() {
						loginPopupBox.css("visibility", "hidden");
						window.location = "/logout";
						document.cookie = "simple_stockapps_login=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
					});
				}

				// login form for prevent default
				loginForm.submit(function(e) {
					e.preventDefault();
					// username and password value
					var usernameValue = $("input.app-username").val();
					var passwordValue = $("input.app-password").val();

					// submit while value not null
					if (usernameValue && passwordValue) {
						// these values will send to server (login controller) using AJAX method
						$.ajax({
							url: "/login",	// send data to login handler on server
							async: true,
							data: {
								username: usernameValue,
								password: passwordValue
							},
							success: function(jsonLoginDataAuth) {
								// jsonLoginDataAuth --> JSON data that sended from login handler AppLogin
								if (jsonLoginDataAuth.Message) {
									window.location = jsonLoginDataAuth.Redirect_Url;
								} else {
									$("div.app-login-alert").html("<b>Incorrect username or password!</b>");
								}
							}
						});
						loginForm[0].reset(); // reset (clearing) the login form after submit
					}
				});
			}

			// appTableHandler for handling table items
			function appTableHandler() {
				// get login cooki if user has logged in
				var login_cookie = document.cookie;
				var tableDataPickupButton = $("td.app-action-table-data");

				// if user has logged in, show table data below Action table header
				if (login_cookie) {
					tableDataPickupButton.css("display", "block");
				}
			}
		</script>
	</head>
	<body>
		<div id="app-container">
			<h2>Main Page: [[.HtmlTitle]]</h2>
			[[ template "navigation". ]]
			[[ template "login_popup". ]]
			[[ template "table_monitor". ]]
		</div>
	</body>
</html>
[[ end ]]

[[ define "login_popup" ]]
<br>
<div id="app-login-popup" class="login-hidden">
	<form class="app-login-form">
		<label><input class="app-username" type="text" placeholder="Username"></label><br>
		<label><input class="app-password" type="password" placeholder="Password"></label><br>
		<label><input class="app-login-btn" type="submit" value="Sign in"></label>
	</form>
	<div class="app-login-alert"></div>
	<br><br>
	<button class="app-close-btn">Close</button>
</div>
[[ end ]]

[[ define "navigation" ]]
<div id="app-navbar">
	<button class="app-sign-btn">[[.HtmlSignButton]]</button>
</div>
[[ end ]]

[[ define "table_monitor" ]]
<div id="app-table-monitor">
	<table border="1" cellspacing="0" cellpadding="10" style="overflow-x: auto;">
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
		[[.HtmlTableActionHeader]]
		[[ range $value := .HtmlTableValueFromItems ]]
			<tr>
				<td>[[$value.Item_id]]</td>
				<td>[[$value.Item_name]]</td>
				<td>[[$value.Item_model]]</td>
				<td>[[$value.Item_quantity]]</td>
				<td>[[$value.Item_unit]]</td>
				<td>[[$value.Date_of_entry]]</td>
				<td>[[$value.Item_time_period]]</td>
				<td>[[$value.Item_expired]]</td>
				<td>[[$value.Item_owner]]</td>
				<td>[[$value.Item_status]]</td>
				<td class="app-action-table-data"><a href="/pick_up/[[$value.Item_id]]">Pick Up</a></td>
			</tr>
		[[ end ]]
	</table>
</div>
[[ end ]]