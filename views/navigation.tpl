[[ define "navigation" ]]

[[ template "script". ]]
[[ template "style". ]]
[[ template "logo". ]]

[[ if .HtmlUserIsLoggedIn ]]
<div id="app-navbar">
	<ul>
		<li>
			<a href="/">Home</a>
		</li>
		<li>
			<a class="ajax-navbar ajax-items" href="/navbar?#navigate_link=/items">Items</a>
		</li>
		<li>
			<a class="ajax-navbar ajax-reports" href="/navbar?#navigate_link=/reports">History</a>
		</li>
		<li>
			<a class="ajax-navbar ajax-users" href="/navbar?#navigate_link=/users">Users</a>
		</li>
	</ul>
</div>
[[ else ]]
<button class="app-sign-btn">Login</button>
[[ end ]]

[[ end ]]

[[ define "logo" ]]
<div id="app-logo">
	<img src="/img/logo_lintasarta.png" style="width: 150px; height: auto;"><br><br>
	<label style="font-size: 80%; font-weight: 600; color: #2980b9;">Data Center Stock of Goods Management System</label>
	[[ if .HtmlUserIsLoggedIn ]]
	[[ template "user_profile". ]]
	[[ end ]]
</div>
[[ end ]]

[[ define "user_profile" ]]
<div id="app-user-profile-nav">
	<a class="app-dropdown-btn" href="">[[.HtmlUserFullName]]</a>
	<div class="app-dropdown-content">
		<a href="/settings">Settings</a>
		<a href="/logout">Logout</a>
	</div>
</div>
[[ end ]]

[[ define "script" ]]
<script>
	$(document).ready(function() {
		$("a.app-dropdown-btn").click(function(e) {
			e.preventDefault();
			$("div.app-dropdown-content").slideToggle(300);
		});
	});
</script>
[[ end ]]

[[ define "style" ]]
<style>
	/* Navigation Bar */
	div#app-navbar {
		background-color: #e74c3c;
	}
	div#app-navbar ul {
		list-style-type: none;
		margin: 0;
		padding: 0;
		overflow: hidden;
	}
	div#app-navbar ul li {
		display: inline;
		float: left;
	}
	div#app-navbar ul li a {
		display: block;
		padding: 10px;
		background-color: #e74c3c;
		color: #FFFFFF;
		text-decoration: none;
		font-weight: 600;
	}
	/* end of navigation style */

	/* User Profile button / navigation */
	div#app-user-profile-nav {
		float: right;
		background-color: #3498db;
		position: absolute;
		top: 55px;
		right: 8px;
		border-radius: 5px;
		text-align: center;
	}
	div#app-user-profile-nav a {
		display: block;
		padding: 7px;
		text-decoration: none;
		color: #FFFFFF;
		font-size: 80%;
	}
	div#app-user-profile-nav .app-dropdown-content {
		display: none;
		min-width: 160px;
		z-index: 2;
		border-radius: 5px;
	}
	div#app-user-profile-nav .app-dropdown-content {
		background-color: #FFFFFF;
	}
	div#app-user-profile-nav .app-dropdown-content a {
		text-align: left;
		color: #000000;
	}
	/* end of profile button */

	/* logo style */
	div#app-logo {
		margin: 0;
		padding: 10px;
		padding-bottom: 20px;
		padding-left: 20px;
		background-color: #ecf0f1;
		border-radius: 5px;
		box-shadow: 1px 2px 2px #888888;
	}
	/* end of logo style */

	/* Sign in Button style */
	button.app-sign-btn {
		position: absolute;
		top: 35px;
		right: 20px;
		border: none;
		padding-top: 10px;
		padding-bottom: 10px;
		padding-left: 20px;
		padding-right: 20px;
		font-family: "arial", sans-serif;
		color: #3498db;
		background-color: #ecf0f1;
		border: solid 1px #3498db;
		border-radius: 5px;
		font-weight: bold;
	}
	button.app-sign-btn:hover {
		cursor: pointer;
	}
	/* end of sign in button style */
</style>
[[ end ]]