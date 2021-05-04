<%	boolean documenti_filtrati = false;
	Boolean validati=null, pubblicati=null, scaduti=null;
	Visibilita visibilita=null;
	Priorita priorita=null;
	TipoDocumento tipo_d=null;
	String titolo_dweb=null;
	String user_dweb=null;%>
<%	if (!inserimento){
		// Carica eventuali filtri passati da request
		if (request.getParameter("titolo_dweb")!=null && !request.getParameter("titolo_dweb").equals("")){
			titolo_dweb=request.getParameter("titolo_dweb");
			documenti_filtrati = true;
		}	
		if (request.getParameter("user_dweb")!=null && !request.getParameter("user_dweb").equals("")){
			user_dweb=request.getParameter("user_dweb");
			documenti_filtrati = true;
		}	
		if (request.getParameter("validati")!=null && !request.getParameter("validati").equals("")){
			validati=new Boolean(request.getParameter("validati"));
			documenti_filtrati = true;
		}	
		if (request.getParameter("pubblicati")!=null && !request.getParameter("pubblicati").equals("")){
			pubblicati=new Boolean(request.getParameter("pubblicati"));
			documenti_filtrati = true;
		}	
		if (request.getParameter("scaduti")!=null && !request.getParameter("scaduti").equals("")){
			scaduti=new Boolean(request.getParameter("scaduti"));
			documenti_filtrati = true;
		}	
		
		if (request.getParameter("visibilita")!=null && !request.getParameter("visibilita").equals("")){
			visibilita=Visibilita.getVisibilita(Long.parseLong(request.getParameter("visibilita")));
			documenti_filtrati = true;
		}
		if (request.getParameter("priorita")!=null && !request.getParameter("priorita").equals("")){
			priorita=Priorita.getPriorita(Long.parseLong(request.getParameter("priorita")));
			documenti_filtrati = true;
		}
		if (request.getParameter("tipo_d")!=null && !request.getParameter("tipo_d").equals("")){
			tipo_d=TipoDocumento.fromID(Long.parseLong(request.getParameter("tipo_d")));
			documenti_filtrati = true;
		}
	}%>