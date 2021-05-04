<%@include file="_header_email.jsp" %>
<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@include file="_header_auth.jsp" %>

<%	if (request.getParameter("id_quesito")!=null){
		String ID_quesito=request.getParameter("id_quesito");
		
		if (request.getParameter("note_operatore")!=null){
			String note_operatore=request.getParameter("note_operatore");
			out.print(note_operatore);
		}
		PreviewQuery quesito = new PreviewQuery(connPostgres);
		quesito.setPreview("select id_quesito, to_char(data_inserimento, 'DD-MM-YYYY') as data_inserimento, id_operatore,  id_amministratore, id_user_smistatore, da_validare, oggetto, testo_quesito, note_operatore, rag_sociale_impresa, num_rea from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_quesiti where id_quesito=" + ID_quesito);
		
		String id_old_operatore=request.getParameter("id_old_operatore");
		String id_new_operatore=request.getParameter("id_new_operatore");
		if (id_new_operatore!=null && !id_new_operatore.equals("") && !id_new_operatore.equals(id_old_operatore)
			&& !id_new_operatore.equals(quesito.getField("id_amministratore"))){

			PreviewQuery operatorePQ= new PreviewQuery(connPostgres);
			operatorePQ.setPreview("select nome as nome_u, cognome as cognome_u, email as email_u from " + Utente.NAME_TABLE + " where id_utente=" + quesito.getField("id_operatore"));
			
			PreviewQuery amministratore= new PreviewQuery(connPostgres);
			amministratore.setPreview("select nome as nome_u, cognome as cognome_u, email as email_u from " + Utente.NAME_TABLE + " where id_utente=" + quesito.getField("id_amministratore"));
			
			PreviewQuery smistatore= new PreviewQuery(connPostgres);
			smistatore.setPreview("select nome as nome_u, cognome as cognome_u, email as email_u from " + Utente.NAME_TABLE + " where id_utente=" + quesito.getField("id_user_smistatore"));

			MailPending mail = new MailPending();
			if (demoMode){
				mail.i_from="abc@xxx.it";
				mail.i_to="abc@xxx.it";
			}else{
				mail.i_from="noreply@xxx.it";
				mail.i_to=operatorePQ.getField("email_u");
			}
			mail.subject="Contatta Camera - Assegnazione quesito ticket n." + ID_quesito;
			mail.contenttype="text/html; charset=utf-8";
			mail.body=emailHeader + "Ciao " + operatorePQ.getField("nome_u") + " " + operatorePQ.getField("cognome_u") + ",<br/>" + smistatore.getField("nome_u") + " " + smistatore.getField("cognome_u") + " ti ha assegnato la risposta al quesito con ticket n." + ID_quesito + (quesito.getField("da_validare").equals("true") ? " (la cui risposta sarà validata da " + amministratore.getField("nome_u") + " " + amministratore.getField("cognome_u") + ")" : "") + ":<br/><br/>Oggetto:<b>" + quesito.getField("oggetto") + "</b><br/> Quesito:" + quesito.getField("testo_quesito") + "<br/><br/> Inserito il " + quesito.getField("data_inserimento") + " per conto di " + quesito.getField("rag_sociale_impresa")  + " " + (!quesito.getField("num_rea").equals("")?  " Numero REA :" + quesito.getField("num_rea"):"") + " " +   (!quesito.getField("note_operatore").equals("")? "Indicazioni dello smistatore per l'operatore: " + quesito.getField("note_operatore"): "" ) + "<br/><br/><a href='http://www.xxx.it/amministrazione/registro_imprese/contatta_cdc/quesiti.jsp'>Clicca qui per avviarne la trattazione dall'area di amministrazione</a>" + emailFooter;
			mail.page_ins="CLCDC";
			mail.submit();
			
		}
	}
	
	response.sendRedirect(backwrapper.getPercorsoWeb(false));
%>

