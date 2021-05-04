<%@page import="it.cise.db.jdbc.*" %>

<%	it.cise.db.jdbc.DBPoolManager poolmanNewCRM=(it.cise.db.jdbc.DBPoolManager)application.getAttribute("poolmanagerNew");
	if (poolmanNewCRM==null){
		poolmanNewCRM=it.cise.db.jdbc.DBPoolManager.getInstance();
		application.setAttribute("poolmanagerNew",poolmanNewCRM);
	}
	it.cise.db.jdbc.DBConnectPool connCRM=poolmanNewCRM.getPool("it.cise.db.database.SugarCRM", "it.cise.db.user.RootSugarCRM");
	//connCRM.checkStatus();%>
