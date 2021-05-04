<%@page import="it.cise.db.jdbc.*" %>

<%	//it.cise.db.jdbc.DBConnectPool connPostgres2=(it.cise.db.jdbc.DBConnectPool)application.getAttribute(it.cise.db.database.CdCRomagnaPostgres.SESSION_PARAM_NAME);
	it.cise.db.jdbc.DBConnectPool connPostgres=(it.cise.db.jdbc.DBConnectPool)application.getAttribute("connPostgres");
	if (connPostgres==null){
		boolean developmentMode = System.getProperty("cise.devMode")!=null && System.getProperty("cise.devMode").equals("yes");
		String database = (developmentMode ? "dbportal_cdc_test" : "dbportal_cdc");
		
		connPostgres=new it.cise.db.jdbc.DBConnectPool(new it.cise.db.database.PostgreSQLDatabase(database),new it.cise.db.user.Postgres(), 5, 15, 1);
		application.setAttribute("connPostgres",connPostgres);
		Portale.setPool(connPostgres);
		//connPostgres.checkStatus();
	}%>

