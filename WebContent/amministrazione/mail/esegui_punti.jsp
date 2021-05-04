<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@page 
	import="org.apache.commons.fileupload.FileItem" 
	import="java.io.File" 
%>
<%@include file="/amministrazione/_load_pagina.jsp" %>
<%@include file="_load_email.jsp" %>
<%	EmailPunto punto = null;
	Long id_email_punto = null;

	try{
		id_email_punto = Long.parseLong(requestMP.getParameter("id_email_punto"));
		punto = new EmailPunto(email);
		punto.initialize(connPostgres);
		punto.id_email_punto = id_email_punto;
		punto.load();
	}catch(Exception e){
		punto = new EmailPunto(email);
		punto.initialize(connPostgres);
	}
	
	if (email==null || operazione.equals("") || punto==null){
		response.sendRedirect(HOME_ADMIN);
	}else{
		
		CdCURLWrapper paramterWrapper=new CdCURLWrapper(urlwrapper);
		paramterWrapper.removeParameterTree(rq_operazione+"_");

		if (operazione.equals("salva")){
			// op=salva
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
					//new:
					String oldValue=(punto.getField(par).getValue()==null ? "" : punto.getField(par).getValue().toString());
					String newValue=paramterWrapper.getParameter(par).get(0);
					if (!oldValue.equals(newValue)){
						if (newValue.equals(""))
							newValue = null;
						
						punto.setField(par, newValue);
					}
					//old: punto.setField(par, paramterWrapper.getParameter(par).get(0));
				}catch(NoSuchFieldException nsfe){}
			punto.insertOrUpdate(operatore);
			
		}else if (operazione.equals("delete")){
			punto.delete(operatore);
		}else{
			response.sendRedirect(HOME_ADMIN);
		}
		
		backwrapper.addParameter(rq_documento, pagina.getId().toString());
		backwrapper.addParameter(rq_email + "_tab", "Punti");
		response.sendRedirect(backwrapper.getPercorsoWeb(false));
	}%>