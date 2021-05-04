<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@page 
	import="org.apache.commons.fileupload.FileItem" 
	import="java.io.File" 
%>
<%@include file="_load_pagina.jsp" %>
<%@include file="_load_luogo.jsp" %>

<%	
	if (luogo==null || operazione.equals("")){
		response.sendRedirect(HOME_ADMIN);
	}else{
		
		CdCURLWrapper paramterWrapper=new CdCURLWrapper(urlwrapper);
		//paramterWrapper.removeParameterTree(rq_operazione+"_");

		if (inserimento_luogo || modifica_luogo){
			
			try{
				MultipartHttpServletRequest requestMPSave = (MultipartHttpServletRequest)requestMP;
				
				String path = luogo.getUploadDirectory();
				Map<String, String> fieldToFile = requestMPSave.saveFiles(path);
				for (String field: fieldToFile.keySet())	
					paramterWrapper.addParameter(field, fieldToFile.get(field));
			}catch(Exception e){
				// Se la request non è multipart (fallisce il cast) -> tutta la gestione file viene saltata
			}
			
			Set<String> parameters = paramterWrapper.getParameters().keySet();
			parameters.remove(rq_luogo);
			
			for (String par: parameters)
				try{
					Logger.write(" ** Test** Setting " + par + " = " + paramterWrapper.getParameter(par).get(0));
					luogo.setField(par, paramterWrapper.getParameter(par).get(0));
				}catch(NoSuchFieldException nsfe){
					Logger.write(" ** Test** Errore");
				}
			
			luogo.insertOrUpdate();
	
		}else{
			response.sendRedirect(HOME_ADMIN);
		}
		
		response.sendRedirect("/amministrazione/luoghi.htm?" + rq_luogo + "=" + luogo.id_luogo + (pagina!=null? "&" + rq_documento + "=" + pagina.getId() : ""));
	}%>