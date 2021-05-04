<%--@page import="org.apache.commons.lang.StringEscapeUtils" --%>

<%	HttpServletRequest requestMP = request;
	try{
		// Adatta la request ad essere Multipart se generata da un form di questo tipo
		requestMP = new MultipartHttpServletRequest(request);
	}catch(Exception e){}
	
	boolean visualLogout=true;

	// Costanti
	String HOME="/index.htm";
	String HOME_ADMIN="/amministrazione/index.htm";
	
	Boolean isArchiveMode = false;
	
	// Identificativi costanti utilizzati per le request
	String rq_operazione = "op";
	String rq_documento = AbstractDocumentoWeb.PARAMETER_ID;
	
	// Recupero operazione eseguita dalla pagina
	String operazione=(requestMP.getParameter(rq_operazione)!=null ? requestMP.getParameter(rq_operazione) : "");
	
	// Recupero url pagina corrente e back
	String currentServer = request.getScheme()+"://"+request.getServerName();
	CdCURLWrapper urlwrapper=new CdCURLWrapper(connPostgres, requestMP);
	CdCURLWrapper backwrapper = urlwrapper.extractURL("back");
	List<DocumentoWeb<?>> ambitiPagina = urlwrapper.getDocumentoGerarchia();
	
	//List<TipoDocumento> tipiDoc_senza_condivisione_social = new ArrayList<TipoDocumento>(Arrays.asList(TipoDocumento.AREA_TEMATICA,TipoDocumento.COMPETENZA,TipoDocumento.NORMATIVA,TipoDocumento.MODULISTICA,TipoDocumento.GUIDA,TipoDocumento.FAQ,TipoDocumento.STRUTTURA_CAMERALE,TipoDocumento.FILE_UTILE,TipoDocumento.FILE_ALLEGATO,TipoDocumento.GUIDE_E_MODULI,TipoDocumento.ATTO_EVENTO,TipoDocumento.IMMAGINE,TipoDocumento.VOLUME,TipoDocumento.AMMINISTRAZIONE_TRASPARENTE,TipoDocumento.SEZIONE_AMMINISTRAZIONE_TRASPARENTE,TipoDocumento.DOCUMENTO_AMMINISTRAZIONE_TRASPARENTE,TipoDocumento.SEZIONE_RISERVATA_AMMINISTRATORI,TipoDocumento.CONSIGLIO_CAMERALE,TipoDocumento.GIUNTA_CAMERALE,TipoDocumento.DOCUMENTO_RISERVATO_GIUNTA,TipoDocumento.DOCUMENTO_RISERVATO_CONSIGLIO,TipoDocumento.DOCUMENTO_RISERVATO_REVISORI,TipoDocumento.HOME_PAGE_NOTIZIARIO,TipoDocumento.NOTIZIARIO,TipoDocumento.ALBO_ONLINE,TipoDocumento.PUBBLICITA_LEGALE,TipoDocumento.VIDEO));
	List<TipoDocumento> tipiDoc_senza_condivisione_social = new ArrayList<TipoDocumento>(Arrays.asList(TipoDocumento.AREA_TEMATICA,TipoDocumento.COMPETENZA,TipoDocumento.NORMATIVA,TipoDocumento.MODULISTICA,TipoDocumento.GUIDA,TipoDocumento.FAQ,TipoDocumento.STRUTTURA_CAMERALE,TipoDocumento.FILE_UTILE,TipoDocumento.GUIDE_E_MODULI,TipoDocumento.ATTO_EVENTO,TipoDocumento.IMMAGINE,TipoDocumento.VOLUME,TipoDocumento.AMMINISTRAZIONE_TRASPARENTE,TipoDocumento.SEZIONE_AMMINISTRAZIONE_TRASPARENTE,TipoDocumento.DOCUMENTO_AMMINISTRAZIONE_TRASPARENTE,TipoDocumento.SEZIONE_RISERVATA_AMMINISTRATORI,TipoDocumento.CONSIGLIO_CAMERALE,TipoDocumento.GIUNTA_CAMERALE,TipoDocumento.GRUPPO_GIUNTE_CAMERALI,TipoDocumento.GRUPPO_CONSIGLI_CAMERALI,TipoDocumento.DOCUMENTO_RISERVATO_GIUNTA,TipoDocumento.DOCUMENTO_RISERVATO_CONSIGLIO,TipoDocumento.DOCUMENTO_RISERVATO_REVISORI,TipoDocumento.HOME_PAGE_NOTIZIARIO,TipoDocumento.NOTIZIARIO,TipoDocumento.ALBO_ONLINE,TipoDocumento.PUBBLICITA_LEGALE,TipoDocumento.VIDEO));
	List<TipoDocumento> tipiDoc_senza_info_aggiornata_al = new ArrayList<TipoDocumento>(Arrays.asList(TipoDocumento.AMMINISTRAZIONE_TRASPARENTE,TipoDocumento.SEZIONE_AMMINISTRAZIONE_TRASPARENTE,TipoDocumento.HOME_PAGE_NOTIZIARIO,TipoDocumento.NOTIZIARIO));
	
	// Carica gli Sportelli per la richiesta di appuntamenti
	Sportello.values();
	
	//Numero notizie in Primo pianio
	int com_count=9;
	
	/******************************************************************************************************************************************/
	// Parametro che esclude l'infrastruttura header/footer delle pagine diverse dalla HOME per indicizzazione con Nutch
	Boolean search_engine=(request.getHeader("User-Agent")!=null && request.getHeader("User-Agent").contains("Nutch Spider CdC"));
	Boolean isHomePage=request.getServletPath().equals("/index.htm");
	/******************************************************************************************************************************************/
	String tagHtmlAttributes="lang=\"it\" itemscope itemtype=\"http://schema.org/WebPage\"";
	String head_title = "";
	if(!search_engine || isHomePage)
		head_title = "";
	
	String meta_keywords = "";
	if(!search_engine || isHomePage)
		meta_keywords = "";
	
	String meta_description = "";%>
