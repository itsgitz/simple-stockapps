[[ define "users_layout" ]]

[[ template "script". ]]
<div id="app-ajax-users">
	<h3>User Dashboard</h3>
	<div id="app-side-nav">
		<button class="add-user menu-button" href="javascript:void(0)">Add</button>&nbsp;
		<button class="user-list menu-button" href="javascript:void(0)">Users List</button>
	</div>
	<div id="users-wrapper">
		[[ template "add_box". ]]
		[[ template "user_list_box". ]]
	</div>
</div>
[[ end ]]

[[ define "script" ]]
<script>
	// box
	var addBox = $("div#users-add-box");
	var userListBox = $("div#users-list-box");
	// sub-navigation button
	var addUserButton = $("button.add-user");
	var userListButton = $("button.user-list");
	var hashUrl = window.location.hash;

	// get partly string from hash url
	// : navbar?#navigate_link=/users#add, partly option string is "add"
	var getOptionFromHash = hashUrl.substring(22);
	
	$(function() {
		// display block when onload event occurs
		userListBox.css("display", "block");

		// determine hash option when onload
		switch(getOptionFromHash) {
			case "add":
				addBox.css("display", "block");
				userListBox.css("display", "none");
				$("title").text("Add Users - Simple StockApps");
			break;
		}

		// sub-navigation click handler
		appSubNavigationButtonOnClick();

		// add user handler
		appAddUser();
	});

	// navigation click handler
	function appSubNavigationButtonOnClick() {
		// add user button clicked
		addUserButton.click(function() {
			var stateObj = {page: "users#add"};
			history.pushState(stateObj, "page", "/navbar?#navigate_link=/users#add");
			userListBox.css("display", "none");
			addBox.css("display", "block");
			$("title").text("Add Users - Simple StockApps");
		});
		// user list button clicked
		userListButton.click(function() {
			var stateObj = {page: "users"};
			history.pushState(stateObj, "page", "/navbar?#navigate_link=/users");
			userListBox.css("display", "block");
			addBox.css("display", "none");
			$("title").text("Users Dashboard - Simple StockApps");
		});
	}

	function appAddUser() {
		var addUserForm = $("form.add-user-form");
		// prevent default
		addUserForm.submit(function(e) {
			e.preventDefault();

			// get the value and store it into variable
			var userName = $("input.users-username").val();
			var fullName = $("input.users-fullname").val();
			var userPassword = $("label.users-password").text();
			var userEmail = $("input.users-mail").val();
			var userRole = $("select.users-role").val();
			var dateCreated = $("label.users-date").text();

			// alert box
			var addUserAlertBox = $("div.users-add-alert");
			var alertCloseButton = "<span>&times;</span>";
			var alertMessage = alertCloseButton;

			// error handling
			if (!userName) {
				alertMessage += "<p>Username is empty!</p>";
				addUserAlertBox.html(alertMessage);
			} else if (!fullName) {
				alertMessage += "<p>User's full name is empty!</p>";
				addUserAlertBox.html(alertMessage);
			} else if (!userEmail) {
				alertMessage += "<p>User's e-mail address is empty!</p>";
				addUserAlertBox.html(alertMessage);
			} else if (!userRole) {
				alertMessage += "<p>User role/privilege is empty!</p>";
				addUserAlertBox.html(alertMessage);
			} else {
				$.ajax({
					url: "/add_user",
					async: true,
					data: {
						user_name: userName,
						user_full_name: fullName,
						user_password: userPassword,
						user_email: userEmail,
						user_role: userRole,
						date_created: dateCreated
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
			}
		});
	}
</script>
[[ end ]]

[[ define "add_box" ]]
<div id="users-add-box">
	<div class="users-add-alert"></div>
	<form class="add-user-form">
		<table class="form-add-users-table" cellpadding="8px" cellspacing="0">
			<tr>
				<td>Username</td>
				<td><input class="users-username" type="text" placeholder="login name"></td>
			</tr>
			<tr>
				<td>Name</td>
				<td><input class="users-fullname" type="text" placeholder="full name"></td>
			</tr>
			<tr>
				<td>Password (Generate)</td>
				<td><label class="users-password">[[.HtmlGenerateDefaultPassword]]</label></td>
			</tr>
			<tr>
				<td>E-mail</td>
				<td><input class="users-mail" type="email" placeholder="e-mail address"></td>
			</tr>
			<tr>
				<td>Role</td>
				<td>
					<select class="users-role">
						<option value="" selected="">-- Privilege --</option>
						<option value="Administrator">Administrator</option>
						<option value="Operator">Operator</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>Date Created</td>
				<td><label class="users-date">[[.HtmlCurrentDate]]</label></td>
			</tr>
			<tr>
				<td colspan="2"><input class="add-submit" type="submit" value="Submit Data"></td>
			</tr>
		</table>
	</form>
</div>
[[ end ]]

[[ define "user_list_box" ]]
<div id="users-list-box">
	<h3>Users List Box</h3>
</div>
[[ end ]]