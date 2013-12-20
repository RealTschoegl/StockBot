$( document ).ready(function() {
	$("#results_gif").hide();
	$(".smallSuccess").hide();
	$(".smallFail").hide();
	$('#results_email').click(function() {
		$("#results_gif").show();
		$("#results_email").removeClass("btn btn-info");
		$("#results_email").addClass("btn btn-info btn-large btn-primary disabled");
		$(".smallSuccess").hide();
	});
	$("form#quoteSend").bind('ajax:complete', function() {
		document.getElementsByName("mailer_email")[0].value = '';
		$("#results_gif").hide();
	});
	$("form").bind('ajax:success', function() {
		$(".smallSuccess").show();
	});
	$("form").bind('ajax:error', function() {
		$(".smallFail").show();
	});
});

