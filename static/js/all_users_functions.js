// navigation click handler
	function appSubNavigationButtonOnClick() {
		// add user button clicked
		addUserButton.click(function() {
			var stateObj = {page: "users#add"};
			history.pushState(stateObj, "users", "/navbar?#navigate_link=/users#add");
			registeredUserListBox.css("display", "none");
			newUsersListBox.css("display", "none");
			addBox.css("display", "block");
			$("title").text("Add Users - Simple StockApps");
		});
		// user list button clicked
		registeredUserListButton.click(function() {
			var stateObj = {page: "users"};
			history.pushState(stateObj, "users", "/navbar?#navigate_link=/users");
			registeredUserListBox.css("display", "block");
			addBox.css("display", "none");
			newUsersListBox.css("display", "none");
			$("title").text("Users Dashboard - Simple StockApps");
			appShowRegisteredUsers();
		});
		newUsersListButton.click(function() {
			var stateObj = {page: "users#new"};
			history.pushState(stateObj, "users", "/navbar?#navigate_link=/users#new");
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
					var modal = document.getElementById("remove-modal-user");
					var jqueryGetModal = $("div#remove-modal-user");
					var jqueryGetModalContent = $("div.remove-modal-content");
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
					// gif data-* attribute for store current data
					resultTable += "   <td><button class='remove-reg-user remove-users' data-user-id='"+res[i].user_id+"' data-user-name='"+res[i].user_login_name+"' data-user-fullname='"+res[i].user_name+"'>Remove</button></td>";
					resultTable += "</tr>";
				}
				resultTable += "</table>";

				document.getElementById("registered-users-box").innerHTML = resultTable;

				// define remove button options
				var removeRegUserButton = $("button.remove-reg-user");

				// removeRegUserButton on click
				removeRegUserButton.click(function() {
					// get the data-* value
					var regUserId = $(this).attr("data-user-id");
					var regUserName = $(this).attr("data-user-name");
					var regFullName = $(this).attr("data-user-fullname");

					var modal = document.getElementById("remove-modal-user");
					var jqueryGetModal = $("div#remove-modal-user");
					var jqueryGetModalContent = $("div.remove-modal-content");
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
					modalTable += "     <td>"+regUserId+"</td>";
					modalTable += "     <td>"+regUserName+"</td>";
					modalTable += "     <td>"+regFullName+"</td>";
					modalTable += "  </tr>";
					modalTable += "</table>";
					modalTable += "<br>";
					modalTable += "<div class='buton-box' style='text-align: center;'>"
					modalTable += "    <button class='remove-true' data-user-id='"+regUserId+"'>Yes</button>&nbsp;";
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
									appShowRegisteredUsers();
									registeredUserListBox.hide();
									registeredUserListBox.fadeIn(300);
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
