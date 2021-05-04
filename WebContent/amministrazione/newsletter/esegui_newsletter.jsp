<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@page 
	import="org.apache.commons.fileupload.FileItem" 
	import="java.io.File" 
%>
<%@include file="_load_newsletter.jsp" %>
<%@include file="_load_numero_newsletter.jsp" %>

<%	
	if (numero_nl==null || operazione.equals("")){
		response.sendRedirect(HOME_ADMIN_NEWSLETTER);
	}else{
		if (operazione.equals("approva")){
			for (PromozioneDocumentoWeb pdweb: numero_nl.getDocumentiPubblicabili()){
				String check_str = requestMP.getParameter("check"+pdweb.id_documento_web);
				Long ordine = null;
				try{
					ordine = new Long(requestMP.getParameter("ordine"+pdweb.id_documento_web));
				}catch(Exception e){
				}	
				pdweb.setApprovazione(operatore, check_str!=null && check_str.equals("true"), ordine);
			}
			backwrapper = new CdCURLWrapper(connPostgres, new URL(currentServer + "/amministrazione/newsletter/index.htm?"+rq_tipo_newsLetter+"=" + tipo_newsLetter.id_nl_tipo + "&"+rq_numero_newsLetter+"="+numero_nl.id_nl_numero));
		}else if (operazione.equals("pubblica")){
			numero_nl.pubblica(operatore);
			backwrapper = new CdCURLWrapper(connPostgres, new URL(currentServer + "/amministrazione/newsletter/index.htm?"+rq_tipo_newsLetter+"=" + tipo_newsLetter.id_nl_tipo));
		}else{
			response.sendRedirect(HOME_ADMIN);
		}
		
		response.sendRedirect(backwrapper.getPercorsoWeb(false));
	}%>