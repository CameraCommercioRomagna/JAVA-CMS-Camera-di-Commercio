<!-- input richiesti:
	List<DocumentoWeb<?>> documenti;	// Lista delle edizioni evento da rappresentare (verranno selezionate a partre da una lista di DocumentoWeb<?>)
	boolean visualAnno;			// Visualizza le edizioni raggruppate per anno
	int numElementiCollettore => numero di elementi che si vogliono visualizzare
	boolean visualAgendaDatiCompatti => visualizza titolo/abstract dell'edizione
	ModalitaVisualizzazioneData modVisualAgenda; // per impostare i parametri della visualizzazione larga o stretta
	String titoloCollettore => titolo del blocco
-->
<%	Set<Edizione> edizioniAgenda=new TreeSet<Edizione>(
			new Comparator<Edizione>() {
				public int compare(Edizione e1, Edizione e2) {
					int ordine = e1.getDal().compareTo(e2.getDal());	// Prima ordine di data...
					if (ordine == 0)
						ordine = e1.getId().compareTo(e2.getId());		//...poi eventualmente di ID
					return ordine;
				}
				
			}
		);
	edizioniAgenda.addAll(DocumentFactory.getAll(documenti, Edizione.class));%>
	
<%	if(titoloCollettore!=null){%>
	<h1><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span> <%=titoloCollettore%></h1>
<%	}%>
<%	if(edizioniAgenda.size()>0){%>
	<%	int annoAgenda=0;
		for(Edizione e: edizioniAgenda){
			if(numElementiCollettore>0){
				if (visualAnno){
					int annoInitEvento=Integer.parseInt(DateUtils.formatDate(e.getDal(), "yyyy"));
					if (annoAgenda != annoInitEvento){
						annoAgenda=annoInitEvento;%>
						<h2><%=annoAgenda%></h2>
				<%	}
				}%>
				<%@include file="/common/componenti/documento/_riga_agenda.jsp"%>
				<%	numElementiCollettore--;
			}%>
	<%	}%>
<%	}else{%>
		<div style="margin:0.5rem;">Nessun evento presente</div>
<%	}%>
				
				
		
				
				
				
				
				
		