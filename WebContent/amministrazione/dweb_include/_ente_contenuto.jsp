<form name="forminsert" enctype="multipart/form-data" method="post" action="/amministrazione/esegui_ente.jsp" class="form-control-cciaa-sm">
	<div class="form-group row">
		<label for="nome" class="col-sm-2 col-form-label"><b>Nome</b>*</label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="nome" name="nome" placeholder="Nome" required value="<%=nullToEmptyString(ente.nome)%>" /> 
		</div>
	</div>
	<div class="form-group row">
		<label for="indirizzo" class="col-sm-2 col-form-label"><b>Indirizzo</b></label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="indirizzo" name="indirizzo" placeholder="Via, num. civico - CAP - Città" value="<%=nullToEmptyString(ente.indirizzo)%>" /> 
		</div>
	</div>
	<div class="form-group row">
		<label for="provincia" class="col-sm-2 col-form-label"><b>Provincia</b></label>
		<div class="col-sm-10">
			<select class="form-control" id="provincia" name="provincia">
				<option value="" <%=(ente.provincia==null ? "selected=\"selected\"" : "")%>>Seleziona</option>
			<%	QueryPager prevProvince = new QueryPager(connPostgres);
				prevProvince.set("select sigla, nome from geografia.province order by nome");
				for(Row<String> p : prevProvince){%>	
				<option value="<%=p.getField(0) %>" <%=(ente.provincia!=null && ente.provincia.equals(p.getField(0)) ? "selected=\"selected\"" : "")%> ><%=p.getField(1)%></option>
			<%	}%>
			</select>
		</div>
	</div>
	<div class="form-group row">
		<label for="nazione" class="col-sm-2 col-form-label"><b>Nazione</b></label>
		<div class="col-sm-10">
			<select class="form-control" id="nazione" name="nazione">
				<option value="" <%=(ente.nazione==null ? "selected=\"selected\"" : "")%>>Seleziona</option>
			<%	QueryPager prevNazioni = new QueryPager(connPostgres);
				prevNazioni.set("select nome from geografia.nazioni order by nome");
				for(Row<String> p : prevNazioni){%>	
				<option value="<%=p.getField(0) %>" <%=(ente.nazione!=null && ente.nazione.equals(p.getField(0)) ? "selected=\"selected\"" : "")%> ><%=p.getField(0)%></option>
			<%	}%>
			</select>
		</div>
	</div>
	<div class="form-group row">
		<label for="tel" class="col-sm-2 col-form-label"><b>Recapito telefonico</b></label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="tel" name="tel" placeholder="Telefono/cellulare" value="<%=nullToEmptyString(ente.tel)%>" /> 
		</div>
	</div>
	<div class="form-group row">
		<label for="email" class="col-sm-2 col-form-label"><b>Email</b></label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="email" name="email" placeholder="Email@" value="<%=nullToEmptyString(ente.email)%>" /> 
		</div>
	</div>
	
	<div class="form-group row">
		<label for="img_path" class="col-sm-2 col-form-label"><b>Logo</b></label>
		<div class="col-sm-10">
			<input type="file" id="img_path" name="img_path" class="form-control">
		<%	String pathIcona=ente.img_path;
			if (pathIcona!=null && !pathIcona.equals("")){%>
			&nbsp;<a href="<%=pathIcona %>" target="_blank">Anteprima logo</a>
		<%	}%>
			<p id="fileHelpBlock" class="form-text text-muted">
				inserire un'immagine (png,jpg) di 310*210 pixel di 72dpi
			</p>
		</div>
	</div>
	<div class="form-group row">
		<label for="url" class="col-sm-2 col-form-label"><b>Sito o pagina WEB</b></label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="url" name="url" placeholder="Sito o pagina WEB" value="<%=nullToEmptyString(ente.url)%>" />
			<span class="form-text text-muted">Inserire il link nella forma http:// o https://</span>
		</div>
	</div>
	
	<div class="form-group row">
		<label for="note" class="col-sm-2 col-form-label"><b>Note</b></label>
		<div class="col-sm-10">
			<textarea id="note" name="note" class="form-control" rows="5"><%=nullToEmptyString(ente.note)%></textarea>
		</div>
	</div>	
	<div class="form-group row">
		<div class="col-sm-2 col-form-label"></div>
		<div class="col-sm-10"><button type="submit" style="width:250px;" class="btn btn-success">Salva</button></div>
	</div>
	
<%	if (inserimento_ente){%>
	<input type="Hidden" name="<%=rq_operazione %>" value="crea_ente" />
<%	}else{%>
	<input type="Hidden" name="<%=rq_ente %>" value="<%=ente.id_ente %>" />
	<input type="Hidden" name="<%=rq_operazione %>" value="salva_ente" />
<%	}%>
<%	if (pagina!=null){%>
	<input type="Hidden" name="<%=rq_documento %>" value="<%=pagina.getId() %>" />
<%	}%>
</form>
