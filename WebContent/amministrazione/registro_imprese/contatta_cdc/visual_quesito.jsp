<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@include file="/amministrazione/_load_pagina.jsp" %>
<%@include file="_header_auth.jsp" %>

<!doctype html>

<% Long id_quesito=null;
	if(request.getParameter("ID_q")!=null){
		id_quesito=Long.parseLong(request.getParameter("ID_q"));
	}else{%>
		<jsp:forward page="quesiti.jsp"/>
<%	}

	boolean modifica_q = false;
	if(request.getParameter("mod")!=null && request.getParameter("mod").equals("yes")){modifica_q=true;}

	boolean nuova_risposta = false;
	boolean continua = false;
	if(request.getParameter("new_risp")!=null && request.getParameter("new_risp").equals("yes")){nuova_risposta=true;}
	if(request.getParameter("new_risp")!=null && request.getParameter("new_risp").equals("continua")){continua=true;}

	//*********MODIFICA RISPOSTA
	Long id_risposta=null;
	if(request.getParameter("ID_r")!=null){
		id_risposta=Long.parseLong(request.getParameter("ID_r"));
	}
		
	PreviewQuery risposta=new PreviewQuery(connPostgres);
	risposta.setPreview("select id_risposta, testo_risposta, allegato_f0, allegato_f1, allegato_f2, id_operatore from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_risposte where id_risposta=" + id_risposta);
	//out.println(risposta);				

	//*********RIMUOVE ALLEGATO 
	String allegato="";
	SQLTransactionManager sql = new SQLTransactionManager(this, connPostgres);
	if((request.getParameter("del")!=null)&&(request.getParameter("del").equals("yes"))){
		allegato=request.getParameter("allegato");
		sql.executeCommandQuery("update " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_risposte set allegato_"+ allegato + "= null where id_risposta= "+id_risposta );
	}
	//out.println(allegato);

	//*********CANCELLA RISPOSTA non inviata
	if((request.getParameter("delrisposta")!=null)&&(request.getParameter("delrisposta").equals("yes"))&&(id_risposta!=null)){
		sql.executeCommandQuery("delete from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_risposte where id_risposta=" + id_risposta + " and id_quesito=" + id_quesito + " and data_invio is null");
	}%>

<%//***********DATI QUESITO%>
<%@include file="_quesito_dati_query.jsp" %>
<%	PreviewQuery prev=quesitoPrev;	// Gestito per compatibilità con la versine precedente all'include della riga sopra 
%>

<%//**************RISPOSTE AL QUESITO	%>
<%@include file="_quesito_risposte_query.jsp" %>

<%	//****************STATI QUESITO
	boolean attesa = false;
	if(prev.getField("id_stato").equals("1")){
		attesa=true;
	}
	boolean assegnato = false;
	if(prev.getField("id_stato").equals("2")){
		assegnato=true;
	}
	boolean in_trattazione = false;
	if(prev.getField("id_stato").equals("3")){
		in_trattazione=true;
	}
	boolean chiuso = false;
	if((prev.getField("da_validare").equals("true") && !prev.getField("data_chiusura_admin").equals(""))|| (prev.getField("da_validare").equals("false") && !prev.getField("data_chiusura_op").equals(""))){
		chiuso=true;
	}
	boolean ultimo=false;

	boolean daValidare = false;
	if(prev.getField("da_validare").equals("true")){
		daValidare=true;
	}


	boolean hasOperatore= false;
	if((prev.getField("id_operatore")!=null) && (!prev.getField("id_operatore").equals("")))
		hasOperatore=true;
	boolean hasAmministratore= false;
	if((prev.getField("id_amministratore")!=null) && (!prev.getField("id_amministratore").equals("")))
		hasAmministratore=true;

	//***********OPERATORE
	PreviewQuery prevOp=new PreviewQuery(connPostgres);
	long id_operatore = -1;
	if (hasOperatore)
		try{
			prevOp.setPreview("select u.id_utente, u.nome, u.cognome, u.email from " + Utente.NAME_TABLE + " u where u.id_utente=" + prev.getField("id_operatore"));
			//out.println(prevOp);
			
			id_operatore = Long.parseLong(prev.getField("id_operatore"));
		}catch(Exception e){}	

	//**********AMMINISTRATORE
	PreviewQuery prevAmm=new PreviewQuery(connPostgres);
	long id_amministratore = -1;
	if (hasAmministratore)
		try{
			prevAmm.setPreview("select u.id_utente, u.nome, u.cognome, u.email from " + Utente.NAME_TABLE + " u where u.id_utente=" + prev.getField("id_amministratore"));
			//out.println(prevOp);

			id_amministratore = Long.parseLong(prev.getField("id_amministratore"));
		}catch(Exception e){}	
%>

<%@include file="/common/jsp/datadioggi.jsp" %>

<html lang="it">

<head>
<%@include file="/amministrazione/common/struct_template/head.htm" %>
<style type="text/css">
</style>
<!--script src="/common/js/jquery-1.9.1.js" type="text/javascript"></script-->
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>
<script src="/common/js/multifile-master/jquery.MultiFile.js" type="text/javascript" language="javascript"></script>
<script type="text/javscript">
$(document).ready(function(){
    $('#openForm').click(function(){
        $('#risposta').show();
    );
});
</script>
</head>

<body>
<%@include file="/amministrazione/common/struct_template/header.htm" %>
	<main class="main-content-admin">
		<div class="row">
			
			<div class="col-md-3 col-sm-4 col-xl-2 order-sm-2" style="padding-left:0px !IMPORTANT;">
				<%@include file="/amministrazione/common/struct_template/menu_sx.htm" %>
			</div>
			
			<div class="col-md-9 col-sm-8 col-xl-10 order-first order-sm-2 border-gray">
			
				<h1>Storia del quesito</h1>
				<%@include file="_quesito_dati.jsp" %>
					
				<h3>Dati della gestione</h3>
				<p class="alert alert-warning" style="font-size:0.9rem">
			<%	if(id_amministratore>0){%> 
						Amministrato da <%=prevAmm.getField("nome")%> <%=prevAmm.getField("cognome")%> <br/>
			<%	}%>

			<%	if(!chiuso && smistatoreQuesiti){%>
					<a href="assegna_operatore.jsp?ID_q=<%=id_quesito%>&<%=urlwrapper.toQueryString("back")%>" title="Assegna quesito all'operatore" id="assegna_operatore"><img src="icone/interviste.gif" style="float:none;" />
						Assegna amministratore e operatore 
					</a>
					<br/>
			<%	}%>
			<%	if(hasOperatore){%>
					Operatore attuale <%=prevOp.getField("nome")%> <%=prevOp.getField("cognome")%> <br/><br/>
			<%	}%>
			<%	if(chiuso){%><b><%}%>
					<%=prev.getField("nome")%>
			<%	if(chiuso){%></b><%}%>

			<%	if(assegnato){%>
					il <%=prev.getField("data_assegnazione")%>
			<%	}else if(in_trattazione){%>
					dal <%=prev.getField("data_trattazione")%> 
				<%	if(!prev.getField("data_assegnazione").equals("")){%> 
						<br/> 
						assegnato il <%=prev.getField("data_assegnazione")%>
				<%	}%>
					
			<%	}%>
				
			<%	if(chiuso){%>
					il <%if(prev.getField("data_chiusura_admin").equals("")){%><%=prev.getField("data_chiusura_op")%><%}else{%><%=prev.getField("data_chiusura_admin")%><%}%>
					<br/> in trattazione dal <%=prev.getField("data_trattazione")%> <br/>
					assegnato il <%=prev.getField("data_assegnazione")%>
				
				<%	if(id_amministratore==operatore.id_utente){%>	
					<form name="riapri_quesito" id="riapri_quesito" method="post" action="/servlet/ExecuteUpdateServletPostgresCdC" class="form-control-cciaa-sm">
						<fieldset id="riapri_quesito" style="border:0;">
							<input style="width:250px;" type="submit" name="Riapri quesito" value="Riapri quesito" class="btn btn-primary"/>
						</fieldset>
						<input type="hidden" name="op" value="U">
						<input type="hidden" name="table" value="<%=AbstractDocumentoWeb.NAME_SCHEMA%>.cc_quesiti" />
						<input type="hidden" name="f_n_data_chiusura_op" value="">
						<input type="hidden" name="f_n_data_chiusura_admin" value="">
						<input type="hidden" name="f_n_id_stato" value="3">
						<input type="hidden" name="condition" value="id_quesito=<%=id_quesito%>"/>
						<input type="hidden" name="pagefwd" value="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>" >
						<input type="hidden" name="connection" value="CdCRomagnaPostgres-Postgres" />
					</form>
				<%	}%>
			<%	}%>
				</p>
			<%	if(prev.getField("note_operatore")!=null && !prev.getField("note_operatore").equals("")){%>
				<p>
					<b>Note per l'operatore:</b> <%=prev.getField("note_operatore")%>
				</p>
			<%	}%>
			
			<%	if((assegnato || in_trattazione) && daValidare){%>
				<p class="alert alert-dark"><em>Necessaria validazione della risposta da parte dell'amministratore di area</em></p>
			<%	}else if(id_amministratore==operatore.id_utente && id_operatore>0 && !chiuso){%>
				<form name="assegna_op" id="assegna_op" method="post" action="/servlet/ExecuteUpdateServletPostgresCdC" class="form-control-cciaa-sm">
					<div class="form-group row">
						<label for="f_b_da_validare" class="col-sm-2 col-form-label">Risposta da validare da parte dell'amministratore di area?</label>
						<div class="col-sm-10">
							Sì<input type="radio" name="f_b_da_validare" id="f_b_da_validare" <%if(daValidare){%>checked="checked"<%}%> value="true"/>
							No<input type="radio" name="f_b_da_validare" id="f_b_da_validare" <%if(!daValidare){%>checked="checked"<%}%>  value="false"/>	
						</div>
					</div>
					<div class="form-group row">
						<label for="f_n_id_cc_argomento" class="col-sm-2 col-form-label">Argomenti</label>
				<%	PreviewQuery prevAInteressi=new PreviewQuery(connPostgres);
					prevAInteressi.setPreview("select id_cc_argomento, descrizione from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_argomenti where id_area_servizio=34 and visibile order by CASE WHEN descrizione='Altro' THEN 'xxxxx' ELSE descrizione END asc");%>
						<div class="col-sm-10">
							<select name="f_n_id_cc_argomento" id="f_n_id_area_interesse" class="form-control" style="width:500px">
								<option value="">Seleziona argomento</option>
				<%	for(int i=0; i<prevAInteressi.getNumberRecords(); i++){%>
								<option value="<%=prevAInteressi.getField(0)%>" <%if(!quesitoPrev.getField("id_cc_argomento").equals("") && quesitoPrev.getField("id_cc_argomento").equals(prevAInteressi.getField(0))){%> selected <%}%>/><%=prevAInteressi.getField("descrizione")%></option>
					<%	prevAInteressi.nextRecord();
					}%>
							</select>
						</div>
					</div>
					
					<p style="text-align:center;"><input style="width:250px;" type="submit" name="Salva" value="Salva" class="btn btn-success"/></p>
					<input type="hidden" name="op" value="U">
					<input type="hidden" name="table" value="<%=AbstractDocumentoWeb.NAME_SCHEMA%>.cc_quesiti" />
					<input type="hidden" name="condition" value="id_quesito=<%=id_quesito%>"/>
					<input type="hidden" name="pagefwd" value="/amministrazione/registro_imprese/contatta_cdc/quesiti.jsp" >
					<input type="hidden" name="connection" value="CdCRomagnaPostgres-Postgres" />
				</form>
			<%	}%> 	
			
				<h2>Risposte</h2>
			<%	if(risposte.getNumberRecords()>0){
					for (int j=1; j<=risposte.getNumberRecords(); j++){
							//***********OPERATORE RISPOSTA
						PreviewQuery prevOpRisp=new PreviewQuery(connPostgres);
						prevOpRisp.setPreview("select u.id_utente, u.nome, u.cognome, u.email from " + Utente.NAME_TABLE + " u where u.id_utente=" + risposte.getField("id_operatore"));%>
						
				<h4 style="font-size:1.1rem">Risposta inserita il <%=risposte.getField("data_inserimento")%> N° <%=risposte.getField("id_risposta")%> da <%=prevOpRisp.getField("nome")%> <%=prevOpRisp.getField("cognome")%>
					<%	if(!risposte.getField("data_invio").equals("")){%>
					- <b>Inviata all'azienda il <%=risposte.getField("data_invio")%></b>
					<%	}    %>
				</h4>
				
				<p><%=org.apache.commons.lang.StringEscapeUtils.unescapeHtml(risposte.getField("testo_risposta"))%><%=(risposte.getField("testo_risposta_1").equals("") ? "" : org.apache.commons.lang.StringEscapeUtils.unescapeHtml(risposte.getField("testo_risposta_1"))) %></p>
					<%	if((!risposte.getField("allegato_f0").equals(""))||(!risposte.getField("allegato_f1").equals(""))||(!risposte.getField("allegato_f2").equals(""))){%>
				<p>Allegati inseriti</p>
				<ul>
						<%	if(!risposte.getField("allegato_f0").equals("")){%>
					<li>
						<a href="<%=risposte.getField("allegato_f0")%>" target="_blank">Visualizza allegato 1</a> 
							<%	if((id_operatore==operatore.id_utente && risposte.getField("data_chiusura_op").equals("") && risposte.getField("data_invio").equals("")) || (id_amministratore==operatore.id_utente && !risposte.getField("data_chiusura_op").equals("") && risposte.getField("data_invio").equals(""))){%>
						<a href="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>&del=yes&allegato=F0&ID_r=<%=risposte.getField("id_risposta")%>"><img src="icone/button_elimina.jpg" style="float:none;"/></a>
							<%	}%>
					</li>
						<%	}%>
						<%	if(!risposte.getField("allegato_f1").equals("")){%>
						<li>
							<a href="<%=risposte.getField("allegato_f1")%>" target="_blank">Visualizza allegato 2</a>
							<%	if((id_operatore==operatore.id_utente && risposte.getField("data_chiusura_op").equals("") && risposte.getField("data_invio").equals("")) || (id_amministratore==operatore.id_utente && !risposte.getField("data_chiusura_op").equals("") && risposte.getField("data_invio").equals(""))){%>
							<a href="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>&del=yes&allegato=F1&ID_r=<%=risposte.getField("id_risposta")%>"><img src="icone/button_elimina.jpg" style="float:none;"/></a>
							<%	}%>
						</li>
						<%	}%>
						<%	if(!risposte.getField("allegato_f2").equals("")){%>
						<li>
							<a href="<%=risposte.getField("allegato_f2")%>" target="_blank">Visualizza allegato 3</a>
							<%	if((id_operatore==operatore.id_utente && risposte.getField("data_chiusura_op").equals("") && risposte.getField("data_invio").equals("")) || (id_amministratore==operatore.id_utente && !risposte.getField("data_chiusura_op").equals("") && risposte.getField("data_invio").equals(""))){%>
							<a href="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>&del=yes&allegato=F2&ID_r=<%=risposte.getField("id_risposta")%>"><img src="icone/button_elimina.jpg" style="float:none;"/></a>
							<%	}%>
						</li>
						<%	}%>
					</ul>
					<%	}%>
					
					<%	//if(risposte.getField("ultima").equals("true")){
						if (j==risposte.getNumberRecords() && !risposte.getField("data_invio").equals("") && !quesitoPrev.getField("data_chiusura_op").equals("")){
							ultimo=true;
						}%>
						
					<hr/>
					<% 	risposte.nextRecord();	%>
			<%		}%>
			<%	}else{%>
					<br/>Nessuna risposta ancora inserita<br/><br/>
			<%	}%>
				
			<%	risposte.resetPrinting();
				boolean puls_modifica=false;
				boolean richiesta_val=false;
				boolean risposteInviate=(risposte.getNumberRecords()>0);
				if(risposte.getNumberRecords()>0){
					for (int j=1; j<=risposte.getNumberRecords(); j++){
						risposteInviate=risposteInviate && !risposte.getField("data_invio").equals("");
						if(!modifica_q){
							if((id_operatore==operatore.id_utente && risposte.getField("data_chiusura_op").equals("")) && risposte.getField("data_invio").equals("") || (id_amministratore==operatore.id_utente && !risposte.getField("data_chiusura_op").equals("") && risposte.getField("data_invio").equals(""))){
								puls_modifica=true;%>
					<div style="float:left; width:15%;">
						<form class="form-control-cciaa-sm">
							<input type="button" class="btn btn-success" name="nuovo" value="Modifica risposta" onclick='location.href="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>&mod=yes&ID_r=<%=risposte.getField("id_risposta")%>"' />
						</form>
					</div>
							<%	if (id_amministratore==operatore.id_utente){
									// cancella solo l'amministratore del quesito 
							%>
					<div style="float:left; width:15%;">
						<form class="form-control-cciaa-sm">
							<input type="button" class="btn btn-danger" name="nuovo" value="Elimina risposta" onclick='if (confirm("Sei sicuro di voler cancellare la risposta?")){location.href="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>&delrisposta=yes&ID_r=<%=risposte.getField("id_risposta")%>";}' />
						</form>
					</div>
							<%	}
							}
							if(daValidare && id_amministratore==operatore.id_utente && !risposte.getField("data_chiusura_op").equals("") && risposte.getField("data_invio").equals("")){%>
					<div style="float:left;padding-right:30px">
						<form class="form-control-cciaa-sm" name="invia" id="ritorna_in_modifica" method="post" action="/amministrazione/registro_imprese/contatta_cdc/ritorna_in_modifica.jsp">
							<input style="width:450px;" type="submit" name="Riformula" value="Richiedi nuova formulazione all'operatore" class="btn btn-primary"/>
							<input type="hidden" name="id_quesito" value="<%=id_quesito%>"/>
							<input type="hidden" name="id_risposta" value="<%=risposte.getField("id_risposta")%>"/>
							<input type="hidden" name="pagefwd" value="/amministrazione/registro_imprese/contatta_cdc/quesiti.jsp" >
						</form>
					</div>
						<%	}
							if(
								(!daValidare && risposte.getField("DATA_INVIO").equals("") && id_operatore==operatore.id_utente)
								|| (daValidare && id_amministratore==operatore.id_utente && !risposte.getField("data_chiusura_op").equals("") && risposte.getField("data_invio").equals("")) 
								|| (daValidare && id_amministratore==operatore.id_utente && id_operatore==id_amministratore && risposte.getField("data_invio").equals(""))
							){%>
					<div style="float:left;padding-right:30px;padding-left:30px">
						<form class="form-control-cciaa-sm" name="invia" id="invia" method="post" action="/amministrazione/registro_imprese/contatta_cdc/validazione_invio.jsp">
							<input style="width:250px;" type="submit" name="Invia" value="Invia all'utente" class="btn btn-primary"/>
							<input type="hidden" name="invia" value="yes" />
							<input type="hidden" name="id_quesito" value="<%=id_quesito%>"/>
							<input type="hidden" name="id_risposta" value="<%=risposte.getField("id_risposta")%>"/>
							<input type="hidden" name="pagefwd" value="/amministrazione/registro_imprese/contatta_cdc/quesiti.jsp" >
						</form>
					</div>
						<%	}
							if(daValidare && id_operatore==operatore.id_utente && id_operatore!=id_amministratore&& risposte.getField("data_chiusura_op").equals("") && risposte.getField("data_invio").equals("")){%>
					<div style="float:left; width:30%;">
						<form class="form-control-cciaa-sm" name="richiesta_validazione" id="richiesta_validazione" method="post" action="/amministrazione/registro_imprese/contatta_cdc/validazione_invio.jsp">
							<input style="width:450px;" type="submit" name="Validazione" value="Richiedi validazione all'amministratore"  class="btn btn-primary"/>
							<input type="hidden" name="id_quesito" value="<%=id_quesito%>"/>
							<input type="hidden" name="id_admin" value="<%=id_amministratore%>">
							<input type="hidden" name="pagefwd" value="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>" >
						</form>
					</div>
						<%	}else{
								if(daValidare&& !risposte.getField("data_chiusura_op").equals("") && prev.getField("data_chiusura_admin").equals("") && id_operatore==operatore.id_utente && risposte.getField("data_invio").equals("")){
									richiesta_val=true;%>
									<p class="alert alert-dark"><em>Richiesta validazione all'amministratore</em></p>
							<%	} 
							}
						
						}
				 		risposte.nextRecord();	
					}
					if(risposte.getNumberRecords()>0 && prev.getField("data_chiusura_admin").equals("") && prev.getField("data_chiusura_op").equals("")){
						if(id_operatore==operatore.id_utente && !nuova_risposta && request.getParameter("nuova")==null && !puls_modifica && !richiesta_val && !modifica_q && !ultimo){%>
					<div style="float:left; width:20%;">
						<form class="form-control-cciaa-sm">
							<input type="button" name="nuovo" value="Inserisci nuova risposta" class="btn btn-success" onclick='location.href="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>&new_risp=yes"' />
						</form>
					</div>
					<%	}else if(!puls_modifica && id_operatore!=operatore.id_utente && !risposteInviate){%>
				
						<p class="alert alert-dark"><em>L'operatore sta elaborando la risposta</em></p>
					<%	}
					}%>
				<%	if(risposteInviate && ((id_operatore==operatore.id_utente && !daValidare) || (id_amministratore==operatore.id_utente && daValidare)) && !puls_modifica && !chiuso && !nuova_risposta && !modifica_q){%>
					<div style="float:left; width:15%;">
						<form class="form-control-cciaa-sm" name="chiudi_quesito" id="chiudi_quesito" method="post" action="/servlet/ExecuteUpdateServletPostgresCdC">
							<fieldset id="chiudi_quesito" style="border:0;">
								<input style="width:250px;" type="submit" name="Chiudi quesito" value="Chiudi quesito" class="btn btn-primary"/>
							</fieldset>
							<input type="hidden" name="op" value="U">
							<input type="hidden" name="table" value="<%=AbstractDocumentoWeb.NAME_SCHEMA%>.cc_quesiti" />
							<input type="hidden" name="f_n_data_chiusura_op" value="current_timestamp">
					<%	if(id_amministratore==operatore.id_utente && prev.getField("da_validare").equals("true")){%>
									<input type="hidden" name="f_n_data_chiusura_admin" value="current_timestamp">
					<%	}%>
							<input type="hidden" name="f_n_id_stato" value="4">
							<input type="hidden" name="condition" value="id_quesito=<%=id_quesito%>"/>
							<input type="hidden" name="pagefwd" value="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>" >
							<input type="hidden" name="connection" value="CdCRomagnaPostgres-Postgres" />
						</form>
					</div>
					
					<%	//if(id_amministratore==u.getID_Utente() && daValidare){%>
							<!--div style="float:left;">
								<form class="form-control-cciaa-sm" name="continua_nuovo" id="continua_nuovo" method="post" action="/servlet/ExecuteUpdateServletPostgresCdC">
									<fieldset id="continua_nuovo" style="border:0;">
										<input style="width:250px;" type="submit" name="Continua con nuova risposta" value="Continua con nuova risposta dell'operatore" class="btn btn-primary"/>
									</fieldset>
									<input type="hidden" name="op" value="U">
									<input type="hidden" name="table" value="<%=AbstractDocumentoWeb.NAME_SCHEMA%>.cc_risposte" />
									<input type="hidden" name="f_b_ultima" value="false">
									<input type="hidden" name="condition" value="id_quesito=<%=id_quesito%>"/>
									<input type="hidden" name="pagefwd" value="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>" >
									<input type="hidden" name="connection" value="CdCRomagnaPostgres-Postgres" />
								</form>
							</div-->
					<%	//}
					}
				}
				if((id_operatore==operatore.id_utente && prev.getField("data_chiusura_op").equals("")) || (risposte.getNumberRecords()>0 && id_amministratore==operatore.id_utente && (!risposte.getField("data_chiusura_op").equals("")) && prev.getField("data_chiusura_admin").equals(""))){
					if(prev.getField("data_trattazione").equals("")){%>
					<form class="form-control-cciaa-sm" name="avvio_trattazione" id="avvio_trattazione" method="post" action="/servlet/ExecuteUpdateServletPostgresCdC">
						<fieldset id="avvio_trattazione1" style="border:0;">
							<input style="width:350px;" type="submit" name="Inizia trattazione quesito" value="Inizia trattazione quesito" class="btn btn-primary" />
						</fieldset>
						<input type="hidden" name="op" value="U">
						<input type="hidden" name="table" value="<%=AbstractDocumentoWeb.NAME_SCHEMA%>.cc_quesiti" />
						<input type="hidden" name="f_n_id_stato" value="3" />
						<input type="hidden" name="f_n_data_trattazione" value="current_timestamp">
						<input type="hidden" name="condition" value="id_quesito=<%=id_quesito%>"/>
						<input type="hidden" name="pagefwd" value="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>" >
						<input type="hidden" name="connection" value="CdCRomagnaPostgres-Postgres" />
					</form>
				<%	}else if(modifica_q){%>
					<form enctype="multipart/form-data" name="risposta" id="risposta" method="post" action="/servlet/ExecuteUpdateUploadServletPostgresCdC" class="form-control-cciaa-sm">
						<fieldset id="risposta1">
							<legend>Modifica risposta N°<%=risposta.getField("id_risposta")%></legend>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label" for="f_s_testo_risposta">Testo della risposta*</label>
								<div class="col-sm-10">
									<textarea class="body" id="f_s_testo_risposta" name="f_s_testo_risposta" rows="10"><%=nullToEmptyString(risposta.getField("testo_risposta"))%></textarea>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label" for="allegati"><b>Allegati</b></label>
								<div class="col-sm-10">
					<%	if(risposta.getField("allegato_f0").equals("") || risposta.getField("allegato_f0")==null){%>
									<input class="form-control" type="file" id="f_f_allegato_f0" name="f_f_allegato_f0" />
					<%	}else{%>
									<a href="<%=risposta.getField("allegato_f0")%>" target="_blank">Visualizza allegato 1</a> <a href="/amministrazione/registroimprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>&del=yes&allegato=F0&ID_r=<%=risposte.getField("id_risposta")%>&mod=yes"><img src="icone/button_elimina.jpg" style="float:none;"/></a>
					<%	}
						if(risposta.getField("allegato_f1").equals("") || risposta.getField("allegato_f1")==null){%>
									<br/><br/><input class="form-control" type="file" id="f_f_allegato_f1" name="f_f_allegato_f1" />
					<%	}else{%>
									<br/><a href="<%=risposta.getField("allegato_f1")%>" target="_blank">Visualizza allegato 2</a> <a href="/amministrazione/registroimprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>&del=yes&allegato=F1&ID_r=<%=risposte.getField("id_risposta")%>&mod=yes"><img src="icone/button_elimina.jpg" style="float:none;"/></a>
					<%	}
						if(risposta.getField("allegato_f2").equals("") || risposta.getField("allegato_f2")==null){%>
									<br/><br/><input class="form-control" type="file" id="f_f_allegato_f2" name="f_f_allegato_f2" />
					<%	}else{%>
									<br/><a href="<%=risposta.getField("allegato_f2")%>" target="_blank">Visualizza allegato 3</a> <a href="/amministrazione/registroimprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>&del=yes&allegato=F2&ID_r=<%=risposte.getField("id_risposta")%>&mod=yes"><img src="icone/button_elimina.jpg" style="float:none;"/></a>
					<%	}%>
									<input  type="hidden" name="upd" value="<%="/upload/quesiti/" + id_quesito + "_R_" + id_risposta + "/" %>" /> 
								</div>
							</div>
							<p style="text-align:center;">
								<input style="width:250px;margin-right:3em;"type="submit" name="Inserisci" value="Salva" class="btn btn-success"/>
								<input style="width:250px;"type="button" class="btn btn-secondary" name="annulla" value="Annulla" onclick='location.href="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito %>"' style="margin-left:50px" />
							</p>
							<input type="hidden" name="op" value="U" />
							<input type="hidden" name="condition" value="id_risposta=<%=id_risposta%>"/>
							<input type="hidden" name="f_n_id_quesito" value="<%=id_quesito%>" />
							<input type="hidden" name="f_n_id_operatore" value="<%=id_operatore%>" />
							<input type="hidden" name="f_n_data_inserimento" value="current_timestamp" />
							<input type="hidden" name="table" value="<%=AbstractDocumentoWeb.NAME_SCHEMA%>.cc_risposte" />
							<input type="hidden" name="pagefwd" value="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>" />
							<input type="hidden" name="connection" value="CdCRomagnaPostgres-Postgres" />
						</fieldset>		
					</form>
				<%	}					
					if(nuova_risposta || ((in_trattazione) && (risposte.getNumberRecords()==0))){
						Long id_risposta_new = null;
						try{
							PreviewQuery prevSequence = new PreviewQuery(connPostgres);
							prevSequence.setPreview("select nextVal('" + AbstractDocumentoWeb.NAME_SCHEMA + ".id_risposta')");
							
							id_risposta_new = Long.parseLong(prevSequence.getField(0));
						}catch(Exception e){}%>
					<form enctype="multipart/form-data" name="risposta" id="risposta" method="post" action="/servlet/ExecuteUpdateUploadServletPostgresCdC" class="form-control-cciaa-sm">
						<fieldset id="risposta1">
							<legend>Inserisci risposta</legend>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label" for="f_s_testo_risposta">Testo della risposta *</label>
								<div class="col-sm-10">	
									<textarea class="body" id="f_s_testo_risposta" name="f_s_testo_risposta" rows="10"></textarea>
								</div>
							</div>
							<div class="form-group row">
								<label class="col-sm-2 col-form-label" for="allegati"><b>Allegati</b></label>
								<div class="col-sm-10">
									<br/><input type="file" id="f_f_allegato_f0" name="f_f_allegato_f0" class="form-control"/>
									<br/><br/><input type="file" id="f_f_allegato_f1" name="f_f_allegato_f1" class="form-control"/>
									<br/><br/><input type="file" id="f_f_allegato_f2" name="f_f_allegato_f2" class="form-control"/>
									<input  type="hidden" name="upd" value="<%="/upload/quesiti/" + id_quesito + "_R_" + id_risposta_new + "/" %>" /> 
								</div>
							</div>
							<p style="text-align:center;">
								<input style="width:250px;margin-right:3em;" type="submit" name="Inserisci" value="Salva"  class="btn btn-success"/>
								<input style="width:250px;" type="button" class="btn btn-secondary" name="annulla" value="Annulla" onclick='location.href="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito %>"' style="margin-left:50px"/>
							</p>
								<input type="hidden" name="op" value="I">
								<input type="hidden" name="f_n_id_risposta" value="<%=id_risposta_new%>" />
								<input type="hidden" name="f_n_id_quesito" value="<%=id_quesito%>" />
								<input type="hidden" name="f_n_data_inserimento" value="current_timestamp" />
								<input type="hidden" name="f_n_id_operatore" value="<%=id_operatore%>" />
								<input type="hidden" name="table" value="<%=AbstractDocumentoWeb.NAME_SCHEMA%>.cc_risposte" />
								<input type="hidden" name="pagefwd" value="/amministrazione/registro_imprese/contatta_cdc/visual_quesito.jsp?ID_q=<%=id_quesito%>&nuova=nuova" />
								<input type="hidden" name="connection" value="CdCRomagnaPostgres-Postgres" />
						</fieldset>		
					</form>
					<%	}
					}%>
				
				<br/>
				<h4 style="text-align:center; clear:both; font-size:1rem;"><a href="<%=urlwrapper.extractURL("back")==null ? "quesiti.jsp" : backwrapper %>"><b>Torna all'elenco quesiti</b></a></h4>

			</div>
		</div>
	</main>
  
</body>
</html>