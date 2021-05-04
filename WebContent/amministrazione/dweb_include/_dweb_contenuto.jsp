<form name="forminsert" enctype="multipart/form-data" method="post" action="/amministrazione/esegui.jsp" class="form-control-cciaa-sm">
	<div class="form-group row">
		<label for="titolo" class="col-sm-2 col-form-label"><b>Titolo</b>*</label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="titolo" name="titolo" placeholder="Titolo" maxlength="100" required value="<%=nullToEmptyString(pagina.titolo).replace("\"", "&quot;")%>" /> 
			<p class="form-text text-info">
				Titolo - max 100 caratteri
			</p>
		</div>
	</div>
	<div class="form-group row">
		<label for="abstract_txt" class="col-sm-2 col-form-label"><b>Abstract</b>*</label>
		<div class="col-sm-10">
			<textarea id="abstract_txt" name="abstract_txt" class="form-control" rows="5" maxlength="250" required><%=nullToEmptyString(pagina.abstract_txt).replace("\"", "&quot;")%></textarea>
			<p class="form-text text-info">
				Testo per la visualizzazione come news - max 250 caratteri
			</p>
		</div>
	</div>
	<div class="form-group row">
		<label for="parole_chiave" class="col-sm-2 col-form-label"><b>Parole chiave</b></label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="parole_chiave" name="parole_chiave" placeholder="Inserisci parole chiave alternate da virgole" value="<%=nullToEmptyString(pagina.parole_chiave)%>" />
		</div>
	</div>
	
	<%	if(tipiDoc_con_ins_immagine.indexOf(pagina.getTipo())>-1){%>	
	<div class="form-group row">
		<label for="icona" class="col-sm-2 col-form-label"><b>Immagine</b></label>
		<div class="col-sm-10">
			<input type="file" id="icona" name="icona" >
		<%	String pathIcona=pagina.icona;
			if (pathIcona!=null && !pathIcona.equals("")){%>
			&nbsp;<a href="<%=pathIcona %>" target="_blank">Anteprima icona</a>
		<%	}%>
		<%	id_modal = "modalEliminaImmagineDocIcona"+pagina.getId();
			if(pagina.isInserted() && pagina.icona!=null && !pagina.icona.equals("")){%>
				- <a style="width:200px;" class="text-danger" data-toggle="modal" data-target="#<%=id_modal%>" href=""> Elimina immagine</a>
				<!--%@include file="/amministrazione/componenti/_modal_elimina_immagine.jsp" %--> <% //aggiunto a fondo pagina per non innestare una form in una form%>
		<%	}%>
			<p class="form-text text-info">
				inserire un'immagine (png,jpg) in proporzioni 2:3(h:l) di preferibilmente 72dpi
			</p> 
			<script>
			var _URL = window.URL || window.webkitURL;

			$("#icona").change(function() {
				var file, img;
				var meInput=this;
				if ((file = this.files[0])) {
					img = new Image();
					img.onload = function() {
						if (this.width<310 || this.height<210){
							alert("Il file inserito non è conforme alle dimensioni minime:  " + this.width + "x" + this.height + " anzichè almeno 310x210");
							meInput.value="";
						}
					};
					img.onerror = function() {
						alert("Il file inserito non è un'immagine: " + file.type);
						meInput.value="";
					};
					img.src = _URL.createObjectURL(file);
				}
			});
			</script>
		</div>
	</div>
	<%	}%>	
	<%	/*Se sono nel caso di un download*/
		if(tipoSistemaPagina == TipoSistema.DOWNLOAD){%>
		<div class="form-group row">
			<label for="url" class="col-sm-2 col-form-label"><b>File</b>*</label>
			<div class="col-sm-10">
			<%	String pathDownload=((Download)pagina).url;%>
				<input type="file" class="form-control" id="url" name="url" <%=((pathDownload==null || pathDownload.equals(""))? "required" : "")%> />
			<%
				if (pathDownload!=null && !pathDownload.equals("")){%>
				&nbsp;<a href="<%=pathDownload %>" target="_blank">Anteprima file</a>
			<%	}%>
			</div>
		</div>
		<%	if(root && false){%>	
		<div class="form-group row">
			<label for="id_autorizzazione" class="col-sm-2 col-form-label"><b>Autorizzazione di visualizzazione</b></label>
			<div class="col-sm-10">
				<select class="form-control" id="id_autorizzazione" name="id_autorizzazione">
					<option value="" <%=(pagina.id_autorizzazione==null ? "selected=\"selected\"" : "")%>>Visibile a tutti</option>
				</select>
			</div>
		</div>
		<%	}%>	
	<%	}else if(tipoSistemaPagina == TipoSistema.LINK){%>
		<div class="form-group row">
			<label for="url" class="col-sm-2 col-form-label"><b>URL</b>*</label>
			<div class="col-sm-10">
				<input type="text" class="form-control" id="url" name="url" required placeholder="Ad esempio: http://www.sito.com/..." value="<%=nullToEmptyString(((Referenza)pagina).url)%>" />
			</div>
		</div>
		<%	if(pagina.getTipo() == TipoDocumento.SERVIZIO_ONLINE){%>
			<div class="form-group row">
				<label for="url_amministrazione" class="col-sm-2 col-form-label"><b>URL Amministrazione</b></label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="url_amministrazione" name="url_amministrazione" placeholder="Ad esempio: /amministrazione/..." value="<%=nullToEmptyString(((Referenza)pagina).url_amministrazione)%>" />
				</div>
			</div>
		<%	}%>
	<%	}else if(tipoSistemaPagina == TipoSistema.DOCUMENTO){%>
		<%	if(pagina.getTipo() == TipoDocumento.SERVIZIO_ONLINE){%>
			<!--div class="form-group row">
				<label for="url" class="col-sm-2 col-form-label"><b>URL</b>*</label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="url" name="url" placeholder="Ad esempio: http://www.sito.com/..." value="<%=nullToEmptyString(((Documento)pagina).url)%>" />
				</div>
			</div-->
			<div class="form-group row">
				<label for="url_amministrazione" class="col-sm-2 col-form-label"><b>URL Amministrazione</b></label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="url_amministrazione" name="url_amministrazione" placeholder="Ad esempio: /amministrazione/..." value="<%=nullToEmptyString(((Documento)pagina).url_amministrazione)%>" />
				</div>
			</div>
		<%	}%>
	<%	}
	
		// Sostituisce il caso del TipoSistema==EVENTO: ora le Edizioni sono sia Interne (TipoSistema==EVENTO) sia esterne (TipoSistema==LINK)
		if(pagina instanceof Edizione){
			Edizione paginaEdizione=(Edizione)pagina;%>
			<div class="form-group row">
				<label for="dal" class="col-sm-2 col-form-label"><b>Periodo</b>*</label>
				<div class="col-sm-10 form-inline">
					dal <input type="date" class="form-control" id="dal" name="dal" required onchange="$('#al').attr('min',this.value);$('#data_scadenza_iscr').attr('max',this.value);" style="width:15rem;margin-left:2rem;margin-right:2rem;" value="<%=paginaEdizione.getDal()!=null ? cise.utils.DateUtils.formatDate(paginaEdizione.getDal(), "yyyy-MM-dd") : ""%>" /> 
					al <input type="date" class="form-control" id="al" name="al" required <%=(paginaEdizione.getDal() != null ? "min=\"" + cise.utils.DateUtils.formatDate(paginaEdizione.getDal(),"yyyy-MM-dd") + "\"" : "") %> style="margin-left:2rem;margin-right:2rem;width:15rem;" value="<%=paginaEdizione.getAl()!=null ? cise.utils.DateUtils.formatDate(paginaEdizione.getAl(), "yyyy-MM-dd") : ""%>" />
				</div>
			</div>
			<div class="form-group row">
				<label for="indicazione_orario" class="col-sm-2 col-form-label"><b>Orario di inizio e fine</b></label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="indicazione_orario" name="indicazione_orario" placeholder="indicazioni sull'orario" value="<%=nullToEmptyString(paginaEdizione.getOrario())%>" />
					<p class="form-text text-info">
						inseriro l'orario di inizio e fine dell'evento, ad es. 09:00-18:00, oppure 09:00-13:00 | 14:00-18:00
					</p>
				</div>
			</div>
			
			<div class="form-group row">
				<label for="note_periodo" class="col-sm-2 col-form-label"><b>Note periodo</b></label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="note_periodo" name="note_periodo" placeholder="ulteriori specifiche sul periodo" value="<%=nullToEmptyString(paginaEdizione.getNotePeriodo())%>" />
					<p class="form-text text-info">
						inserire le note se è necessario specificare meglio il periodo, ad es. evento a cadenza settimanale oppure tutti i martedì ecc...
					</p>
				</div>
			</div>
			<div class="form-group row">
				<label for="id_luogo" class="col-sm-2 col-form-label"><b>Luogo</b></label>
				<div class="col-sm-10">
					<select class="form-control" id="id_luogo" name="id_luogo">
					<%	Luogo paginaEdizioneLuogo=paginaEdizione.getLuogo();%>
						<option value="" <%=(paginaEdizioneLuogo==null ? "selected=\"selected\"" : "")%>>Seleziona</option>
					<%	for(Luogo l : Luogo.loadEntitiesFromQuery("select * from " + Luogo.NAME_TABLE + " order by nome",connPostgres,Luogo.class)){%>	
						<option value="<%=l.id_luogo%>" <%=(paginaEdizioneLuogo!=null && paginaEdizioneLuogo.id_luogo.compareTo(l.id_luogo)==0 ? "selected=\"selected\"" : "")%> ><%=l.nome%></option>
					<%	}%>
					</select>
				</div>
			</div>
			<div class="alert alert-info" role="alert"><span class="glyphicon glyphicon-info-sign" style="font-size:1.5rem;margin-right:1.2rem;"></span> Il luogo che cerchi non è presente nella tendina? <a href="/amministrazione/luoghi.htm?<%=(pagina!=null ? rq_documento+"="+pagina.getId() : "")%>" class="alert-link">Inserisci un nuovo luogo.</a></div>
			<div class="form-group row">
				<label for="note_luogo" class="col-sm-2 col-form-label"><b>Note luogo</b></label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="note_luogo" name="note_luogo" placeholder="ulteriori specifiche sul luogo" value="<%=nullToEmptyString(paginaEdizione.getNoteLuogo())%>" />
					<p class="form-text text-info">
						inserire le note se è necessario specificare meglio il luogo (ad es. il piano di una sala) oppure se il luogo non è ancora definito (luogo da difinirsi)
					</p>
				</div>
			</div>
			
			
		<%	if(pagina instanceof EdizioneInterna){
				EdizioneInterna paginaEdizioneInterna = (EdizioneInterna)pagina;%>
				
				<div class="form-group row">
					<label for="abilita_modalita_mista" class="col-sm-2 col-form-label"><b>Evento misto (in sede e via web)?</b></label>
					<div class="col-sm-10 form-inline">
						<div class="form-check" style="padding-right:2rem;">
							<label class="form-check-label">
								<input type="radio" class="form-check-input" id="abilita_modalita_mista1" name="abilita_modalita_mista" value="true" <%=(paginaEdizioneInterna.abilita_modalita_mista!=null && paginaEdizioneInterna.abilita_modalita_mista ? "checked" : "") %> /> Si
							</label>
						</div>
						<div class="form-check">
							<label class="form-check-label">
								<input type="radio" class="form-check-input" id="abilita_modalita_mista2" name="abilita_modalita_mista" value="false" <%=(paginaEdizioneInterna.abilita_modalita_mista!=null && !paginaEdizioneInterna.abilita_modalita_mista ? "checked" : "") %> /> No
							</label>
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label for="a_pagamento" class="col-sm-2 col-form-label"><b>Evento a pagamento</b></label>
					<div class="col-sm-10 form-inline">
						<div class="form-check" style="padding-right:2rem;">
							<label class="form-check-label">
								<input type="radio" class="form-check-input" id="a_pagamento1" name="a_pagamento" value="true" <%=(paginaEdizioneInterna.a_pagamento!=null && paginaEdizioneInterna.a_pagamento ? "checked" : "") %> /> Si
							</label>
						</div>
						<div class="form-check">
							<label class="form-check-label">
								<input type="radio" class="form-check-input" id="a_pagamento2" name="a_pagamento" value="false" <%=(paginaEdizioneInterna.a_pagamento!=null && !paginaEdizioneInterna.a_pagamento ? "checked" : "") %> /> No
							</label>
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label for="iscrizione_online" class="col-sm-2 col-form-label"><b>Iscrizione online</b></label>
					<div class="col-sm-10 form-inline">
						<div class="form-check" style="padding-right:2rem;">
							<label class="form-check-label">
								<input type="radio" class="form-check-input" id="iscrizione_online1" name="iscrizione_online" value="true" <%=(paginaEdizioneInterna.iscrizione_online!=null && paginaEdizioneInterna.iscrizione_online ? "checked" : "") %> /> Si
							</label>
						</div>
						<div class="form-check">
							<label class="form-check-label">
								<input type="radio" class="form-check-input" id="iscrizione_online2" name="iscrizione_online" value="false" <%=(paginaEdizioneInterna.iscrizione_online!=null && !paginaEdizioneInterna.iscrizione_online ? "checked" : "") %> /> No
							</label>
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label for="iscrizione_online_url_ext" class="col-sm-2 col-form-label"><b>Link iscrizione online</b></label>
					<div class="col-sm-10">
						<input type="text" class="form-control" id="iscrizione_online_url_ext" name="iscrizione_online_url_ext" placeholder="Ad esempio: https://www....." value="<%=nullToEmptyString(paginaEdizioneInterna.iscrizione_online_url_ext)%>" />
						<p class="form-text text-info">
							inserire il link di iscrizione solo se è esterno al sito camerale (Es. form di google). ATTENZIONE: il link funziona se e solo se l'iscrizione online è settata a sì 
						</p>
					</div>
				</div>
				<div class="form-group row">
					<label for="data_scadenza_iscr" class="col-sm-2 col-form-label"><b>Data fine iscrizione</b></label>
					<div class="col-sm-10">
						<input type="date" class="form-control" id="data_scadenza_iscr" <%=(paginaEdizioneInterna.dal != null ? "max=\"" + cise.utils.DateUtils.formatDate(paginaEdizioneInterna.dal,"yyyy-MM-dd") + "\"" : "") %> name="data_scadenza_iscr" value="<%=paginaEdizioneInterna.data_scadenza_iscr!=null ? cise.utils.DateUtils.formatDate(paginaEdizioneInterna.data_scadenza_iscr, "yyyy-MM-dd") : ""%>" />
						<p class="form-text text-info">
							la data di fine iscrizione deve essere minore o uguale alla data prevista di inizio edizione (vedi campo "dal")
						</p>
					</div>
				</div>
				
			<%	if(root){%>
				<div class="form-group row">
					<label for="conf_iscr_note" class="col-sm-2 col-form-label"><b>Configurazione campo note form iscrizione</b></label>
					<div class="col-sm-10">
						<textarea id="conf_iscr_note" name="conf_iscr_note" class="form-control" rows="2"><%=nullToEmptyString(paginaEdizioneInterna.conf_iscr_note).replace("\"", "&quot;")%></textarea>
						<p class="form-text text-info">
							Testo che precederà il campo note nella pagina di iscrizione all'evento (se prevista). Il campo note comparirà nel form di iscrizione solo se sarà compilato questo testo. Il campo note darà quindi la possibilità di raccogliere informazioni personalizzate per evento secondo indicazioni che dovrete indicare in questo testo.
						</p>
					</div>
				</div>
				<div class="form-group row">
					<label for="conf_iscr_privacy" class="col-sm-2 col-form-label"><b>Configurazione privacy form iscrizione</b></label>
					<div class="col-sm-10">
						<textarea id="conf_iscr_privacy" name="conf_iscr_privacy" class="form-control" rows="5"><%=nullToEmptyString(paginaEdizioneInterna.conf_iscr_privacy).replace("\"", "&quot;")%></textarea>
						<p class="form-text text-info">
							Testo che sarà aggiunto alla dicitura della privacy già presente nella pagina di iscrizione all'evento.
						</p>
					</div>
				</div>
			<%	}%>
				
				<div class="form-group row">
					<label for="incontro_relatore" class="col-sm-2 col-form-label"><b>Incontro con i relatori</b></label>
					<div class="col-sm-10 form-inline">
						<div class="form-check" style="padding-right:2rem;">
							<label class="form-check-label">
								<input type="radio" class="form-check-input" id="incontro_relatore" name="incontro_relatore" value="true" <%=(paginaEdizioneInterna.incontro_relatore!=null && paginaEdizioneInterna.incontro_relatore ? "checked" : "") %> /> Si
							</label>
						</div>
						<div class="form-check">
							<label class="form-check-label">
								<input type="radio" class="form-check-input" id="incontro_relatore" name="incontro_relatore" value="false" <%=(paginaEdizioneInterna.incontro_relatore!=null && !paginaEdizioneInterna.incontro_relatore ? "checked" : "") %> /> No
							</label>
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label for="disponibilita_atti" class="col-sm-2 col-form-label"><b>Disponibilità atti</b></label>
					<div class="col-sm-10 form-inline">
						<div class="form-check" style="padding-right:2rem;">
							<label class="form-check-label">
								<input type="radio" class="form-check-input" id="disponibilita_atti" name="disponibilita_atti" value="true" <%=(paginaEdizioneInterna.disponibilita_atti!=null && paginaEdizioneInterna.disponibilita_atti ? "checked" : "") %> /> Si
							</label>
						</div>
						<div class="form-check">
							<label class="form-check-label">
								<input type="radio" class="form-check-input" id="disponibilita_atti" name="disponibilita_atti" value="false" <%=(paginaEdizioneInterna.disponibilita_atti!=null && !paginaEdizioneInterna.disponibilita_atti ? "checked" : "") %> /> No
							</label>
						</div>
					</div>
				</div>
			<%	}%>
	<%	}%>
	<div class="form-group row">
		<div class="col-sm-2 col-form-label"></div>
		<div class="col-sm-10">
			<button type="submit" style="width:250px;" class="btn btn-success">Salva</button>
		<%	if (inserimento){%>
			<a style="width:250px;" class="btn btn-secondary" href="<%=backwrapper.getPercorsoWeb(false) %>">Annulla</a>
		<%	}%>
		</div>
	</div>
	
<%	if (inserimento){%>
	<input type="Hidden" name="<%=rq_operazione %>" value="crea" />
	<input type="Hidden" name="<%=rq_operazione %>_crea_tipo_d" value="<%=pagina.id_tipo_documento_web %>" />
	<input type="Hidden" name="<%=rq_operazione %>_crea_tipo_s" value="<%=pagina.id_tipo_sistema %>" />
	<%	if (padre!=null){%>
	<input type="Hidden" name="<%=rq_documento %>" value="<%=padre.getId() %>" /><%-- serve il padre per la creazione del figlio --%>
	<%	}%>
<%	}else{%>
	<input type="Hidden" name="<%=rq_documento %>" value="<%=pagina.getId() %>" />
	<input type="Hidden" name="<%=rq_operazione %>" value="salva" />
<%	}%>
</form>

<%	id_modal = "modalEliminaImmagineDocIcona"+pagina.getId();
	if(pagina.isInserted() && pagina.icona!=null && !pagina.icona.equals("")){
		doc_modal = pagina;
		form_action = "/amministrazione/esegui.jsp";
		form_add_input_hidden = "";
		name_field_img = "icona";%>
	<%@include file="/amministrazione/componenti/_modal_elimina_immagine.jsp" %>
<%	}%>