<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@page 
	import="org.apache.commons.fileupload.FileItem" 
	import="java.io.File" 
%>
<%@include file="/amministrazione/_load_pagina.jsp" %>
<%@include file="_load_email.jsp" %>
<%	
	if (email==null || operazione.equals("")){
		response.sendRedirect(HOME_ADMIN);
	}else{

		CdCURLWrapper paramterWrapper=new CdCURLWrapper(urlwrapper);
		
		if (inserimento || modifica){
			
			try{
				MultipartHttpServletRequest requestMPSave = (MultipartHttpServletRequest)requestMP;
				
				String path = email.getUploadDirectory();
				Map<String, String> fieldToFile = requestMPSave.saveFiles(path);
				for (String field: fieldToFile.keySet())	
					paramterWrapper.addParameter(field, fieldToFile.get(field));
			}catch(Exception e){
				// Se la request non è multipart (fallisce il cast) -> tutta la gestione file viene saltata
			}
			
			Set<String> parameters = paramterWrapper.getParameters().keySet();
			parameters.remove(rq_email);
			
			for (String par: parameters)
				try{
					//Logger.write(" ** Test** Setting " + par + " = " + paramterWrapper.getParameter(par).get(0));
					String oldValue=(email.getField(par).getValue()==null ? "" : email.getField(par).getValue().toString());
					String newValue=paramterWrapper.getParameter(par).get(0);
					if (!oldValue.equals(newValue)){
						if (newValue.equals(""))
							newValue = null;
						
						email.setField(par, newValue);
					}
				}catch(NoSuchFieldException nsfe){
					//Logger.write(" ** Test** Errore " + email.getFields());
					//nsfe.printStackTrace();
				}
			
			email.insertOrUpdate(operatore);
	
			String paramterTab=requestMP.getParameter(rq_email + "_tab");
			if (paramterTab != null)
				backwrapper.addParameter(rq_email + "_tab",paramterTab);
			
		}else if (operazione.equals("copia")){
			EmailWeb copia = email.copia(operatore);
			email = copia;
		}else{
			response.sendRedirect(HOME_ADMIN);
		}
		
		if (inserimento || operazione.equals("copia"))
			backwrapper = new CdCURLWrapper(connPostgres, new URL(currentServer + email.getLink()));	// deve reimpostarlo per recuperare l'ID (alla primma inizializzaizone - nel _load_email.jsp - era null)
		
		if (pagina != null)
			backwrapper.addParameter(rq_documento,pagina.getId().toString());
		
		Logger.write("urlwrapper(3): " + urlwrapper);
		Logger.write("backwrapper(3): " + backwrapper);
		response.sendRedirect(backwrapper.getPercorsoWeb(false));
	}%>