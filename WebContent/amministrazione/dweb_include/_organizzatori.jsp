<%	List<Organizzatore> organizzatori = ((EdizioneInterna)pagina).getOrganizzatori();

	Organizzatore org = new Organizzatore((EdizioneInterna)pagina);
	Long id_ente = null;
	
	org.initialize(connPostgres);
	PreviewQuery prevSequenceOrg = new PreviewQuery(connPostgres);
	prevSequenceOrg.setPreview("select max(ordine) from " + Organizzatore.NAME_TABLE + " where id_documento_web="+pagina.getId());
	Long newPosOrg = 1l;
	try{
		newPosOrg = Long.parseLong(prevSequenceOrg.getField(0))+1;
	}catch(Exception e1){}
	org.ordine = newPosOrg;
%>

<div class="list-group">
	<div id="nuovo_organizzatore" role="tablist" aria-multiselectable="false">
		<div class="card">
			<div class="list-group-item list-group-item-primary" role="tab" id="organizzatoreT00">
				<div class="d-flex w-75 justify-content-between">
					<h5 class="mb-1"><a data-toggle="collapse" data-parent="#nuovo_organizzatore" href="#organizzatore00" aria-expanded="false" aria-controls="organizzatore00">Inserisci nuovo organizzatore</a></h5>
				</div>
			</div>
			<div id="organizzatore00" class="collapse" role="tabcard" aria-labelledby="organizzatore00">
				<div class="card-body" style="padding-left:5rem;">
					<%@include file="/amministrazione/dweb_include/_organizzatore_contenuto.jsp" %>
				</div>
			</div>
		</div>
	</div>

<%	if(organizzatori.size()>0){%>
	<div class="list-group-item list-group-item-success" style="margin-top:2rem;">
		<div class="d-flex w-75 justify-content-between">
			<h5 class="mb-1">Organizzatori inseriti</h5>
		</div>
	</div>
	<div id="organizzatori" role="tablist" aria-multiselectable="false">
	<%	for(Organizzatore o : organizzatori){
			org = o;
			id_ente = org.id_ente;
			Ente ente = o.getEnte();%>
		<div class="card border-light">
			<div class="card-header" role="tab" id="organizzatoreT<%=id_ente%>">
				<h5 class="card-title">
					<a data-toggle="collapse" data-parent="#organizzatori" href="#organizzatore<%=id_ente%>" aria-expanded="false" aria-controls="organizzatore<%=id_ente%>">
						<%=(org.ordine!=null ? org.ordine + ". " : "") + ente.nome + " (" + org.getTipoCollaborazione() + ")" %>
					</a>
				</h5>
			</div>
			<div id="organizzatore<%=id_ente%>" class="collapse" role="tabcard" aria-labelledby="organizzatoreT<%=id_ente%>">
				<div class="card-body" style="padding-left:5rem;">
					<%@include file="/amministrazione/dweb_include/_organizzatore_contenuto.jsp" %>
				</div>
			</div>
		</div>
		
	<%	}%>
	</div>

<%	}%>
</div>
