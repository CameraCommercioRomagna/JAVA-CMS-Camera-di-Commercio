<form name="forminsert" method="post" action="/amministrazione/esegui.jsp" class="form-control-cciaa-sm">
	<div class="form-group row">
		<label for="data_inserimento" class="col-sm-2 col-form-label"><b>Data inserimento</b></label>
		<div class="col-sm-10"><%=(pagina.data_inserimento != null ? cise.utils.DateUtils.formatTime(pagina.data_inserimento) : "") %></div>
	</div>
	<div class="form-group row">
		<label for="data_modifica" class="col-sm-2 col-form-label"><b>Data ultima modifica</b></label>
		<div class="col-sm-10"><%=(pagina.data_modifica != null ? cise.utils.DateUtils.formatTime(pagina.data_modifica) : "") %></div>
	</div>
	<div class="form-group row">
		<label for="id_proprietario" class="col-sm-2 col-form-label"><b>Proprietario</b></label>
		<div class="col-sm-10"><%=(pagina.getProprietario() != null ? pagina.getProprietario().getIdentita() : "") %></div>
	</div>

	<div class="form-group row">
		<label for="data_pubblicazione" class="col-sm-2 col-form-label"><b>Data pubblicazione</b></label>
		<div class="col-sm-10">
			<input type="date" class="form-control" id="data_pubblicazione" name="data_pubblicazione" onchange="$('#data_scadenza').attr('min',this.value)" required value="<%=(pagina.data_pubblicazione != null ? cise.utils.DateUtils.formatDate(pagina.data_pubblicazione,"yyyy-MM-dd") : "") %>" />
		</div>
	</div>
	<div class="form-group row">
		<label for="data_scadenza" class="col-sm-2 col-form-label"><b>Data scadenza</b></label>
		<div class="col-sm-10">
			<input type="date" class="form-control" id="data_scadenza" name="data_scadenza" required <%	if((pagina instanceof Edizione) && ((Edizione)pagina).getDal()!=null){%>max="<%=cise.utils.DateUtils.formatDate(((Edizione)pagina).getDal(),"yyyy-MM-dd")%>"<%	}%> <%=(pagina.data_pubblicazione != null ? "min=\"" + cise.utils.DateUtils.formatDate(pagina.data_pubblicazione,"yyyy-MM-dd") + "\"" : "") %> value="<%=(pagina.data_scadenza != null ? cise.utils.DateUtils.formatDate(pagina.data_scadenza,"yyyy-MM-dd") : "") %>" />
		<%	if(pagina instanceof Edizione){%>
			<p class="form-text text-info">
				la data di scadenza deve essere minore o uguale alla data prevista di inizio edizione (vedi dati scheda "Contenuto" - campo "dal")
			</p>
		<%	}%>		
		</div>
	</div>
	<div class="form-group row">
		<label for="anno_pertinenza" class="col-sm-2 col-form-label"><b>Anno pertinenza</b></label>
		<div class="col-sm-10">
			<input type="number" class="form-control" id="anno_pertinenza" name="anno_pertinenza" placeholder="Inserisci anno pertinenza aaaa" value="<%=(pagina.anno_pertinenza != null ? pagina.anno_pertinenza : "") %>" />
		</div>
	</div>
	<%if(operatoreComitatoDiRedazione){%>
	<div class="form-group row">
		<label for="priorita" class="col-sm-2 col-form-label"><b>Priorità</b></label>
		<div class="col-sm-10 form-inline">
			<div class="form-check" style="padding-right:2rem;">
				<label class="form-check-label">
					<input type="radio" class="form-check-input" id="priorita" name="priorita" value="0" <%=(pagina.priorita!=null && pagina.priorita.compareTo(new Long(0l))==0 ? "checked" : "") %> /> Nulla
				</label>
			</div>
			<div class="form-check" style="padding-right:2rem;">
				<label class="form-check-label">
					<input type="radio" class="form-check-input" id="priorita" name="priorita" value="1" <%=(pagina.priorita!=null && pagina.priorita.compareTo(new Long(1l))==0 ? "checked" : "") %> /> Bassa
				</label>
			</div>
			<div class="form-check" style="padding-right:2rem;">
				<label class="form-check-label">
					<input type="radio" class="form-check-input" id="priorita" name="priorita" value="2" <%=(pagina.priorita!=null && pagina.priorita.compareTo(new Long(2l))==0 ? "checked" : "") %> /> Media
				</label>
			</div>
			<div class="form-check" style="padding-right:2rem;">
				<label class="form-check-label">
					<input type="radio" class="form-check-input" id="priorita" name="priorita" value="3" <%=(pagina.priorita!=null && pagina.priorita.compareTo(new Long(3l))==0 ? "checked" : "") %> /> Alta
				</label>
			</div>
			<div class="form-check" style="padding-right:2rem;">
				<label class="form-check-label">
					<input type="radio" class="form-check-input" id="priorita" name="priorita" value="4" <%=(pagina.priorita!=null && pagina.priorita.compareTo(new Long(4l))==0 ? "checked" : "") %> /> Massima
				</label>
			</div>
		</div>
	</div>
	<%}%>
	<div class="form-group row">
		<label for="punteggio" class="col-sm-2 col-form-label"><b>Visibile in</b></label>
		<div class="col-sm-10 form-inline">
			<div class="form-check" style="padding-right:2rem;">
				<label class="form-check-label">
					<input type="radio" class="form-check-input" id="punteggio" name="punteggio" value="1" <%=(pagina.punteggio!=null && pagina.punteggio.compareTo(new Long(1l))==0 ? "checked" : "") %> /> Home Page, documento padre e collettori di documenti
				</label>
			</div>
			<div class="form-check" style="padding-right:2rem;">
				<label class="form-check-label">
					<input type="radio" class="form-check-input" id="punteggio" name="punteggio" value="0" <%=(pagina.punteggio!=null && pagina.punteggio.compareTo(new Long(0l))==0 ? "checked" : "") %> /> documento padre e collettori di documenti
				</label>
			</div>
			<div class="form-check" style="padding-right:2rem;">
				<label class="form-check-label">
					<input type="radio" class="form-check-input" id="punteggio" name="punteggio" value="-1" <%=(pagina.punteggio!=null && pagina.punteggio.compareTo(new Long(-1l))==0 ? "checked" : "") %> /> solo nei collettori di documenti
				</label>
			</div>
			<div class="form-check" style="padding-right:2rem;">
				<label class="form-check-label">
					<input type="radio" class="form-check-input" id="punteggio" name="punteggio" value="-2" <%=(pagina.punteggio!=null && pagina.punteggio.compareTo(new Long(-2l))==0 ? "checked" : "") %> /> documento nascosto
				</label>
			</div>
		</div>
	</div>
	<div class="form-group row">
		<div class="col-sm-2 col-form-label"></div>
		<div class="col-sm-10"><button type="submit" style="width:250px;" class="btn btn-success">Salva</button></div>
	</div>
	
	<input type="Hidden" name="<%=rq_documento %>" value="<%=pagina.getId() %>" />
	<input type="Hidden" name="<%=rq_operazione %>" value="salva" />
</form>
