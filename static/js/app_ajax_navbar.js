$(document).ready(function() {
	///////// Navigation Ajax Page /////////
	appAjaxController();
})

// Ajax Controller
// This script used in ajax_navbar.tpl file (html)
function appAjaxController() {
	var hashUrl = window.location.hash;
	var getUrlFromHash = hashUrl.substring(15);
	
	window.onpopstate = function(event) {
		// get state
		console.log(JSON.stringify(event.state));
		var eventState = JSON.stringify(event.state);

		if (eventState == "null") {
			window.location = "/";
		} else {
			var url = "/" + event.state.page;
			appAjaxRequestPage(url);
			switch(event.state.page) {
				case "items": $("title").text("Items Dashboard - Simple StockApps"); break;
				case "reports": $("title").text("History - Simple StockApps"); break;
				case "users": $("title").text("Users Dashboard - Simple StockApps"); break;
				case "settings": $("title").text("Settings Dashboard - Simple StockApps"); break;
				case "search_reports": $("title").text("Reports Dashboard - Simple StockApps"); break;
			}
		}
	}

	// if current url/access url contains hash url,
	// then request page using AJAX and display it on div#app-container
	if (hashUrl) {	// hashUrl = "/foo, /bar"
		switch(getUrlFromHash) {
			// change title
			case "/items":
				$("title").text("Goods Dashboard - Simple StockApps");
				break;
			case "/reports":
				$("title").text("History Dashboard - Simple StockApps");
				break;
			case "/users":
				$("title").text("Users Dashboard - Simple StockApps");
				break;
			case "/settings":
				$("title").text("Settings Dashboard - Simple StockApps");
				break;
			case "/search_reports":
				$("title").text("Reports Dashboard - Simple StockApps");
				break;
		}
		var getStateFromUrl = getUrlFromHash.substring(1);
		var stateObj = { page: getStateFromUrl };
		var urlState = "/navbar?#navigate_link=" + getUrlFromHash;
		history.pushState(stateObj, getStateFromUrl, urlState);
		appAjaxRequestPage(getUrlFromHash);
	} else {
		window.location = "/";
	}

	// prevent default on "a" element link onclick
	$("a.ajax-navbar").click(function(e) {
		e.preventDefault();
	});	

	// items page click
	$("a.ajax-items").click(function() {
		// create history pushstate
		var stateObj = { page: "items" };
		history.pushState(stateObj, "items", "/navbar?#navigate_link=/items");

		// Change HTML Title when link clicked
		$("title").text("Items Dashboard - Simple StockApps");

		// load again with ajax
		appAjaxRequestPage("/items");
	});

	// history page click
	$("a.ajax-reports").click(function() {
		var stateObj = { page: "reports" };
		history.pushState(stateObj, "reports", "/navbar?#navigate_link=/reports");
		$("title").text("History Dashboard - Simple StockApps");
		
		// load again with ajax
		appAjaxRequestPage("/reports");
	});

	// users page click
	$("a.ajax-users").click(function() {
		var stateObj = { page: "users" };
		history.pushState(stateObj, "users", "/navbar?#navigate_link=/users");
		$("title").text("Users Dashboard - Simple StockApps");

		// load again with ajax
		appAjaxRequestPage("/users");
	});

	// settings page click
	$("a.ajax-settings").click(function() {
		var stateObj = { page: "settings" };
		history.pushState(stateObj, "settings", "/navbar?#navigate_link=/settings");
		$("title").text("Settings Dashboard - Simple StockApps");
		appAjaxRequestPage("/settings");
	});

	// reports page click
	$("a.ajax-search-reports").click(function() {
		var stateObj = { page: "search_reports" };
		history.pushState(stateObj, "search_reports", "/navbar#navigate_link=/search_reports");
		$("title").text("Reports Dashboard - Simple StockApps");
		appAjaxRequestPage("/search_reports");
	})
}

function appAjaxRequestPage(url) {
	$.ajax({
		url: url,
		asycn: true,
		success: function(response) {
			if (response.Message) {
				window.location = "/";
			}

			$("div#app-ajax-wrapper").html(response);
			$("div#app-loading-bar").css("display", "none");
		},
		beforeSend: function(response) {
			$("div#app-loading-bar").css("display", "block");
		},
		error: function(response) {
			console.log(response);
			window.location = "/";
		}
	});
}