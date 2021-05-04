<%@include file="/amministrazione/common/include/begin.jsp" %>

<%	boolean updating_mode = request.getParameter("update")!=null && request.getParameter("update").equals("1");
	String[] query = request.getParameterValues("query[]");
	
	if(updating_mode && query!=null){
		SQLTransactionManager sqlMan = new SQLTransactionManager(this, connPostgres);
		for (int i=0; i<query.length; i++){
			sqlMan.executeCommandQuery(operatore, query[i]);
			//Logger.write("*** servlet query:" + query[i]);
		}
	}%>