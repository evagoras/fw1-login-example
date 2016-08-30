var FormHandler = function() {

	var handleForm = function() {

		$('input').keypress(function (e) {
			if (e.which == 13) {
				$(this).closest('form').find('#btnSubmit').trigger('click');
				return false;    //<---- Add this line
			}
		});

	}

	var compress = function(data) {
		data = data.replace(/([^&=]+=)([^&]*)(.*?)&\1([^&]*)/g, "$1$2,$4$3");
		return /([^&=]+=).*?&\1/.test(data) ? Compress(data) : data;
	}


	var ajaxCall = function(url, data) {
		$('html,body').animate({ scrollTop: 0 }, 'fast');
		var loadingHtml = '<div class="alert alert-dismissable alert-info"><img src="/assets/img/loading-spinner-blue.gif"> Processing</div>';
		//$('#feedback').html(loadingHtml);
		//var postData = Compress( $("#frmMain").serialize() );
		$.ajax({
			type: "POST",
			url: url,
			data: data,
			//dataType: "json",
			success: function(data, textStatus) {
				if (data.redirect) {
					// data.redirect contains the string URL to redirect to
					window.location.href = data.redirect;
				}
				else {
					//JSON parse error, this is not json (or JSON isn't in your browser)
					$("#feedback").delay(2000).html(data);
				}
			}
		});
	}

	return {

		//main function to initiate the theme
		Init: function() {
			handleForm();
		},
		Compress: function(data) {
			compress( data ); // handles horizontal menu    
		},
		AjaxCall: function(el, url, data) {
			ajaxCall(el, url, data);
		}
	}

}();