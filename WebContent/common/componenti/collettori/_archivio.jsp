<!--
	input richiesti:
		List<DocumentoWeb<?>> lista;	// Documenti da visualizzare
		TipoDocumento tipoBlocco;		// Tipologia dei documenti della lista; se è null, lo deduce dal primo elemento
		Boolean visualAbstract;			// Definisce se visualizzare anche l'abstract; default false
 -->
 <%	boolean archivioCompleto = (request.getParameter("archivioCompleto") != null);
	if (!archivioCompleto){%>
		<%@include file="/common/componenti/collettori/_archivio_elenco.jsp"%>
<%	}else{
		// Se il numero di documenti relativi ad anni comuni è superiore a 5 li gestisce con un tabulatore di anni
		List<Long> anni=new ArrayList<Long>();
		int collisioni=0;
		for (DocumentoWeb<?> d: lista){
			Long anno=d.getAnnoPertinenza();
			if (!anni.contains(anno))
				anni.add(anno);
			else
				collisioni++;
			if (collisioni > 5)
				break;
		}
		
		if (collisioni > 5){
			ModalitaVisualizzazioneTabAnni modOrganizza=(tipoBlocco == TipoDocumento.EDIZIONE_EVENTO ? ModalitaVisualizzazioneTabAnni.ARCHIVIO : ModalitaVisualizzazioneTabAnni.ANNI);
			ModalitaVisualizzazioneDocumenti modElenco=(tipoBlocco == TipoDocumento.EDIZIONE_EVENTO ? ModalitaVisualizzazioneDocumenti.AGENDA : ModalitaVisualizzazioneDocumenti.LISTA);
			boolean visualTitolo=false;
			boolean visualCompatta=false;%>
			<%@include file="/common/componenti/collettori/_tab_anni.jsp"%>
<%		}else{%>
			<%@include file="/common/componenti/collettori/_archivio_elenco.jsp"%>
<%		}
}	%>