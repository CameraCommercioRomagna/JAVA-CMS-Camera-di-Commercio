<!--
	input richiesti:
		List<DocumentoWeb<?>> lista;	// Documenti da visualizzare
		TipoDocumento tipoBlocco;		// Tipologia dei documenti della lista; se è null, lo deduce dal primo elemento
		Boolean visualAbstract;			// Definisce se visualizzare anche l'abstract; default false
		boolean archivioCompleto;		// Definisce se visualizzare tutti i documenti in archivio;
 -->

<%	if (lista.size()>0){
		
		if (tipoBlocco == null)
			tipoBlocco=lista.get(0).getTipo();
		if (visualAbstract == null)
			visualAbstract = false;
		boolean visualEdizioniEvento = ((tipoBlocco!=null) && (tipoBlocco==TipoDocumento.EDIZIONE_EVENTO));
		
		List<DocumentoWeb<?>> listaInCorso = new ArrayList<DocumentoWeb<?>>();
		int numItem=0;
		for (DocumentoWeb<?> d: lista)
			if (!d.archiviato()){
				listaInCorso.add(d);
				numItem++;
			}else
				break;
		List<DocumentoWeb<?>> listaArchivio=(numItem>0 ? new ArrayList<DocumentoWeb<?>>( lista.subList(numItem, lista.size()) ) : lista );%>
		

			
		<%	if (listaInCorso.size()>0){
				if (tipoBlocco == TipoDocumento.EDIZIONE_EVENTO){
					Collections.reverse(listaInCorso);
					List<Edizione> edizioni_list = new ArrayList<Edizione>();
					for (DocumentoWeb<?> n: listaInCorso)
						edizioni_list.add((Edizione)n);
					
					Collections.sort(edizioni_list, new Comparator<Edizione>(){
						public int compare(Edizione e1, Edizione e2) {
							int ordine = e1.getDal().compareTo(e2.getDal());	// Prima ordine di data...
							if (ordine == 0)
								ordine = e1.getId().compareTo(e2.getId());		//...poi eventualmente di ID
							return ordine;
						}
					});
					
					listaInCorso = new ArrayList<DocumentoWeb<?>>();
					for (Edizione<?> n: edizioni_list)
						listaInCorso.add(n);
				}%>
				<div class="card" style="margin-top:1rem;">
					<div class="card-title-block-right bg_footer bg_footer_text" style="padding:0.3rem">
						<span class="glyphicon glyphicon-<%=tipoBlocco.getGlyphicon()%>" aria-hidden="true"></span> <%=(visualEdizioniEvento ? "In calendario" : tipoBlocco.getNomePlurale()) %>
					</div>
					<div class="card-body-block-right" >
				<%	for (DocumentoWeb<?> n: listaInCorso){%>
						<%@include file="/common/componenti/documento/_riga_sceltapertipo.jsp"%>
				<%	}%>
					</div>
				</div>
		<%	}%>
		<%	if (listaArchivio.size()>0){%>
				<div class="card" style="margin-top:1rem;">
					<div class="card-title-block-right bg_footer bg_footer_text" style="padding:0.3rem">
						<span class="glyphicon glyphicon-<%=tipoBlocco.getGlyphicon()%>" aria-hidden="true"></span> <strong><%=(visualEdizioniEvento ? "Eventi passati" : "Archivio") %></strong><br/>
					</div>
					<div class="card-body-block-right" >
					
			<%		int capienzaArchivio=(archivioCompleto ? listaArchivio.size() : 5);
					for (DocumentoWeb<?> n: listaArchivio){%>
						<%@include file="/common/componenti/documento/_riga_sceltapertipo.jsp"%>
						<%	capienzaArchivio--;
							if (!archivioCompleto && capienzaArchivio == 0){%>
								<br/><a href="<%=pagina.getLink()%>&archivioCompleto">Consulta l'archivio completo</a>
					<%			break;
							}%>
			<%		}%>
					</div>
				</div>
		<%	}%>
<%	}

	// Resetta i parametri di input per evitare di interferire con altri blocchi della pagina
	visualAbstract = null;
	tipoBlocco = null;%>