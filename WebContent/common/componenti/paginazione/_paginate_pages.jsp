<!-- input richiesti:
	List<DocumentoWeb<?>> documentiPaginare;	// Lista dei documenti da paginare
	int pageSize;								// Numero di elementi per pagina
	String paginationParameter;					// Parametro della request contenente la pagina corrente
-->
<%	if (documentiPaginare.size() > pageSize){%>
		<div style="text-align:center; margin-top:2rem; width:100%"> Vai alla pagina 
	<%	int numPages = documentiPaginare.size() / pageSize + (documentiPaginare.size() % pageSize > 0 ? 1 : 0);
		paginationPage++;	//...per coerenza con la numerazione delle pagine che segue
		for (int pageNumber=1; pageNumber<=numPages; pageNumber++){%>
		<%	if (pageNumber == 1 || pageNumber == numPages || (pageNumber>=paginationPage-2 && pageNumber<=paginationPage+2)){
				URLWrapper paginationWrapper=new CdCURLWrapper(urlwrapper);
				paginationWrapper.modifyParameter(paginationParameter, String.valueOf(pageNumber));%>
				<a href="<%=paginationWrapper.getPercorsoWeb(false) %>"><%=pageNumber %></a>
		<%	}else{%>
				...
			<%	pageNumber=(pageNumber<paginationPage-2 ? paginationPage-3 : numPages-1);
			}
	}%>
		</div>
<%	}%>