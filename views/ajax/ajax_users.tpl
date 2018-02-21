[[ define "users_layout" ]]

[[ template "script". ]]
<div id="app-ajax-users">
	<h4 style="padding-left: 5px; color: #d63031;">Users Dashboard</h4><hr>
	<div id="app-side-nav">
		<button class="add-user menu-button" href="javascript:void(0)">Add</button>&nbsp;
		<button class="registered-users menu-button" href="javascript:void(0)">Registered Users</button>&nbsp;
		<button class="new-users menu-button" href="javascript:void(0)">New Users</button>
	</div>
	<div id="users-wrapper">
		[[ template "add_box". ]]
		[[ template "registered_user_list_box". ]]
		[[ template "new_user_list_box". ]]
		[[ template "remove_user_modal". ]]
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
		appShowRegisteredUsers();
	});
</script>
[[ end ]]

[[ define "add_box" ]]
<div id="users-add-box">
	<div class="users-add-alert"></div>
	<form class="add-user-form">
		<table class="form-add-users-table" cellpadding="8px" cellspacing="0">
			<tr>
				<td>Username</td>
				<td><input class="users-username users-text" type="text" placeholder="login name" maxlength="3"></td>
			</tr>
			<tr>
				<td>Name</td>
				<td><input class="users-fullname users-text" type="text" placeholder="full name" maxlength="64"></td>
			</tr>
			<tr>
				<td>Password (Generate)</td>
				<td><label class="users-password label-text">[[.HtmlGenerateDefaultPassword]]</label></td>
			</tr>
			<tr>
				<td>E-mail</td>
				<td><input class="users-mail users-text" type="email" placeholder="e-mail address" maxlength="64"></td>
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
				<td><label class="users-date label-text">[[.HtmlCurrentDate]]</label></td>
			</tr>
			<tr>
				<td colspan="2"><br><input class="add-submit" type="submit" value="Submit Data"></td>
			</tr>
		</table>
	</form>
</div>
[[ end ]]

[[ define "registered_user_list_box" ]]
<div id="registered-users-box"></div>
[[ end ]]

[[ define "new_user_list_box" ]]
<div id="new-users-box"></div>
[[ end ]]

[[ define "remove_user_modal" ]]
<!-- Modal Wrapper -->
<div id="remove-modal-user" class="remove-modal">
	<!-- Modal Content -->
	<div class="remove-modal-content">
		<p id="ask-to-remove">Are you sure want to remove?</p><br>
		<div id="modal-table"></div><br>
	</div>
</div>
[[ end ]]