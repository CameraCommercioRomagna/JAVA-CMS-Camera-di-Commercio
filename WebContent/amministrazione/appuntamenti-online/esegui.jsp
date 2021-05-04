<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@include file="./_header_auth.jsp" %>
<%	if (amministratoreAppuntamenti)
		try{
			String operation = (request.getParameter("op")!=null ? request.getParameter("op") : "");
			Logger.write(" ----> " + operation);
			
			if (operation.equals("sposta")){
				Appuntamento a=new Appuntamento(connPostgres, new Long(request.getParameter("id_appuntamento")));
				a.inizio = DateUtils.stringToDate(request.getParameter("inizio"), "dd/MM/yyyy H:m");
				a.fine = DateUtils.stringToDate(request.getParameter("fine"), "dd/MM/yyyy H:m");
				a.update(operatore);
			
			}else if (operation.equals("elimina")){
				try{
					Appuntamento a=new Appuntamento(connPostgres, new Long(request.getParameter("id_appuntamento")));
					a.cancella(operatore);
				}catch(Exception eElimina){
					Logger.write("Eccomi . " + request.getParameter("id_annotazione"));
					Annotazione a = new Annotazione(connPostgres, new Long(request.getParameter("id_annotazione")));
					a.delete();
				}
			}
			
		}catch(Exception e){
			out.print("ERRORE");
		}
	else
		response.sendRedirect(HOME_ADMIN);%>