<%--	Visualizza un elenco di documenti raggruppati in tabulatori per anno, secondo 3 possibili modalità

		Parametri richiesti:
		 - List<DocumentoWeb<?>> lista;	// Lista dei documenti da rappresentare
		 - TipoDocumento tipoBlocco;	// Tipologia dei documenti rappresentati (null se non è unica)
		 - String sottotitolo;
		 - boolean visualTitolo;		// Definisce se deve essere visualizzato il titolo del Collettore
		 - boolean visualInfo;			// Definisce se deve essere visualizzata la numerosità dei documenti (stile motore di ricerca)
		 --%>
	<%	boolean visualEdizioniEvento = ((tipoBlocco!=null) && (tipoBlocco==TipoDocumento.EDIZIONE_EVENTO));
	
		

		List<DocumentoWeb<?>> documenti = lista;%>
		

	<%	if (visualTitolo && tipoBlocco!=null){%>
			<h1><span class="glyphicon glyphicon-<%=tipoBlocco.getGlyphicon()%>" aria-hidden="true"></span> <%=tipoBlocco.getNomePlurale() %></h1>
	<%	}%>
	
		<%	boolean visualNumerosita=false;%>
	
	<%	if(lista.size()==1){%>
		<%@include file="/common/componenti/collettori/_card.jsp" %>
	<%	}else{%>
		<div class="card" style="margin:2rem 0;">
			<div class="card-header">
				<h3><%=sottotitolo %></h3>
			</div>
			<div class="tab-content card-body" style="padding:1rem 0 0 0">
			<%@include file="/common/componenti/collettori/_card.jsp" %>
			</div>
		</div>
	<%	}%>
