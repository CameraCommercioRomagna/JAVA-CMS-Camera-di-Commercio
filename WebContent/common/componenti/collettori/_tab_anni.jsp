<%--	Visualizza un elenco di documenti raggruppati in tabulatori per anno, secondo 3 possibili modalità

		Parametri richiesti:
		 - List<DocumentoWeb<?>> lista;	// Lista dei documenti da rappresentare
		 - TipoDocumento tipoBlocco;	// Tipologia dei documenti rappresentati (null se non è unica)
		 - ModalitaVisualizzazioneTabAnni modOrganizza;	// Modalità di visualizzazione della tabulazione
		 - ModalitaVisualizzazioneDocumenti modElenco;	// Modalità di visualizzazione dell'elenco documenti 
		 - boolean visualTitolo;		// Definisce se deve essere visualizzato il titolo del Collettore
		 - boolean visualInfo;			// Definisce se deve essere visualizzata la numerosità dei documenti (stile motore di ricerca) 
		 - boolean visualCompatta;		// Definisce se il singolo documento dve essere visualizato in modalità campatta (per ora applicato solo all'agenda) 
		 Nuovi parametri
		 - Integer numAnniLimiteArchivio;	// Numero massimo di anni da visualizzare in archivio a partire dal corrente; se nullo il sistema deve calcolare i soli anni per cui esiste un documento
		 --%>
	<%	boolean visualEdizioniEvento = ((tipoBlocco!=null) && (tipoBlocco==TipoDocumento.EDIZIONE_EVENTO));
	
		boolean archivioAnnoInCorso=false;	// Indica se si sta visualizzando l'archivio dell'anno in corso
		int annoCurr=Integer.parseInt(DateUtils.getYear(new Date()));
		int annoFineVisualizzazione = isArchiveMode ? 2001 : (annoCurr-5 > 2015 ? annoCurr-15 : 2015);
		int anno=annoCurr;
		if (modOrganizza != ModalitaVisualizzazioneTabAnni.INCORSO){
			try{
				anno=Integer.parseInt(requestMP.getParameter("anno"));
				archivioAnnoInCorso = (modOrganizza == ModalitaVisualizzazioneTabAnni.ARCHIVIO);
			}catch(Exception eAnno){}
		}
		
		ConfigurazionePagina confPagina = new ConfigurazionePagina(modOrganizza, archivioAnnoInCorso, String.valueOf(anno));
		Map<ConfigurazionePagina, List<DocumentoWeb<?>>> mapDocumenti = new HashMap<ConfigurazionePagina, List<DocumentoWeb<?>>>();
		for (DocumentoWeb<?> documento: lista){
			ConfigurazionePagina confDocumento = new ConfigurazionePagina(modOrganizza, documento);
			List<DocumentoWeb<?>> listaDocumentiConfigurazione = mapDocumenti.get(confDocumento);
			if (listaDocumentiConfigurazione == null){
				listaDocumentiConfigurazione = new ArrayList<DocumentoWeb<?>>();
				mapDocumenti.put(confDocumento, listaDocumentiConfigurazione);
			}
			listaDocumentiConfigurazione.add(documento);
		}
		
		if (tipoBlocco == TipoDocumento.VOLUME)
			try{
				ConfigurazionePagina ultimaConf=(ConfigurazionePagina)new TreeSet(mapDocumenti.keySet()).first();
				annoFineVisualizzazione = Integer.parseInt(ultimaConf.getAnno()) - 1;
			}catch(Exception e){}

		List<DocumentoWeb<?>> documenti = (mapDocumenti.get(confPagina)==null ? new ArrayList<DocumentoWeb<?>>() : mapDocumenti.get(confPagina));%>
		
	<%	if (visualTitolo && tipoBlocco==TipoDocumento.STRUTTURA_CAMERALE){%>
		<h1><span class="glyphicon glyphicon-<%=tipoBlocco.getGlyphicon()%>" aria-hidden="true"></span> Contatti</h1>
	<%}else{%>
	<%	if (visualTitolo && tipoBlocco!=null){%>
		<h1><span class="glyphicon glyphicon-<%=tipoBlocco.getGlyphicon()%>" aria-hidden="true"></span> <%=tipoBlocco.getNomePlurale() %></h1>
	<%	}%>
	<%}%>
	
		<div class="card" style="margin:2rem 0;">
			<div class="card-header">
	<%	URLWrapper wrapperArchivio=new CdCURLWrapper(urlwrapper);
		switch (modOrganizza){
			case ARCHIVIO:
				//wrapperArchivio.removeParameter("organizza");
				wrapperArchivio.removeParameter("anno");%>
				<ul class="nav nav-tabs card-header-tabs">
					<li class="nav-item">
						<a class="nav-link <%if(!archivioAnnoInCorso){%>active<%}%>" href="<%=wrapperArchivio.getPercorsoWeb(false) %>"><%=(!visualEdizioniEvento ? "In corso" : "<span class=\"glyphicon glyphicon-calendar\" aria-hidden=\"true\"></span> In calendario") %></a>
					</li>
				<%	for(int a=annoCurr; a>annoFineVisualizzazione; a--){
						try{
							if (mapDocumenti.get(new ConfigurazionePagina(modOrganizza, true, String.valueOf(a))).size() > 0){
								wrapperArchivio.modifyParameter("anno", String.valueOf(a));%>
								<li class="nav-item">
									<a class="nav-link <%if(archivioAnnoInCorso && (a==anno)){%> active <%}%>" href="<%=wrapperArchivio.getPercorsoWeb(false) %>">Archivio <%=a %></a>
								</li>
					<%		}
						}catch(Exception e){}
					}%>
				</ul>
		<%		break;
			case ANNI:%>
				<ul class="nav nav-tabs card-header-tabs">
				<%	for(int a=annoCurr; a>annoFineVisualizzazione; a--){
						try{
							if (mapDocumenti.get(new ConfigurazionePagina(modOrganizza, false, String.valueOf(a))).size() > 0){
								wrapperArchivio.modifyParameter("anno", String.valueOf(a));%>
								<li class="nav-item ">
									<a class="nav-link <%if(a==anno){%> active <%}%>" href="<%=wrapperArchivio.getPercorsoWeb(false) %>"><%=a %></a>
								</li>
				<%			}
						}catch(Exception e){}
					}%>
				</ul>
		<%		break;
		}%>
			</div>
			<div class="tab-content card-body" style="padding:1rem 0 0 0">
<%	{
		boolean visualNumerosita=false;
		switch (modElenco){
			case LISTA:
				boolean visualInfo=false;%>
				<%@include file="/common/componenti/collettori/_list.jsp" %>
			<%	break;
			case AGENDA:
				int numElementiCollettore=documenti.size();
				boolean visualAnno = (modOrganizza!=ModalitaVisualizzazioneTabAnni.ARCHIVIO && visualEdizioniEvento);
				ModalitaVisualizzazioneData modVisualAgenda=ModalitaVisualizzazioneData.MEDIUM;
				boolean visualAgendaDatiCompatti = visualCompatta;
				String titoloCollettore = null;%>
				<%@include file="/common/componenti/collettori/_agenda.jsp"%>
			<%	break;
			case CARD:
			default:%>
			<%@include file="/common/componenti/collettori/_card.jsp" %>
	<%	}
	}%>
			</div>
	<%	if (modOrganizza!=ModalitaVisualizzazioneTabAnni.ARCHIVIO && visualEdizioniEvento){
			wrapperArchivio.modifyParameter("organizza", "archivio");%>
			<div class="card-footer">
				<a href="<%=wrapperArchivio.getPercorsoWeb(false) %>">Consulta l'archivio storico</a>
			</div>
	<%	}%>
		</div>

