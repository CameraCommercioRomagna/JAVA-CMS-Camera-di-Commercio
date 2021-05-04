<%@include file="/common/include/begin.jsp" %>
<%@include file="include/_load_pagina.jsp" %>

<%	StrutturaCamerale struttura=pagina.getStrutturaCamerale();

	QueryPager pager = new QueryPager(connPostgres);
	
	String email = request.getParameter("email").trim();
	String key = request.getParameter("key").trim();
	
	pager.set("SELECT id_utente FROM " + UtenteNl.NAME_TABLE + " WHERE email='"+email+"' AND key='"+key+"'");
	
	Long id_utente = pager.getNumberRecords()>0 ? new Long(pager.iterator().next().getField("id_utente")) : null;
	UtenteNl utente = id_utente != null ? new UtenteNl(connPostgres, new Long(pager.iterator().next().getField("id_utente"))) : new UtenteNl();
	if (utente.valido())
		session.setAttribute("UtenteNl", utente);
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
				<h2><span class="glyphicon glyphicon-bullhorn" aria-hidden="true" style="margin-right:10px;"></span> Iscrizione servizi online</h2>

		<%	SQLTransactionManager sqlMan = new SQLTransactionManager(this, connPostgres);
			if (sqlMan.executeCommandQuery("UPDATE " + UtenteNl.NAME_TABLE + " SET data_attivazione=current_date WHERE email='"+email+"' AND key='"+key+"'")){%>
				<h4><span class="glyphicon glyphicon-ok" aria-hidden="true" style="margin-right:10px;"></span> L'indirizzo <b><%=email%></b> è attivo per l'accesso ai servizi online.</h4>
				<p>Per qualsiasi informazione può contattarci all'indirizzo: <a href="mailto:abc@xxx.it">abc@xxx.it</a></p>
				
			<%	//Inserimento in tabella di log
				pager.set("SELECT * FROM " + AbstractDocumentoWeb.NAME_SCHEMA + ".rel_utenti_tematiche_nl where id_utente="+id_utente);
				String[] id_tematica =  new String[pager.getNumberRecords()];	
				int i=0;
				for (Row<String> rs : pager){
					id_tematica[i] = rs.getField("id_tematica");
					i++;
				}
				int presente=0; 	
				pager.set("select * from " + TematicaNl.NAME_TABLE + " order by nome");
				QueryPager pagerCrm = new QueryPager(connCRM);
				SQLTransactionManager manager = new SQLTransactionManager(this, connCRM);

				//Inserimento in tabella di log
				for (Row<String> rs : pager){ // Per ogni prospect list (prospectListId) controllo i consensi dati da email 
					boolean found = Arrays.asList( id_tematica ).contains( rs.getField("id_tematica") );
					if (found) { // Consenso dato 
						manager.executeCommandQuery("insert into cise_log_cancellazioni(id, email,area,data,prospect_list_id, related_id, related_type,canceled,descr) values (UUID(),'" + email + "','" + rs.getField("id_tematica") + "',now(),'','','utente_nl',0,'Nuova Iscrizione Portale')");
					} else { // Consenso non dato
						manager.executeCommandQuery("insert into cise_log_cancellazioni(id, email,area,data,prospect_list_id, related_id, related_type,canceled,descr) values (UUID(),'" + email + "','" + rs.getField("id_tematica") + "',now(),'','','utente_nl',1,'Nuova Iscrizione Portale')");
					}// Fine else - Consenso non dato

				} // Fine for - Per ogni prospect list%>
		<%	}else{%>
				<h4><span class="glyphicon glyphicon-remove" style="color:red;" aria-hidden="true" style="margin-right:10px;"></span> Si è verificato un errore.</h4>
				<p>Per assistenza scrivere una mail a <a href="mailto:abc@xxx.it">abc@xxx.it</a></p>
		<%	}%>	

			<h3>Servizi online</h3>
			<p>La tua registrazione ti consente di accedere ai seguenti servizi online:</p>
			<ul>
				<li><a href="http://www.xxx.it/contatta_camera/">Contatta il Registro Imprese</a></li>
			</ul>
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