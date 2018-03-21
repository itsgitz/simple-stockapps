[[ define "reports_layout" ]]
[[ template "script". ]]
<div id="app-ajax-reports">
	<h4 style="padding-left: 5px; color: #d63031;">History Dashboard</h4><hr>
	<div id="app-side-nav">
		<button class="history-all menu-button" href="javascript:void(0)">All History</button>&nbsp;
		<button class="history-my menu-button" href="javascript:void(0)">My History</button><br><br>
	</div>
	<div id="history-wrapper">
		[[ template "get_all_history". ]]
		[[ template "get_my_history". ]]
		[[ template "notes_popup". ]]
	</div>
</div>
[[ end ]]

[[ define "script" ]]
<script>
	//var ws = new WebSocket('ws://10.24.24.76:8080/ws');
	var ws = new WebSocket('ws://localhost:8080/ws');
	// all websocket request

	// if browser support or not support
	if (window.WebSocket) {
		console.log("Your web browser is support websocket");
	} else {
		console.log("Your web browser doesn't support websocket");
	}
	ws.onopen = function() {
		console.log("WebSocket connection opened!");
		var greetingCard = "I'm connected with you :), My Platform: " + navigator.platform;
		ws.send(greetingCard);
	}
	ws.onclose = function() {
		console.log("WebSocket connection closed!");
		console.log("Ready: " + ws.readyState);
		console.log("WebSocket server connection is close... I'll try to reconnecting in 3s ... Or if I always try to reconnecting to websocket server, please clean the cookies and cache in your browser :) -AQX-");
		setTimeout(function() {
			window.location = "/";
		}, 3000);
		setTimeout(function() {
			console.log("Establish WebSocket server connection in 1s ... -AQX-")
			window.location = "/";
		}, 1000);
	}
	ws.onerror = function(error) {
		console.log(error);
	}
	var allHistoryButton = $("button.history-all");
	var myHistoryButton = $("button.history-my");
	var allHistoryBox = $("div#history-all-box");
	var myHistoryBox = $("div#history-my-box");
	var hashUrl = window.location.hash;

	// get partly string from hash url
	// : navbar?#navigate_link=/users#add, partly option string is "add"
	var getOptionFromHash = hashUrl.substring(24);

	$(function() {
		allHistoryBox.css("display", "block");
		switch (getOptionFromHash) {
			case "my":
				allHistoryBox.css("display", "none");
				myHistoryBox.css("display", "block");
				appGetMyHistory();
				$("title").text("My History - Simple StockApps");
			break;
		}
		appSubNavigationOnClick();
		appGetAllHistory();
		appGetMyHistory();
	});

	function appSubNavigationOnClick() {
		allHistoryButton.click(function() {
			var stateObj = {page: "reports"};
			history.pushState(stateObj, "reports", "/navbar?#navigate_link=/reports");
			allHistoryBox.css("display", "block");
			myHistoryBox.css("display", "none");
			$("title").text("History Dashboard - Simple StockApps");
			appGetAllHistory();
		});
		myHistoryButton.click(function() {
			var stateObj = {page: "reports"};
			history.pushState(stateObj, "reports", "/navbar?#navigate_link=/reports#my");
			allHistoryBox.css("display", "none");
			myHistoryBox.css("display", "block");
			$("title").text("My History - Simple StockApps");
			appGetMyHistory();
		});
	}
	function appGetAllHistory() {
		$.ajax({
			url: "/json_get_side_notification",
			async: true,
			success: function(res) {
				var respLength = res.length;
				var i;
				var resultHistory;
				resultHistory = "<br>";
				for (i=0; i<respLength; i++) {
					resultHistory += "<div class='history-content' data-by='"+res[i].history_by+"' data-notes='"+res[i].history_notes+"' title='Click for display notes'>";
					if (res[i].history_status == "Canceled") {
						resultHistory += res[i].history_content + " (Canceled)";
					} else {
						resultHistory += res[i].history_content;
					}
					resultHistory += "</div>";
				}
				document.getElementById("history-all-box").innerHTML = resultHistory;

				var historyContent = $("div.history-content");
				// history content box
				historyContent.click(function() {
					var thisBy = $(this).attr("data-by");
					var thisNotes = $(this).attr("data-notes");
					var notes;
					var jqueryGetModal = $("div#history-modal");
					var getModal = document.getElementById("history-modal");
					var getContent = document.getElementById("history-modal-content");
					notes = "<h4>Notes</h4><hr>";
					notes += "<p><i>" + thisNotes + "</i></p>";
					notes += "<p> -"+ thisBy +"- </p>";
					notes += "<p style='text-align: center;'><button class='close-modal'>Close</button></p>";

					jqueryGetModal.fadeIn(300);
					window.onclick = function(e) {
						if (e.target == getModal) {
							jqueryGetModal.fadeOut(300);
						}
					}

					getContent.innerHTML = notes;
					$("button.close-modal").click(function() {
						jqueryGetModal.fadeOut(300);
					});
				});
			}
		});
	}
	function appGetMyHistory() {
		$.ajax({
			url: "/json_get_my_history",
			async: true,
			success: function(res) {
				var respLength = res.length;
				var i;
				var resultHistory;
				resultHistory = "<br>";
				for (i=0; i<respLength; i++) {
					resultHistory += "<div class='history-content' data-history-id='"+res[i].history_id+"' data-code='"+res[i].history_code+"' data-by='"+res[i].history_by+"' data-notes='"+res[i].history_notes+"' data-item-id='"+res[i].item_id+"' data-picked-item='"+res[i].picked_item+"' data-history-status='"+res[i].history_status+"' title='Click for display notes'>";
					if (res[i].history_status == "None") {
						resultHistory += res[i].history_content;
					} else {
						resultHistory += res[i].history_content + " (Canceled)";
					}
					resultHistory += "</div>";
				}
				document.getElementById("history-my-box").innerHTML = resultHistory;
				var historyContent = $("div.history-content");
				// history content box
				historyContent.click(function() {
					var thisBy = $(this).attr("data-by");
					var thisNotes = $(this).attr("data-notes");
					var thisCode = $(this).attr("data-code");
					var thisItemId = $(this).attr("data-item-id"); // item id
					var thisPickedItem = $(this).attr("data-picked-item"); // number of picked item before
					var thisHistoryId = $(this).attr("data-history-id");
					var thisHistoryStatus = $(this).attr("data-history-status");
					var notes;
					var jqueryGetModal = $("div#history-modal");
					var getModal = document.getElementById("history-modal");
					var getContent = document.getElementById("history-modal-content");
					notes = "<h4>Notes</h4><hr>";
					notes += "<p><i>" + thisNotes + "</i></p>";
					notes += "<p> -"+ thisBy +"- </p>";
					notes += "<p style='text-align: center;'>"
					notes += "  <button class='close-modal'>Close</button>";
					if (thisCode == "#001-pick-up" && thisHistoryStatus == "None") {
						notes += "   <button class='cancel-pick'>Cancel Pick up</button>";
					} else if (thisCode == "#001-pick-up" && thisHistoryStatus == "Canceled") {
						notes += "   <span class='canceled-text'>Canceled</span>";
					}
					notes += "</p>";

					jqueryGetModal.fadeIn(300);
					window.onclick = function(e) {
						if (e.target == getModal) {
							jqueryGetModal.fadeOut(300);
						}
					}

					getContent.innerHTML = notes;
					var closeButtonModal = $("button.close-modal");
					var cancelPickButton = $("button.cancel-pick");

					// close button
					closeButtonModal.click(function() {
						jqueryGetModal.fadeOut(300);
					});

					// cancel pick up
					cancelPickButton.click(function() {
						//console.log(thisItemId, thisPickedItem);
						$.ajax({
							url: "/json_cancel_pick",
							async: true,
							method: "POST",
							data: {
								history_id: thisHistoryId,
								item_id: thisItemId,
								picked_item: thisPickedItem
							},
							success: function(res) {
								console.log(res);
								if (res.Message_Timeout) {
									alert("Session has timeout :(");
									window.location = "/";
								} else {
									var getContent = document.getElementById("history-modal-content");
									var historyMyBox = $("div#history-my-box");
									getContent.innerHTML = "<h3 style='padding: 10px; font-weight: bold; color: #3498db;'>" + res.message; + "</h2>";
									setTimeout(function() {
										$("div#history-modal").fadeOut(300);
									}, 3000);
									window.onclick = function(e) {
										if (e.target == getContent) {
											$("div#history-modal-content").css("display", "block");
										}
									}
									ws.send("#006-cancel-pick-up");
									historyMyBox.load(" #history-my-box");
									appGetMyHistory();
								}
							}
						});
					});
				});
			}
		});
	}
</script>
[[ end ]]

[[ define "notes_popup" ]]
<div id="history-modal" class="modal">
	<div id="history-modal-content" class="modal-content"></div>
</div>
[[ end ]]

[[ define "get_all_history" ]]
<div id="history-all-box"></div>
[[ end ]]

[[ define "get_my_history" ]]
<div id="history-my-box"></div>
[[ end ]]
