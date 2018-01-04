// jQuery.3.2.1
	var ws = new WebSocket('ws://192.168.43.56/ws');
	if (window.WebSocket) {
		console.log("Your web browser is support websocket");
	} else {
		console.log("Your web browser doesn't support websocket");
	}
	ws.onopen = function() {
		console.log("WebSocket connection opened!");
	}
	ws.onclose = function() {
		console.log("WebSocket connection closed!");
		console.log("Ready: " + ws.readyState);
	}
	ws.onerror = function(error) {
		alert('WebSocket' + error);
	}
$(function() {
	////////// Main Page ///////////////////
	// login popup box function
	appLoginHandler();
	// table handler function
	appTableHandler();
	var navigationBar = document.getElementById("app-navbar");
	var jqueryGetSideNotificationBar = $("div#app-side-notif");
	var jqueryGetTableBox = $("div#app-table-box");
	var documentWidth = $(document).width();
	
	if (navigationBar) {
		jqueryGetSideNotificationBar.css("top", "200px");
		jqueryGetTableBox.css("top", "200px");
	}

	ws.onmessage = function(e) {
		var tableBox = $("div#app-table-box");
		console.log("Pesan: "+ e.data);
		if (e.data) {
			switch(e.data) {
				case "#001-pick-up":
					tableBox.load(" #app-table-box", function() {
						appTableHandler();
						tableBox.hide();
						tableBox.fadeIn(300);
					});
				break;
			}
		}
	}
});

// Login popup box function
function appLoginHandler() {
	// login form variable element
	var loginForm = $("form.app-login-form");
	// login popup box
	var loginPopupBox = $("div#app-login-popup");
	// login button and close button
	var signButton = $("button.app-sign-btn");
	var closeButton = $("button.app-close-btn");

	// show login popup when sign button clicked
	signButton.click(function() {
		loginPopupBox.fadeIn(300);
	});
	// close login popup
	closeButton.click(function() {
		loginPopupBox.fadeOut(300);
		loginForm[0].reset();
		$("div.app-login-alert").hide();
	});

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
						$("div.app-login-alert").html("<b>Incorrect username or password!</b><br><br>");
						$("div.app-login-alert").hide();
						$("div.app-login-alert").fadeIn("300");
					}
				}
			});
			loginForm[0].reset(); // reset (clearing) the login form after submit
		}
	});
}

// appTableHandler for handling table items
function appTableHandler() {
	// AJAX Request
	$.ajax({
		url: "/json_get_items",
		async: true,
		success: function(res) {
			var isLoggedIn = $("div#app-user-islogged-in").text();
			console.log("Logged In is: " + isLoggedIn);
			var tableMonitoring = "<table id='app-table' class='app-table' border='0' cellpadding='12' cellspacing='0'>";
				tableMonitoring += "  <th>No.</th>";
				tableMonitoring += "  <th>Name</th>";
				tableMonitoring += "  <th>Model/Brand</th>";
				tableMonitoring += "  <th>Quantity</th>";
				tableMonitoring += "  <th>Limitation</th>";
				tableMonitoring += "  <th>Item Unit</th>";
				tableMonitoring += "  <th>Status</th>";
				if (isLoggedIn == "true") {
					tableMonitoring += "  <th>Action</th>";
				}

			for (var i=0; i<res.length; i++) {
				tableMonitoring += "  <tr>";
				tableMonitoring += "    <td>"+ (i+1) +"</td>";
				tableMonitoring += "    <td>"+ res[i].item_name +"</td>";
				tableMonitoring += "    <td>"+ res[i].item_model +"</td>";
				tableMonitoring += "    <td>"+ res[i].item_quantity +"</td>";
				tableMonitoring += "    <td>"+ res[i].item_limitation +"</td>";
				tableMonitoring += "    <td>"+ res[i].item_unit +"</td>";
				tableMonitoring += "    <td class='tb-status'>"+ res[i].item_status +"</td>";
				if (isLoggedIn == "true") {
					tableMonitoring += "    <td><a id='app-pick-btn' href='' data-item-id='"+res[i].item_id+"' data-item-name='"+res[i].item_name+"' data-item-quantity='"+res[i].item_quantity+"' data-item-limitation='"+res[i].item_limitation+"' data-item-owner='"+res[i].item_owner+"'>Pick Up</a></td>";
				}
				tableMonitoring += "  </tr>";
			}
			tableMonitoring += "</table>";

			// print the table in app-table-box
			document.getElementById("app-table-box").innerHTML = tableMonitoring;

			// give style to status rows
			// if "Available" has blue background color
			// if "Limited" has orange background color
			$("div#app-table-box .tb-status").each(function() {
				var statusColumnValue = $(this).text();
				var statusRowsValue = $(".tb-status");
				statusRowsValue.css("font-weight", "bold");
				switch(statusColumnValue) {
					case "Available": statusRowsValue.css("color", "#2980b9"); break;
					case "Limited": statusRowsValue.css("color", "#d35400"); break;
					case "Not Available": statusRowsValue.css("color", "#c0392b"); break;
				}
			});

			var pickUpButton = $("a#app-pick-btn");

			pickUpButton.click(function(e) {
				e.preventDefault();
				var getItemId = $(this).attr("data-item-id");
				var getName = $(this).attr("data-item-name");
				var getQuantity = $(this).attr("data-item-quantity");
				var getLimitation = $(this).attr("data-item-limitation");
				var getOwner = $(this).attr("data-item-owner");
				
				var pickupModalText;
				pickupModalText = "<div id='app-pickup-modal'>";
				pickupModalText += "   <div class='app-pickup-content'>";
				pickupModalText += "      <div id='tbl-input-content'>";
				pickupModalText += "         <table cellpadding='5px' cellspacing='0' style='border: solid 1px #ddd; font-size: 80%;'>";
				pickupModalText += "            <tr colspan='2'><td>Current Data</td></tr>";
				pickupModalText += "            <tr>";
				pickupModalText += "               <td>ID</td>";
				pickupModalText += "               <td>"+getItemId+"</td>";
				pickupModalText += "            </tr>";
				pickupModalText += "            <tr>";
				pickupModalText += "               <td>Name</td>";
				pickupModalText += "               <td>"+getName+"</td>";
				pickupModalText += "            </tr>";
				pickupModalText += "            <tr>";
				pickupModalText += "               <td>Owner</td>";
				pickupModalText += "               <td>"+getOwner+"</td>";
				pickupModalText += "            </tr>";
				pickupModalText += "            <tr>";
				pickupModalText += "               <td>Quantity</td>";
				pickupModalText += "               <td>"+getQuantity+"</td>";
				pickupModalText += "            </tr>";
				pickupModalText += "            <tr>";
				pickupModalText += "               <td>Limitation</td>";
				pickupModalText += "               <td>"+getLimitation+"</td>";
				pickupModalText += "            </tr>";
				pickupModalText += "         </table>";
				pickupModalText += "         <br><label style='color: #27ae60; font-weight: bold;'>How much do you want to pick up?</label><br><br>";
				pickupModalText += "         <input class='app-howmuch' type='number' placeholder='Quantity'><br><br>";
				pickupModalText += "         <textarea class='text-notes' rows='5' cols='50' placeholder='Notes'></textarea>";				
				pickupModalText += "      </div>";
				pickupModalText += "      <div id='app-pickup-btn-box'>";
				pickupModalText += "         <br><button class='modal-button pickup-yes'>Pick up</button>&nbsp;<button class='modal-button pickup-close'>Close</button>";
				pickupModalText += "      </div>";
				pickupModalText += "   </div>";
				pickupModalText += "</div>";

				document.getElementById("app-modal-pickup-container").innerHTML = pickupModalText;

				// modal box
				var pickupModalBox = document.getElementById("app-pickup-modal");
				var cliseBtn = document.getElementsByClassName("pickup-close")[0];
				var pickupYes = $("button.pickup-yes");

				// open modal
				var jqueryGetModalBox = $("div#app-pickup-modal");
				jqueryGetModalBox.fadeIn(300);

				// close modal if close button clicked
				jqueryClose = $("button.pickup-close");
				jqueryClose.click(function() {
					jqueryGetModalBox.fadeOut(100);
					$("div#app-pickup-alert").fadeOut(300);
				});

				// if user clicks anywhere outside of the modal, then close it
				window.onclick = function(e) {
					if (e.target == pickupModalBox) {
						jqueryGetModalBox.fadeOut(100);
						$("div#app-pickup-alert").fadeOut(100);
					}
				}

				pickupYes.click(function () {
					var itemHowMuch = $("input.app-howmuch").val();

					var alertPickupMessage;
					var modalPickupAlert = document.getElementById("app-pickup-alert");
					var jqueryModalPickupAlert = $("div#app-pickup-alert");
					var textNotes = $("textarea.text-notes").val();

					var quantityToMin = parseInt(getQuantity - itemHowMuch);
					console.log(quantityToMin);
						
					if (parseInt(itemHowMuch)) {
						if (parseInt(itemHowMuch) < parseInt(getQuantity) && textNotes) {
							$.ajax({
								url: "/json_pickup_item",
								method: "POST",
								data: {
									item_id: getItemId,
									item_quantity_picked: quantityToMin,
								},
								async: true,
								success: function(res) {
									if (!res.Message_Timeout) {
										jqueryModalPickupAlert.fadeOut(300);
										$("div.app-pickup-content").html("<p style='padding: 10px; font-weight: bold; color: #3498db;'>"+res.Message+" Please wait ...</p>");
										$("div#app-pickup-btn-box").css("display", "none");
										setTimeout(function() {
											jqueryGetModalBox.fadeOut(300);
										}, 3000)
										// if user clicks anywhere outside of the modal
										window.onclick = function(e) {
											if (e.target == pickupModalBox) {
												$("div#app-pickup-modal").css("display", "block");
											}
										}
										ws.send("#001-pick-up");
									} else {
										alert("Session has timed out :(");
										window.location = "/";
									}
								}
							});
						} else if (parseInt(itemHowMuch) > parseInt(getQuantity)) {
							alertPickupMessage = "<span class='close-alert'>&times;</span><br>";
							alertPickupMessage += "<p>The number of pick up is more than current quantity</p>";
							jqueryModalPickupAlert.html(alertPickupMessage);
							jqueryModalPickupAlert.fadeIn(300);
							$("span.close-alert").click(function() {
								jqueryModalPickupAlert.fadeOut(300);
							});
						} else if (!textNotes) {
							alertPickupMessage = "<span class='close-alert'>&times;</span><br>";
							alertPickupMessage += "<p>Notes is empty!</p>";
							jqueryModalPickupAlert.html(alertPickupMessage);
							jqueryModalPickupAlert.fadeIn(300);
							$("span.close-alert").click(function() {
								jqueryModalPickupAlert.fadeOut(300);
							});
						}
					} else {
						alertPickupMessage = "<span class='close-alert'>&times;</span><br>";
						alertPickupMessage += "<p>Please fill the quantity</p>";
						jqueryModalPickupAlert.html(alertPickupMessage);
						jqueryModalPickupAlert.fadeIn(300);
						$("span.close-alert").click(function() {
							jqueryModalPickupAlert.fadeOut(300);
						});
					}
				});
			});
		},
		beforeSend: function(res) {
			$("div#app-table-box").html("<h2 style='color: #7f8c8d; padding: 50px;'>Loading please wait ...</h2>");
		},
		error: function(res) {
			console.log(res.responseText);
			$("div#app-table-box").html("<p style='color: #7f8c8d; padding: 30px; text-align:left;'>"+res.responseText+"</p>");
		}
	});
}