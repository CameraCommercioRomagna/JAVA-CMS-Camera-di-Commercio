<%	PaginaWeb<?> pagina=null;
	PaginaWeb<?> pagina_padre=null;
	
	boolean preview=false;
	boolean previewConfermaContenuti=false;
	
	Long id=2868l;
	pagina = (PaginaWeb<?>)DocumentFactory.load(connPostgres, id);
	pagina_padre=pagina.getPadre();%>