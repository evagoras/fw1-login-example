component accessors=true {


	property userService;

	property framework;


	function session(rc) localmode="modern" {
		session.auth = {};
		session.auth.isLoggedIn = false;
		session.auth.fullname = 'Guest';

		if( structKeyExists(cookie, "rememberToken") ) {

			<!--- Decrypt out remember me cookie. --->
			decryptedCookie = Decrypt(
				cookie.rememberToken,
				application.EncryptionKey,
				"cfmx_compat",
				"hex"
				);

			<!---
				For security purposes, we tried to obfuscate the
				way the ID was stored. We wrapped it in the middle
				of list. Extract it from the list.
			--->
			iUserID = int(
				listGetAt(
					decryptedCookie,
					2,
					":"
				)
			);

			cUserToken = listGetAt(
				decryptedCookie,
				3,
				":"
			);

			<!---
				Check to make sure this value is numeric,
				otherwise, it was not a valid value.
			--->
			if ( isNumeric(iUserID) && len(cUserToken) ) {
				user = variables.userService.getByCookie( iUserID, cUserToken );
				if ( ! isNull(user) ) {
					session.auth.isLoggedIn = true;
					session.auth.fullname = user.getFirstName() & " " & user.getLastName();
					session.auth.ID = iUserID;
					//session.auth.user = user;
		
					// session["user"] = {
					// 	ID = iUserID,
					// 	"name" = oUser.getFirstName() & " " & oUser.getLastName()
					// }
				}

			}

		}


		
	}

	function authorize( rc ) localmode="modern" {
		// check to make sure the user is logged on
		if ( ! ( structKeyExists( session, "auth" ) && session.auth.isLoggedIn ) && 
		//if ( ! structKeyExists( session, "user" ) && 
			 !listfindnocase( 'login', framework.getSection() ) && 
			 !listfindnocase( 'main.error', framework.getFullyQualifiedAction() )
		) {
			framework.redirect('login');
		}
	}

}