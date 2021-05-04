<%@include file="/common/include/begin.jsp" %>
<%@include file="include/_load_pagina.jsp" %>

<%	if(request.getParameter("id_utente")!=null && operatore_nl!=null){%>

<%	StrutturaCamerale struttura=pagina.getStrutturaCamerale();
	
	Long id_utente = new Long(request.getParameter("id_utente").trim());
	String password = request.getParameter("password1").trim();
	String nome = request.getParameter("nome").trim();
	String cognome = request.getParameter("cognome").trim();
	String organizzazione = request.getParameter("organizzazione").trim();
	String privacy_mail = request.getParameter("privacy_mail")!=null ? request.getParameter("privacy_mail") : "true";
	String privacy_dati = request.getParameter("privacy_dati")!=null ? request.getParameter("privacy_dati") : "true";
	
	String prospectListId="";	
	ArrayList<TematicaNl> areeTematiche = new ArrayList<TematicaNl>();
	String[] id_tematica = {};%>
	<%if ((id_tematica!=null)&&(id_tematica.length>0)){
		id_tematica = request.getParameterValues("tematica");	
		for (int i=0; i<id_tematica.length; i++){
			try{
				areeTematiche.add(new TematicaNl(connPostgres, new Long(id_tematica[i])));
				//out.print("["+i+"] -----> "+areeTematiche.get(i).nome);
			}catch(Exception e){}
		}
	}%>
	<%int presente=0; 	
	QueryPager pager = new QueryPager(connPostgres);
	pager.set("select * from " + TematicaNl.NAME_TABLE + " order by nome");
	QueryPager pagerCrm = new QueryPager(connCRM);
	QueryPager pagerPl = new QueryPager(connCRM);	
	SQLTransactionManager manager = new SQLTransactionManager(this, connCRM);
%>

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
				<h2><span class="glyphicon glyphicon-bullhorn" aria-hidden="true" style="margin-right:10px;"></span> Newsletter Camera di Commercio della Romagna - Forlì-Cesena e Rimini</h2>
		
		<%@include file="/amministrazione/mail/HeaderFooter/_header_email.jsp" %>
		<%	UtenteNl utente = new UtenteNl(connPostgres, id_utente);
				
			//Aggiorno le aree tematiche in base a quelle selezionate dall'utente
			utente.associaAreeTematiche(areeTematiche);
			SQLTransactionManager sqlMan = new SQLTransactionManager(this, connPostgres);
			if (sqlMan.executeCommandQuery("UPDATE " + UtenteNl.NAME_TABLE + " SET password='"+StringUtils.doubleQuotes(password)+"', nome='"+StringUtils.doubleQuotes(nome)+"', cognome='"+StringUtils.doubleQuotes(cognome)+"', organizzazione='"+StringUtils.doubleQuotes(organizzazione)+"', privacy_mail="+privacy_mail+", privacy_dati=" + privacy_dati + " WHERE id_utente="+id_utente)){
				MailPending mail = new MailPending();
				mail.i_from="abc@xx.it";
				mail.i_replyto="abc@xxx.it";
				mail.i_to=utente.email;
				mail.contenttype="text/html; charset=utf-8";
				mail.subject="Modifica dell'iscrizione alla Newsletter della XXX";
				mail.body="<div style=\"color:#000;\">" + emailHeader + "Come richiesto abbiamo modificato l'iscrizione alla newsletter della XXX per l'indirizzo <b>"+utente.email+"</b>.<br/><br/>" + emailFooter+ "</div>";
				mail.page_ins="ATTNL";
				mail.submit();
			%>
		
				<h4><span class="glyphicon glyphicon-ok" aria-hidden="true" style="margin-right:10px;"></span> Modifica completata.</h4>
				
				<p>
					Grazie <b><%=utente.email%></b>,
					<br />la sua richiesta di modifica alla newsletter della XXX è stata registrata correttamente.
				</p>
				
				<p><b>A breve invieremo al suo indirizzo una mail di conferma.</b>
				<p>Per qualsiasi informazione può contattarci all'indirizzo: <a href="mailto:abc@xxx.it">abc@xxx.it</a></p>
			
		<%	}else{%>
				<br /><br />
				<p><b>ERRORE NELLA MODIFICA DEI DATI UTENTE</b></p>
				<p>Per assistenza scrivere una mail a <a href="mailto:abc@xxx.it">abc@xxx.it</a></p>
		<%	}%>
	
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

<%	}else
		response.sendRedirect("/newsletter/");%>