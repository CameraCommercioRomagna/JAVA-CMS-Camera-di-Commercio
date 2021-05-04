<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@page 
	import="org.apache.commons.fileupload.FileItem" 
	import="java.io.File" 
%>
<%@include file="_load_pagina.jsp" %>
<%	PuntoProgramma punto = null;
	Long id_punto = null;

	try{
		id_punto = Long.parseLong(requestMP.getParameter("id_punto"));
		punto = new PuntoProgramma((EdizioneInterna)pagina);
		punto.initialize(connPostgres);
		punto.id_punto = id_punto;
		punto.load();
	}catch(Exception e){
		punto = new PuntoProgramma((EdizioneInterna)pagina);
		punto.initialize(connPostgres);
	}
	
	if (pagina==null || operazione.equals("") || punto==null){
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
			
			backwrapper.addParameter(rq_documento + "_tab", "Programma");
			
		}else if (operazione.equals("delete")){
			punto.delete(operatore);
		}else{
			response.sendRedirect(HOME_ADMIN);
		}
		
		backwrapper.addParameter(rq_documento + "_tab", "Programma");
		response.sendRedirect(backwrapper.getPercorsoWeb(false));
	}%>