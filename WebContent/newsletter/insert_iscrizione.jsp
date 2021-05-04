<%@include file="/common/include/begin.jsp" %>
<%@include file="include/_load_pagina.jsp" %>

<%	StrutturaCamerale struttura=pagina.getStrutturaCamerale();
	
	PreviewQuery prev_dual = new PreviewQuery(connPostgres);
	prev_dual.setPreview("SELECT nextval('" + AbstractDocumentoWeb.NAME_SCHEMA + ".id_utentenl')");
	Long id_utente = new Long(prev_dual.getField(0));
	String email = (request.getParameter("email")!=null ? request.getParameter("email").toLowerCase().trim() : "");
	String password = request.getParameter("password1").trim();
	String nome = request.getParameter("nome").trim();
	String cognome = request.getParameter("cognome").trim();
	String privacy_mail = request.getParameter("privacy_mail")!=null ? request.getParameter("privacy_mail") : "true";
	String privacy_dati = request.getParameter("privacy_dati")!=null ? request.getParameter("privacy_dati") : "true";
	String organizzazione = request.getParameter("organizzazione").trim();
	String[] id_tematica = request.getParameterValues("tematica");
	String key = request.getParameter("key").trim();
	Date data_inserimento = new Date();
	
	if (backwrapper == null)
		backwrapper = new CdCURLWrapper(connPostgres, new URL(currentServer + "/newsletter/"));%>

<!doctype html>
<head>
	<%@include file="/common/struct_template/head.htm" %>
</head>

<body class="body-public">
	<%@include file="/common/struct_template/header.htm" %>
	<%@include file="struct_template/_barra_navigazione.htm" %>

	<main class="main-content">
		<div class="row">
			
			<%@include file="/common/struct_template/menu_sx.htm" %>
			
			<!----CENTRO PAGINA---->
			<div class="col-md-6 order-first order-md-2">
				<%@include file="/common/struct_template/operatore_nl.htm" %>
				<h2><span class="glyphicon glyphicon-bullhorn" aria-hidden="true" style="margin-right:10px;"></span>Iscrizione servizi online</h2>
				<br/><br/>
				
		<%	PreviewQuery prev = new PreviewQuery(connPostgres);
			prev.setPreview("SELECT email, data_attivazione FROM " + UtenteNl.NAME_TABLE + " WHERE LOWER(email)='"+email+"'");
			if (prev.getNumberRecords()>0 && (prev.getField("email").toLowerCase()).equals(email) && prev.getField("data_attivazione")!=null && !prev.getField("data_attivazione").equals("")){%>
				<h4><span class="glyphicon glyphicon-remove" style="color:red;" aria-hidden="true" style="margin-right:10px;"></span> Indirizzo email già presente nel nostro archivio.</h4>
				<p>
					<br/><br/>Nel caso in cui non ricordasse più la password per l'accesso, può <a href="/newsletter/recupero.htm" title="Recupera password">procedere con il recupero</a>.
				</p>
				<p>In alternativa può sempre procedere con una <a href="iscrizione.htm">richiesta di iscrizione per un indirizzo email diverso dal precedente</a>.</p>
		<%	}else if(prev.getNumberRecords()>0 && (prev.getField("email").toLowerCase()).equals(email) && (prev.getField("data_attivazione")==null || prev.getField("data_attivazione").equals(""))){%>
				<h4><span class="glyphicon glyphicon-remove" style="color:red;" aria-hidden="true" style="margin-right:10px;"></span> Indirizzo email già presente nel nostro archivio ma non ancora attivata</h4>
				<p>
					<br/><br/>
					<b>Si ricorda che al momento dell'iscrizione, è stata inviata una e-mail all'indirizzo da Lei indicato contenente un link per l'attivazione</b>.
				</p>
				<p>In alternativa può sempre procedere con una <a href="iscrizione.htm" title="Iscrizione online">richiesta di iscrizione per un indirizzo email diverso dal precedente</a>.</p>
		<%	}else{	%>
			<%@include file="/amministrazione/mail/HeaderFooter/_header_email.jsp" %>
	<%		SQLTransactionManager sqlMan = new SQLTransactionManager(this, connPostgres);
			if (sqlMan.executeCommandQuery("INSERT INTO " + UtenteNl.NAME_TABLE + " (id_utente, email, password, nome, cognome, data_inserimento, privacy_mail, privacy_dati, organizzazione, key, valido) VALUES (" + id_utente + ", '" + email + "', '" + StringUtils.doubleQuotes(password) + "', '" + StringUtils.doubleQuotes(nome) + "', '" + StringUtils.doubleQuotes(cognome) + "', current_date, " + privacy_mail + ", " + privacy_dati + ", '" + StringUtils.doubleQuotes(organizzazione) + "', '" + StringUtils.doubleQuotes(key) + "', true)")){
				if (id_tematica != null){
					for (int i=0; i<id_tematica.length; i++){
						if (id_tematica[i]!=null && !id_tematica[i].equals("on"))
							sqlMan.executeCommandQuery("INSERT INTO " + AbstractDocumentoWeb.NAME_SCHEMA + ".rel_utenti_tematiche_nl(id_utente, id_tematica) VALUES ("+id_utente+", "+id_tematica[i]+")");
					}
				}
				
				MailPending mail = new MailPending();
				mail.contenttype="text/html; charset=utf-8";
				mail.i_from="abc@xxx.it";
				mail.i_replyto="abc@xxx.it";
				mail.i_to=email;
				mail.subject="Richiesta di iscrizione ai servizi online della XXX";		  
				mail.body = emailHeader + "Ci &egrave; giunta la richiesta di iscrizione ai servizi online della XXX per l'indirizzo: <b>"+email+"</b>.<br />La password da utilizzare per l'accesso &egrave;: <b>"+password+"</b>.<br /><br />Per confermare l'iscrizione clicca su questo link: <a href='" + currentServer + "/newsletter/conferma.jsp?key="+key+"&email="+email+"'>" + currentServer +"/newsletter/conferma.jsp?key="+key+"&email="+email+"</a><br />(Se il link non dovesse funzionare correttamente, si prega di provare copiando e incollando tutta la riga nel proprio browser)<br /><br />Hai 7 giorni di tempo per confermare la tua iscrizione.<br /><br />Ai sensi del D. Lgs. 30/06/2003 n.196, i dati saranno oggetto di trattamento informatico e manuale, ai fini della trasmissione, da parte della Camera di Commercio della Romagna - Forli-Cesena e Rimini, di comunicazioni riguardanti l'attivit&agrave; istituzionale.<br/><br/>"+emailFooter;
				mail.page_ins="ATTNL";
				mail.submit();%>
				
				<h4><span class="glyphicon glyphicon-ok green-colored" aria-hidden="true" style="margin-right:10px;"></span> Richiesta di iscrizione completata.</h4>
				<br/><br/>
				<p>
					Grazie <b><%=email%></b>,
					<br />per la sua richiesta di iscrizione ai servizi online della XXX.
				</p>
				
				<p>
					<b>A breve riceverà una e-mail all'indirizzo da Lei indicato contenente un link per l'attivazione.
					<br />Cliccare sul link per procedere con l'attivazione.</b>
					<br />Se la conferma non perviene entro 7 giorni, questa richiesta sarà cancellata.
				</p>
				<p>Per qualsiasi informazione può contattarci all'indirizzo: <a href="mailto:abc@xxx.it">abc@xxx.it</a></p>
				<p style="text-align:center"><a href="<%=backwrapper %>">Indietro</a></p>
		<%	}else{%>
				
				<h4><span class="glyphicon glyphicon-remove" style="color:red;" aria-hidden="true" style="margin-right:10px;"></span> <b>ERRORE NELL'INSERIMENTO UTENTE</b></h4>
				<br /><br />
				<p>Per assistenza tecnica scrivere una mail a <a href="mailto:abc@xxx.it">abc@xxx.it</a></p>
		<%	}
		}%>
			</div>
			<!--- FINE CENTRO PAGINA--->
			
			<!-- BARRA LATERALE DESTRA -->
			<%@include file="struct_template/_componenti_destra.htm" %>
			<!--FINE BARRA LATERALE DESTRA-->
		</div>
	</main>
<%@include file="/common/struct_template/feedback.htm" %>
<%@include file="/common/struct_template/footer.htm" %>
<%@include file="/common/struct_template/footer_script.htm" %>

  </body>
</html>