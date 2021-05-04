<form name="forminsert" method="post" action="/amministrazione/esegui.jsp" class="form-control-cciaa-sm">
	<div class="form-group row">
		<label for="id_nl_numero" class="col-sm-2 col-form-label"><b>Numero</b></label>
		<div class="col-sm-10">
			<select class="form-control" id="id_nl_numero" name="id_nl_numero" required <%=(promo.isInserted() ? "disabled" : "")%>>
				<option value="" <%=(promo.id_nl_numero==null ? "selected=\"selected\"" : "")%>>Seleziona</option>
			<%	if(promo.isInserted() && nnl_list.indexOf(numeroNewsletter)==-1)
					nnl_list.add(0, numeroNewsletter);
				for(NumeroNewsLetter nnl : nnl_list){
					if(nnl.isModificabile()){%>	
				<option value="<%=nnl.id_nl_numero%>" <%=(promo.id_nl_numero!=null && promo.id_nl_numero.compareTo(nnl.id_nl_numero)==0 ? "selected=\"selected\"" : "")%> >Newsletter del <%=cise.utils.DateUtils.formatDate(nnl.data)%></option>
				<%	}
				}%>
			</select>
		</div>
	</div>
	<div class="form-group row">
		<label for="nome" class="col-sm-2 col-form-label"><b>Sezione</b></label>
		<div class="col-sm-10">
			<select class="form-control" id="nome" name="nome" required>
				<option value="" <%=(promo.sezione==null ? "selected=\"selected\"" : "")%>>Seleziona</option>
			<%	for(Sezione sez : tipo_nl.getSezioni()){
					if(sez.valida){%>	
				<option value="<%=sez.nome%>" <%=(promo.sezione!=null && promo.sezione.equals(sez.nome) ? "selected=\"selected\"" : "")%> ><%=sez.nome%></option>
				<%	}
				}%>
			</select>
		</div>
	</div>
	
	<div class="form-group row">
		<div class="col-sm-2 col-form-label"></div>
		<div class="col-sm-10">
			<button type="submit" style="width:200px;" class="btn btn-success">Salva</button>
			<button type="reset" style="width:200px;" class="btn btn-secondary" data-toggle="collapse" data-parent="#<%=(promo.isInserted() ? "associazioneNL" : "nuova_associazioneNL")%><%=tipo_nl.id_nl_tipo%>" href="#associazioneNL<%=tipo_nl.id_nl_tipo%>-<%=(promo.isInserted() ? promo.id_nl_pubblicazione : "00")%>" aria-expanded="false" aria-controls="associazioneNL<%=tipo_nl.id_nl_tipo%>-<%=(promo.isInserted() ? promo.id_nl_pubblicazione : "00")%>">Annulla</button>
			<%	if(promo.isInserted()){%>
				<a style="margin-left:5rem;width:200px;" href="/amministrazione/esegui.jsp?<%=rq_documento %>=<%=pagina.getId() %>&id_nl_numero=<%=numeroNewsletter.id_nl_numero %>&<%=rq_operazione %>=associa_nl&<%=rq_operazione %>_associa_nl=false" style="width:250px;" class="btn btn-danger">Disassocia</a>
			<%	}%>
		</div>
	</div>
	
	<%	if(promo.isInserted()){%>	
		<input type="Hidden" name="id_nl_pubblicazione" value="<%=promo.id_nl_pubblicazione %>" />
	<%	}%>
	<input type="Hidden" name="<%=rq_documento %>" value="<%=pagina.getId() %>" />
	<input type="Hidden" name="id_documento_web" value="<%=pagina.getId() %>" />
	<input type="Hidden" name="<%=rq_operazione %>" value="associa_nl" />
	<input type="Hidden" name="<%=rq_operazione %>_associa_nl" value="true" />
</form>
