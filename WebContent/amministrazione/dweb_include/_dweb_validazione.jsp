<form name="forminsert" method="post" action="/amministrazione/esegui.jsp" class="form-control-cciaa-sm"> 
	<%	if(pagina.valido()){%>
	<div class="form-group row">
		<label for="data_validazione" class="col-sm-2 col-form-label"><b>Data validazione</b></label>
		<div class="col-sm-10"><%=(pagina.data_validazione != null ? cise.utils.DateUtils.formatTime(pagina.data_validazione) : "") %></div>
	</div>
	<%	}%>
	<div class="form-group row">
		<label for="op_valida" class="col-sm-2 col-form-label"><b>Valido</b></label>
		<div class="col-sm-10 form-inline">
			<div class="form-check" style="padding-right:2rem;">
				<label class="form-check-label">
					<input type="radio" class="form-check-input" id="op_valida" name="op_valida" value="true" <%=(pagina.validato!=null && pagina.validato ? "checked" : "") %> /> Si
				</label>
			</div>
			<div class="form-check">
				<label class="form-check-label">
					<input type="radio" class="form-check-input" id="op_valida" name="op_valida" value="false" <%=(pagina.validato==null || !pagina.validato ? "checked" : "") %> /> No
				</label>
			</div>
		</div>
	</div>
	
	<div class="form-group row">
		<div class="col-sm-2 col-form-label"></div>
		<div class="col-sm-10"><button type="submit" style="width:250px;" class="btn btn-success">Salva</button></div>
	</div>
	
	<input type="Hidden" name="<%=rq_documento %>" value="<%=pagina.getId() %>" />
	<input type="Hidden" name="<%=rq_operazione %>" value="valida" />
</form>
