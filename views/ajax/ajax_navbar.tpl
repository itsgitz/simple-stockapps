[[ define "ajax_navbar_layout" ]]
<!DOCTYPE html>
<html>
	<head>
		<title></title>
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" href="/css/navbar_style.css">
		<link rel="icon" href="/img/lintasarta_icon.png" type="image/gif">
		<script src="/js/jquery-3.2.1.min.js"></script>
		<script src="/js/app_ajax_navbar.js"></script>
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