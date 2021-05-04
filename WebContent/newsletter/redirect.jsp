<%@include file="/common/include/begin.jsp" %>
<%@include file="include/_load_pagina.jsp" %>

<%	StrutturaCamerale struttura=pagina.getStrutturaCamerale();
	if (backwrapper == null)
		backwrapper = new CdCURLWrapper(connPostgres, new URL(currentServer + "/newsletter/"));
	
	QueryPager pager = new QueryPager(connPostgres);
	
	String email = request.getParameter("email")==null ? "" : request.getParameter("email").toLowerCase().trim();
	String password = request.getParameter("password")==null ? "" : request.getParameter("password").trim();
	String modcanc = request.getParameter("modcanc")==null ? "" : request.getParameter("modcanc").trim();
	String login = request.getParameter("login")==null ? "0" : request.getParameter("login").trim();
	String logout = request.getParameter("logout")==null ? "0" : request.getParameter("logout").trim();
	String fwd = request.getParameter("fwd")==null ? backwrapper.getPercorsoWeb() : request.getParameter("fwd").trim();
	Logger.write(" **REDIRECT.JSP** [email=" + email +", password=" + password +", modcanc=" + modcanc +", login=" + login +", logout=" + logout +", fwd=" + fwd +"]");
	
	pager.set("SELECT id_utente FROM " + UtenteNl.NAME_TABLE + " WHERE LOWER(email)='"+email+"' AND password='"+password+"'");
	
	Long id_utente = pager.getNumberRecords()>0 ? new Long(pager.iterator().next().getField("id_utente")) : null;
	UtenteNl utente = id_utente != null ? new UtenteNl(connPostgres, id_utente) : new UtenteNl();%>

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
				<h2><span class="glyphicon glyphicon-bullhorn" aria-hidden="true" style="margin-right:10px;"></span>Iscrizione servizi online</h2>
		<%	if (utente.valido() && login.equals("1")){
				Logger.write(" **REDIRECT.JSP** - utente.valido() && login.equals(1)");
				session.setAttribute("UtenteNl", utente);
				response.sendRedirect(fwd);
			}else if (utente.valido() && !login.equals("1") && logout.equals("0")){
				Logger.write(" **REDIRECT.JSP** - utente.valido() && !login.equals(1) && logout.equals(0)");
				if (modcanc.equals("modifica")){
					Logger.write(" **REDIRECT.JSP** - modcanc.equals(modifica)");
					response.sendRedirect("/newsletter/modifica.htm?id_utente="+id_utente);
				}else if (modcanc.equals("cancella")){
					Logger.write(" **REDIRECT.JSP** - modcanc.equals(cancella)");
					response.sendRedirect("/newsletter/cancella.htm?id_utente="+id_utente);
				}
			}else if (logout.equals("1")){
				Logger.write(" **REDIRECT.JSP** - logout.equals(1)");
				session.removeAttribute("UtenteNl");
				response.sendRedirect(fwd);
			}else{
				Logger.write(" **REDIRECT.JSP** - logout.equals(1) - else");
				QueryPager pagerStatoUtente = new QueryPager(connPostgres);
				pagerStatoUtente.set("SELECT id_utente, data_attivazione FROM " + UtenteNl.NAME_TABLE + " WHERE email='"+email+"'");
				
				if (pagerStatoUtente.getNumberRecords()==0){
					Logger.write(" **REDIRECT.JSP** - pagerStatoUtente.getNumberRecords()==0");%>
				<h4><span class="glyphicon glyphicon-remove" style="color:red;" aria-hidden="true" style="margin-right:10px;"></span> Indirizzo email non presente nel nostro archivio.</h4>
				<p><span class="glyphicon glyphicon-pencil" aria-hidden="true" style="margin-right:10px;"></span><a href="iscrizione.htm">Iscriviti ora ai servizi online della Camera di Commercio</a></p>
		<%		}else if (pagerStatoUtente.iterator().next().getField("data_attivazione").equals("")){
					Logger.write(" **REDIRECT.JSP** - pagerStatoUtente.iterator().next().getField(data_attivazione).equals()");%>
				<h4><span class="glyphicon glyphicon-remove" style="color:red;" aria-hidden="true" style="margin-right:10px;"></span>Indirizzo email già presente nel nostro archivio ma non ancora attivata</h4>
				<p>
					<br/><br/>
					<b>Si ricorda che al momento dell'iscrizione, è stata inviata una e-mail all'indirizzo indicato contenente un link per l'attivazione</b>.
				</p>
				<p>In alternativa puoi procedere con una <a href="iscrizione.htm" title="Iscrizione online">richiesta di iscrizione per un indirizzo email diverso dal precedente</a>.</p>
		<%		}else{
					Logger.write(" **REDIRECT.JSP** - logout.equals(1) - else - else");%>
				<h4><span class="glyphicon glyphicon-remove" style="color:red;" aria-hidden="true" style="margin-right:10px;"></span>Password errata</h4>
				<p>
					<br/><br/>
					Nel caso in cui non ricordasse più la password per l'accesso, può <a href="/newsletter/recupero.htm" title="Recupera password">procedere con il recupero</a>.
				</p>
				<p>In alternativa può sempre procedere con una <a href="iscrizione.htm">richiesta di iscrizione per un indirizzo email diverso dal precedente</a>.</p>
				<p style="text-align:center"><a href="<%=fwd%>">Torna alla pagina di provenienza</a></p>
			<%	}%>
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