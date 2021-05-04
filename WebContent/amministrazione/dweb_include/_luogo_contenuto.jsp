<form name="forminsert" method="post" action="/amministrazione/esegui_luogo.jsp" class="form-control-cciaa-sm">
	<div class="form-group row">
		<label for="nome" class="col-sm-2 col-form-label"><b>Nome</b>*</label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="nome" name="nome" placeholder="Nome" required value="<%=nullToEmptyString(luogo.nome)%>" /> 
		</div>
	</div>
	<div class="form-group row">
		<label for="indirizzo" class="col-sm-2 col-form-label"><b>Indirizzo</b></label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="indirizzo" name="indirizzo" placeholder="Via, num. civico - CAP" value="<%=nullToEmptyString(luogo.indirizzo)%>" /> 
		</div>
	</div>
	<div class="form-group row">
		<label for="citta" class="col-sm-2 col-form-label"><b>Città</b></label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="citta" name="citta" placeholder="Città" value="<%=nullToEmptyString(luogo.citta)%>" /> 
		</div>
	</div>
	<div class="form-group row">
		<label for="provincia" class="col-sm-2 col-form-label"><b>Provincia</b></label>
		<div class="col-sm-10">
			<select class="form-control" id="provincia" name="provincia">
				<option value="" <%=(luogo.provincia==null ? "selected=\"selected\"" : "")%>>Seleziona</option>
			<%	QueryPager prevProvince = new QueryPager(connPostgres);
				prevProvince.set("select sigla, nome from geografia.province order by nome");
				for(Row<String> p : prevProvince){%>	
				<option value="<%=p.getField(0) %>" <%=(luogo.provincia!=null && luogo.provincia.equals(p.getField(0)) ? "selected=\"selected\"" : "")%> ><%=p.getField(1)%></option>
			<%	}%>
			</select>
		</div>
	</div>
	<div class="form-group row">
		<label for="citta" class="col-sm-2 col-form-label"><b>Disabilita visualizzazione mappa</b></label>
		<div class="col-sm-10">
			<input type="checkbox" style="width:10px; " id="no_gmaps" name="no_gmaps" value="true" <%=luogo.no_gmaps!=null && luogo.no_gmaps ? "checked=\"checked\"" : ""%> /> 
		</div>
	</div>
	<div class="form-group row">
		<label for="note" class="col-sm-2 col-form-label"><b>Note</b></label>
		<div class="col-sm-10">
			<textarea id="note" name="note" class="form-control" rows="5"><%=nullToEmptyString(luogo.note)%></textarea>
		</div>
	</div>	
	<div class="form-group row">
		<div class="col-sm-2 col-form-label"></div>
		<div class="col-sm-10"><button type="submit" style="width:250px;" class="btn btn-success">Salva</button></div>
	</div>
	
<%	if (inserimento_luogo){%>
	<input type="Hidden" name="<%=rq_operazione %>" value="crea_luogo" />
<%	}else{%>
	<input type="Hidden" name="<%=rq_luogo %>" value="<%=luogo.id_luogo %>" />
	<input type="Hidden" name="<%=rq_operazione %>" value="salva_luogo" />
<%	}%>
<%	if (pagina!=null){%>
	<input type="Hidden" name="<%=rq_documento %>" value="<%=pagina.getId() %>" />
<%	}%>
</form>
