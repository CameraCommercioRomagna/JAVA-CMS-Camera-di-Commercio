<%	PaginaWeb<?> pagina=null;
	PaginaWeb<?> pagina_padre=null;
	
	boolean preview=false;
	boolean previewConfermaContenuti=false;
	
	//Long id=301l; //comunicazione
	Long id=0l;
	if(requestMP.getParameter("back")!=null && requestMP.getParameter("back").indexOf("contatta_camera")>-1)
		id=1l;
	pagina = (PaginaWeb<?>)DocumentFactory.load(connPostgres, id);
	pagina_padre=pagina.getPadre();%>