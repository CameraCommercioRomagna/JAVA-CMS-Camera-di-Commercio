<form name="forminsert" enctype="multipart/form-data" method="post" action="/amministrazione/esegui_paragrafo.jsp" class="form-control-cciaa-sm">
	<div class="form-group row">
		<label for="titolo" class="col-sm-2 col-form-label"><b>Titolo</b></label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="titolo" name="titolo" placeholder="Titolo" value="<%=nullToEmptyString(paragrafo.titolo)%>" />
		</div>
	</div>
	<div class="form-group row">
		<label for="testo" class="col-sm-2 col-form-label"><b>Testo</b></label>
		<div class="col-sm-10">
			<textarea id="testo" name="testo" class="body form-control" rows="5"><%=nullToEmptyString(paragrafo.testo)%></textarea>
		</div>
	</div>
<%	if(tipiDoc_senza_immagini_nei_paragrafi.indexOf(pagina.getTipo())==-1){%>	
	<div class="form-group row">
		<label for="img_path" class="col-sm-2 col-form-label"><b>Immagine</b></label>
		<div class="col-sm-10">
			<input type="file" id="img_path" name="img_path" class="form-control">
		<%	pathImmagine=paragrafo.img_path;
			if (pathImmagine!=null && !pathImmagine.equals("")){%>
			&nbsp;<a href="<%=pathImmagine %>" target="_blank">Anteprima immagine</a>
		<%	}%>
		<%	id_modal = "modalEliminaImmagineParagrafo"+paragrafo.id_paragrafo;
			if(paragrafo.isInserted() && paragrafo.img_path!=null && !paragrafo.img_path.equals("")){%>
				- <a style="width:200px;" class="text-danger" data-toggle="modal" data-target="#<%=id_modal%>" href=""> Elimina immagine</a>
				<!--%@include file="/amministrazione/componenti/_modal_elimina_immagine.jsp" %--> <%//aggiunta a fine pagina per non innestare una form in una form%>
		<%	}%>
		</div>
	</div>
	<div class="form-group row">
		<label for="img_url" class="col-sm-2 col-form-label"><b>URL dell'immagine</b></label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="img_url" name="img_url" placeholder="URL" value="<%=nullToEmptyString(paragrafo.img_url)%>" /> 
			<p class="form-text text-info">
				Inserire nella forma http://www.abc.it
			</p>
		</div>
	</div>
<%	}%>	
	<div class="form-group row">
		<label for="ordine" class="col-sm-2 col-form-label"><b>Ordine</b></label>
		<div class="col-sm-10">
			<input type="number" class="form-control" id="ordine" name="ordine" required value="<%=paragrafo.ordine%>" style="width:10rem;" />
		</div>
	</div>
	
	<div class="form-group row">
		<div class="col-sm-2 col-form-label"></div>
		<div class="col-sm-10">
			<button type="submit" style="width:200px;" class="btn btn-success">Salva</button>
			<button type="reset" style="width:200px;" class="btn btn-secondary" data-toggle="collapse" data-parent="#<%=(paragrafo.isInserted() ? "paragrafi" : "nuovo_paragrafo")%>" href="#paragrafo<%=(paragrafo.isInserted() ? paragrafo.id_paragrafo : "00")%>" aria-expanded="false" aria-controls="paragrafo<%=(paragrafo.isInserted() ? paragrafo.id_paragrafo : "00")%>">Annulla</button>
			<%	id_modal = "modalEliminaParagrafi"+paragrafo.id_paragrafo;
				if(paragrafo.isInserted()){%>
					<a class="btn btn-danger" style="width:200px;" data-toggle="modal" data-target="#<%=id_modal%>" href=""> Elimina paragrafo</a>
					<!--%@include file="/amministrazione/componenti/_modal_confirmation.jsp" %--> <%//aggiunta a fine pagina per non innestare una form in una form%>
			<%	}%>
		</div>
	</div>
	
	<%	if(paragrafo.isInserted()){%>	
		<input type="Hidden" name="id_paragrafo" value="<%=paragrafo.id_paragrafo %>" />
	<%	}%>
	<input type="Hidden" name="<%=rq_documento %>" value="<%=pagina.getId() %>" />
	<input type="Hidden" name="id_documento_web" value="<%=pagina.getId() %>" />
	<input type="Hidden" name="<%=rq_operazione %>" value="salva" />
</form>

<%	id_modal = "modalEliminaImmagineParagrafo"+paragrafo.id_paragrafo;
	if(paragrafo.isInserted() && paragrafo.img_path!=null && !paragrafo.img_path.equals("")){
		doc_modal = pagina;
		form_action = "/amministrazione/esegui_paragrafo.jsp";
		form_add_input_hidden = "<input type=\"Hidden\" name=\"id_paragrafo\" value=\"" + paragrafo.id_paragrafo + "\" />";
		name_field_img = "img_path";%>
		<%@include file="/amministrazione/componenti/_modal_elimina_immagine.jsp" %>
<%	}%>