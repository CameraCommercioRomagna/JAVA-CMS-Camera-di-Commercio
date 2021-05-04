<%	PaginaWeb<?> pagina=null;
	PaginaWeb<?> pagina_padre=null;
	
	boolean preview=false;
	boolean previewConfermaContenuti=false;
	
	try{
		/* 04/03/2019: Versione precedete a questa data, gestiva il caricamento solo da ID (ora anche da campo alias)*/
		pagina = (PaginaWeb<?>)urlwrapper.getDocumento();
		if (pagina==null){
			// Prova a determinare il documento indirettamente dai parametri (ad esempio per tutte le pagine di iscrizione* evento)
			Long id=Long.parseLong(requestMP.getParameter(rq_documento));
			pagina = (PaginaWeb<?>)DocumentFactory.load(connPostgres, id);
		}
			
		pagina_padre=pagina.getPadre();
		//Logger.write("pagina " + pagina);
		//Logger.write("pagina_padre " + pagina_padre);
		
		preview=requestMP.getParameter(AbstractDocumentoWeb.PARAMETER_PREVIEW)!=null && requestMP.getParameter(AbstractDocumentoWeb.PARAMETER_PREVIEW).equals(AbstractDocumentoWeb.PARAMETER_PREVIEW_VALUE);
		if (!pagina.accessibile(operatore)){
			Logger.write("Accesso ad una pagina per utente non autorizzato (" + operatore + ")... redirecting to home");
			response.sendRedirect(HOME);
		}else if (preview){
			if (operatore == null){
				urlwrapper.removeParameter(AbstractDocumentoWeb.PARAMETER_PREVIEW);
				Logger.write("Visualizzazione di una pagina in preview senza accesso all'amministrazione... redirecting to: " + urlwrapper.getPercorsoWeb(false));
				response.sendRedirect(urlwrapper.getPercorsoWeb(false));
			}
		}else if (!pagina.pubblico() && !pagina.archiviato()){
			Logger.write("Accesso ad una pagina NON pubblica/archiviata... redirecting to home");
			response.sendRedirect(HOME);
		}else if (pagina.isForward()){
			response.sendRedirect(pagina.getLink());
		}
		
		previewConfermaContenuti=preview && requestMP.getParameter("confermacontenuti")!=null && requestMP.getParameter("confermacontenuti").equals("yes");

	}catch(Exception e){
		//e.printStackTrace();
		response.sendRedirect(HOME);
	}%>