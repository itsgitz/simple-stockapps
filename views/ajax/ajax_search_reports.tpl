[[ define "search_reports_layout" ]]
<div id="ajax-settings">
	<h4 style="padding-left: 5px; color: #d63031;">Reports Dashboard</h4><hr><br>
	<table>
		<tr>
			<td>Show reports</td>
			<td>
				<select id="report-month">
					<option value="None" selected="">-- Month --</option>
					<option value="January">January</option>
					<option value="February">February</option>
					<option value="March">March</option>
					<option value="April">April</option>
					<option value="May">May</option>
					<option value="June">June</option>
					<option value="July">July</option>
					<option value="August">August</option>
					<option value="September">September</option>
					<option value="October">October</option>
					<option value="November">November</option>
					<option value="December">December</option>
				</select>
			</td>
			<td>
				<input class="report-year" type="text" placeholder="Year">
			</td>
			<td>
				<button class="submit-report">Create</button>
			</td>
		</tr>
	</table>
	<div id="report-result"></div>
</div>
[[ end ]]