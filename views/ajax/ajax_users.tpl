[[ define "users_layout" ]]

[[ template "script". ]]
<div id="app-ajax-users">
	<h4 style="padding-left: 5px; color: #d63031;">User Dashboard</h4>
	<div id="app-side-nav">
		<button class="add-user menu-button" href="javascript:void(0)">Add</button>&nbsp;
		<button class="registered-users menu-button" href="javascript:void(0)">Registered Users</button>&nbsp;
		<button class="new-users menu-button" href="javascript:void(0)">New Users</button>
	</div>
	<div id="users-wrapper">
		[[ template "add_box". ]]
		[[ template "registered_user_list_box". ]]
		[[ template "new_user_list_box". ]]
		[[ template "remove_reg_user_modal". ]]
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
			appShowRegisteredUsers();
		});
		newUsersListButton.click(function() {
			var stateObj = {page: "users#new"};
			history.pushState(stateObj, "page", "/navbar?#navigate_link=/users#new");
			newUsersListBox.css("display", "block");
			registeredUserListBox.css("display", "none");
			addBox.css("display", "none");
			$("title").text("New Users - Simple StockApps");
			appShowNewUsers();
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
			var alertCloseButton = "<span class='users-close-alert'>&times;</span>";
			var alertMessage = alertCloseButton;

			// error handling
			if (!userName) {
				alertMessage += "<p>Username is empty!</p>";
				addUserAlertBox.html(alertMessage);
				addUserAlertBox.hide();
				addUserAlertBox.fadeIn(300);
			} else if (!fullName) {
				alertMessage += "<p>User's full name is empty!</p>";
				addUserAlertBox.html(alertMessage);
				addUserAlertBox.hide();
				addUserAlertBox.fadeIn(300);
			} else if (!userEmail) {
				alertMessage += "<p>User's e-mail address is empty!</p>";
				addUserAlertBox.html(alertMessage);
				addUserAlertBox.hide();
				addUserAlertBox.fadeIn(300);
			} else if (!userRole) {
				alertMessage += "<p>User role/privilege is empty!</p>";
				addUserAlertBox.html(alertMessage);
				addUserAlertBox.hide();
				addUserAlertBox.fadeIn(300);
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
							addUserForm[0].reset();
						}
					}
				});
			}

			// close button
			var closeButton = $("span.users-close-alert");
			var alertBox = $("div.users-add-alert");
			closeButton.click(function() {
				alertBox.fadeOut(300);
			});
		});
	}

	// show all new users
	function appShowNewUsers() {
		$.ajax({
			url: "/json_new_users",
			async: true,
			success: function(res) {
				var resultTable;
				var lengthResponse = res.length;
				var i;

				resultTable =  "<table class='new-users-table users-table' border='0' cellpadding='10' cellspacing='0'>";
				resultTable += "   <th>No.</th>";
				resultTable += "   <th>User ID</th>";
				resultTable += "   <th>Username</th>";
				resultTable += "   <th>Fullname</th>";
				resultTable += "   <th>Role/Privilege</th>";
				resultTable += "   <th>Password</th>";
				resultTable += "   <th>E-mail Address</th>";
				resultTable += "   <th>Date Created</th>";
				resultTable += "   <th>Status</th>";
				resultTable += "   <th>Action</th>";
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
					resultTable += "   <td><button class='remove-users' data-user-id='"+res[i].user_id+"' data-user-name='"+res[i].user_login_name+"' data-user-fullname='"+res[i].user_name+"'>Remove</button></td>";
					resultTable += "</tr>";
				}
				resultTable += "</table>";

				document.getElementById("new-users-box").innerHTML = resultTable;

				var removeButton = $("button.remove-users");


				removeButton.click(function() {
					// get user id
					var thisUserId = $(this).attr("data-user-id");
					var thisUserName = $(this).attr("data-user-name");
					var thisUserFullName = $(this).attr("data-user-fullname");
					var modalTable;
					
					// open popup section ...
					var modal = document.getElementById("remove-modal-reg-user");
					var jqueryGetModal = $("div#remove-modal-reg-user");
					var jqueryGetModalContent = $("div.remove-modal-reg-content");
					var jqueryGetModalTable = $("div#modal-table");
					var jqueryGetAskToRemove = $("p#ask-to-remove");

					// show popup
					jqueryGetModal.fadeIn(300);
					window.onclick = function(e) {
						if (e.target == modal) {
							jqueryGetModal.fadeOut(100);
						}
					}

					// fill the modal table
					modalTable = "<table class='table-modal-content' cellspacing='0' cellpadding='10px'>";
					modalTable += "  <th>ID</th>";
					modalTable += "  <th>Login Name</th>";
					modalTable += "  <th>Fullname</th>";
					modalTable += "  <tr>";
					modalTable += "     <td>"+thisUserId+"</td>";
					modalTable += "     <td>"+thisUserName+"</td>";
					modalTable += "     <td>"+thisUserFullName+"</td>";
					modalTable += "  </tr>";
					modalTable += "</table>";
					modalTable += "<br>";
					modalTable += "<div class='buton-box' style='text-align: center;'>"
					modalTable += "    <button class='remove-true' data-user-id='"+thisUserId+"'>Yes</button>&nbsp;";
					modalTable += "    <button class='close-modal'>No</button>";
					modalTable += "</div>";
					document.getElementById("modal-table").innerHTML = modalTable;

					var closeModalButton = $("button.close-modal");
					// close modal button
					closeModalButton.click(function() {
						jqueryGetModal.fadeOut(100);
					});

					var removeTrue = $("button.remove-true");

					removeTrue.click(function() {
						var catchUserId = $(this).attr("data-user-id");
						$.ajax({
							url: "/remove_user",
							async: true,
							data: {
								user_id: catchUserId
							},
							success: function(res) {
								if (!res.Timeout) {
									jqueryGetAskToRemove.css("display", "none");
									jqueryGetModalTable.html("<p>Successful removing user!</p>");
									setTimeout(function() {
										jqueryGetModal.fadeOut(300);
									}, 2000);
									window.onclick = function(e) {
										if (e.target == modal) {
											jqueryGetModal.css("display", "block");	
										}
									}
									// load again using recursive
									appShowNewUsers();
									newUsersListBox.hide();
									newUsersListBox.fadeIn(300);
								} else {
									alert("Session timed out :(");
									window.location = "/";
								}
							}
						});
					});
				});
			},
			beforeSend: function() {
				document.getElementById("registered-users-box").innerHTML = "<h2 style='color: #636e72;'>Loading please wait ...</h2>";
			}
		});
	}

	// show registered users
	function appShowRegisteredUsers() {
		$.ajax({
			url: "/json_reg_users",
			async: true,
			success: function(res) {
				var resultTable;
				var lengthResponse = res.length;
				var i;
				resultTable =  "<table class='registered-users-table users-table' border='0' cellpadding='10' cellspacing='0'>";
				resultTable += "   <th>No.</th>";
				resultTable += "   <th>User ID</th>";
				resultTable += "   <th>Username</th>";
				resultTable += "   <th>Fullname</th>";
				resultTable += "   <th>Role/Privilege</th>";
				resultTable += "   <th>E-mail Address</th>";
				resultTable += "   <th>Date Created</th>";
				resultTable += "   <th>Status</th>";
				resultTable += "   <th>Action</th>";
				for (i=0; i<lengthResponse; i++) {
					resultTable += "<tr>";
					resultTable += "   <td>"+(i+1)+"</td>";
					resultTable += "   <td>"+res[i].user_id+"</td>";
					resultTable += "   <td>"+res[i].user_login_name+"</td>";
					resultTable += "   <td>"+res[i].user_name+"</td>";
					resultTable += "   <td>"+res[i].user_privilege+"</td>";
					resultTable += "   <td>"+res[i].user_email+"</td>";
					resultTable += "   <td>"+res[i].date_created+"</td>";
					resultTable += "   <td>"+res[i].status+"</td>";
					resultTable += "   <td><button class='remove-reg-user remove-users'>Remove</button></td>";
					resultTable += "</tr>";
				}
				resultTable += "</table>";

				document.getElementById("registered-users-box").innerHTML = resultTable;
			},
			beforeSend: function() {
				document.getElementById("registered-users-box").innerHTML = "<h2 style='color: #636e72;'>Loading please wait ...</h2>";
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

[[ define "remove_reg_user_modal" ]]
<!-- Modal Wrapper -->
<div id="remove-modal-reg-user" class="remove-modal">
	<!-- Modal Content -->
	<div class="remove-modal-reg-content">
		<p id="ask-to-remove">Are you sure want to remove?</p><br>
		<div id="modal-table"></div><br>
	</div>
</div>
[[ end ]]