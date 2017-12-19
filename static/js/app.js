// jQuery.3.2.1
$(document).ready(function() {
	////////// Main Page ///////////////////
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
	$.ajax({
		url: "/json_get_items",
		async: true,
		success: function(res) {
			var isLoggedIn = $("div#app-user-islogged-in").text();
			console.log("Logged In is: " + isLoggedIn);
			var tableMonitoring = "<table class='app-table' border='0' cellpadding='10' cellspacing='0'>";
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
				tableMonitoring += "    <td>"+ res[i].item_status +"</td>";
				if (isLoggedIn == "true") {
					tableMonitoring += "    <td><a href='/pick_up/"+res[i].item_id+"'>Pick Up</a></td>";
				}
				tableMonitoring += "  </tr>";
			}
			tableMonitoring += "</table>";

			// print the table in app-table-box
			document.getElementById("app-table-box").innerHTML = tableMonitoring;
		},
		beforeSend: function(res) {
			$("div#app-table-box").html("<h2 style='color: #7f8c8d; padding: 50px;'>Loading please wait ...</h2>");
		},
		error: function(res) {
			console.log(res.responseText);
			$("div#app-table-box").html("<p style='color: #7f8c8d; padding: 30px; text-align:justify;'>"+res.responseText+"</p>");
		}
	});
}

/*
	var ws = new WebSocket('ws://127.0.0.1:8080/ws');
	ws.onopen = function() {
		console.log("Connection Open");
	}
	ws.onerror = function(error) {
		console.error('WebSocket' + error);
	}
	ws.onmessage = function(e) {
		var msg = JSON.parse(e.data)
			$("p.app-msg-box").html(msg.Pesan);
		}
		// button on click
	$("button.app-send").click(function() {
		var msg = $("input.message").val();
		var json_msg = JSON.stringify({
			Pesan: msg
		});
			ws.send(json_msg);
	});*/