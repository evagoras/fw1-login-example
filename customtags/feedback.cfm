<cfparam name="ATTRIBUTES.data" type="struct" default="#{type='',lines=[]}#" />
<cfparam name="ATTRIBUTES.dismissable" type="boolean" default="true" />
<cfparam name="ATTRIBUTES.returnVariable" type="string" default="" />


<cfsavecontent variable="body">
<cfif arrayLen(ATTRIBUTES.data.lines)>
<cfoutput>
	<div class="alert alert-#ATTRIBUTES.data.type# chaos-feedback<cfif ATTRIBUTES.dismissable> alert-dismissable</cfif>">
		<cfif ATTRIBUTES.dismissable>
			<button type="button" class="close" data-dismiss="alert" aria-hidden="true"></button>
		</cfif>
		<strong>
			<cfswitch expression="#ATTRIBUTES.data.type#">
				<cfcase value="danger">
					Error<cfif arrayLen(ATTRIBUTES.data.lines) GT 1>s</cfif>!
				</cfcase>
				<cfcase value="success">
					Success!
				</cfcase>
				<cfcase value="warning">
					Warning!
				</cfcase>
				<cfcase value="info">
					Info!
				</cfcase>
			</cfswitch>
		</strong>
		<br>
		<cfif arrayLen(ATTRIBUTES.data.lines) GT 1>
			<ul>
		</cfif>
		<cfloop array="#ATTRIBUTES.data.lines#" index="LOCAL.line">
			<cfif arrayLen(ATTRIBUTES.data.lines) GT 1>
				<li>
			</cfif>
				#LOCAL.line#
			<cfif arrayLen(ATTRIBUTES.data.lines) GT 1>
				</li>
			</cfif>
		</cfloop>
		<cfif arrayLen(ATTRIBUTES.data.lines) GT 1>
			</ul>
		</cfif>
	</div>
</cfoutput>
</cfif>
</cfsavecontent>

<cfif len(ATTRIBUTES.returnVariable)>
	<cfset CALLER[ ATTRIBUTES.returnVariable ] = body />
<cfelse>
	<cfoutput>#body#</cfoutput>
</cfif>



<cfexit method="exittag" />