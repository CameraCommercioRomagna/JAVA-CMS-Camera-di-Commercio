<%	List<PuntoProgramma> punti_programma = ((EdizioneInterna)pagina).getProgramma();

	PuntoProgramma punto = new PuntoProgramma((EdizioneInterna)pagina);
	Long id_punto = null;
	String pathImmagine = "";
	
	punto.initialize(connPostgres);
	PreviewQuery prevSequence = new PreviewQuery(connPostgres);
	prevSequence.setPreview("select max(ordine) from " + PuntoProgramma.NAME_TABLE + " where id_documento_web="+pagina.getId());
	Long newPos = 1l;
	try{
		newPos = Long.parseLong(prevSequence.getField(0))+1;
	}catch(Exception e1){}
	punto.ordine = newPos;
%>

<div class="list-group">
	<div id="nuovo_programma" role="tablist" aria-multiselectable="false">
		<div class="card">
			<div class="list-group-item list-group-item-primary" role="tab" id="programmaT00">
				<div class="d-flex w-75 justify-content-between">
					<h5 class="mb-1"><a data-toggle="collapse" data-parent="#nuovo_programma" href="#programma00" aria-expanded="false" aria-controls="programma00"><span class="glyphicon glyphicon-plus"></span> Inserisci nuovo punto del programma</a></h5>
				</div>
			</div>
			<div id="programma00" class="collapse" role="tabcard" aria-labelledby="programma00">
				<div class="card-body" style="padding-left:5rem;">
					<%@include file="/amministrazione/dweb_include/_programma_contenuto.jsp" %>
				</div>
			</div>
		</div>
	</div>
	
<%	if(punti_programma.size()>0){%>
	<div class="list-group-item list-group-item-success" style="margin-top:2rem;">
		<div class="d-flex w-75 justify-content-between">
			<h5 class="mb-1">Punti inseriti</h5>
		</div>
	</div>
	<div id="programma" role="tablist" aria-multiselectable="false">
	<%	for(PuntoProgramma p : punti_programma){
			punto = p;
			id_punto = punto.id_punto;
			%>
		<div class="card border-light">
			<div class="card-header" role="tab" id="programmaT<%=id_punto%>">
				<h5 class="card-title">
					<a data-toggle="collapse" data-parent="#programma" href="#programma<%=id_punto%>" aria-expanded="false" aria-controls="programma<%=id_punto%>">
						<%=(punto.ordine!=null ? punto.ordine + ". " : "") + (punto.getInfoTempo()!=null ? punto.getInfoTempo() + " - " : "") + (punto.titolo!=null && !punto.titolo.equals("") ? punto.titolo : "Punto programma senza titolo") %>
					</a>
					<a data-toggle="collapse" data-parent="#programma" style="float:right;" title="modifica" href="#programma<%=id_punto%>" aria-expanded="false" aria-controls="programma<%=id_punto%>"><span style="color:green;margin-left:10px;font-size:1.2rem;" class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>
				<%	id_modal = "modalEliminaPuntoProgramma"+punto.id_punto;
					if(punto.isInserted()){%>
						<a data-toggle="modal" data-target="#<%=id_modal%>" style="float:right;" title="elimina" href=""><span style="color:red;margin-left:10px;font-size:1.2rem;" class="glyphicon glyphicon-remove" aria-hidden="true"></span></a>
					<%	href_redirect = "/amministrazione/esegui_programma.jsp?" + rq_documento + "=" + pagina.getId() + "&id_punto=" + punto.id_punto + "&" + rq_operazione + "=delete";%>
						<%@include file="/amministrazione/componenti/_modal_confirmation.jsp" %>
				<%	}%>
				</h5>
			</div>
			<div id="programma<%=id_punto%>" class="collapse" role="tabcard" aria-labelledby="programmaT<%=id_punto%>">
				<div class="card-body" style="padding-left:5rem;">
					<%@include file="/amministrazione/dweb_include/_programma_contenuto.jsp" %>
				</div>
			</div>
		</div>
		
	<%	}%>
	</div>

<%	}%>
</div>
