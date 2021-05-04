<form name="forminsert" enctype="multipart/form-data" method="post" action="/amministrazione/mail/esegui.jsp" class="form-control-cciaa-sm">
	<div class="form-group row">
		<label for="titolo" class="col-sm-2 col-form-label"><b>Titolo</b>*</label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="titolo" name="titolo" placeholder="Titolo" maxlength="100" required value="<%=nullToEmptyString(email.titolo).replace("\"", "&quot;")%>" /> 
			<p class="form-text text-info">
				Titolo - max 100 caratteri
			</p>
		</div>
	</div>
	<div class="form-group row">
		<label for="abstract_txt" class="col-sm-2 col-form-label"><b>Abstract</b>*</label>
		<div class="col-sm-10">
			<textarea id="abstract_txt" name="abstract_txt" class="form-control" rows="5" maxlength="250"><%=nullToEmptyString(email.abstract_txt).replace("\"", "&quot;")%></textarea>
		</div>
	</div>
	
	<div class="form-group row">
		<label for="icona" class="col-sm-2 col-form-label"><b>Immagine</b></label>
		<div class="col-sm-10">
			<input type="file" id="icona" name="icona" >
		<%	String pathIcona=email.icona;
			if (pathIcona!=null && !pathIcona.equals("")){%>
			&nbsp;<a href="<%=pathIcona %>" target="_blank">Anteprima icona</a>
		<%	}%>
		<%	id_modal = "modalEliminaImmagineEmailIcona"+email.getId();
			if(email.isInserted() && email.icona!=null && !email.icona.equals("")){%>
				- <a style="width:200px;" class="text-danger" data-toggle="modal" data-target="#<%=id_modal%>" href=""> Elimina immagine</a>
				<!--%@include file="/amministrazione/componenti/_modal_elimina_immagine_email.jsp" %--> <% //aggiunto a fondo pagina per non innestare una form in una form%>
		<%	}%>
			<p class="form-text text-info">
				inserire un'immagine (png,jpg) in proporzioni 2:3(h:l) di preferibilmente 72dpi
			</p>
		</div>
	</div>
	<%	}
	
		if(pagina instanceof Edizione){%>
			<div class="form-group row">
				<label for="dal" class="col-sm-2 col-form-label"><b>Periodo</b>*</label>
				<div class="col-sm-10 form-inline">
					dal <input type="date" class="form-control" id="dal" name="dal" required onchange="$('#al').attr('min',this.value);$('#data_scadenza_iscr').attr('max',this.value);" style="width:15rem;margin-left:2rem;margin-right:2rem;" value="<%=email.dal!=null ? cise.utils.DateUtils.formatDate(email.dal, "yyyy-MM-dd") : ""%>" /> 
					al <input type="date" class="form-control" id="al" name="al" required <%=(email.dal != null ? "min=\"" + cise.utils.DateUtils.formatDate(email.dal,"yyyy-MM-dd") + "\"" : "") %> style="margin-left:2rem;margin-right:2rem;width:15rem;" value="<%=email.al!=null ? cise.utils.DateUtils.formatDate(email.al, "yyyy-MM-dd") : ""%>" />
				</div>
			</div>
			<div class="form-group row">
				<label for="indicazione_orario" class="col-sm-2 col-form-label"><b>Orario di inizio e fine</b></label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="indicazione_orario" name="indicazione_orario" placeholder="indicazioni sull'orario" value="<%=nullToEmptyString(email.indicazione_orario)%>" />
					<p class="form-text text-info">
						inseriro l'orario di inizio e fine dell'evento, ad es. 09:00-18:00, oppure 09:00-13:00 | 14:00-18:00
					</p>
				</div>
			</div>
			
			<div class="form-group row">
				<label for="note_periodo" class="col-sm-2 col-form-label"><b>Note periodo</b></label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="note_periodo" name="note_periodo" placeholder="ulteriori specifiche sul periodo" value="<%=nullToEmptyString(email.note_periodo)%>" />
					<p class="form-text text-info">
						inserire le note se è necessario specificare meglio il periodo, ad es. evento a cadenza settimanale oppure tutti i martedì ecc...
					</p>
				</div>
			</div>
			<div class="form-group row">
				<label for="id_luogo" class="col-sm-2 col-form-label"><b>Luogo</b></label>
				<div class="col-sm-10">
					<select class="form-control" id="id_luogo" name="id_luogo">
					<%	Luogo emailLuogo=email.getLuogo();%>
						<option value="" <%=(emailLuogo==null ? "selected=\"selected\"" : "")%>>Seleziona</option>
					<%	for(Luogo l : Luogo.loadEntitiesFromQuery("select * from " + Luogo.NAME_TABLE + " order by nome",connPostgres,Luogo.class)){%>	
						<option value="<%=l.id_luogo%>" <%=(emailLuogo!=null && emailLuogo.id_luogo.compareTo(l.id_luogo)==0 ? "selected=\"selected\"" : "")%> ><%=l.nome%></option>
					<%	}%>
					</select>
				</div>
			</div>
			<div class="alert alert-info" role="alert"><span class="glyphicon glyphicon-info-sign" style="font-size:1.5rem;margin-right:1.2rem;"></span> Il luogo che cerchi non è presente nella tendina? <a href="/amministrazione/luoghi.htm?<%=(pagina!=null ? rq_documento+"="+pagina.getId() : "")%>" class="alert-link">Inserisci un nuovo luogo.</a></div>
			<div class="form-group row">
				<label for="note_luogo" class="col-sm-2 col-form-label"><b>Note luogo</b></label>
				<div class="col-sm-10">
					<input type="text" class="form-control" id="note_luogo" name="note_luogo" placeholder="ulteriori specifiche sul luogo" value="<%=nullToEmptyString(email.note_luogo)%>" />
					<p class="form-text text-info">
						inserire le note se è necessario specificare meglio il luogo (ad es. il piano di una sala) oppure se il luogo non è ancora definito (luogo da difinirsi)
					</p>
				</div>
			</div>
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
	<input type="Hidden" name="<%=rq_documento %>" value="<%=pagina.getId() %>" />
	<input type="Hidden" name="<%=rq_email %>" value="<%=email.getId() %>" />
	<input type="Hidden" name="<%=rq_operazione %>" value="salva" />
</form>

<%	id_modal = "modalEliminaImmagineEmailIcona"+email.getId();
	if(email.isInserted() && email.icona!=null && !email.icona.equals("")){
		email_modal = email;
		form_action = "/amministrazione/mail/esegui.jsp";
		form_add_input_hidden = "";
		name_field_img = "icona";%>
	<%@include file="/amministrazione/componenti/_modal_elimina_immagine_email.jsp" %>