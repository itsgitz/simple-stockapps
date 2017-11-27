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
		loginPopupBox.fadeIn(500);
	});
	// close login popup
	closeButton.click(function() {
		loginPopupBox.fadeOut();
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
						$("div.app-login-alert").html("<b>Incorrect username or password!</b>");
					}
				}
			});
			loginForm[0].reset(); // reset (clearing) the login form after submit
		}
	});
}

// appTableHandler for handling table items
function appTableHandler() {/*
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
}
