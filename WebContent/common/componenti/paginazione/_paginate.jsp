<!-- input richiesti:
	List<DocumentoWeb<?>> documentiPaginare;	// Lista dei documenti da paginare
	int pageSize;								// Numero di elementi per pagina
	String paginationParameter;					// Parametro della request contenente la pagina corrente
	
	 output generati:
	List<DocumentoWeb<?>> paginaDocumenti;		// Pagina dei documenti da gestire
-->
<%	// Pagina il numero di figli se necessario
	List<DocumentoWeb<?>> paginaDocumenti=documentiPaginare;
	int paginationPage=0;
	if (documentiPaginare.size() > pageSize){
		int startPagina=0;
		int endPagina=pageSize;
		
		try{
			paginationPage=Integer.parseInt(request.getParameter(paginationParameter)) - 1;	// La pagina da estrarre è 0-based
			startPagina=pageSize*paginationPage;
			if (startPagina < 0 || startPagina > documentiPaginare.size())
				startPagina=0;
			endPagina=startPagina+pageSize;
			if (endPagina > documentiPaginare.size())
				endPagina = documentiPaginare.size();
		}catch(Exception e){}
		paginaDocumenti = documentiPaginare.subList(startPagina, endPagina);
	}
	%>