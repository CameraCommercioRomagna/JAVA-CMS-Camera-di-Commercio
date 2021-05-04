<!--
	input richiesti:
		List<DocumentoWeb<?>> lista;	// Documenti da visualizzare
		TipoDocumento tipoBlocco;		// Tipologia dei documenti della lista; se è null, lo deduce dal primo elemento
		Boolean visualAbstract;			// Definisce se visualizzare anche l'abstract; default false
 -->

<%	if (lista.size()>0){
		if (tipoBlocco == null)
			tipoBlocco=lista.get(0).getTipo();
		if (visualAbstract == null)
			visualAbstract = false;%>
		
		<div class="card" style="margin-top:1rem;">
			<div class="card-title-block-right bg_footer bg_footer_text" style="padding:0.3rem">
				<span class="glyphicon glyphicon-<%=tipoBlocco.getGlyphicon()%>" aria-hidden="true"></span><a id="<%=tipoBlocco.getNomePlurale().replace(" ", "_") %>" name="<%=tipoBlocco.getNomePlurale().replace(" ", "_") %>" style="display:inline;"></a><%=tipoBlocco.getNomePlurale() %>
			</div>
			<div class="card-body-block-right" >
		<%	for (DocumentoWeb<?> n: lista){%>
				<%@include file="/common/componenti/documento/_riga_standard.jsp"%>
		<%	}%>
			</div>
		</div>
<%	}

	// Resetta i parametri di input per evitare di interferire con altri blocchi della pagina
	visualAbstract = null;
	tipoBlocco = null;%>