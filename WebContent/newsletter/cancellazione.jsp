<%	String email = request.getParameter("email")==null ? "" : request.getParameter("email").trim().toLowerCase();
	String areaNewsletter=request.getParameter("areaNewsletter");
	if (areaNewsletter == null) 
		areaNewsletter=""; 
	else  
		areaNewsletter=areaNewsletter.toLowerCase();
	if (email == null || email.equals("") || email.equals("$contact_email1") || email.equals("contact_email1")){
		response.sendRedirect("/newsletter/canc_email.htm?areaNewsletter="+areaNewsletter);
	}else{%>

<%@include file="/common/include/begin.jsp" %>
<%@include file="include/_load_pagina.jsp" %>
<%@ page import="java.io.*" %> 
<%@ page import="java.sql.*" %>

<%	StrutturaCamerale struttura=pagina.getStrutturaCamerale();

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
				<h2><span class="glyphicon glyphicon-bullhorn" aria-hidden="true" style="margin-right:10px;"></span> Disiscrizione newsletter</h2>
	
		<% 		String send=request.getParameter("send"); //Conferma cancellazione
				if (send == null) send="0";
				String areaNews=areaNewsletter;
				String prospectListId="";
				int nObj=0;
				int tematica=0;
				Long id_utente=null;
				
				//	out.println("Send "+send);
					
				if (areaNewsletter.contains("registro") || areaNewsletter.equals("1")){ 
					prospectListId = "a0a03c3a-357d-50ef-5139-574c114ee7e1";
					areaNews = "dell'Area Registro imprese";
					tematica = 1;
				}	else if (areaNewsletter.contains("finanza") || areaNewsletter.equals("2")){
					prospectListId="889e2e8b-9cc1-a279-0bce-574c10c2870b";
					areaNews = "dell'Area Finanza d'impresa";	
					tematica = 2;
				} else if (areaNewsletter.contains("imprendit") || areaNewsletter.equals("3")){
					prospectListId = "e1a919b1-fe11-63b6-94a0-574c10e200b8";
					areaNews = "dell'Area Imprenditorialità";	
					tematica = 3;
				} else if (areaNewsletter.contains("formaz") || areaNewsletter.equals("4")){
					prospectListId = "163e6b28-579d-efcb-7ee9-574c109562bb";
					areaNews = "dell'Area Formazione";	
					tematica = 4;
				} else if (areaNewsletter.contains("innovaz") || areaNewsletter.equals("5")){
					prospectListId = "cdbd07e5-5a1f-7b64-9532-574c10d661d3";
					areaNews = "dell'Area Innovazione";	
					tematica = 5;
				} else if (areaNewsletter.contains("internaz") || areaNewsletter.equals("6")){
					prospectListId = "aeb22027-020d-2577-715c-54b3b1b2d3dd";
					areaNews = "dell'Area Internazionalizzazione";	
					tematica = 6;
				} else if (areaNewsletter.contains("attrattiv") || areaNewsletter.equals("7")){
					prospectListId = "41cc1eb9-cbac-474c-986d-574c0fb12df0";
					areaNews = "dell'Area Attrattività del territorio";
					tematica = 7;	
				} else if (areaNewsletter.contains("econom") || areaNewsletter.equals("8")){
					prospectListId = "23d865ef-d3aa-1552-8d01-557fefdc260e";
					areaNews = "dell'Area Informazione economica";	
					tematica = 8;
				} else if (areaNewsletter.contains("regolaz") || areaNewsletter.equals("9")){
					prospectListId = "a9680ac3-dd39-12d1-ddbf-574c11b6ff52";
					areaNews = "dell'Area Regolazione del mercato";	
					tematica = 9;
				} else if (areaNewsletter.contains("arbitrat") || areaNewsletter.equals("10")){
					prospectListId = "bb250c90-c850-ccf7-f2f4-574c0f32e683";
					areaNews = "dell'Area Arbitrato e conciliazione";
					tematica = 10;		
				} else if (areaNewsletter.contains("sviluppo") || areaNewsletter.equals("11")){
					prospectListId = "2d4aba65-d43d-0e5a-33eb-574c1156202e";
					areaNews = "dell'Area Sviluppo sostenibile";		
					tematica = 11;										
				} else if (areaNewsletter.contains("notiziario") || areaNewsletter.equals("12")){
					prospectListId = "7d1e4005-7d84-d1b1-e950-54af914ab737";
					areaNews = "del Notiziario quindicinale";		
					tematica = 12;										
				} else {
					prospectListId = "0000000000";
					areaNews = "della Camera di Commercio";
					tematica = 0;
				}

				//Controllo se ci sono bean con E-mail= email data
				pagerCrm.set("SELECT abr.bean_id as id_acl, trim(a.email_address) as email_address,abr.bean_module as bean_module FROM sugarcrm.email_addresses a, sugarcrm.email_addr_bean_rel abr where a.id=abr.email_address_id AND a.email_address is not null AND a.deleted=0 AND abr.deleted=0 AND abr.bean_module in ('Contacts','Accounts','Leads') AND lower(trim(a.email_address))='"+ email+"'");
				nObj = pagerCrm.getNumberRecords();

				PreviewQuery prev = new PreviewQuery(connPostgres);
				SQLTransactionManager sqlMan = new SQLTransactionManager(this, connPostgres);
				if (nObj==0) { //Non c'è la email nei nostri archivi
			%>
				<p>
					Gentile utente <b> <%= email %></b>,
					</br>a seguito della richiesta di cancellazione, desideriamo comunicare che il suo indirizzo e-mail non è presente nei nostri sistemi, per cui non abbiamo provveduto alla disiscrizione. 
					<br/><br/>A disposizione per ulteriori informazioni, la invitiamo a contattarci.
					<br/><b>E-mail:</b> <a href="mailto:cancellazioni@xxx.it">cancellazioni@xxx.it</a> 
				</p> 
		<%          MailPending mail = new MailPending();
					mail.i_from="abc@xxx.it";
					mail.i_replyto="abc@xxx.it";
					mail.i_to="abc@xxx.it";
					mail.subject="***** Cancellazione automatica: INDIRIZZO INESISTENTE";
					mail.body="<div style='clear: both; overflow: hidden; width: 600px; font-family: Arial, Helvetica, sans-serif; font-size: 1em; display: block;'>"
								+"Area Newsletter: <b>" +areaNewsletter+"</b></br>"
								+"Email: <b>"+email+"</b></br>"					
								+"</div>";
					mail.page_ins="ATTNL";
					mail.submit();
				} else { //Email presente nei nostri archivi

					if (send.equals("1")){ //Cancellazione confermata
						if (!prospectListId.equals("0000000000")){
							int presente=0; 
							
							prev.setPreview("SELECT id_utente FROM " + UtenteNl.NAME_TABLE + " WHERE email='"+email+"'");		
							if (prev.getNumberRecords()>0) {
								id_utente=new Long(prev.getField("id_utente"));
								if (id_utente>0){
									sqlMan.executeCommandQuery("DELETE FROM " + AbstractDocumentoWeb.NAME_SCHEMA + ".rel_utenti_tematiche_nl WHERE id_tematica=" + tematica + " AND id_utente=" + id_utente);
								}
							}%>
				<%     	} else {
							MailPending mail = new MailPending();
							mail.i_from="abc@xxx.it";
							mail.i_replyto="abc@xxx.it";
							mail.i_to="abc@xxx.it";
							mail.subject="***** Cancellazione automatica: AREA NON TROVATA";
							mail.body="<div style='clear: both; overflow: hidden; width: 600px; font-family: Arial, Helvetica, sans-serif; font-size: 1em; display: block;'>"
										+"Area Newsletter: <b>" +areaNewsletter+"</b></br>"
										+"Email: <b>"+email+"</b></br>"					
										+"</div>";
							mail.page_ins="ATTNL";
							mail.submit();
						}%> 
				<p>
					Come da lei richiesto, abbiamo provveduto alla disiscrizione del suo indirizzo di posta <b> <%= email %></b>
					<br/>dalla newsletter <b><%= areaNews %></b>
				</p> 
				<br/><br/>
				<p>
					Grazie per la collaborazione.
				</p>
					 
				<%	} else { //Richiesta conferma di cancellazione%>

				<p>
					Gentile utente <b> <%= email %></b>,</br>
					confermi di non voler più ricevere la newsletter <b><%= areaNews %></b>?</br>
				</p>
				
				<form method="get" name="cancellazione" action="cancellazione.jsp">
					<input type="hidden" name="send" value="1">
					<input type="hidden" name="email" value="<%=email%>">
					<input type="hidden" name="areaNewsletter" value="<%=areaNewsletter%>">  
					<p>
						<input style="width:150px;margin-right:3em;" type="submit" class="btn btn-primary" name="conferma">
						<input style="width:150px;margin-right:3em;" type="button" class="btn btn-secondary" value="Annulla" name="annulla" onclick="location.href='http://www.xxx.it'">
					</p>
				</form>
							   
		<%		}
			} //end email presente nei nostri archivi
		%> 

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
<%}%>