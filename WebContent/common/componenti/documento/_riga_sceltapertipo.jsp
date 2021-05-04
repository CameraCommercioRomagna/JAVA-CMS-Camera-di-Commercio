<!--
	input richiesti:
		DocumentoWeb<?> n;		// Documento da visualizzare
		Boolean visualAbstract;	// Definisce se visualizzare anche l'abstract; default false
 -->

<%	if (n instanceof Edizione){
		Edizione e=(Edizione)n;
		boolean visualAgendaDatiCompatti=false;
		ModalitaVisualizzazioneData modVisualAgenda=ModalitaVisualizzazioneData.MEDIUM;%>
		<%@include file="/common/componenti/documento/_riga_agenda.jsp"%>
<%	}else{%>
		<%@include file="/common/componenti/documento/_riga_standard.jsp"%>
<%	}%>