component accessors=true {

	function init() {
		return this;
	}

	function delete( string id ) {
		LOCAL.oUser = entityLoadByPK( "User", ARGUMENTS.id );
		entityDelete( LOCAL.oUser );
	}

	function get( string id ) {
		if ( len(ARGUMENTS.id) ) {
			return entityLoadByPK( "User", ARGUMENTS.id );  
		} else {
			return entityNew("User");
		}
	}

	function getByCookie( string id, string token ) {
		if ( len(ARGUMENTS.id) && len(ARGUMENTS.token) ) {
			return entityLoad( "User", {id=ARGUMENTS.id, token=ARGUMENTS.token}, true );  
		} else {
			return entityNew("User");
		}
	}

	function getByEmail( string email ) {
		var user = entityLoad( "User", {email=ARGUMENTS.email}, true );
		if ( isNull(user) ) {
			var user = entityNew( "User" );
		}
		return user;
	}

	function list() {
		return entityLoad( "User", {}, "ID DESC" );
	}

	function validate( any user, string firstName = "", string lastName = "", string email = "", string password = "" ) {
		var aErrors = [ ];
		var userByEmail = getByEmail( ARGUMENTS.email );
		//var department = variables.departmentService.get( departmentId );
		//var role = variables.roleService.get( roleId );

		// validate first and last name
		if ( ! len( user.getFirstName() ) && ! len( firstName ) ) {
			arrayAppend( aErrors, "Please enter the user's First Name" );
		}
		if ( ! len( user.getLastName() ) && ! len( lastName ) ) {
			arrayAppend( aErrors, "Please enter the user's Last Name" );
		}
		// validate email address
		if ( ! len( user.getEmail() ) && ! len( email ) ) {
			arrayAppend( aErrors, "Please enter the user's Email address" );
		} else if ( len( email ) && ! isEmail( email ) ) {
			arrayAppend( aErrors, "Please enter a valid Email address" );
		} else if ( len(ARGUMENTS.email) && ! isNull(userByEmail.getID()) ) {
			if( compareNoCase( userByEmail.getID(), ARGUMENTS.user.getID() ) ) {
				arrayAppend( aErrors, "A user already exists with this Email address, please enter a new address" );
			}
		}
		// validate password for new or existing user
		if ( ! len( user.getID() ) && ! len( password ) ) {
			arrayAppend( aErrors, "Please enter a password for the user" )
		} else if ( len( password ) ) {
			var aPasswordErrors = checkPassword( user = user, newPassword = password, retypePassword = password );
			arrayAppend(aErrors, aPasswordErrors, true);
		}
		// validate department ID
		// if ( !len( departmentId ) || !isNumeric( departmentId ) || !department.getId() ) {
		//     arrayAppend( aErrors, "Please select a department" );
		// }
		// validate role ID
		// if ( !len( roleId ) || !isNumeric( roleId ) || !role.getId() ) {
		//     arrayAppend( aErrors, "Please select a role" );
		// }

		return aErrors;
	}

	function save( any user ) {
		entitySave( ARGUMENTS.user );
	}


	// function saveSettings(numeric userID, struct data) {
	// 	var oSetting = "";
	// 	var field = "";
	// 	var oUser = entityLoadByPK("User", arguments.userID);
	// 	loop collection=arguments.data item="field" {
	// 		if( len(arguments.data[field]) ) {
	// 			oSetting = entityLoad("BeamUserSetting", {userID=arguments.userID, name=field}, true);
	// 			oSetting = isNull(oSetting) ? entityNew("BeamUserSetting") : oSetting;
	// 			oSetting.setUser( oUser );
	// 			oSetting.setName( field );
	// 			oSetting.setValue( arguments.data[field] );
	// 			entitySave(oSetting);
	// 		}
	// 	}
	// }


	// public any function getSettings(numeric userID, string returnType="objects") {
	// 	var aoUserSettings = entityLoad("BeamUserSetting", {userID=arguments.userID});
	// 	switch( arguments.returnType ) {
	// 		case "objects":
	// 			return aoUserSettings;
	// 			break;
	// 		case "struct":
	// 			var sSettings = {};
	// 			if( arrayLen(aoUserSettings) ) {
	// 				loop array=aoUserSettings index="local.oSetting" {
	// 					sSettings[ local.oSetting.getName() ] = local.oSetting.getValue();
	// 				}
	// 			}
	// 			return sSettings;
	// 			break;
	// 		default:
	// 			return aoUserSettings;
	// 			break;
	// 	}
	// }


	// public string function getSetting(numeric userID, string name) {
	// 	var oUserSetting = entityLoad("BeamUserSetting", {userID=arguments.userID, name=arguments.name}, true);
	// 	return oUserSetting.getValue();
	// }


	// public struct function initSettings() {
	// 	return {
	// 		"theme" = "default"
	// 	};
	// }


/*
security functions were adapted from Jason Dean's security series
http://www.12robots.com/index.cfm/2008/5/13/A-Simple-Password-Strength-Function-Security-Series-4.1
http://www.12robots.com/index.cfm/2008/5/29/Salting-and-Hashing-Code-Example--Security-Series-44
http://www.12robots.com/index.cfm/2008/6/2/User-Login-with-Salted-and-Hashed-passwords--Security-Series-45
*/

	function hashPassword( string password ) {
		var returnVar = { };
		returnVar.salt = createUUID();
		returnVar.hash = hash( password & returnVar.salt, "SHA-512" );
		return returnVar;
	}

	function validatePassword( any user, string password ) {
		// catenate password and user salt to generate hash
		var inputHash = hash( trim( password ) & trim( user.getPasswordSalt() ), "SHA-512" );
		// password is valid if hash matches existing user hash
		return !compare( inputHash, user.getPasswordHash() );
	}

	function checkPassword( any user, string currentPassword = "",
							string newPassword = "", string retypePassword = "" ) {
		// Initialize return variable
		var aErrors = arrayNew(1);
		var inputHash = '';
		var count = 0;

		// if the password fields to not have values, add an error and return
		if (not len(arguments.newPassword) or not len(arguments.retypePassword)) {
			arrayAppend(aErrors, "Please fill out all form fields");
			return aErrors;
		}

		if (len(arguments.currentPassword) and isObject(user)) {
			// If the user is changing their password, compare the current password to the saved hash
			inputHash = hash(trim(arguments.currentPassword) & trim(user.getPasswordSalt()), 'SHA-512');

			/* Compare the inputHash with the hash in the user object. if they do not match,
				then the correct password was not passed in */
			if (not compare(inputHash, user.getPasswordHash()) IS 0) {
				arrayAppend(aErrors, "Your current password does not match the current password entered");
				// Return now, there is no point testing further
				return aErrors;
			}

			// Compare the current password to the new password, if they match add an error
			if (compare(arguments.currentPassword, arguments.newPassword) IS 0)
				arrayAppend(aErrors, "The new password can not match your current password");
		}

		// Check the password rules
		// *** to change the strength of the password required, uncomment as needed

		// Check to see if the two passwords match
		if (not compare(arguments.newPassword, arguments.retypePassword) IS 0) {
			arrayAppend(aErrors, "The new passwords you entered do not match");
			// Return now, there is no point testing further
			return aErrors;
		}

		// If the password is more than X and less than Y, add an error.
		if (len(arguments.newPassword) LT 8)// OR Len(arguments.newPassword) GT 25
			arrayAppend(aErrors, "Your password must be at least 8 characters long");// between 8 and 25

		// Check for atleast 1 uppercase or lowercase letter
		/* if (NOT REFind('[A-Z]+', arguments.newPassword) AND NOT REFind('[a-z]+', arguments.newPassword))
			ArrayAppend(aErrors, "Your password must contain at least 1 letter"); */

		// check for at least 1 letter
		if (reFind('[A-Z]+',arguments.newPassword))
			count++;
		if (reFind('[a-z]+', arguments.newPassword))
			count++;
		if (not count)
			arrayAppend(aErrors, "Your password must contain at least 1 letter");

		// Check for at least 1 uppercase letter
		/*if (NOT REFind('[A-Z]+', arguments.newPassword))
			ArrayAppend(aErrors, "Your password must contain at least 1 uppercase letter");*/

		// Check for at least 1 lowercase letter
		/*if (NOT REFind('[a-z]+', arguments.newPassword))
			ArrayAppend(aErrors, "Your password must contain at least 1 lowercase letter");*/

		// check for at least 1 number or special character
		count = 0;
		if (reFind('[1-9]+', arguments.newPassword))
			count++;
		if (reFind("[;|:|@|!|$|##|%|^|&|*|(|)|_|-|+|=|\'|\\|\||{|}|?|/|,|.]+", arguments.newPassword))
			count++;
		if (not count)
			arrayAppend(aErrors, "Your password must contain at least 1 number or special character");

		// Check for at least 1 numeral
		/*if (NOT REFind('[1-9]+', arguments.newPassword))
			ArrayAppend(aErrors, "Your password must contain at least 1 number");*/

		// Check for one of the predfined special characters, you can add more by seperating each character with a pipe(|)
		/* if (NOT REFind("[;|:|@|!|$|##|%|^|&|*|(|)|_|-|+|=|\'|\\|\||{|}|?|/|,|.]+", arguments.newPassword))
			ArrayAppend(aErrors, "Your password must contain at least 1 special character"); */

		// Check to see if the password contains the username
		if (len(user.getEmail()) and arguments.newPassword CONTAINS user.getEmail())
			arrayAppend(aErrors, "Your password cannot contain your email address");

		// Check to see if password is a date
		if (isDate(arguments.newPassword))
			arrayAppend(aErrors, "Your password cannot be a date");

		// Make sure password contains no spaces
		if (arguments.newPassword CONTAINS " ")
			arrayAppend(aErrors, "Your password cannot contain spaces");

		return aErrors;
	}

	/* cflib.org */

	/**
* Tests passed value to see if it is a valid e-mail address (supports subdomain nesting and new top-level domains).
* Update by David Kearns to support '
* SBrown@xacting.com pointing out regex still wasn't accepting ' correctly.
* Should support + gmail style addresses now.
* More TLDs
* Version 4 by P Farrel, supports limits on u/h
* Added mobi
* v6 more tlds
*
* @param str      The string to check. (Required)
* @return Returns a boolean.
* @author Jeff Guillaume (SBrown@xacting.comjeff@kazoomis.com)
* @version 7, May 8, 2009
*/
	function isEmail(str) {
		return REFindNoCase("^['_a-z0-9-\+]+(\.['_a-z0-9-\+]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|asia|biz|cat|coop|info|museum|name|jobs|post|pro|tel|travel|mobi))$",str) &&
			len( listFirst(str, "@") ) <= 64 &&
			len( listRest(str, "@") ) <= 255;
	}

}