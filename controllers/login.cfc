component accessors=true {


	property userService;
	property framework;


	function before( rc ) localmode="modern" {
		param name="rc.email" type="string" default="";
		param name="rc.password" type="string" default="";
		param name="rc.rememberme" type="string" default="";
		// if ( structKeyExists( session, "user" ) && framework.getItem() != "logout" ) {
		// 	framework.redirect( "main" );
		// }
	}


	function default( rc ) localmode="modern" {}


	function login( rc ) localmode="modern" {
		cFeedback = "";
		sFeedback = {
			type = "",
			lines = []
		}
		if ( ! len(rc.email) ) {
			arrayAppend( sFeedback.lines, "Missing Email" );
		}
		if ( ! len(rc.password) ) {
			arrayAppend( sFeedback.lines, "Missing Password" );
		}

		if ( arrayLen(sFeedback.lines) ) {
			sFeedback.type = "warning";
			module template="/customtags/feedback.cfm" data="#sFeedback#" returnVariable="cFeedback";
			content reset=true;
			framework.renderData( "text", cFeedback );
			return;
		}
		
		// look up the user's record by the email address
		var user = variables.userService.getByEmail( rc.email );
		// if that's a real user, verify their password is also correct
		var userValid = ! isNull(user) ? variables.userService.validatePassword( user, rc.password ) : true;
		// on invalid credentials, redisplay the login form
		if ( userValid ) {

			session.auth.isLoggedIn = true;
			session.auth.fullname = user.getFirstName() & " " & user.getLastName();
			session.auth.ID = user.getID();
			//session.auth.user = user;

			// set session variables from valid user
			// session["user"] = {
			// 	"name" = user.getFirstName() & " " & user.getLastName(),
			// 	ID = user.getID()
			// }

			if ( rc.rememberMe == "1" ) {
				var strRememberMe = (
					CreateUUID() & ":" &
					user.getID() & ":" &
					user.getToken() & ":" &
					CreateUUID()
					);
				strRememberMe = Encrypt(
					strRememberMe,
					application.EncryptionKey,
					"cfmx_compat",
					"hex"
					);
				cookie name="rememberToken" value=strRememberMe expires="never";
			}

			content reset=true;
			framework.renderData(
				"json",
				{
					"redirect" : framework.buildURL(
						action="main"
					)
				}
			);
		 
		} else {
			sFeedback = {
				type = "danger",
				lines = ["Invalid Email or Password"]
			};
			module template="/customtags/feedback.cfm" data="#sFeedback#" returnVariable="cFeedback";
			content reset=true;
			framework.renderData( "text", cFeedback );
			return;
		}
	}

	function logout( rc ) localmode="modern" {
		session.auth.isLoggedIn = false;
		session.auth.fullname = "Guest";
		//structDelete( session.auth, "user" );
		cookie
			name="rememberToken"
			value=""
			expires="now";
		session.feedback = {
			lines = ["You have safely logged out"],
			type = "success"
		};
		framework.redirect( "login" );
	}

}