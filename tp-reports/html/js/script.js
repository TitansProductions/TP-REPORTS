function closeInventory() {
    $.post("http://tp-reports/closeNUI", JSON.stringify({}));
	$('#report').html('');
}

$(function() {
	window.addEventListener('message', function(event) {
		if (event.data.type == "enableui") {
			document.body.style.display = event.data.enable ? "block" : "none";
			document.getElementById("reports").style.display="block";
			document.getElementById("showreports").style.display="none";

		}else if (event.data.type == "enablereportsui"){
			document.body.style.display = event.data.enable ? "block" : "none";
			document.getElementById("reports").style.display="none";
			document.getElementById("showreports").style.display="block";

		}else if (event.data.action == "addReportInformation") {
			document.getElementById("current-reports").innerHTML = "[ Reports: " + event.data.currentReports + " ] - [ Solved: " + event.data.solvedReports + " ] - [ In Progress: " + event.data.inProgress + " ]";

		}else if (event.data.action == "clearReports") {
			$('#report').html('');

		}else if (event.data.action == "addReport") {
			var prod_report = event.data.reports_det;

			if (prod_report.description == "N/A") {
				prod_report.description = "There is no description.";
			}

			$("#report").append(
				`<div id="report_main">`+
				`<div id="report_det">`+
				`<div>`+
				`<span id="report_player_report_dnt">` + prod_report.currentDateTime + ` </span>`+
				`</div>`+

				    `<div>`+
			        	`<span id="report_player_report_name_title"> [ PLAYER: ` + prod_report.name  + ` ] </span> <span id="report_player_report_id_title"> ‍ ‍ ‍[ ID: ` + prod_report.source + ` ] </span>`+
			       `</div>`+
				   
				   `<div>`+
				        `<span id="report_player_report_id_title">  ‍  ‍  </span>`+
				   `</div>`+

					`<div>`+
				        `<span id="report_player_report_reason">[` +  prod_report.reason + `] </span>`+
					`</div>`+

					`<div>`+
					    `<span id="report_player_report_description">` + prod_report.description + ` </span>`+
					`</div>`+

					`<div>`+
					    `<span id="report_player_report_id_title">  ‍  ‍  </span>`+
					`</div>`+

					`<div id="report_teleport" source=`+prod_report.source+`>`+
						`TELEPORT`+
					`</div>`+


				   `<div id="report_state" reportId =`+event.data.reports_id + `>`+
				        `SET SOLVED`+
			       `</div>`+

				`</div>`+

				`</div>`+
			`</div>`
			);

		}

	});

	var buttonPressed;

    $('.submit').click(function() {
		buttonPressed = $(this).attr('name')

		if (buttonPressed === "cancel"){
			
			$.post("http://tp-reports/closeNUI", JSON.stringify({}));

		}else if (buttonPressed === "create") {
		
			var descriptionLength = $("#description").val().length;

			$.post('http://tp-reports/submitReport', JSON.stringify({
				description: $("#description").val(),
				reason: $("#reason").val(),
				descriptionLength: descriptionLength,
			}));
		}
    })

	$("#report").on("click", "#report_teleport", function() {
        var $button = $(this);
        var $source = $button.attr('source')


		$.post('http://tp-reports/teleportTo', JSON.stringify({
			source : $source,
		}))
		return
	});

	$("#report").on("click", "#report_state", function() {
        var $button = $(this);
        var $reportId = $button.attr('reportId')
		
		$.post('http://tp-reports/changeStatus', JSON.stringify({
			reportId : $reportId
		}))
		return
	});
});

$("body").on("keyup", function (key) {
    // use e.which
    if (key.which == 27){
		closeInventory();
    }
});

