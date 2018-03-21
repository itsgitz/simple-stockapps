[[ define "ajax_navbar_layout" ]]
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" href="/css/navbar_style.css?[[.HtmlScriptVersion]]">
		<link rel="stylesheet" href="/css/items_style.css?[[.HtmlScriptVersion]]">
		<link rel="stylesheet" href="/css/users_style.css?[[.HtmlScriptVersion]]">
		<link rel="stylesheet" href="/css/settings.css?[[.HtmlScriptVersion]]">
		<link rel="stylesheet" href="/css/history.css?[[.HtmlScriptVersion]]">
		<link rel="icon" href="/img/lintasarta_icon.png" type="image/gif">
		<!--<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>-->
		<script src="/js/jquery-3.3.1.min.js"></script>
		<script src="/js/all_items_functions.js?[[.HtmlScriptVersion]]"></script>
		<script src="/js/all_users_functions.js?[[.HtmlScriptVersion]]"></script>
		<script src="/js/app_ajax_navbar.js?[[.HtmlScriptVersion]]"></script>
	</head>
	<body>
		<div id="app-container">
			<div id="app-loading-bar"></div>
			[[ template "navigation". ]]
			<div id="app-ajax-wrapper"></div>
		</div>
	</body>
</html>
[[ end ]]
