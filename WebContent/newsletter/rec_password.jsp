<%@include file="/common/include/begin.jsp" %>
<%@include file="include/_load_pagina.jsp" %>

<%	StrutturaCamerale struttura=pagina.getStrutturaCamerale();
	
	String email = (request.getParameter("email")!=null ? request.getParameter("email").toLowerCase().trim() : "");
	QueryPager pager = new QueryPager(connPostgres);
	pager.set("select password from " + UtenteNl.NAME_TABLE + " where LOWER(email)='"+email+"'");
	
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
	
				<h1><span class="glyphicon glyphicon-bullhorn" aria-hidden="true" style="margin-right:10px;"></span>Procedura di recupero password</h1>
	
		<%	if (pager.getNumberRecords()==1){%>
				<%@include file="/amministrazione/mail/HeaderFooter/_header_email.jsp" %>
		<%		String password = pager.iterator().next().getField("password").trim();
				MailPending mail = new MailPending();
				mail.contenttype="text/html; charset=utf-8";
				mail.i_from="abc@xxx.it";
				mail.i_replyto="abc@xxx.it";
				mail.i_to=email;
				mail.subject="Recupero password per servizi online della XXX";
				mail.body=emailHeader + "In base alla sua richiesta di recupero password per i servizi online della XXX, le comunichiamo che la password per l'indirizzo email "+email+" e': <b>"+password+"</b><br/><br/>" + emailFooter;
				mail.page_ins="ATTNL";
				mail.submit();%>
				
				<h4><span class="glyphicon glyphicon-ok" aria-hidden="true" style="margin-right:10px;"></span> Richiesta recupero password inoltrata</h4>
				<br />
				<p>
					Grazie <b><%=email%></b>,
					<br />la sua richiesta di recupero password è stata inviata.
				</p>
				
				<p><b>A breve riceverà al suo indirizzo email la password.</b></p>
				<p>Per qualsiasi informazione può contattarci all'indirizzo: <a href="mailto:abc@xxx.it">abc@xxx.it</a></p>
		<%	}else{%>
				<p>
					Indirizzo email non presente nelle nostre banche dati.
					<br /> Per informazioni scrivere a <a href="mailto:abc@xxx.it">informatica@xxx.it</a>.
				</p>
		<%	}%>
				<hr/>
				<p style="text-align:center"><a href="<%=backwrapper %>">Indietro</a></p>
				
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
