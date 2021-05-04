<form name="forminsert" enctype="multipart/form-data" method="post" action="/amministrazione/esegui_organizzatore.jsp" class="form-control-cciaa-sm">
	
	<div class="form-group row">
		<label for="id_ente" class="col-sm-2 col-form-label"><b>Ente</b></label>
		<div class="col-sm-10">
			<select class="form-control" id="id_ente" name="id_ente">
				<option value="" <%=(org.id_ente==null ? "selected=\"selected\"" : "")%>>Seleziona</option>
			<%	for(Ente e : Ente.loadEntitiesFromQuery("select * from " + Ente.NAME_TABLE + " order by nome",connPostgres,Ente.class)){%>	
				<option value="<%=e.id_ente%>" <%=(org.id_ente!=null && org.id_ente.compareTo(e.id_ente)==0 ? "selected=\"selected\"" : "")%> ><%=e.nome%></option>
			<%	}%>
			</select>
		</div>
	</div>
	<div class="alert alert-info" role="alert"><span class="glyphicon glyphicon-info-sign" style="font-size:1.5rem;margin-right:1.2rem;"></span> L'organizzatore che cerchi non è presente nella tendina? <a href="/amministrazione/enti.htm?<%=(pagina!=null ? rq_documento+"="+pagina.getId() : "")%>" class="alert-link">Inserisci un nuovo ente.</a></div>
	<div class="form-group row">
		<label for="id_tipo_collaborazione" class="col-sm-2 col-form-label"><b>Tipo di Collaborazione</b></label>
		<div class="col-sm-10">
			<select class="form-control" id="id_tipo_collaborazione" name="id_tipo_collaborazione">	
			<%	for(TipoCollaborazione tipoCollaborazione: TipoCollaborazione.values()){%>	
				<option value="<%=tipoCollaborazione.getId() %>" <%=(org.id_tipo_collaborazione!=null && org.getTipoCollaborazione()==tipoCollaborazione ? "selected=\"selected\"" : "")%> ><%=tipoCollaborazione %></option>
			<%	}%>
			</select>
		</div>
	</div>
	
	<div class="form-group row">
		<label for="ordine" class="col-sm-2 col-form-label"><b>Ordine</b></label>
		<div class="col-sm-10">
			<input type="number" class="form-control" id="ordine" name="ordine" required value="<%=org.ordine%>" style="width:10rem;" />
		</div>
	</div>
	
	<div class="form-group row">
		<div class="col-sm-2 col-form-label"></div>
		<div class="col-sm-10">
			<button type="submit" style="width:200px;" class="btn btn-success">Salva</button>
			<button type="reset" style="width:200px;" class="btn btn-secondary" data-toggle="collapse" data-parent="#<%=(org.isInserted() ? "organizzatori" : "nuovo_organizzatore")%>" href="#organizzatore<%=(org.isInserted() ? org.id_ente : "00")%>" aria-expanded="false" aria-controls="organizzatore<%=(org.isInserted() ? org.id_ente : "00")%>">Annulla</button>
			<%	if(org.isInserted()){%>
				<a style="margin-left:5rem;width:200px;" href="/amministrazione/esegui_organizzatore.jsp?<%=rq_documento %>=<%=pagina.getId() %>&id_ente=<%=org.id_ente %>&<%=rq_operazione %>=delete" style="width:250px;" class="btn btn-danger">Elimina organizzatore</a>
			<%	}%>
		</div>
	</div>
	
	<input type="Hidden" name="<%=rq_documento %>" value="<%=pagina.getId() %>" />
	<input type="Hidden" name="id_documento_web" value="<%=pagina.getId() %>" />
	<input type="Hidden" name="<%=rq_operazione %>" value="salva" />
</form>