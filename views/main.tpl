[[ define "main_layout" ]]
<!DOCTYPE html>
<html>
	<head>
		<title>None</title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
		<script>
			// jQuery.3.2.1
			$(document).ready(function() {
				// login form variable element
				var loginForm = $("form.app-login-form");
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
							success: function(data) {
									
							}
						});
						loginForm[0].reset(); // reset (clearing) the form after submit
					}
				});
			});
		</script>
	</head>
	<body>
		<div id="app-container">
			<h2>Main Page: None</h2>
			[[ template "login_popup". ]]
		</div>
	</body>
</html>
[[ end ]]

[[ define "login_popup" ]]
<div id="app-login-popup">
	<form class="app-login-form">
		<label><input class="app-username" type="text" placeholder="Username"></label><br>
		<label><input class="app-password" type="password" placeholder="Password"></label><br>
		<label><input class="app-login-btn" type="submit" value="Sign in"></label>
	</form>
</div>
[[ end ]]