<%	Utente operatore = (Utente)session.getAttribute("user");
	UtenteNl operatore_nl=(UtenteNl)session.getAttribute("UtenteNl");%>
<%@include file="/common/include/_login_var.jsp" %>
<%	if (utenteLoggato){
		%><%@include file="/common/include/_login_load.jsp" %><%
	}%>