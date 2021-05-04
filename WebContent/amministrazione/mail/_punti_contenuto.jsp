<form name="forminsert" enctype="multipart/form-data" method="post" action="/amministrazione/mail/esegui_punti.jsp" class="form-control-cciaa-sm">
<%	if(pagina instanceof Edizione){%>	
	<div class="form-group row">
		<label for="info_data" class="col-sm-2 col-form-label"><b>Informazioni data</b></label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="info_data" name="info_data" placeholder="Data" value="<%=nullToEmptyString(punto.info_data)%>" />
			<p class="form-text text-info">
				Inserire nella forma 2 agosto 2018
			</p>
		</div>
	</div>
	<div class="form-group row">
		<label for="info_ora_inizio" class="col-sm-2 col-form-label"><b>Informazioni orario di inizio</b></label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="info_ora_inizio" name="info_ora_inizio" placeholder="nella forma 9.00" value="<%=nullToEmptyString(punto.info_ora_inizio)%>" />
			<p class="form-text text-info">
				Inserire nella forma 9.00
			</p>
		</div>
	</div>
	<div class="form-group row">
		<label for="info_ora_fine" class="col-sm-2 col-form-label"><b>Informazioni orario di fine</b></label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="info_ora_fine" name="info_ora_fine" placeholder="nella forma 13.00" value="<%=nullToEmptyString(punto.info_ora_fine)%>" />
			<p class="form-text text-info">
				Inserire nella forma 13.00
			</p>
		</div>
	</div>
<%	}%>	
	<div class="form-group row">
		<label for="titolo" class="col-sm-2 col-form-label"><b>Titolo</b></label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="titolo" name="titolo" placeholder="Titolo" value="<%=nullToEmptyString(punto.titolo)%>" />
		</div>
	</div>
	<div class="form-group row">
		<label for="testo" class="col-sm-2 col-form-label"><b>Testo</b></label>
		<div class="col-sm-10">
			<textarea id="testo" name="testo" class="body form-control" rows="5"><%=nullToEmptyString(punto.testo)%></textarea>
		</div>
	</div>
	<div class="form-group row">
		<label for="img_path" class="col-sm-2 col-form-label"><b>Immagine</b></label>
		<div class="col-sm-10">
			<input type="file" id="img_path" name="img_path" class="form-control">
		<%	pathImmagine=punto.img_path;
			if (pathImmagine!=null && !pathImmagine.equals("")){%>
			&nbsp;<a href="<%=pathImmagine %>" target="_blank">Anteprima immagine</a>
		<%	}%>
		<%	id_modal = "modalEliminaImmaginePunto"+punto.id_email_punto;
			if(punto.isInserted() && punto.img_path!=null && !punto.img_path.equals("")){%>
				- <a style="width:200px;" class="text-danger" data-toggle="modal" data-target="#<%=id_modal%>" href=""> Elimina immagine</a>
				<!--%@include file="/amministrazione/componenti/_modal_elimina_immagine_email.jsp" %--> <%//inserito a fondo pagina per non innestare una form dentro altra form %>
		<%	}%>
		</div>
	</div>
	<!--div class="form-group row">
		<label for="img_url" class="col-sm-2 col-form-label"><b>URL dell'immagine</b></label>
		<div class="col-sm-10">
			<input type="text" class="form-control" id="img_url" name="img_url" placeholder="URL" value="<%--=nullToEmptyString(punto.img_url)--%>" />
		</div>
	</div-->
	
	<div class="form-group row">
		<label for="ordine" class="col-sm-2 col-form-label"><b>Ordine</b></label>
		<div class="col-sm-10">
			<input type="number" class="form-control" id="ordine" name="ordine" required value="<%=punto.ordine%>" style="width:10rem;" />
		</div>
	</div>
	
	<div class="form-group row">
		<div class="col-sm-2 col-form-label"></div>
		<div class="col-sm-10">
			<button type="submit" style="width:200px;" class="btn btn-success">Salva</button>
			<button type="reset" style="width:200px;" class="btn btn-secondary" data-toggle="collapse" data-parent="#<%=(punto.isInserted() ? "punto" : "nuovo_punto")%>" href="#punto<%=(punto.isInserted() ? punto.id_email_punto : "00")%>" aria-expanded="false" aria-controls="punto<%=(punto.isInserted() ? punto.id_email_punto : "00")%>">Annulla</button>
			<%	id_modal = "modalEliminaPunto"+punto.id_email_punto;
				if(punto.isInserted()){
					href_redirect = "/amministrazione/mail/esegui_punti.jsp?" + rq_documento + "=" + pagina.getId() + "&" + rq_email + "=" + email.getId() + "&id_email_punto=" + punto.id_email_punto + "&" + rq_operazione + "=delete";%>
					<a class="btn btn-danger" style="margin-left:3rem;width:200px;" data-toggle="modal" data-target="#<%=id_modal%>" href=""> Elimina punto</a>
					<!--%@include file="/amministrazione/componenti/_modal_confirmation.jsp" %--> <%//inserito a fondo pagina per non innestare una form dentro altra form %>
			<%	}%>
		</div>
	</div>
	
	<%	if(punto.isInserted()){%>	
		<input type="Hidden" name="id_email_punto" value="<%=punto.id_email_punto %>" />
	<%	}%>
	<input type="Hidden" name="<%=rq_documento %>" value="<%=pagina.getId() %>" />
	<input type="Hidden" name="<%=rq_email %>" value="<%=email.getId() %>" />
	<input type="Hidden" name="id_email_web" value="<%=email.getId() %>" />
	<input type="Hidden" name="<%=rq_operazione %>" value="salva" />
</form>

<%	id_modal = "modalEliminaImmaginePunto"+punto.id_email_punto;
	if(punto.isInserted() && punto.img_path!=null && !punto.img_path.equals("")){
		doc_modal = pagina;
		form_action = "/amministrazione/mail/esegui_punti.jsp";
		form_add_input_hidden = "<input type=\"Hidden\" name=\"id_email_punto\" value=\"" + punto.id_email_punto + "\" />";
		name_field_img = "img_path";%>
		<%@include file="/amministrazione/componenti/_modal_elimina_immagine.jsp" %>
<%	}%>