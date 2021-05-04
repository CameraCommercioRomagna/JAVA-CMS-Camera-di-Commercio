<%---@include file="_header_email.jsp" ---%>
<%@include file="/amministrazione/mail/HeaderFooter/_header_email.jsp" %>
<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@include file="_header_auth.jsp" %>

<%	if(request.getParameter("invia")!=null&&request.getParameter("invia").equals("yes")){
		String pagefwd=request.getParameter("pagefwd");
		String ID_quesito=request.getParameter("id_quesito");
		String ID_risposta=request.getParameter("id_risposta");
		
		PreviewQuery quesito= new PreviewQuery(connPostgres);
		quesito.setPreview("select id_quesito, to_char(data_inserimento, 'DD-MM-YYYY') as data_inserimento, id_utente, oggetto, testo_quesito, id_operatore, da_validare from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_quesiti where id_quesito=" + ID_quesito);
		
		PreviewQuery operatorePQ= new PreviewQuery(connPostgres);
		operatorePQ.setPreview("select nome as nome_u, cognome as cognome_u, email as email_u from " + Utente.NAME_TABLE + " where id_utente=" + quesito.getField("id_operatore"));
		
		PreviewQuery user= new PreviewQuery(connPostgres);
		user.setPreview("select nome as nome_u, cognome as cognome_u, email as email_u from " + UtenteNl.NAME_TABLE + " where id_utente=" + quesito.getField("id_utente"));
		//out.print(user);
		
		PreviewQuery risposta= new PreviewQuery(connPostgres);
		risposta.setPreview("select id_risposta, to_char(data_inserimento, 'DD-MM-YYYY') as data_inserimento, testo_risposta, allegato_f0, allegato_f1, allegato_f2 from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_risposte where id_risposta=" + ID_risposta);
		
		SQLTransactionManager sqlCloseRisposta = new SQLTransactionManager(this, connPostgres);
		String queryCloseRisposta="update " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_risposte set data_validazione=current_timestamp, data_invio=current_timestamp, ultima=true where id_risposta= "+ID_risposta ;
		
		if (sqlCloseRisposta.executeCommandQuery(queryCloseRisposta)){
			session.setAttribute("tokenMailServlet","true");
			Map<String, String> pathAttachments=new HashMap<String, String>();
			int countAllegati=1;
			if (!risposta.getField("allegato_f0").equals("")){
				String allegato=risposta.getField("allegato_f0");
				String estensione = (allegato.lastIndexOf(".")==-1 ? "" : allegato.substring(allegato.lastIndexOf(".")));
				pathAttachments.put("Allegato"+countAllegati+estensione, "/opt/tomcat/domini" + allegato);
				countAllegati++;
			}
			if (!risposta.getField("allegato_f1").equals("")){
				String allegato=risposta.getField("allegato_f1");
				String estensione = (allegato.lastIndexOf(".")==-1 ? "" : allegato.substring(allegato.lastIndexOf(".")));
				pathAttachments.put("Allegato"+countAllegati+estensione, "/opt/tomcat/domini" + allegato);
				countAllegati++;
			}
			if (!risposta.getField("allegato_f2").equals("")){
				String allegato=risposta.getField("allegato_f2");
				String estensione = (allegato.lastIndexOf(".")==-1 ? "" : allegato.substring(allegato.lastIndexOf(".")));
				pathAttachments.put("Allegato"+countAllegati+estensione, "/opt/tomcat/domini" + allegato);
				countAllegati++;
			}
	
			MailPending mail = new MailPending();
				if (demoMode){
					mail.i_from="abc@xxx.it";
					mail.i_to="abc@xxx.it";
				}else{
					//mail.i_from="no_reply@fc.camcom.gov.it";
					mail.i_from="noreply@xxx.it";
					mail.i_to=user.getField("email_u");
					if(quesito.getField("da_validare").equals("true")){
						mail.i_bcc=operatorePQ.getField("email_u");
					}
				}
				mail.subject="XXX - Ticket n." + ID_quesito + " - Risposta al quesito";
				mail.contenttype="text/html; charset=utf-8";
				mail.body=emailHeader + "Gentile " + user.getField("nome_u") + " " + user.getField("cognome_u") + ",<br/>segue la risposta al quesito con ticket n." + ID_quesito + " inviato alla XXX tramite il servizio online <i>Contatta il Registro Imprese</i>.<br/><br/><div style=\"margin-left:10px\">Oggetto: <b>" + quesito.getField("oggetto") +"</b><br/>" + quesito.getField("testo_quesito") + "</div><br/><i>" + risposta.getField("testo_risposta") + "</i><br/><br/><b>Non rispondere a questa email</b>.<br/>Qualora fossero necessari approfondimenti, è possibile inviare un <a href='http://www.xxx.it/contatta_camera/'>nuovo quesito</a>.<br/><br/>Cordiali saluti,<br/>XXX" + emailFooter ;
				if (pathAttachments!=null){
					mail.attach = "";
					for(String nameFileEmail: pathAttachments.keySet()){
						if (mail.attach.length()>0)
							mail.attach += ",";
						
						String path=pathAttachments.get(nameFileEmail);
						mail.attach += "[" + nameFileEmail + ";" + path + "]";
					}
				}
				mail.page_ins="CLCDC";
				mail.submit();
				response.sendRedirect("/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=" +ID_quesito);
				//out.print(mail.body);
		}
	
	}else{
		
		String pagefwd=request.getParameter("pagefwd");
		String ID_quesito=request.getParameter("id_quesito");
		String ID_admin=request.getParameter("id_admin");

		PreviewQuery admin=new PreviewQuery(connPostgres);
		admin.setPreview("select nome, cognome, email from " + Utente.NAME_TABLE + " where id_utente=" + ID_admin);
		out.print(admin);
		String nome=admin.getField("nome");
		String cognome=admin.getField("cognome");
		String email=admin.getField("email");

		SQLTransactionManager sql = new SQLTransactionManager(this, connPostgres);
		String query="update " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_risposte set data_chiusura_op=current_timestamp where id_quesito= "+ID_quesito ;

		if (sql.executeCommandQuery(query)){
				session.setAttribute("tokenMailServlet","true");
				MailPending mail = new MailPending();
				if (demoMode){
					mail.i_from="abc@xxx.it";
					mail.i_to="abc@xxx.it;
				}else{
					mail.i_from=operatore.email;
					mail.i_to=email;
				}
				mail.subject="Contatta Camera - Richiesta validazione quesito ticket n." + ID_quesito;
				mail.contenttype="text/html; charset=utf-8";
				mail.body=emailHeader + "Gentile " + nome + " " + cognome + " (" + email + "),<br/>è stata richiesta la validazione del quesito n." + ID_quesito + " da " + operatore.email + ".<br/><br/><a href='http://www.xxx.it/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=" + ID_quesito + "'>Clicca qui per validarlo nell'area di amministrazione</a>" + emailFooter;
				mail.page_ins="CLCDC";
				
				mail.submit();
				response.sendRedirect("/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=" +ID_quesito);
				//out.print(mail.body);
		}
	}
%>