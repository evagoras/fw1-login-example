<cfscript>
	request.layout = false;
</cfscript>

<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>FW/1 Custom Security Login</title>

	<!-- Bootstrap -->
	<link href="/assets/css/bootstrap.min.css" rel="stylesheet">

	<!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
	<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
	<!--[if lt IE 9]>
	<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
	<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
	<![endif]-->
	<style>
	html {
	overflow-y: scroll;
	}
	.-railo-dump .label {
		display: table-cell;
		font-size: 100%;
		font-weight: normal;
		color: #000;
	}
	body { padding-top: 70px; }
	</style>
</head>
<body>
	<div class="row">
		<div class="col-md-4"></div>
		<div class="col-md-4">
			<cfoutput>#body#</cfoutput>
		</div>
		<div class="col-md-4"></div>
	</div>

	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	<script src="/assets/js/jquery-2.1.3.min.js"></script>
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	<script src="/assets/js/bootstrap.min.js"></script>
	<script src="/assets/js/custom/FormHandler.js"></script>

	<script>
	$(function() {

		FormHandler.Init();

		$("input[name=email]").focus();

		$( 'body' ).on( 'click', '#btnSubmit', function(event) {
			event.preventDefault();
			$(this).addClass('disabled');
			var postData = $("#frmLogin").serialize();
			FormHandler.AjaxCall( '<cfoutput>#buildURL("login.login")#</cfoutput>', postData );
			$(this).removeClass('disabled');
		});

	});
	</script>
</body>
</html>