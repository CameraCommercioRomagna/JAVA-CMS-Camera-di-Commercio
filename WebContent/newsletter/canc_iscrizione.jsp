<%@include file="/common/include/begin.jsp" %>
<%@include file="include/_load_pagina.jsp" %>

<%	StrutturaCamerale struttura=pagina.getStrutturaCamerale();
	
	Long id_utente = new Long(request.getParameter("id_utente").trim());%>

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
				<h2><span class="glyphicon glyphicon-bullhorn" aria-hidden="true" style="margin-right:10px;"></span> Newsletter XXX</h2>
	
		<%	try{
				UtenteNl utente = new UtenteNl(connPostgres, id_utente);
				SQLTransactionManager sqlMan = new SQLTransactionManager(this, connPostgres);
				
				sqlMan.executeCommandQuery("DELETE FROM " + AbstractDocumentoWeb.NAME_SCHEMA + ".rel_utenti_tematiche_nl WHERE id_utente="+id_utente);
				sqlMan.executeCommandQuery("DELETE FROM " + UtenteNl.NAME_TABLE + " WHERE id_utente="+id_utente);
				session.removeAttribute("UtenteNl");
				
				MailPending mail = new MailPending();
				mail.i_from="abc@xxx.it";
				mail.i_replyto="abc@xxx.it";
				mail.i_to=utente.email;
				mail.subject="Cancellazione dalla Newsletter della XXX";
				mail.body="<div style='clear: both; overflow: hidden; width: 600px; font-family: Arial, Helvetica, sans-serif; font-size: 1em; display: block;'><a href='http://www.xxx.it'><img style='border: 0px;' src='http://www.fc.camcom.it/common/mail/header_mail.gif' alt='XXX' /></a><br /><table style='width: 100%; font-family: Arial,Helvetica,sans-serif; font-size: 12px;' border='0' cellspacing='2' cellpadding='2'><tbody><tr><td valign='top'>Ci &egrave; giunta la richiesta di cancellazione alla newsletter della XXX per l'indirizzo: <b>"+utente.email+"</b>.<br /><br />Cordialmente,<br /><a href='mailto:abc@xxx.it'>abc@xxx.it</a></td></tr></tbody></table><br /> <img style='border: 0px;' src='http://www.xxx/xxx.gif' alt='' /><p style='font-size: 12px; margin: 1em 1.5em 1em 0; width: 550px; text-align: center; margin-top: 0;'><strong>XXX</strong></p></div>";
				mail.page_ins="ATTNL";
				mail.submit();%>
				
				<h4><span class="glyphicon glyphicon-ok green-colored" aria-hidden="true" style="margin-right:10px;"></span> Cancellazione completata.</h4>
				<p>
					Grazie <b><%=utente.email%></b>,
					<br />la sua richiesta di cancellazione alla newsletter della XXX è arrivata.
				</p>
				
				<p><b>A breve invieremo al suo indirizzo una mail di conferma.</b><p>
				
				<p>Per qualsiasi informazione può contattarci all'indirizzo: <a href="mailto:abc@xxx.it">abc@xxx.it</a></p>
				
				<meta http-equiv="refresh" content="4;URL=http://www.xxx.it/">
		<%	}catch(Exception e){
				e.printStackTrace();
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