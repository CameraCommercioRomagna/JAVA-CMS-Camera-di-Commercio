<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@page 
	import="org.apache.commons.fileupload.FileItem" 
	import="java.io.File" 
%>
<%@include file="_load_pagina.jsp" %>
<%@include file="_load_ente.jsp" %>

<%	
	if (ente==null || operazione.equals("")){
		response.sendRedirect(HOME_ADMIN);
	}else{
		
		CdCURLWrapper paramterWrapper=new CdCURLWrapper(urlwrapper);
		//paramterWrapper.removeParameterTree(rq_operazione+"_");

		if (inserimento_ente || modifica_ente){
			
			try{
				MultipartHttpServletRequest requestMPSave = (MultipartHttpServletRequest)requestMP;
				
				String path = ente.getUploadDirectory();
				Map<String, String> fieldToFile = requestMPSave.saveFiles(path);
				for (String field: fieldToFile.keySet())	
					paramterWrapper.addParameter(field, fieldToFile.get(field));
			}catch(Exception e){
				// Se la request non è multipart (fallisce il cast) -> tutta la gestione file viene saltata
			}
			
			Set<String> parameters = paramterWrapper.getParameters().keySet();
			parameters.remove(rq_ente);
			
			for (String par: parameters)
				try{
					Logger.write(" ** Test** Setting " + par + " = " + paramterWrapper.getParameter(par).get(0));
					ente.setField(par, paramterWrapper.getParameter(par).get(0));
				}catch(NoSuchFieldException nsfe){
					Logger.write(" ** Test** Errore");
				}
			
			ente.insertOrUpdate();
	
		}else{
			response.sendRedirect(HOME_ADMIN);
		}
		
		response.sendRedirect("/amministrazione/enti.htm?" + rq_ente + "=" + ente.id_ente + (pagina!=null? "&" + rq_documento + "=" + pagina.getId() : ""));
	}%>