<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@page 
	import="org.apache.commons.fileupload.FileItem" 
	import="java.io.File" 
%>
<%@include file="_load_pagina.jsp" %>
<%	Paragrafo paragrafo=null;
	Long id_paragrafo = null;

	try{
		id_paragrafo = Long.parseLong(requestMP.getParameter("id_paragrafo"));
		paragrafo = new Paragrafo((Documento)pagina);
		paragrafo.initialize(connPostgres);
		paragrafo.id_paragrafo = id_paragrafo;
		paragrafo.load();
	}catch(Exception e){
		paragrafo = new Paragrafo((Documento)pagina);
		paragrafo.initialize(connPostgres);
	}
	
	if (pagina==null || operazione.equals("") || paragrafo==null){
		response.sendRedirect(HOME_ADMIN);
	}else{
		
		CdCURLWrapper paramterWrapper=new CdCURLWrapper(urlwrapper);
		paramterWrapper.removeParameterTree(rq_operazione+"_");

		if (operazione.equals("salva")){
			// op=salva
			
			if(!paragrafo.isInserted()){
				paragrafo.insert(operatore);
				id_paragrafo = paragrafo.id_paragrafo;
			}
			
			try{
				MultipartHttpServletRequest requestMPSave = (MultipartHttpServletRequest)requestMP;
				
				String path = pagina.getUploadDirectory()+id_paragrafo+"/";
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
					String oldValue=(paragrafo.getField(par).getValue()==null ? "" : paragrafo.getField(par).getValue().toString());
					String newValue=paramterWrapper.getParameter(par).get(0);
					if (!oldValue.equals(newValue)){
						if (newValue.equals(""))
							newValue = null;
						
						paragrafo.setField(par, newValue);
					}
					//old: paragrafo.setField(par, paramterWrapper.getParameter(par).get(0));
				}catch(NoSuchFieldException nsfe){}
			paragrafo.insertOrUpdate(operatore);
			
			backwrapper.addParameter(rq_documento + "_tab", "Paragrafi");
			
		}else if (operazione.equals("delete")){
			paragrafo.delete(operatore);
		}else{
			response.sendRedirect(HOME_ADMIN);
		}
		
		backwrapper.addParameter(rq_documento + "_tab", "Paragrafi");
		response.sendRedirect(backwrapper.getPercorsoWeb(false));
	}%>