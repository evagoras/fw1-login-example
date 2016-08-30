<cfoutput>
<div class="well">
	<form class="form-horizontal" name="login" id="frmLogin" action="#buildURL('login.login')#" method="post">
		<h3 class="form-title">Log In to your account</h3>
		<div id="feedback">
			<cfif structKeyExists( session, "feedback" )>
				<cfmodule template="/customtags/feedback.cfm" data="#session.feedback#" />
				<cfset structDelete(session,"feedback") />
			</cfif>
		</div>
		<div class="form-group">
			<label for="inputEmail" class="col-sm-3 control-label">Email</label>
			<div class="col-sm-9">
				<input type="email" class="form-control" id="inputEmail" placeholder="Email" name="email" value="#rc.email#">
			</div>
		</div>
		<div class="form-group">
			<label for="inputPassword" class="col-sm-3 control-label">Password</label>
			<div class="col-sm-9">
				<input type="password" id="inputPassword" class="form-control" placeholder="Password" name="password">
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-offset-3 col-sm-9">
				<div class="checkbox">
					<label>
						<input type="checkbox" name="rememberme" value="1"/> Remember me 
					</label>
				</div>
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-offset-3 col-sm-9">
				<input type="submit" class="btn btn-default" id="btnSubmit">
			</div>
		</div>
	</form>
</div>
</cfoutput>