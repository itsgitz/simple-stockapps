$(document).ready(function() {
	///////// Navigation Ajax Page /////////
	appAjaxController();
})

// Ajax Controller
// This script used in ajax_navbar.tpl file (html)
function appAjaxController() {
	var hashUrl = window.location.hash;
	var getUrlFromHash = hashUrl.substring(15);
	
	// if current url/access url contains hash url,
	// then request page using AJAX and display it on div#app-container
	if (hashUrl) {
		switch(getUrlFromHash) {
			case "/items":
				$("title").text("Items Management - Simple StockApps");
				break;
			case "/reports":
				$("title").text("Reports Management - Simple StockApps");
				break;
			case "/users":
				$("title").text("Users Management - Simple StockApps");
				break;
		}
		appAjaxRequestPage(getUrlFromHash);
	}

	// prevent default on "a" element link onclick
	$("a.ajax-navbar").click(function(e) {
		e.preventDefault();
	});	

	$("a.ajax-items").click(function() {
		// create history pushstate
		var stateObj = { foo: "bar" };
		history.pushState(stateObj, "page", "/navbar?#navigate_link=/items");

		// Change HTML Title when link clicked
		$("title").text("Items Management - Simple StockApps");

		// load again with ajax
		appAjaxRequestPage("/items");
	});

	$("a.ajax-reports").click(function() {
		var stateObj = { foo: "bar" };
		history.pushState(stateObj, "page", "/navbar?#navigate_link=/reports");
		$("title").text("Reports Management - Simple StockApps");
		
		// load again with ajax
		appAjaxRequestPage("/reports");
	});

	$("a.ajax-users").click(function() {
		var stateObj = { foo: "bar" };
		history.pushState(stateObj, "page", "/navbar?#navigate_link=/users");
		$("title").text("Users Management - Simple StockApps");

		// load again with ajax
		appAjaxRequestPage("/users");
	});
}

function appAjaxRequestPage(url) {
	$.ajax({
		url: url,
		asycn: true,
		success: function(response) {
			$("div#app-ajax-wrapper").html(response);
			$("div#app-loading-bar").css("display", "none");
		},
		beforeSend: function(response) {
			$("div#app-loading-bar").css("display", "block");
		}
	});
}