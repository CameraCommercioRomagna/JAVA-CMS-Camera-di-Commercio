<%@include file="_header_email.jsp" %>
<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@include file="_header_auth.jsp" %>

<%	String pagefwd=request.getParameter("pagefwd");
	String ID_quesito=request.getParameter("id_quesito");
	String ID_risposta=request.getParameter("id_risposta");
	
	PreviewQuery quesito= new PreviewQuery(connPostgres);
	quesito.setPreview("select id_quesito, to_char(data_inserimento, 'DD-MM-YYYY') as data_inserimento, id_operatore, id_amministratore, testo_quesito from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_quesiti where id_quesito=" + ID_quesito);
	
	PreviewQuery userPQ= new PreviewQuery(connPostgres);
	userPQ.setPreview("select nome, cognome, email from " + Utente.NAME_TABLE + " where id_utente=" + quesito.getField("id_operatore"));

	PreviewQuery adminPQ=new PreviewQuery(connPostgres);
	adminPQ.setPreview("select nome, cognome, email from " + Utente.NAME_TABLE + " where id_utente=" + quesito.getField("id_amministratore"));
	
	String nome=userPQ.getField("nome");
	String cognome=userPQ.getField("cognome");
	String email=userPQ.getField("email");

	SQLTransactionManager sql = new SQLTransactionManager(this, connPostgres);
	String query="update " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_risposte set data_chiusura_op=null where id_quesito= "+ID_quesito ;

	if (sql.executeCommandQuery(query)){
		session.setAttribute("tokenMailServlet","true");
		MailPending mail = new MailPending();
		if (demoMode){
			mail.i_from="abc@xxx.it";
			mail.i_to="abc@xxx.it";
		}else{
			mail.i_from=adminPQ.getField("email");
			mail.i_to=email;
		}
		mail.subject="Contatta Camera - Richiesta riformulazione risposta quesito ticket n." + ID_quesito;
		mail.contenttype="text/html; charset=utf-8";
		mail.body=emailHeader + "Gentile " + nome + " " + cognome + " (" + email + "),<br/>" + adminPQ.getField("nome") + " " + adminPQ.getField("cognome") + " ritiene necessaria la riformulazione della risposta relativa al quesito con ticket n." + ID_quesito + ", di cui hai in precedenza richiesto la validazione.<br/><br/><a href='http://www.xxx.it/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=" + ID_quesito + "'>Clicca qui per riformularla nell'area di amministrazione</a>" + emailFooter;
		mail.page_ins="CLCDC";
		
		mail.submit();
		response.sendRedirect(pagefwd);
	}%>