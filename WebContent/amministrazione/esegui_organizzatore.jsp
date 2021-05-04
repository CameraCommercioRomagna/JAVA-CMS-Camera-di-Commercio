<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@page 
	import="org.apache.commons.fileupload.FileItem" 
	import="java.io.File" 
%>
<%@include file="_load_pagina.jsp" %>
<%	Organizzatore organizzatore=null;
	Long id_ente = null;

	organizzatore = new Organizzatore((EdizioneInterna)pagina);
	organizzatore.initialize(connPostgres);
	try{
		organizzatore.id_ente = Long.parseLong(requestMP.getParameter("id_ente"));
		organizzatore.load();
	}catch(Exception e){
	}
	
	if (pagina==null || operazione.equals("") || organizzatore==null){
		response.sendRedirect(HOME_ADMIN);
	}else{
		
		CdCURLWrapper paramterWrapper=new CdCURLWrapper(urlwrapper);
		paramterWrapper.removeParameterTree(rq_operazione+"_");

		if (operazione.equals("salva")){
			// op=salva
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
					//new:
					String oldValue="";
					try{
						oldValue=(organizzatore.getField(par).getValue()==null ? "" : organizzatore.getField(par).getValue().toString());
					}catch(it.cise.structures.field.NullValueException nvexc){}
					
					String newValue=paramterWrapper.getParameter(par).get(0);
					if (!oldValue.equals(newValue)){
						if (newValue.equals(""))
							newValue = null;
						
						organizzatore.setField(par, newValue);
					}
					//old: organizzatore.setField(par, paramterWrapper.getParameter(par).get(0));
				}catch(NoSuchFieldException nsfe){}
			organizzatore.insertOrUpdate(operatore);
		
		}else if (operazione.equals("delete")){
			organizzatore.delete(operatore);
		}else{
			response.sendRedirect(HOME_ADMIN);
		}
		
		backwrapper.addParameter(rq_documento + "_tab", "Organizzatori");
		response.sendRedirect(backwrapper.getPercorsoWeb(false));
	}%>