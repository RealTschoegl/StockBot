$( document ).ready(function() {
	$("#results_gif").hide();
	$(".smallSuccess").hide();
	$(".smallFail").hide();
	$('#results_email').click(function() {
		$("#results_gif").show();
		$("#results_email").toggleClass("pure-button-disabled");
		$(".smallSuccess").hide();
	});
	$("form#quoteSend").bind('ajax:complete', function() {
		document.getElementsByName("mailer_email")[0].value = '';
		$("#results_gif").hide();
		$("#results_email").removeClass("pure-button-disabled");
	});
	$("form").bind('ajax:success', function() {
		$(".smallSuccess").show();
	});
	$("form").bind('ajax:error', function() {
		$(".smallFail").show();
	});
});

