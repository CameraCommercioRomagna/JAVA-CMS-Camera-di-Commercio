<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@include file="/amministrazione/_load_pagina.jsp" %>
<%@include file="_header_auth.jsp" %>

<!doctype html>

<%@page import="java.util.Date"%>

<%@page import="java.util.Calendar" %> 
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.text.ParseException " %>

<%@page import="cise.db.constants.FieldConstants" %> 

<%!	class TimerDifferenze {
		private Date d1;
		private Date d2;

		public Long days;
		public Long hours;
		public Long minutes;
		
		public TimerDifferenze(String data){
			this(null, data);
		}
		
		public TimerDifferenze(String data1, String data2){
			SimpleDateFormat formatter=new SimpleDateFormat(FieldConstants.FORMAT_DATE_HOUR_JAVA);
			Date today=new Date();
			
			try{
				d1=getDate(formatter, data1);
			}catch(Exception e){
				d1=today;
			}
			
			try{
				d2=getDate(formatter, data2);
			}catch(Exception e){
				d2=today;
			}
			
			difference();
		}	
		
		private Date getDate(SimpleDateFormat formatter, String data) throws ParseException {
			return formatter.parse(data.replaceAll("-","/"));
		}
		
		private void difference(){
			long msecDiff=d1.getTime() - d2.getTime();
			
			// 86400000 = # millis in un giorno ;3600000 = # millis in un ora
			days= msecDiff /(86400000);
			hours= (msecDiff - (86400000 * days))/(1000*60*60);
			minutes= (msecDiff - (86400000*days) - (3600000*hours))/60000;
		}
		
		public String toString(){
			return days + " g, " + hours + " h, " + minutes + " m";
		}
	}%>

<%	String emailUtenteNLConnesso=null;%>

<%@include file="_query_ricerca_quesiti.jsp" %>

<%@include file="/common/jsp/datadioggi.jsp" %>
<%@include file="/common/jsp/dayleft.jsp" %>

<html lang="it">

<head>
<%@include file="/amministrazione/common/struct_template/head.htm" %>
	<style type="text/css">
		label{float:left; width:220px; text-align:left;}
		.form-padding{padding-top:0; padding-bottom:0;}
		.form-group {margin-bottom: .5rem;}
		.table td, .table th { padding: .2rem;}
	</style>
</head>

<body>
<%@include file="/amministrazione/common/struct_template/header.htm" %>
	<main class="main-content-admin">
		<div class="row">
			
			<div class="col-md-3 col-sm-4 col-xl-2 order-sm-2" style="padding-left:0px !IMPORTANT;">
				<%@include file="/amministrazione/common/struct_template/menu_sx.htm" %>
			</div>
			
			<div class="col-md-9 col-sm-8 col-xl-10 order-first order-sm-2 border-gray">
				
				<h1><span class="glyphicon glyphicon-search" aria-hidden="true" style="margin-right:10px;"></span> Quesiti</h1>

				<h4>Imposta i criteri di selezione</h4>
				<form name="ricerca" action="<%=request.getServletPath() %>" method="get" class="form-control-cciaa-sm">
					<div class="form-group row">
						<label for="rag_sociale" class="col-sm-3 col-form-label form-padding"><b>Ricerca per testo contenuto:</b></label>
						<div class="col-sm-9">
							<input type="text" name="rag_sociale" value="<%=(rag_sociale!=null ? rag_sociale : "") %>" style="width:30rem;" class="form-control form-control-sm form-padding" />
						</div>
					</div>
					<div class="form-group row">
						<label for="n_quesito" class="col-sm-3 col-form-label form-padding"><b>Numero quesito:</b></label>
						<div class="col-sm-9">
							<input type="text" name="n_quesito" value="<%=(n_quesito!=null ? n_quesito : "") %>"  style="width:10rem;" class="form-control form-control-sm form-padding" />
						</div>
					</div>
					<div class="form-group row">
						<label for="email_inseritore" class="col-sm-3 col-form-label form-padding"><b>Ricerca per email utente inseritore:</b></label>
						<div class="col-sm-9">
							<input type="text" name="email_inseritore" value="<%=(email_inseritore!=null ? email_inseritore : "") %>" style="width:20rem; display:inline;" class="form-control form-control-sm form-padding" />&nbsp;&nbsp;
							<a href="/amministrazione/utenti_registrati/">Ricerca utenti registrati ai servizi online</a>
						</div>
					</div>
					<div class="form-group row">
						<label for="inserito_dal" class="col-sm-2 col-form-label form-padding"><b>Inserito dal</b></label>
						<div class="col-sm-2">
							<input type="text" name="inserito_dal" value="<%=(inserito_dal!=null ? inserito_dal : "") %>" class="form-control form-control-sm form-padding" style="width:10rem;" />
						</div>
						<label for="inserito_dal" class="col-sm-1 col-form-label form-padding"><b>al</b></label>
						<div class="col-sm-7">
							<input type="text" name="inserito_al" value="<%=(inserito_al!=null ? inserito_al : "") %>" class="form-control form-control-sm form-padding" style="width:10rem;" />
						</div>
					</div>
					<div class="form-group row">
						<label for="assegnato_dal" class="col-sm-2 col-form-label form-padding"><b>Assegnato dal</b></label>
						<div class="col-sm-2">
							<input type="text" name="assegnato_dal" value="<%=(assegnato_dal!=null ? assegnato_dal : "") %>" class="form-control form-control-sm form-padding" style="width:10rem;" />
						</div>
						<label for="assegnato_al" class="col-sm-1 col-form-label"><b>al</b></label>
						<div class="col-sm-7">
							<input type="text" name="assegnato_al" value="<%=(assegnato_al!=null ? assegnato_al : "") %>" class="form-control form-control-sm form-padding" style="width:10rem;" />
						</div>
					</div>
					<div class="form-group row">
						<label for="chiuso_dal" class="col-sm-2 col-form-label form-padding"><b>Chiuso dal</b></label>
						<div class="col-sm-2">
							<input type="text" size="20" name="chiuso_dal" value="<%=(chiuso_dal!=null ? chiuso_dal : "") %>" class="form-control form-control-sm form-padding" style="width:10rem;" />
						</div>
						<label for="chiuso_al" class="col-sm-1 col-form-label"><b>al</b></label>
						<div class="col-sm-7">
							<input type="text" size="20" name="chiuso_al" value="<%=(chiuso_al!=null ? chiuso_al : "") %>" class="form-control form-control-sm form-padding" style="width:10rem;" />
						</div>
					</div>
					<div class="form-group row">
						<label for="stato" class="col-sm-2 col-form-label form-padding"><b>Stato quesito:</b></label>
						<div class="col-sm-10">
							<input type="checkbox" name="stato" value="1" <% if (stato.equals("") || statiList.contains("1")){%> checked="checked" <%}%> /> <span>In attesa di assegnazione <% if (operatore.authorizedFor(Autorizzazione.CC_AMMINISTRATORE) || operatore.authorizedFor(Autorizzazione.CC_SMISTATORE)){%><span style="font-size:11px;"><%=prevStati.getField("attesa")%> quesiti</span><%}%></span>
							<input type="checkbox" name="stato" value="2" <% if (stato.equals("") || statiList.contains("2")){%> checked="checked" <%}%> style="margin-left:2rem;" /> <span>Assegnato <% if (operatore.authorizedFor(Autorizzazione.CC_AMMINISTRATORE) || operatore.authorizedFor(Autorizzazione.CC_SMISTATORE)){%><span style="font-size:11px;"><%=prevStati.getField("assegnato")%> quesiti </span><%}%></span>
							<input type="checkbox" name="stato" value="3" <% if (stato.equals("") || statiList.contains("3")){%> checked="checked" <%}%> style="margin-left:2rem;" /> <span>In trattazione <% if (operatore.authorizedFor(Autorizzazione.CC_AMMINISTRATORE) || operatore.authorizedFor(Autorizzazione.CC_SMISTATORE)){%><span style="font-size:11px;"><%=prevStati.getField("trattazione")%> quesiti </span><%}%></span>
							<input type="checkbox" name="stato" value="4" <% if (stato.equals("") || statiList.contains("4")){%> checked="checked" <%}%> style="margin-left:2rem;" /> <span>Completato <% if (operatore.authorizedFor(Autorizzazione.CC_AMMINISTRATORE) || operatore.authorizedFor(Autorizzazione.CC_SMISTATORE)){%><span style="font-size:11px;"><%=prevStati.getField("completato")%> quesiti </span><%}%></span>
						</div>
					</div>
					<div class="form-group row">
						<label for="smistatore" class="col-sm-3 col-form-label form-padding"><b>Smistatore del quesito</b></label>
						<div class="col-sm-9">
							<select name="smistatore" id="smistatore" style="width:20rem;" class="form-control form-control-sm form-padding">
								<option value="">Seleziona smistatore</option>
				<%	for(int j=0; j<user.getNumberRecords(); j++){%>
					<%	if((user.getField("id_autorizzazione").equals(Autorizzazione.CC_SMISTATORE.getId().toString())) || (user.getField("id_autorizzazione").equals(Autorizzazione.CC_AMMINISTRATORE.getId().toString()))){%> 
								<option value="<%=user.getField("id_utente")%>" <% if (user_smistatore!=null && user_smistatore.equals(user.getField("id_utente"))){%>selected="selected"<%}%>><%=user.getField("cognome")%> <%=user.getField("nome")%>
						<%	if(user.getField("id_autorizzazione").equals(Autorizzazione.CC_AMMINISTRATORE.getId().toString())){%> (Amministratore)<%}%>
								</option>
					<%	}%>
					<%	user.nextRecord();
					}%>
							</select>
						</div>
					</div>
				<%	user.resetPrinting();%>
					<div class="form-group row">
						<label for="amministratore" class="col-sm-3 col-form-label form-padding"><b>Amministratore del quesito</b></label>
						<div class="col-sm-9">
							<select name="amministratore" id="amministratore" style="width:20rem;" class="form-control form-control-sm form-padding">
								<option value="">Seleziona amministratore</option>
				<%	for(int j=0; j<user.getNumberRecords(); j++){%>
					<%	if(user.getField("id_autorizzazione").equals(Autorizzazione.CC_AMMINISTRATORE.getId().toString())){%> 
								<option value="<%=user.getField("id_utente")%>" <% if (user_amministratore!=null && user_amministratore.equals(user.getField("id_utente"))){%>selected="selected"<%}%>><%=user.getField("cognome")%> <%=user.getField("nome")%> </option>
					<%	}%>
					<%	user.nextRecord();
					}%>
						</select>
						</div>
					</div>
				<%	user.resetPrinting();%>
					<div class="form-group row">
						<label for="operatore" class="col-sm-3 col-form-label form-padding"><b>Operatore a cui è assegnato il quesito</b></label>
						<div class="col-sm-9">
							<select name="operatore" id="operatore" style="width:20rem;" class="form-control form-control-sm form-padding">
								<option value="">Seleziona operatore</option>
				<%	for(int i=0; i<user.getNumberRecords(); i++){%>
								<option value="<%=user.getField("id_utente")%>" <% if (user_operatore!=null && user_operatore.equals(user.getField("id_utente"))){%>selected="selected"<%}%>>
							<%=user.getField("cognome")%> <%=user.getField("nome")%>
					<%	if(user.getField("id_autorizzazione").equals(Autorizzazione.CC_AMMINISTRATORE.getId().toString())){%> (Amministratore)<%}%>
						<%	if(user.getField("id_autorizzazione").equals(Autorizzazione.CC_SMISTATORE.getId().toString())){%> (Smistatore)<%}%>
								</option>
					<%	user.nextRecord();
					}%>
							</select>
						</div>
					</div>

					<div class="form-group row">
						<div class="col-sm-2 col-form-label"></div>
						<div class="col-sm-10">
							<input style="width:150px;" type="submit" name="cerca" value="Cerca" class="btn btn-primary btn-sm">
						</div>
					</div>

				</form>
				
				<%	if(prevQuesiti.getNumberRecords() >0){%>
				<p style="font-size:0.8rem;">
					<b>LEGENDA:</b><br/>
					<b>att ASS</b>: Inserito da &nbsp;|&nbsp; <b>ASS in</b>: Assegnato in &nbsp;|&nbsp; <b>att TRA</b>: In attesa di trattazione da &nbsp;|&nbsp; <b>TRA in</b>: Avviata trattazione in &nbsp;|&nbsp; <b>CHI in</b>: Completato in &nbsp;|&nbsp; <b>att CHI</b>: In trattazione da  
				</p>

					<%	prevQuesiti.setPageSize(500);
						int numPagina=1;
						try{
							numPagina = Integer.parseInt(request.getParameter("page"));
							if (numPagina > prevQuesiti.getNumberPages()){
								numPagina=1;
								throw new IllegalArgumentException("Forzata una pagina inesistente");
							}
						}catch(Exception e){}%>
				<h4>
					<span class="glyphicon glyphicon-th-list" aria-hidden="true" style="margin-right:10px;"></span>
					Risultato della ricerca : <%=prevQuesiti.getNumberRecords() %>
					<%	if (prevQuesiti.getNumberPages() > 1){%>
					- Pagina <%=numPagina %> di <%=prevQuesiti.getNumberPages() %>
					<%	}%>
				</h4>	
				<div class="table-responsive">
					<table class="table table-striped table-hover" style="font-size:0.8rem;">
						<tr>
							<th style="width:20px;"></th>
							<th style="width:170px;">Inserito da</th>
							<th style="width:100px;">Inserito il</th>
							<th style="width:165px;">Tempi di gestione</th>
							<th style="width:200px;">Oggetto del quesito</th>
							<th style="width:180px;">Stato quesito</th>
							<th style="width:80px;">Chiuso il</th>
							<th style="width:50px;"></th>
						</tr>

					<%	for (Row<String> prev: prevQuesiti.getPage(numPagina)){
							String nome_amm="";
							String cognome_amm="";
							String nome_smist="";
							String cognome_smist="";
							String nome_op="";
							String cognome_op="";
							
							if(prev.getField("id_amministratore")!=null && !prev.getField("id_amministratore").equals("")){
								PreviewQuery amm=new PreviewQuery(connPostgres);
								amm.setPreview("select u.id_utente, u.nome as nome_amm, u.cognome as cognome_amm, u.email from " + Utente.NAME_TABLE + " u where u.id_utente=" + prev.getField("id_amministratore"));
								nome_amm=amm.getField("nome_amm");
								cognome_amm=amm.getField("cognome_amm");
							}
							if(prev.getField("id_user_smistatore")!=null && !prev.getField("id_user_smistatore").equals("")){
								PreviewQuery smist=new PreviewQuery(connPostgres);
								smist.setPreview("select u.id_utente, u.nome as nome_smist, u.cognome as cognome_smist, u.email from " + Utente.NAME_TABLE + " u where u.id_utente=" + prev.getField("id_user_smistatore"));
								nome_smist=smist.getField("nome_smist");
								cognome_smist=smist.getField("cognome_smist");
							}
							if(prev.getField("id_operatore")!=null && !prev.getField("id_operatore").equals("")){
								PreviewQuery op=new PreviewQuery(connPostgres);
								op.setPreview("select u.id_utente, u.nome as nome_op, u.cognome as cognome_op, u.email from " + Utente.NAME_TABLE + " u where u.id_utente=" + prev.getField("id_operatore"));
								nome_op=op.getField("nome_op");
								cognome_op=op.getField("cognome_op");
							}
							String tempi = "";
							if (prev.getField("id_stato").equals("2")){
								tempi += /*"In attesa di trattazione da "*/ "att TRA " + new TimerDifferenze(prev.getField("data_assegnazione")) + "<br/>";
								tempi += /*"Assegnato in "*/ "ASS in " + new TimerDifferenze(prev.getField("data_assegnazione"), prev.getField("data_inserimento")) + "<br/>";
							}else if (prev.getField("id_stato").equals("3")){
							   tempi += /*"In trattazione da "*/ "att CHI " + new TimerDifferenze(prev.getField("data_trattazione")) + "<br/>";               
							   tempi += /*"Avviata trattazione in "*/ "TRA in " + new TimerDifferenze(prev.getField("data_trattazione"), prev.getField("data_assegnazione")) + "<br/>";               
							   tempi += /*"Assegnato in "*/ "ASS in " + new TimerDifferenze(prev.getField("data_assegnazione"), prev.getField("data_inserimento")) + "<br/>";
							}else if (prev.getField("id_stato").equals("4")){
								String data_chiusura=(prev.getField("da_validare").equals("false") ? prev.getField("data_chiusura_op") :  prev.getField("data_chiusura_admin"));
								tempi += /*"Completato in "*/ "CHI in " + new TimerDifferenze(data_chiusura, prev.getField("data_trattazione")) + "<br/>";
								tempi += /*"Avviata trattazione in "*/ "TRA in " + new TimerDifferenze(prev.getField("data_trattazione"), prev.getField("data_assegnazione")) + "<br/>";
								tempi += /*"Assegnato in "*/ "ASS in " + new TimerDifferenze(prev.getField("data_assegnazione"), prev.getField("data_inserimento")) + "<br/>";
								
							}else{
								tempi += /*"Inserito da "*/ "att ASS " + new TimerDifferenze(prev.getField("data_inserimento")) + "<br/>";
							}%>
					
						<tr>
							<td style="padding:3px;"><%=prev.getField("id_quesito")%></td>
							<td style="padding:3px;"><%=prev.getField("nome_u")%> <%=prev.getField("cognome_u")%> per conto di <%=prev.getField("rag_sociale_impresa")%></td>
							<td style="padding:3px;"><%=prev.getField("data_inserimento")%></td>
							<td style="padding:3px;"><%=tempi %></td>
							<td style="padding:3px;"><%=org.apache.commons.lang.StringEscapeUtils.unescapeHtml(prev.getField("oggetto"))%></td>
							<td style="padding:3px;">
						<%	if(root && prev.getField("id_user_smistatore")!=null && !prev.getField("id_user_smistatore").equals("")){%> 
									(Assegnato da <%=nome_smist%> <%=cognome_smist%>)<br/>
						<%	}%>
						<%	if(prev.getField("id_amministratore")!=null && !prev.getField("id_amministratore").equals("")){%> 
									Amministrato da <%=nome_amm%> <%=cognome_amm%><br/>
						<%	}%>
							<%=prev.getField("nome")%> 
						<%	if(prev.getField("id_operatore")!=null && !prev.getField("id_operatore").equals("")){%> 
							<%	if((prev.getField("nome")).equals("assegnato")){%> a <%} else{%> da <%}%><%=nome_op%> <%=cognome_op%> 
							<%	if((prev.getField("nome")).equals("assegnato")){%> il <%=prev.getField("data_assegnazione")%> <%} else{%> dal <%}%><%=prev.getField("data_trattazione")%>
						<%	}%></td>
							
							<td style="padding:3px;">
						<%	if(prev.getField("da_validare").equals("false")){%>
								<%=prev.getField("data_chiusura_op")%>
						<%	}else{%>
								<%=prev.getField("data_chiusura_admin")%>
						<%	}%>
							</td>
							<td style="padding:3px;">
						<% long id_operatore = -1;
							try{
								id_operatore = Long.parseLong(prev.getField("id_operatore"));
							}catch(Exception e){}
							long id_amministratore = -1;
							try{
								id_amministratore = Long.parseLong(prev.getField("id_amministratore"));
							}catch(Exception e){}
							
							if(id_operatore==operatore.id_utente && prev.getField("data_chiusura_op").equals("")){%>
								<a href="visual_quesito.jsp?ID_q=<%=prev.getField("id_quesito")%>&<%=urlwrapper.toQueryString("back", false)%>" title="Inserisci una risposta"><img src="icone/gestione_visual_quesito_op.png" /></a>
						<%	}else if (id_amministratore==operatore.id_utente && ((prev.getField("da_validare").equals("false") && prev.getField("data_chiusura_op").equals(""))|| (prev.getField("da_validare").equals("true") && prev.getField("data_chiusura_admin").equals("")))){%>
								<a href="visual_quesito.jsp?ID_q=<%=prev.getField("id_quesito")%>&<%=urlwrapper.toQueryString("back", false)%>" title="Amministra il quesito"><img src="icone/gestione_visual_quesito_admin.png" /></a>
						<%	}else if((prev.getField("da_validare").equals("false") && !prev.getField("data_chiusura_op").equals(""))|| (prev.getField("da_validare").equals("true") && !prev.getField("data_chiusura_admin").equals(""))){%>
								<a href="visual_quesito.jsp?ID_q=<%=prev.getField("id_quesito")%>&<%=urlwrapper.toQueryString("back", false)%>" title="Quesito chiuso - Visualizza"><img src="icone/quesito_chiuso.png" /></a>
							<%	if(id_amministratore==operatore.id_utente){
									if((prev.getField("faq").equals(""))||(prev.getField("faq")==null)){%>
										<a href="crea_faq.jsp?ID_q=<%=prev.getField("id_quesito")%>" onclick="return confirm('Confermi la creazione di una FAQ dal quesito corrente?')" title="Crea FAQ del quesito" target="_blank"><img src="icone/FAQ.gif" /></a>
								<%	}else{%>
										<a href="/amministrazione/index.htm?<%=rq_documento%>=<%=prev.getField("faq")%>" title="Visualizza FAQ" target="_blank"><img src="icone/doc_FAQ.png" /></a>
								<%	}%>
							<%	}%>
						<%	}else{%>
								<a href="visual_quesito.jsp?ID_q=<%=prev.getField("id_quesito")%>&<%=urlwrapper.toQueryString("back", false)%>" title="Visualizza quesito"><img src="icone/foglio_anteprima.gif" /></a> 
						<%	}%>

						<%	if((smistatoreQuesiti && (!prev.getField("id_stato").equals("4"))  || (id_amministratore==operatore.id_utente && prev.getField("data_chiusura_op").equals(""))|| ( id_amministratore==operatore.id_utente && prev.getField("da_validare").equals("true") && prev.getField("data_chiusura_admin").equals("")))){%>
								<a href="assegna_operatore.jsp?ID_q=<%=prev.getField("id_quesito")%>&<%=urlwrapper.toQueryString("back", false)%>" title="Assegna quesito all'operatore"><img src="icone/interviste.gif" /></a>
						<%	}%>	
							</td>
						</tr>
					<%	}%>
					</table>
							
					<%	if (prevQuesiti.getNumberPages() > 1){
							CdCURLWrapper urlwrapperPage = new CdCURLWrapper(urlwrapper);%>
					<h5>
						<span class="glyphicon glyphicon-stop" aria-hidden="true" style="margin-right:10px;"></span>
							Vai alla pagina
						<%	for (int p=1; p<=prevQuesiti.getNumberPages(); p++){ 
								urlwrapperPage.modifyParameter("page",String.valueOf(p));%> 
								<%=(p==numPagina ? ""+p : "<a href=\"" + urlwrapperPage + "\">" + p + "</a>" ) %>
						<%	}%>
					</h5>
					<%	}%>
				</div>
			<%	}else{%>
				<h3>
					<span class="glyphicon glyphicon-th-list" aria-hidden="true" style="margin-right:10px;"></span>
					Nessun quesito trovato
				</h3>
			<%	}%>			
			</div>
		</div>
	</main>
  
</body>
</html>