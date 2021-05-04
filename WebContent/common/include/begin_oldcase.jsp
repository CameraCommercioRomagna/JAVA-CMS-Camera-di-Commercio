<%@page buffer="512kb" autoFlush="false" %>
<%@page 
	language="java"
	import="java.util.*"
	import="java.net.URL"
	import="it.cise.sql.*" 
	import="it.cise.util.http.*" 
	import="it.cise.structures.field.*"
	import="it.cise.structures.preview.*"
	import="it.cise.db.SQLTransactionManager" 
	import="it.cise.portale.cdc.*"
	import="it.cise.portale.cdc.auth.*"
	import="it.cise.portale.cdc.documenti.*" 
	import="it.cise.portale.cdc.documenti.eventi.*" 
	import="it.cise.portale.cdc.documenti.standard.*"
	import="it.cise.portale.cdc.documenti.download.*" 
	import="it.cise.portale.cdc.documenti.referenza.*" 
	import="it.cise.portale.cdc.documenti.pubblicazioni.*" 
	import="it.cise.portale.cdc.newsletters.*" 
	import="it.cise.portale.cdc.searchengine.*"
	import="it.cise.portale.statistica.congiuntura.*"
	import="it.cise.portale.cdc.appuntamenti.*"
	import="it.cise.mailing.*"
	import="cise.utils.*"
%>

<%@include file="/common/jsp/connect_postgres.jsp"%>
<%@include file="/common/jsp/connect_crm.jsp"%>
<%@include file="/common/jsp/extractinitchars.jsp"%>
<%@include file="/common/jsp/nulltoemptystring.jsp"%>
<%@include file="/common/jsp/replacehtml.jsp" %>

<%@include file="/common/include/_project_var.jsp" %>
<%	isArchiveMode = true;%>
<%@include file="/common/include/_login.jsp" %>
