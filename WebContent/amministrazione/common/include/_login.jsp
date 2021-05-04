<%	Utente operatore = (Utente)session.getAttribute("user");%>
<%@include file="/common/include/_login_var.jsp" %>
<%	if (!utenteLoggato){%>
		<jsp:forward page="/auth/login.htm">
			<jsp:param name="pagefwd" value="/auth/redirect.htm"/>
		</jsp:forward>
<%	}%>
<%@include file="/common/include/_login_load.jsp" %>
<%	if (!operatoreAmministrazione){
		response.sendRedirect("/auth/redirect.htm");
	}
	
	boolean visualMenuAdminSx=operatoreAmministrazione;
%>