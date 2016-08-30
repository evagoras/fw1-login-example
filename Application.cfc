component extends=framework.one {

	THIS.sessionManagement = true;
	THIS.sessionTimeout = createTimeSpan(0,2,0,0); // 2 hours
	THIS.datasource = "security";

	THIS.ormEnabled = true;
	THIS.ormsettings = {
	    datasource = "security",
	    cfclocation = "/model/beans",
	    namingStrategy = "model.dbNamingStrategy",
	    logsql = false,
	    dialect = "PostgreSQL",
	    flushAtRequestEnd = false,
	    dbCreate = "none",
	    useDBForMapping = false
    }

	// FW/1 - configuration:
	variables.framework = {
		action = 'action',
		usingSubsystems = false,
		defaultSubsystem = 'home',
		defaultSection = 'main',
		defaultItem = 'default',
		subsystemDelimiter = ':',
		siteWideLayoutSubsystem = 'common',
		subsystems = { },
		home = 'main.default', // defaultSection & '.' & defaultItem
		// or: defaultSubsystem & subsystemDelimiter & defaultSection & '.' & defaultItem
		error = 'main.error', // defaultSection & '.error'
		// or: defaultSubsystem & subsystemDelimiter & defaultSection & '.error'
		reload = 'reload',
		password = 'true',
		reloadApplicationOnEveryRequest = true,
		generateSES = false,
		SESOmitIndex = false,
		// base = omitted so that the framework calculates a sensible default
		baseURL = 'useCgiScriptName',
		// cfcbase = omitted so that the framework calculates a sensible default
		unhandledExtensions = 'cfc',
		unhandledPaths = '/flex2gateway',
		unhandledErrorCaught = false,
		preserveKeyURLKey = 'fw1pk',
		maxNumContextsPreserved = 1,
		cacheFileExists = false,
		applicationKey = 'framework.one',
		trace = false,
		routes = [],
		// resourceRouteTemplates - see routes documentation
		noLowerCase = false,
		diEngine = "di1",
		diComponent = "framework.ioc",
		diLocations = "model,controllers",
		diConfig = { }
	};

	function setupApplication() {
		APPLICATION.EncryptionKey = "S3xy8run3tt3s";
	}

	function setupSession() {
		controller( "security.session" );
	}

	function setupRequest() {
		ormReload();
		controller( "security.authorize" );
	}

}