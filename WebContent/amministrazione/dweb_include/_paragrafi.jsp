<%	Paragrafo paragrafo=null;
	Long id_paragrafo = null;
	String pathImmagine = "";
	
	paragrafo = new Paragrafo((Documento)pagina);
	paragrafo.initialize(connPostgres);
	PreviewQuery prevSequence = new PreviewQuery(connPostgres);
	prevSequence.setPreview("select max(ordine) from " + Paragrafo.NAME_TABLE + " where id_documento_web="+pagina.getId());
	Long newPos = 1l;
	try{
		newPos = Long.parseLong(prevSequence.getField(0))+1;
	}catch(Exception e1){}
	paragrafo.ordine = newPos;%>

<div class="list-group">
	<div id="nuovo_paragrafo" role="tablist" aria-multiselectable="false">
		<div class="card">
			<div class="list-group-item list-group-item-primary" role="tab" id="paragrafoT00">
				<div class="d-flex w-75 justify-content-between">
					<h5 class="mb-1"><a data-toggle="collapse" data-parent="#nuovo_paragrafo" href="#paragrafo00" aria-expanded="false" aria-controls="paragrafo00"><span class="glyphicon glyphicon-plus"></span> Inserisci nuovo paragrafo</a></h5>
				</div>
			</div>
			<div id="paragrafo00" class="collapse" role="tabcard" aria-labelledby="paragrafoT00">
				<div class="card-body" style="padding-left:5rem;">
					<%@include file="/amministrazione/dweb_include/_paragrafo_contenuto.jsp" %>
				</div>
			</div>
		</div>
	</div>
	
<%	List<Paragrafo> paragrafi = ((Documento)pagina).getParagrafi();
	if(paragrafi.size()>0){%>
	<div class="list-group-item list-group-item-success" style="margin-top:2rem;">
		<div class="d-flex w-75 justify-content-between">
			<h5 class="mb-1">Paragrafi inseriti</h5>
		</div>
	</div>
	<div id="paragrafi" role="tablist" aria-multiselectable="false">
	<%	for(Paragrafo p : paragrafi){
			paragrafo = p;			
			id_paragrafo = paragrafo.id_paragrafo;%>
		<div class="card border-light">
			<div class="card-header" role="tab" id="paragrafoT<%=p.id_paragrafo%>">
				<h5 class="card-title">
					<a data-toggle="collapse" data-parent="#paragrafi" href="#paragrafo<%=id_paragrafo%>" aria-expanded="false" aria-controls="paragrafo<%=id_paragrafo%>">
						<%=(paragrafo.ordine!=null ? paragrafo.ordine + ". " : "") + (paragrafo.titolo!=null && !paragrafo.titolo.equals("") ? paragrafo.titolo : "Paragrafo senza titolo") %>
					</a>
					<a data-toggle="collapse" data-parent="#paragrafi" style="float:right;" title="modifica" href="#paragrafo<%=id_paragrafo%>" aria-expanded="false" aria-controls="paragrafo<%=id_paragrafo%>"><span style="color:green;margin-left:10px;font-size:1.2rem;" class="glyphicon glyphicon-edit" aria-hidden="true"></span></a>
				<%	id_modal = "modalEliminaParagrafi"+paragrafo.id_paragrafo;
					if(paragrafo.isInserted()){%>
						<a data-toggle="modal" data-target="#<%=id_modal%>" style="float:right;" title="elimina" href=""><span style="color:red;margin-left:10px;font-size:1.2rem;" class="glyphicon glyphicon-remove" aria-hidden="true"></span></a>
					<%	href_redirect = "/amministrazione/esegui_paragrafo.jsp?" + rq_documento + "=" + pagina.getId() + "&id_paragrafo="+ paragrafo.id_paragrafo + "&" + rq_operazione + "=delete";%>
						<%@include file="/amministrazione/componenti/_modal_confirmation.jsp" %>
				<%	}%>
				</h5>
			</div>
			<div id="paragrafo<%=id_paragrafo%>" class="collapse" role="tabcard" aria-labelledby="paragrafoT<%=id_paragrafo%>">
				<div class="card-body" style="padding-left:5rem;">
					<%@include file="/amministrazione/dweb_include/_paragrafo_contenuto.jsp" %>
					
				</div>
			</div>
		</div>
		
	<%	}%>
	</div>

<%	}%>

<%	boolean visualizza_indice = ((Documento)pagina).visualizza_indice!=null && ((Documento)pagina).visualizza_indice; %>
	<br/>
	<div class="alert alert-<%=(visualizza_indice ? "success" : "secondary")%>" role="alert">
		<span class="glyphicon glyphicon-info-sign" style="font-size:1.5rem;margin-right:1.2rem;"></span> Indice dei paragrafi <%=(visualizza_indice ? "" : " non ")%> abilitato.
		<a style="width:150px;margin-left:2rem;" href="/amministrazione/esegui.jsp?<%=rq_documento %>=<%=pagina.getId() %>&<%=rq_documento %>_tab=Paragrafi&<%=rq_operazione %>=salva&visualizza_indice=<%=(visualizza_indice ? "false" : "true")%>" class="form-control-sm btn btn-<%=(visualizza_indice ? "danger" : "success")%>"><%=(visualizza_indice ? "Disabilita" : "Abilita")%></a>
		<p style="margin-top:1rem;font-size:0.8rem;">Abilitare solo nel caso in cui si voglia visualizzare all'inizio della pagina web l'indice dei paragrafi con titolo. Consigliato nel caso di FAQ o documenti particolarmente lunghi.</p>
	</div>
</div>
