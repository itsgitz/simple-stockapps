[[ define "reports_layout" ]]
[[ template "script". ]]
<div id="app-ajax-reports">
	<h4 style="padding-left: 5px; color: #d63031;">History Dashboard</h4>
	<div id="app-side-nav">
		<button class="history-all menu-button" href="javascript:void(0)">All History</button>&nbsp;
		<button class="history-my menu-button" href="javascript:void(0)">My History</button>
	</div>
</div>
[[ end ]]

[[ define "script" ]]
<script>
	var allHistoryButton = $("button.history-all");
	var myHistoryButton = $("button.history-my");
	$(function() {
		
	});
</script>
[[ end ]]