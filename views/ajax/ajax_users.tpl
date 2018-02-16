[[ define "users_layout" ]]

[[ template "script". ]]
<div id="app-ajax-users">
	<h3>User Dashboard</h3>
	<div id="app-side-nav">
		<button class="add-user menu-button" href="javascript:void(0)">Add</button>&nbsp;
		<button class="registered-users menu-button" href="javascript:void(0)">Registered Users</button>&nbsp;
		<button class="new-users menu-button" href="javascript:void(0)">New Users</button>
	</div>
	<div id="users-wrapper">
		[[ template "add_box". ]]
		[[ template "registered_user_list_box". ]]
		[[ template "new_user_list_box". ]]
	</div>
</div>
[[ end ]]

[[ define "script" ]]
<script>
	// box
	var addBox = $("div#users-add-box");
	var registeredUserListBox = $("div#registered-users-box");
	var newUsersListBox = $("div#new-users-box");
	// sub-navigation button
	var addUserButton = $("button.add-user");
	var registeredUserListButton = $("button.registered-users");
	var newUsersListButton = $("button.new-users");

	var hashUrl = window.location.hash;

	// get partly string from hash url
	// : navbar?#navigate_link=/users#add, partly option string is "add"
	var getOptionFromHash = hashUrl.substring(22);
	
	$(function() {
		// display block when onload event occurs
		registeredUserListBox.css("display", "block");

		// determine hash option when onload
		switch(getOptionFromHash) {
			case "add":
				addBox.css("display", "block");
				registeredUserListBox.css("display", "none");
				newUsersListBox.css("display", "none");
				$("title").text("Add Users - Simple StockApps");
			break;
			case "new":
				newUsersListBox.css("display", "block");
				addBox.css("display", "none");
				registeredUserListBox.css("display", "none");
				$("title").text("New Users - Simple StockApps");
			break;
		}

		// sub-navigation click handler
		appSubNavigationButtonOnClick();

		// add user handler
		appAddUser();

		// registered user list
		appShowNewUsers();
		//appShowRegisteredUsers();
	});

	// navigation click handler
	function appSubNavigationButtonOnClick() {
		// add user button clicked
		addUserButton.click(function() {
			var stateObj = {page: "users#add"};
			history.pushState(stateObj, "page", "/navbar?#navigate_link=/users#add");
			registeredUserListBox.css("display", "none");
			newUsersListBox.css("display", "none");
			addBox.css("display", "block");
			$("title").text("Add Users - Simple StockApps");
		});
		// user list button clicked
		registeredUserListButton.click(function() {
			var stateObj = {page: "users"};
			history.pushState(stateObj, "page", "/navbar?#navigate_link=/users");
			registeredUserListBox.css("display", "block");
			addBox.css("display", "none");
			newUsersListBox.css("display", "none");
			$("title").text("Users Dashboard - Simple StockApps");
		});
		newUsersListButton.click(function() {
			var stateObj = {page: "users#new"};
			history.pushState(stateObj, "page", "/navbar?#navigate_link=/users#new");
			newUsersListBox.css("display", "block");
			registeredUserListBox.css("display", "none");
			addBox.css("display", "none");
			$("title").text("New Users - Simple StockApps");
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

	function appShowNewUsers() {
		$.ajax({
			url: "/json_new_users",
			async: true,
			success: function(res) {
				var resultTable;
				var lengthResponse = res.length;
				var i;

				resultTable =  "<table class='new-users-table' border='0' cellpadding='10' cellspacing='0'>";
				resultTable += "   <th>No.</th>";
				resultTable += "   <th>User ID</th>";
				resultTable += "   <th>Username</th>";
				resultTable += "   <th>Fullname</th>";
				resultTable += "   <th>Role/Privilege</th>";
				resultTable += "   <th>Password</th>";
				resultTable += "   <th>E-mail Address</th>";
				resultTable += "   <th>Date Created</th>";
				resultTable += "   <th>Status</th>";
				for (i=0; i<lengthResponse; i++) {
					resultTable += "<tr>";
					resultTable += "   <td>"+(i+1)+"</td>";
					resultTable += "   <td>"+res[i].user_id+"</td>";
					resultTable += "   <td>"+res[i].user_login_name+"</td>";
					resultTable += "   <td>"+res[i].user_name+"</td>";
					resultTable += "   <td>"+res[i].user_privilege+"</td>";
					resultTable += "   <td>"+res[i].password+"</td>";
					resultTable += "   <td>"+res[i].user_email+"</td>";
					resultTable += "   <td>"+res[i].date_created+"</td>";
					resultTable += "   <td>"+res[i].status+"</td>";
					resultTable += "</tr>";
				}
				resultTable += "</table>";

				document.getElementById("new-users-box").innerHTML = resultTable;
			}
		});
	}
	//function appShowRegisteredUsers() {

	//}
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

[[ define "registered_user_list_box" ]]
<div id="registered-users-box">
	<h3>Registered Users List Box</h3>
</div>
[[ end ]]

[[ define "new_user_list_box" ]]
<div id="new-users-box">
</div>
[[ end ]]