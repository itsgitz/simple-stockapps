[[ define "settings_layout" ]]
[[ template "script". ]]
<div id="ajax-settings">
	[[ template "edit_alert". ]]
	<h4 style="padding-left: 5px; color: #d63031;">Settings Dashboard</h4>
	<div id="setting-table">
		<form id="edit-settings">
			<table id="form-table" cellspacing="0" cellpadding="10">
				<tr>
					<td>ID</td>
					<td><label id="setting-user-id" class="label-text-setting">[[.Id]]</label></td>
				</tr>
				<tr>
					<td>Full name</td>
					<td><input id="setting-fullname" class="input-text" type="text" placeholder="Your full name" value="[[.Fullname]]"></td>
				</tr>
				<tr>
					<td>Username</td>
					<td><input id="setting-username" class="input-text" type="text" placeholder="Your Username" value="[[.Username]]"></td>
				</tr>
				<tr>
					<td>Role/Privilege</td>
					<td><label id="setting-role" class="label-text-setting">[[.Role]]</label></td>
				</tr>
				<tr>
					<td>Password</td>
					<td><input id="setting-password" class="input-text" type="password" placeholder="Your secret Password"></td>
				</tr>
				<tr>
					<td>E-mail</td>
					<td><input id="setting-email" class="input-text" type="email" placeholder="Your e-mail address" value="[[.Email]]"></td>
				</tr>
				<tr>
					<td>Date Created</td>
					<td><label id="setting-date" class="label-text-setting">[[.Date]]</label></td>
				</tr>
				<tr>
					<td>Status</td>
					<td><label id="setting-status" class="label-text-setting">[[.Status]]</label></td>
				</tr>
				<tr>
					<td colspan="2"><input id="update-button" type="submit" value="Update"></td>
				</tr>
			</table>
		</form>
	</div>
</div>
[[ end ]]

[[ define "script" ]]
<script>
	$(function() {
		var formSetting = $("form#edit-settings");

		// prevent default and still using ajax request
		formSetting.submit(function(e) {
			e.preventDefault();

			var updateButton = $("input#update");
			// get the value
			var userId = $("label#setting-user-id").text();
			var userFullname = $("input#setting-fullname").val();
			var userName = $("input#setting-username").val();
			var userRole = $("label#setting-role").text();
			var userPassword = $("input#setting-password").val();
			var userEmail = $("input#setting-email").val();
			var settingAlert = document.getElementById("setting-alert");
			var closeAlert = "<span id='close'></span>";

			if (!userFullname) {
				settingAlert.innerHTML = closeAlert + "<p>User full name is empty!</p>";
			} else if (!userName) {
				settingAlert.innerHTML = closeAlert + "<p>Username is empty!</p>";
			} else if (!userEmail) {
				settingAlert.innerHTML = closeAlert + "<p>E-mail address is empty</p>";
			} else {
				$.ajax({
					url: "/setting_user",
					async: true,
					data: {
						user_id: userId,
						user_fullname: userFullname,
						user_name: userName,
						user_email: userEmail,
						user_password: userPassword
					},
					success: function(res) {
						if (!res.Timeout) {
							alert("Success updating your information! You will logout!");
							window.location = "/logout";
						} else {
							alert("Session timeout :(");
							window.location = "/";
						}
					}
				});
			}
		});
	});
</script>
[[ end ]]

[[ define "edit_alert" ]]
<div id="setting-alert"></div>
[[ end ]]