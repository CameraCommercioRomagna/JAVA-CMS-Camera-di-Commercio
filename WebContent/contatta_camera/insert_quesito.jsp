<%@include file="/common/include/begin.jsp" %>
<%@include file="include/_load_pagina.jsp" %>
<%@include file="/common/jsp/datadioggi.jsp" %>

<%	StrutturaCamerale struttura=pagina.getStrutturaCamerale();%>

<!doctype html>
<html <%=tagHtmlAttributes%>>
<head>
	<%@include file="/common/struct_template/head.htm" %>
	<script type="text/javascript" src="/common/js/jquery.form.js"></script>
	<style type="text/css">
		label{
			font-weight:bold;
			float:left; 
			width:175px; 
			text-align:left;
		}
		.MultiFile-label{
				clear:both;
				margin:10px 0;
			}
		textarea {
			font-size: 12px;
	}
	</style>
	<script src="/common/js/Controlli.js" type="text/javascript" language="javascript"></script>
	<script src="/common/js/multifile-master/jquery.MultiFile.js" type="text/javascript" language="javascript"></script>
<%	if(operatore_nl!=null){%>
	<script type="text/javascript">
	function check(){
			var ritorno=false;
			var rag_soc=$("#f_s_rag_sociale_impresa").val();
			var testo=$("#f_s_testo_quesito").val();
			var oggetto=$("#f_s_oggetto").val();
			var sigla_REA=$("#sigla_REA").val();
			var numero_rea=$("#numero_rea").val();
			var f_s_num_rea=$("#f_s_num_rea").val();
			if (rag_soc!='')
				if ($("[name=nuovaImpresa]").is(':checked'))
					if ($("[name=nuovaImpresa]:checked").val()=='1' ||( sigla_REA!=''&& numero_rea!=''))
						if($("[name=nuovaImpresa]:checked").val()=='1' || $("#numero_rea").val()!='' && ControllaInt(numero_rea))
							if($("[name=nuovaImpresa]:checked").val()=='1' ||numero_rea.length==6)
								if (oggetto!='')	
									if (testo!=''){
										ritorno=true;
										$("#f_s_num_rea").val(sigla_REA + numero_rea);
									}else
										alert("Immettere un testo per il quesito");
								else
									alert("Inserire un oggetto inerente l'argomento del quesito");
							else
								alert("In numero REA deve essere composto da 6 cifre")
						else
							alert("Il campo del REA deve essere numerico")
					else
						alert("Inserire il numero REA dell'impresa") ;
				else
					alert("Indicare se nuova impresa");
			else
				alert("Immettere la Ragione Sociale dell'impresa");

			return ritorno;
		}
		/*$(function() { // wait for document to load 
			$('#f_f_allegato').MultiFile({
				max:3,
				STRING: {
					remove: '<img src="/imgs/foglio_scaduto.gif" height="16" width="16" alt="Elimina"/>',
					toomany: 'Il numero massimo di file consentito è (max: $max)'
				}
				
			});
		});*/
		$(function(){
		  // cache these!
		  var radioButton = $("[name=nuovaImpresa]"),
			  label = $("#sigla_REA");
			  num_rea = $("[for=sigla_REA]");
			  numero_rea = $("#numero_rea");
		  
		  radioButton.change(function () { 
			if($(this).val()=="0" ) { 
				num_rea.show();
				numero_rea.show();
				label.show()
			}else{
				num_rea.hide();
				numero_rea.hide();
				label.hide();
			}
		  });
		});
	</script>
	<%	}%>
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
				<h1>Contatta il Registro Imprese</h1>
				<h2>Quesito online</h2>

		<%	if(new Date().before(DateUtils.stringToDate("27/12/2018", "dd/MM/yyyy"))){%>
				<div style="color:red; margin:20px 0; font-size:14px;">
					Si informa che il giorno 24 dicembre 2018 la Camera di Commercio della Romagna - Forlì-Cesena e Rimini sarà chiusa.<br/>
					Per la trattazione dei quesiti inoltrati dopo le ore 13:00 del giorno 21/12/2018 sarà necessario attendere il giorno 27 dicembre 2018.
				</div>
		<%	}%>
		<%	if(new Date().before(DateUtils.stringToDate("03/06/2020", "dd/MM/yyyy"))){%>
				<div style="color:red; margin:20px 0; font-size:14px;">
					<b>AVVISO IMPORTANTE</b> <br/>
					Lunedì 1 giugno e martedì 2 giugno (Festa della Repubblica) la Camera di commercio della Romagna - Forlì-Cesena e Rimini sarà chiusa.
					Conseguentemente, ai quesiti inviati dopo le ore 13 del giorno 29 maggio 2020 potrà essere data risposta solo a partire dal giorno 3 giugno 2020.
				</div>
		<%	}%>
				
		<%	if(operatore_nl==null){%>
				<p>
					Per accedere al servizio è necessario identificarsi.<br/>
					Se non possiedi username e password<br/> <a class="btn btn-primary" role="button" href="/newsletter/iscrizione.htm?<%=urlwrapper.toQueryString("back") %>" title="Nuova registrazione">Registrati ora</a> è gratuito!<br/><br/>
				</p>
				<div style="margin-left:2em;">
					<form id="login" method="post" action="/newsletter/redirect.jsp" class="form-control-cciaa-sm">
						<fieldset id="Autenticazione">
							<legend><h4><b>Autenticazione utente</b></h4></legend>
							<div class="form-group row">
								<label for="email" class="col-sm-2 col-form-label"><b>e-mail</b></label>
								<div class="col-sm-5">
									<input type="text" name="email" id="email" size="30" tabindex="1" autocomplete="email" class="form-control" />
								</div>
							</div>
							<div class="form-group row">
								<label for="password" class="col-sm-2 col-form-label"><b>password</b></label>
								<div class="col-sm-5">
									<input type="password" name="password" id="password" size="30" tabindex="2" autocomplete="current-password" class="form-control"/>
									<input type="hidden" name="login" value="1" />
									<input type="hidden" name="fwd" value="<%=urlwrapper %>" />
								</div>
								<div class="col-sm-3">
									<input type="submit" name="Submit" value="Entra" tabindex="3" class="btn btn-primary" style="margin-left:30px;width:10em;" />
								</div>
							</div>
						</fieldset>
					</form>
					<br/>
					<b>Attenzione sessione temporizzata</b> <br/>
					Una volta eseguito l'accesso al sistema avrai a disposizione 2 ore di tempo per completare la procedura.
					
					
				</div>
				<br/>
				<h3><span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true" style="font-size:1.2em;margin-right:5px;"></span> Hai dimenticato username e password? <a href="/newsletter/recupero.htm?<%=urlwrapper.toQueryString("back") %>" title="Richiedi username e password">Richiedili via email</a></h3>
	
		<%	}else{
				Long id_quesito_new = null;
				try{
					id_quesito_new=Long.parseLong(request.getParameter("ID_q"));
				}catch(Exception e1){
					PreviewQuery prevSequence = new PreviewQuery(connPostgres);
					try{
						prevSequence.setPreview("select nextVal('" + AbstractDocumentoWeb.NAME_SCHEMA + ".id_quesito_upload')");
						id_quesito_new = Long.parseLong(prevSequence.getField(0));
					}catch(Exception e){
					}
				}%>
				
				<form enctype="multipart/form-data" data-toggle="validator" class="form-control-cciaa-sm" name="quesito" id="quesito" method="post" action="/servlet/ExecuteUpdateUploadServletPostgresCdC" onsubmit="return check(this)" >
					<fieldset id="quesito1">
						<legend>Utente connesso</legend>
						<p>
							<b>Nome e cognome:</b> <%=operatore_nl.getIdentita()%> (e-mail: <%=operatore_nl.email%>)<br/>
							<%	if((operatore_nl.organizzazione!=null)&&(!operatore_nl.organizzazione.equals(""))){%>
								<b>Impresa:</b> <%=operatore_nl.organizzazione%><br/>
							<%	}%>
							<br/>
							<span class="glyphicon glyphicon-list-alt" aria-hidden="true" style="margin-right:10px;"></span><a href="utente/quesiti.htm?<%=urlwrapper.toQueryString("back") %>" title="Accedi ai questiti già inviati">Accedi all'elenco dei questiti precedentemente inviati</a><br/>
							<br/>
						</p>
					</fieldset>	
					<fieldset id="quesito2">
						<legend>Impresa interessata al quesito</legend>
						<p>Inserire di seguito i dati richiesti, il testo del quesito e un eventuale allegato.</p>
						
						<div class="form-group row">
							<label for="f_s_rag_sociale_impresa" class="col-sm-3 col-form-label"><b>Ragione sociale impresa*</b></label>
							<div class="col-sm-9">
								<input class="form-control" type="text" size="80px" id="f_s_rag_sociale_impresa" name="f_s_rag_sociale_impresa" value=""/>
							</div>
						</div>
						<div class="form-group row">
							<label for="nuovaImpresa" class="col-sm-3 col-form-label"><b>Nuova Impresa</b></label>
							<div class="col-sm-9">
								<input type="radio" name="nuovaImpresa" id="nuovaImpresa1" value="1"/> S&#236;
								<input type="radio" name="nuovaImpresa" id="nuovaImpresa0" value="0" checked="checked"/> No
							</div>
						</div>
						<div class="form-group row">
							<label for="sigla_REA" class="col-sm-3 col-form-label"><b>Indicare il Numero REA*</b></label>
							<div class="col-sm-9">
								<select class="form-control" name="sigla_REA" id="sigla_REA">
									<option value="">Seleziona sigla</option>
									<option value="FO">FO</option>
									<option value="RN">RN</option>
								</select>
								<input class="form-control" type="number" size="40px" id="numero_rea" name="numero_rea"/>
							</div>
						</div>
					</fieldset>
					<fieldset id="quesito3">
						<legend>Quesito</legend>
						<div class="form-group row">
							<label for="f_n_id_cc_argomento" class="col-sm-3 col-form-label"><b>Argomento</b></label>
							<div class="col-sm-9">
							<%	PreviewQuery prevCCArgomenti=new PreviewQuery(connPostgres);
								prevCCArgomenti.setPreview("select id_cc_argomento, descrizione from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_argomenti where id_area_servizio=34 and visibile order by (CASE WHEN descrizione like 'Altro' THEN 'xxxxx' ELSE descrizione END) asc");%>
								<select class="form-control" name="f_n_id_cc_argomento" id="f_n_id_cc_argomento">
									<option value="">Seleziona l'argomento di pertinenza</option>
							<%	for(int i=0; i<prevCCArgomenti.getNumberRecords(); i++){%>
									<option value="<%=prevCCArgomenti.getField("id_cc_argomento")%>"/><%=prevCCArgomenti.getField("descrizione")%></option>
								<%	prevCCArgomenti.nextRecord();
								}%>
								</select>
							</div>
						</div>
						<div class="form-group row">
							<label for="f_s_oggetto" class="col-sm-3 col-form-label"><b>Oggetto del quesito* </b></label>
							<div class="col-sm-9">
								<input placeholder="Inserisci l'oggetto" class="form-control" type="text" size="70px" id="f_s_oggetto" name="f_s_oggetto"/>
							</div>
						</div>
						<div class="form-group row">
							<label for="f_s_testo_quesito" class="col-sm-3 col-form-label"><b>Descrivere sinteticamente il quesito* </b></label>
							<div class="col-sm-9">
								<textarea id="f_s_testo_quesito" name="f_s_testo_quesito" rows="10" cols="85" class="form-control"></textarea>
							</div>
						</div>
						<div class="form-group row">
							<label for="allegati" class="col-sm-3 col-form-label"><b>Allegato</b></label>
							<div class="col-sm-9">
								<input class="form-control" type="file" name="f_f_allegato_f0" id="f_f_allegato_f0"/>
							<%	String uploadDirectory="/upload/quesiti/" + id_quesito_new + "/";%>
								<input class="form-control" type="hidden" name="upd" value="<%=uploadDirectory %>" />
							</div>
						</div>
					</fieldset>
					<br/>
					<p>* Campi obbligatori</p>
					
					<p style="text-align:center;">
						<input style="width:250px;margin-right:3em;" type="submit" class="btn btn-success" name="Inserisci" value="Salva">
					</p>
					<input type="hidden" name="f_n_id_quesito" value="nextVal('<%=AbstractDocumentoWeb.NAME_SCHEMA%>.id_quesito')" />
					<input type="hidden" name="f_n_id_quesito_upload" value="<%=id_quesito_new%>" />
					<input type="hidden" name="f_n_id_area_servizio" value="34" />
					<input type="hidden" name="f_n_id_utente" value="<%=operatore_nl.id_utente%>">
					<input type="hidden" name="f_n_id_stato" value="1">
					<input type="hidden" name="f_s_num_rea" id="f_s_num_rea" >
					<input type="hidden" name="f_n_data_inserimento" value="current_timestamp">
					<input type="hidden" name="table" value="<%=AbstractDocumentoWeb.NAME_SCHEMA%>.cc_quesiti" />
					<input type="hidden" name="op" value="I">
					<input type="hidden" name="pagefwd" value="/contatta_camera/fine_insert.htm?id_quesito_upload=<%=id_quesito_new%>"/ >
					<input type="hidden" name="connection" value="CdCRomagnaPostgres-Postgres" />
					
				</form>
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