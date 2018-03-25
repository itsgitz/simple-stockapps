[[ define "search_reports_layout" ]]
[[ template "script" ]]

<div id="ajax-reports">
	<h4 style="padding-left: 5px; color: #d63031;">Reports Dashboard</h4><hr><br>
	<div id="report-option">
		<form id="show-report">
			<table cellpadding="5" cellspacing="0">
				<tr>
					<td><label style="font-weight: 600; color: #6C7A89; padding: 15px;">Show reports</label></td>
					<td>
						<select id="report-month">
							<option value="0" selected="">-- Month --</option>
							<option value="01">January</option>
							<option value="02">February</option>
							<option value="03">March</option>
							<option value="04">April</option>
							<option value="05">May</option>
							<option value="06">June</option>
							<option value="07">July</option>
							<option value="08">August</option>
							<option value="09">September</option>
							<option value="10">October</option>
							<option value="11">November</option>
							<option value="12">December</option>
						</select>
					</td>
					<td>
						<input id="report-year" type="text" placeholder="Year" maxlength="4">
					</td>
					<td>
						<input id="submit-report" type="submit" value="OK">
					</td>
				</tr>
			</table>
		</form>
	</div>
	<br>
	<div id="report-result">
		<h3 style="color: #7f8c8d; padding-left: 35px; padding-top: 35px; font-weight: 500;">Results are here ...</h3>
	</div>
	<div id="report-modal">
		<div id="report-modal-content"></div>
	</div>
	<div id="report-alert">
	</div>
</div>
[[ end ]]

[[ define "script" ]]
<script>
	$(function() {
		var submitReport = $("input#submit-report");
		var modal = document.getElementById("report-modal");
		var content = document.getElementById("report-modal-content");
		var jqModal = $("div#report-modal");
		var jqContent = $("div#report-modal-content");
		var jqAlert = $("div#report-alert");
		var alertBox = document.getElementById("report-alert");

		submitReport.click(function(e) {
			e.preventDefault();
			var month = $("select#report-month").val();
			var year = $("input#report-year").val();
			// testing regular exp
			var regularExp = /^(\d{4})$/;
			var regValidation = regularExp.test(year);
			var reportResult = document.getElementById("report-result");
			var jqReportResult = $("div#report-result");

			// condition
			if (month == "0") {
				jqAlert.fadeOut(300);
				jqAlert.fadeIn(300);
				alertBox.innerHTML = "<span class='close'>&times;</span><p>Please fill the month!</p>";
			} else if (!year) {
				jqAlert.fadeOut(300);
				jqAlert.fadeIn(300);
				alertBox.innerHTML = "<span class='close'>&times;</span><p>Please fill the year!</p>";
			} else if (!regValidation) {
				jqAlert.fadeOut(300);
				jqAlert.fadeIn(300);
				alertBox.innerHTML = "<span class='close'>&times;</span><p>Year format is wrong!</p>";
			} else {
				var tableText;
				jqAlert.fadeOut(300);
				$.ajax({
					url: "/show_report",
					async: true,
					method: "POST",
					data: {
						year: year,
						month: month
					},
					success: function(res) {
						if (res.redirect) {
							alert("Session timed out :(");
							window.location = "/";
						}

						if (res[0].name == "Not Found") {
							jqReportResult.fadeOut(300);
							jqReportResult.fadeIn(300);
							reportResult.innerHTML = "<h3 style='color: #7f8c8d; padding-left: 35px; padding-top: 35px; font-weight: 500;'>"+res[0].name+"</h3>";
						} else {
							tableText = "<table cellspacing='0' cellpadding='12'>";
							tableText += "  <th>No.</th>";
							tableText += "  <th>ID</th>";
							tableText += "  <th>Name</th>";
							tableText += "  <th>In</th>";
							tableText += "  <th>Quantity</th>";
							tableText += "  <th>Used</th>";
							tableText += "  <th>Rest</th>";
							tableText += "  <th>Status</th>";
							for (var i=0; i<res.length; i++) {
								tableText += "  <tr>";
								tableText += "   <td>"+(i+1);+"</td>";
								tableText += "   <td>"+res[i].item_id+"</td>";
								tableText += "   <td>"+res[i].name+"</td>";
								tableText += "   <td>"+res[i].in+"</td>";
								tableText += "   <td>"+res[i].quantity+"</td>";
								tableText += "   <td>"+res[i].used+"</td>";
								tableText += "   <td>"+res[i].rest+"</td>";
								tableText += "   <td>"+res[i].status+"</td>";
								tableText += "  </tr>";
							}
							tableText += "</table>";
							tableText += "<br>";
							tableText += "<button class='export-button'>Export PDF</button>";
							jqReportResult.fadeOut(300);
							jqReportResult.fadeIn(300);
							reportResult.innerHTML = tableText;
							var exportPDF = $("button.export-button");
							exportPDF.click(function() {
								$.ajax({
									url: "/to_pdf",
									async: true,
									data: {
										year: year,
										month: month
									},
									success: function(res) {
										if (res.redirect) {
											alert("Session timed out :(");
											window.location = "/";
										}
									}
								});
							});
						}
					}
				});
			}

			var closeBtn = $("span.close");
			closeBtn.click(function() {
				jqAlert.fadeOut(300);
			});
		});
	});
</script>
[[ end ]]