<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@include file="/amministrazione/_load_pagina.jsp" %>
<%@include file="_header_auth.jsp" %>

<!doctype html>

<%	if (!smistatoreQuesiti){	// Accesso alla pagina consentito solo agli smistatori!!
		response.sendRedirect("/amministrazione/registroimprese/contatta_cdc/quesiti.jsp");
	}else{
		Long id_quesito=null;
		if(request.getParameter("ID_q")!=null){
			id_quesito=Long.parseLong(request.getParameter("ID_q"));
		}else{%>
		<jsp:forward page="quesiti.jsp"/>
	<%	}

		PreviewQuery prev=new PreviewQuery(connPostgres);
		prev.setPreview("select u.id_utente, u.nome, u.cognome, u.email, rua.id_autorizzazione from " + Utente.NAME_TABLE + " u, " + AbstractDocumentoWeb.NAME_SCHEMA + ".rel_utenti_autorizzazioni rua where u.id_utente=rua.id_utente and rua.id_autorizzazione in (" + Autorizzazione.CC_OPERATORE.getId() + ", " + Autorizzazione.CC_AMMINISTRATORE.getId() + ", " + Autorizzazione.CC_SMISTATORE.getId() + ") order by lower(u.cognome)" );
		//out.println(prev);%>
	
	<%	PreviewQuery quesito=new PreviewQuery(connPostgres);
		quesito.setPreview("select q.rag_sociale_impresa, q.num_rea, q.id_stato, to_char(q.data_inserimento, 'DD-MM-YYYY') as data_inserimento, q.data_assegnazione, q.id_area_interesse, q.id_utente,  q.testo_quesito, sq.nome, q.id_operatore, q.da_validare, q.id_amministratore, q.id_cc_argomento, q.note_operatore from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_quesiti q, " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_stati_quesito sq where q.id_stato=sq.id_stato and id_quesito=" + id_quesito );
		//out.println(quesito);
	
		long statoQuesito=-1;
		try{
			statoQuesito=Long.parseLong(quesito.getField("id_stato"));
		}catch(Exception e){}%>
	
	
<%@include file="/common/jsp/datadioggi.jsp" %>

<head>
<%@include file="/amministrazione/common/struct_template/head.htm" %>
<style type="text/css"></style>
<script type="text/javascript">
function setUtenti(form){
	if (form.f_n_id_operatore.value==""){
		alert("Occorre assegnare il quesito ad un operatore");
		return false;
	}else{
		form.pagefwd_id_new_operatore.value=form.f_n_id_operatore.value;
		if (form.f_n_id_amministratore.value==""){
			//form.f_n_id_amministratore.value=form.f_n_id_operatore.value;
			alert("Occorre assegnare il quesito ad un amministratore");
			return false;
		}
		return true;
	}
}
//]]>
</script>
<style type="text/css">
		.form-padding{padding-top:0; padding-bottom:0;}
		.form-group {margin-bottom: .5rem;}
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
				<h1>Assegna operatività</h1>
				<%@include file="_quesito_dati_query.jsp" %>
				<%@include file="_quesito_dati.jsp" %>

				<%	boolean assegnatoAmm=!quesito.getField("id_amministratore").equals("");
					boolean assegnatoOp=!quesito.getField("id_operatore").equals("");%>

				<br/>
				<h3>ASSEGNA AMMINISTRATORE E OPERATORE</h3>

				<%	if(assegnatoAmm&&assegnatoOp){%>
					<p>Quesito già assegnato sia ad amministratore che a operatore</p>
				<%	}else{
						if(assegnatoAmm && !assegnatoOp){%>
						<p>Assegnato Amministratore ma operatore ancora da assegnare</p>
					<%	}else{%>
						<p>Quesito non ancora assegnato</p>
					<%	}
					}%>
		
				<form name="assegna_op" id="assegna_op" method="post" action="/servlet/ExecuteUpdateServletPostgresCdC" onsubmit="return setUtenti(this)" class="form-control-cciaa-sm">
					<fieldset id="assegna_op">
						<div class="form-group row">
							<label for="f_n_id_amministratore" class="col-sm-3 col-form-label form-padding">Seleziona l'amministratore del quesito</label>
							<div class="col-sm-9">
								<select name="f_n_id_amministratore" id="f_n_id_amministratore" class="form-control form-control-sm form-padding" style="width:25rem;">
									<option value="">Seleziona amministratore</option>
					<%	for(int j=0; j<prev.getNumberRecords(); j++){
							if(prev.getField("id_autorizzazione").equals(String.valueOf(Autorizzazione.CC_AMMINISTRATORE.getId()))){
								//boolean isUtenteLoggato=prev.getField("id_utente").equals(String.valueOf(operatore.id_utente));
								boolean isAmministratore=prev.getField("id_utente").equals(quesito.getField("id_amministratore"));%> 
									<option value="<%=prev.getField("id_utente")%>" <%if(assegnatoAmm && isAmministratore){%> selected <%}%>/><%=prev.getField("cognome")%> <%=prev.getField("nome")%> </option>
						<%	}
							prev.nextRecord();
						}%>
								</select>
							</div>
						</div>
					<%	prev.resetPrinting();%>
						<div class="form-group row">
							<label for="f_n_id_operatore" class="col-sm-3 col-form-label form-padding">Seleziona l'operatore che risponderà al quesito</label>
							<div class="col-sm-9">
								<select name="f_n_id_operatore" id="f_n_id_operatore" class="form-control form-control-sm form-padding" style="width:25rem;">
									<option value="">Seleziona operatore</option>
					<%	for(int i=0; i<prev.getNumberRecords(); i++){
							//boolean isUtenteLoggato=prev.getField("id_utente").equals(String.valueOf(operatore.id_utente));
							boolean isOperatore=prev.getField("id_utente").equals(quesito.getField("id_operatore"));%>
									<option value="<%=prev.getField("id_utente")%>" <%if(assegnatoOp && isOperatore){%> selected <%}%>/>
							<%=prev.getField("cognome")%> <%=prev.getField("nome")%>
							<%--if(prev.getField("id_autorizzazione").equals(String.valueOf(Autorizzazione.CC_AMMINISTRATORE.getId())))){%> (Amministratore)<%	}%>
							<%	if(prev.getField("id_autorizzazione").equals(String.valueOf(Autorizzazione.CC_SMISTATORE.getId())))){%> (Smistatore)<%	}--%>
									</option>
						<%	prev.nextRecord();
					
						}%>
								</select>
							</div>
						</div>
					<%	boolean da_validare=false;
						if(quesito.getField("da_validare").equals("true")){da_validare=true;}%>
						<div class="form-group row">
							<label for="f_b_da_validare" class="col-sm-3 col-form-label">Risposta da validare da parte dell'amministratore di area?</label>
							<div class="col-sm-9">
								<input type="radio" name="f_b_da_validare" id="f_b_da_validare" value="true" <%	if(da_validare){%>checked="checked"<%}%>/> Sì 
								<input type="radio" name="f_b_da_validare" id="f_b_da_validare" value="false" <% if(!da_validare){%>checked="checked"<%}%>/> No
							</div>	
						</div>
						
						<div class="form-group row">
							<label for="f_n_id_cc_argomento" class="col-sm-3 col-form-label form-padding">Argomenti</label>
					<%	PreviewQuery prevAInteressi=new PreviewQuery(connPostgres);
						prevAInteressi.setPreview("select id_cc_argomento, descrizione from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_argomenti where id_area_servizio=34 and visibile order by (CASE WHEN descrizione ilike 'Altro' THEN 'xxxxx' ELSE descrizione END) asc");
						//out.println(prevAInteressi);%>
							<div class="col-sm-9">
								<select name="f_n_id_cc_argomento" id="f_n_id_cc_argomento" class="form-control form-control-sm form-padding" style="width:35rem;">
									<option value="">Seleziona argomento</option>
					<%	if(prevAInteressi.getNumberRecords()>0){
							for(int i=0; i<prevAInteressi.getNumberRecords(); i++){%>
									<option value="<%=prevAInteressi.getField("id_cc_argomento")%>" <%if(quesito.getField("id_cc_argomento")!=null && quesito.getField("id_cc_argomento").equals(prevAInteressi.getField("id_cc_argomento"))){%> selected <%}%>/><%=prevAInteressi.getField("descrizione")%></option>
							<%	prevAInteressi.nextRecord();
							}%>
					<%	}%>
							</select>
							</div>
						</div>
						
						<div class="form-group row">
							<label for="f_s_note_operatore" class="col-sm-3 col-form-label">Note per l'operatore</label>
							<div class="col-sm-9">
								<textarea rows="10"  style="width:35rem;" id="f_s_note_operatore" name="f_s_note_operatore" class="form-control form-control-sm form-padding"><%=quesito.getField("note_operatore")%></textarea>
							</div>
						</div>
						<div class="form-group row">
							<div class="col-sm-3"></div>
							<div class="col-sm-9">
								<input style="width:150px;margin-right:3em;" type="submit" class="btn btn-success btn-sm" name="Inserisci" value="Assegna">
							</div>
						</div>
					</fieldset>

					<input type="hidden" name="op" value="U">
					<input type="hidden" name="table" value="<%=AbstractDocumentoWeb.NAME_SCHEMA%>.cc_quesiti" />
					<input type="hidden" name="f_n_id_stato" value="<%=(statoQuesito>2 ? statoQuesito : 2)%>" />
					<%if(quesito.getField("data_assegnazione").equals("")){%>
						<input type="hidden" name="f_n_data_assegnazione" value="current_timestamp" />
					<%}%>
					<input type="hidden" name="f_n_id_user_smistatore" value="<%=operatore.id_utente%>" />
					<input type="hidden" name="condition" value="id_quesito=<%=id_quesito%>"/>
					
					<input type="hidden" name="pagefwd" value="/amministrazione/registro_imprese/contatta_cdc/mail_assegnazione.jsp" >
					<input type="hidden" name="pagefwd_id_quesito" value="<%=id_quesito%>" >
					<input type="hidden" name="pagefwd_id_old_operatore" value="<%=quesito.getField("id_operatore") %>" >
					<input type="hidden" name="pagefwd_id_new_operatore" value="" >
					<input type="hidden" name="pagefwd_back" value="<%=backwrapper.getResourceName() %>" ><%
					Map<String, List<String>> parsBack=backwrapper.getParameters();
					for (String par: parsBack.keySet()){
						for (String value: parsBack.get(par)){%>
						<input type="hidden" name="pagefwd_back_<%=par %>" value="<%=value %>" ><%
						}
					}%>
					<input type="hidden" name="connection" value="CdCRomagnaPostgres-Postgres" />
				</form>

				<br/>
				<h4 style="text-align:center; font-size:1rem;"><a href="<%=backwrapper %>"><b>Torna all'elenco quesiti</b></a></h4>
			
			</div>
		</div>
	</main>

</body>
</html>

<%	}	// chiude else di: if (!smistatoreQuesiti)%>