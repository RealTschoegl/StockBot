$( document ).ready(function() {
	$("#results_gif").hide();
	$('#results_email').click(function() {
		$("#results_gif").show();
	});
	$("form").bind('ajax:complete', function() {
		document.getElementsByName("mailer_email")[0].value = '';
		$("#results_gif").hide();
	});
});

