<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@page 
	import="org.apache.commons.fileupload.FileItem" 
	import="java.io.File" 
%>
<%@include file="_load_pagina.jsp" %>
<%	
	if (pagina==null || operazione.equals("")){
		response.sendRedirect(HOME_ADMIN);
	}else{

		CdCURLWrapper paramterWrapper=new CdCURLWrapper(urlwrapper);
		//paramterWrapper.removeParameterTree(rq_operazione+"_");

		if (inserimento || modifica || operazione.equals("valida")){
			
			try{
				MultipartHttpServletRequest requestMPSave = (MultipartHttpServletRequest)requestMP;
				
				String path = pagina.getUploadDirectory();
				Map<String, String> fieldToFile = requestMPSave.saveFiles(path);
				for (String field: fieldToFile.keySet())	
					paramterWrapper.addParameter(field, fieldToFile.get(field));
			}catch(Exception e){
				// Se la request non è multipart (fallisce il cast) -> tutta la gestione file viene saltata
			}
			
			Set<String> parameters = paramterWrapper.getParameters().keySet();
			parameters.remove(rq_documento);
			
			for (String par: parameters)
				try{
					//Logger.write(" ** Test** Setting " + par + " = " + paramterWrapper.getParameter(par).get(0));
					String oldValue=(pagina.getField(par).getValue()==null ? "" : pagina.getField(par).getValue().toString());
					String newValue=paramterWrapper.getParameter(par).get(0);
					if (!oldValue.equals(newValue)){
						if (newValue.equals(""))
							newValue = null;
						
						pagina.setField(par, newValue);
					}
				}catch(NoSuchFieldException nsfe){
					//Logger.write(" ** Test** Errore " + pagina.getFields());
					//nsfe.printStackTrace();
				}
			
			pagina.insertOrUpdate(operatore);
	
			if (operazione.equals("valida")){
				boolean valida=requestMP.getParameter("op_valida")!=null && requestMP.getParameter("op_valida").equals("true");
				pagina.valida(operatore, valida);
			}
			
			String paramterTab=requestMP.getParameter(rq_documento + "_tab");
			if (paramterTab != null)
				backwrapper.addParameter(rq_documento + "_tab",paramterTab);
			
		}else if (operazione.equals("copia")){
			AbstractDocumentoWeb<?> copia = (AbstractDocumentoWeb<?>)pagina.copia(operatore);
			pagina = copia;
			
		}else if (operazione.equals("conferma_aggiornamento")){
			pagina.confermaAggiornamento(operatore);
			backwrapper.addParameter(rq_documento + "_tab", "Aggiornamento contenuti");
			
		}else if (operazione.equals("associa_nl")){
			NumeroNewsLetter nnl = null;
			String associa_nl = requestMP.getParameter(rq_operazione+"_associa_nl");
			try{
				nnl = new NumeroNewsLetter(Long.parseLong(requestMP.getParameter("id_nl_numero")), connPostgres);
				if(associa_nl!=null && associa_nl.equals("true"))
					nnl.associa(operatore, pagina, requestMP.getParameter("nome"));
				else if(associa_nl!=null && associa_nl.equals("false")){
					//Logger.write("**********************************disassocia");
					nnl.disassocia(operatore, pagina);
				}
				
				backwrapper.addParameter(rq_documento + "_tab", "Associa a newsletter");
			}catch(Exception e){
			}	
		}else if (operazione.equals("associa_padre")){
			try{
				PaginaWeb<?> nuovoPadre=(PaginaWeb<?>)DocumentFactory.fromString(connPostgres, requestMP.getParameter(rq_operazione+"_associa_padre_url"));
			/*	Gestione "light": associa solo il padre passato in input */
				pagina.assegnaPadre(operatore, nuovoPadre);
			/*	Gestione completa: controlla che il padre passato in input non sia già tra i padri attuali (lo aggiunge solo se non lo è) e che il documento abbia già un padre principale (lo setta principale solo se non ce l'ha)
				PaginaWeb<?> padrePrincipale = getPadre();
				List<PaginaWeb<?>> padriAttuali = getPadri(false, null, null, null, null, null);
				if (!padriAttuali.contains(nuovoPadre)){
					padriAttuali.add(nuovoPadre);
					if (padrePrincipale == null)
						padrePrincipale = nuovoPadre;
					pagina.assegnaPadri(padriAttuali, padrePrincipale);
				}*/
			}catch(Exception e){
				Logger.write("Impossibile associare un padre a " + pagina + " a causa dell'errore seguente:");
				e.printStackTrace();
				// TODO Passare un parametro di info su errore da visualizzare nella pagina (come modal?)
			}
		}else{
			response.sendRedirect(HOME_ADMIN);
		}
		
		if (inserimento || operazione.equals("copia"))
			backwrapper = new CdCURLWrapper(connPostgres, new URL(currentServer + pagina.getAdminLink()));	// deve reimpostarlo per recuperare l'ID (alla primma inizializzaizone - nel _load_pagina.jsp - era null)
		
		Logger.write("urlwrapper(3): " + urlwrapper);
		Logger.write("backwrapper(3): " + backwrapper);
		response.sendRedirect(backwrapper.getPercorsoWeb(false));
	}%>