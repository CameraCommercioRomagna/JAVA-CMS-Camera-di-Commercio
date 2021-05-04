<%@include file="/common/include/begin.jsp" %>

<%	try{
		String orario=request.getParameter("orari");
		
		
		Date inizio = DateUtils.stringToDate(orario, "dd/MM/yyyy HH:mm");
		
		Servizio servizio = Servizio.getServizio(Long.parseLong(request.getParameter("id_servizio")));
		Sede erogatore=Sede.valueOf(request.getParameter("sede"));
		
/*out.print("Inizio=" + inizio + "<br>");
out.print("erogatore=" + erogatore + "<br>");
out.print("servizio=" + servizio + "<br>");
	*/	
		Appuntamento appuntamento=erogatore.opziona(inizio, servizio, null);
		if (appuntamento != null)
			response.sendRedirect("richiedente-pratiche.htm?id_appuntamento="+appuntamento.id_appuntamento);
		else{
			response.sendRedirect("index.htm?id_servizio=" + servizio.getId()+"&sede="+ erogatore.name()+"&data=" + DateUtils.formatDate(inizio, "yyyy-M-d") +"&notDisponibile=yes");
		}
		
	}catch(Exception e){
		response.sendRedirect(HOME);
	}%>
