<%	List<EmailPunto> punti_email = email.getPunti();

	EmailPunto punto = new EmailPunto(email);
	Long id_email_punto = null;
	String pathImmagine = "";
	
	punto.initialize(connPostgres);
	PreviewQuery prevSequence = new PreviewQuery(connPostgres);
	prevSequence.setPreview("select max(ordine) from " + EmailPunto.NAME_TABLE + " where id_email_web="+email.getId());
	Long newPos = 1l;
	try{
		newPos = Long.parseLong(prevSequence.getField(0))+1;
	}catch(Exception e1){}
	punto.ordine = newPos;
%>

<div class="list-group">
	<div id="nuovo_punto" role="tablist" aria-multiselectable="false">
		<div class="card">
			<div class="list-group-item list-group-item-primary" role="tab" id="puntoT00">
				<div class="d-flex w-75 justify-content-between">
					<h5 class="mb-1"><a data-toggle="collapse" data-parent="#nuovo_punto" href="#punto00" aria-expanded="false" aria-controls="punto00"><span class="glyphicon glyphicon-plus"></span> Inserisci nuovo punto</a></h5>
				</div>
			</div>
			<div id="punto00" class="collapse" role="tabcard" aria-labelledby="punto00">
				<div class="card-body" style="padding-left:5rem;">
					<%@include file="/amministrazione/mail/_punti_contenuto.jsp" %>
				</div>
			</div>
		</div>
	</div>
	
<%	if(punti_email.size()>0){%>
	<div class="list-group-item list-group-item-success" style="margin-top:2rem;">
		<div class="d-flex w-75 justify-content-between">
			<h5 class="mb-1">Punti inseriti</h5>
		</div>
	</div>
	<div id="punto" role="tablist" aria-multiselectable="false">
	<%	for(EmailPunto p : punti_email){
			punto = p;
			id_email_punto = punto.id_email_punto;
			%>
		<div class="card border-light">
			<div class="card-header" role="tab" id="punto<%=id_email_punto%>">
				<h5 class="card-title">
					<a data-toggle="collapse" data-parent="#punto" href="#punto<%=id_email_punto%>" aria-expanded="false" aria-controls="punto<%=id_email_punto%>">
						<%=(punto.ordine!=null ? punto.ordine + ". " : "") + (punto.getInfoTempo()!=null ? punto.getInfoTempo() + " - " : "") + (punto.titolo!=null && !punto.titolo.equals("") ? punto.titolo : "Punto senza titolo") %>
					</a>
					<a data-toggle="collapse" data-parent="#punto" style="float:right;" title="modifica" href="#punto<%=id_email_punto%>" aria-expanded="false" aria-controls="punto<%=id_email_punto%>"><span style="color:green;margin-left:10px;font-size:1.2rem;" class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>
				<%	id_modal = "modalEliminaPunto"+punto.id_email_punto;
					if(punto.isInserted()){%>
						<a data-toggle="modal" data-target="#<%=id_modal%>" style="float:right;" title="elimina" href=""><span style="color:red;margin-left:10px;font-size:1.2rem;" class="glyphicon glyphicon-remove" aria-hidden="true"></span></a>
					<%	href_redirect = "/amministrazione/mail/esegui_punti.jsp?" + rq_documento + "=" + pagina.getId() + "&" + rq_email + "=" + email.getId() + "&id_email_punto=" + punto.id_email_punto + "&" + rq_operazione + "=delete";%>
						<%@include file="/amministrazione/componenti/_modal_confirmation.jsp" %>
				<%	}%>
				</h5>
			</div>
			<div id="punto<%=id_email_punto%>" class="collapse" role="tabcard" aria-labelledby="punto<%=id_email_punto%>">
				<div class="card-body" style="padding-left:5rem;">
					<%@include file="/amministrazione/mail/_punti_contenuto.jsp" %>
				</div>
			</div>
		</div>
		
	<%	}%>
	</div>

<%	}%>
</div>
