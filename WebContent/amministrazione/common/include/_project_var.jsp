<%!	public static String encodeHTML(String s)
{
    StringBuffer out = new StringBuffer();
    for(int i=0; i<s.length(); i++)
    {
        char c = s.charAt(i);
        if(c > 127 || c=='"' || c=='<' || c=='>')
        {
           out.append("&#"+(int)c+";");
        }
        else
        {
            out.append(c);
        }
    }
    return out.toString();
}%>
<%	HttpServletRequest requestMP = request;
	try{
		// Adatta la request ad essere Multipart se generata da un form di questo tipo
		requestMP = new MultipartHttpServletRequest(request);
	}catch(Exception e){}
	
	boolean visualLogout=true;

	// Costanti
	String HOME="/index.htm";
	String HOME_ADMIN="/auth/redirect.htm";	// era: "/amministrazione/index.htm"; ma Ë stata cambiata perchË affida il redirezionamento alla pagina che sa chi Ë l'utente
	String HOME_ADMIN_NEWSLETTER="/amministrazione/newsletter/index.htm";
	Long HOME_ID_D=0l;
	
	//tiene traccia dei tipo documento che possono essere inseriti con tipi di sistema diversi (--> nel caso il sistema mi imporr√† la scelta al momento della creazione)
	Map<TipoDocumento, List<TipoSistema>> mappa_tipi_sistema_per_tipi_dweb = new HashMap<TipoDocumento, List<TipoSistema>>();
	mappa_tipi_sistema_per_tipi_dweb.put(TipoDocumento.NORMATIVA, Arrays.asList(TipoSistema.DOWNLOAD,TipoSistema.LINK));
	mappa_tipi_sistema_per_tipi_dweb.put(TipoDocumento.MODULISTICA, Arrays.asList(TipoSistema.DOWNLOAD,TipoSistema.LINK));
	mappa_tipi_sistema_per_tipi_dweb.put(TipoDocumento.GUIDA, Arrays.asList(TipoSistema.DOWNLOAD,TipoSistema.LINK));
	mappa_tipi_sistema_per_tipi_dweb.put(TipoDocumento.SERVIZIO_ONLINE, Arrays.asList(TipoSistema.DOCUMENTO,TipoSistema.LINK));
	mappa_tipi_sistema_per_tipi_dweb.put(TipoDocumento.NOTIZIA_DAL_TERRITORIO, Arrays.asList(TipoSistema.DOCUMENTO,TipoSistema.LINK));
	mappa_tipi_sistema_per_tipi_dweb.put(TipoDocumento.DOCUMENTO_AMMINISTRAZIONE_TRASPARENTE, Arrays.asList(TipoSistema.DOCUMENTO,TipoSistema.DOWNLOAD,TipoSistema.LINK));
	mappa_tipi_sistema_per_tipi_dweb.put(TipoDocumento.AFFISSIONE, Arrays.asList(TipoSistema.DOCUMENTO,TipoSistema.DOWNLOAD,TipoSistema.LINK));
	mappa_tipi_sistema_per_tipi_dweb.put(TipoDocumento.PUBBLICITA_LEGALE, Arrays.asList(TipoSistema.DOCUMENTO,TipoSistema.DOWNLOAD,TipoSistema.LINK));
	
	List<TipoDocumento> tipiDoc_con_ins_immagine = new ArrayList<TipoDocumento>(Arrays.asList(TipoDocumento.GUIDA,TipoDocumento.MODULISTICA,TipoDocumento.COMUNICATO_STAMPA,TipoDocumento.NOTIZIA_DALLA_CAMERA,TipoDocumento.NOTIZIA_DAL_TERRITORIO,TipoDocumento.EDIZIONE_EVENTO,TipoDocumento.EDIZIONE_EVENTO_CAMERA,TipoDocumento.INIZIATIVA,TipoDocumento.GRUPPO_ATTIVITA,TipoDocumento.SERVIZIO_ONLINE,TipoDocumento.ATTIVITA_FORMATIVA,TipoDocumento.PUBBLICAZIONE,TipoDocumento.FINANZIAMENTO,TipoDocumento.PROCEDIMENTO));
	List<TipoDocumento> tipiDoc_senza_immagini_nei_paragrafi = new ArrayList<TipoDocumento>(Arrays.asList(TipoDocumento.STRUTTURA_CAMERALE));
	
	// Identificativi costanti utilizzati per le request
	String rq_operazione = "op";
	String rq_documento = AbstractDocumentoWeb.PARAMETER_ID;
	String rq_email = EmailWeb.PARAMETER_ID;
	String rq_ente = "ID_ENTE";
	String rq_luogo = "ID_LUOGO";
	String rq_tipo_newsLetter = NewsLetter.PARAMETER_ID;
	String rq_numero_newsLetter = NumeroNewsLetter.PARAMETER_ID;
	
	//admin - gestione modal confirmation
	String id_modal = "";
	String href_redirect = "";
	Long id_requested = null;
	DocumentoWeb<?> doc_modal = null;
	EmailWeb email_modal = null;
	String form_action = "";
	String form_add_input_hidden = "";
	String name_field_img = "";
	
	// Oggetti di "sistema"
	//boolean inAreaCamera = false; //mi trovo nella root e quindi sotto all'unica area di servizio della Camera
	//boolean inAreaAdmin = false; //per identificare l'area di Amministrazione
	
	//String name_page = "";
	
	// Recupero operazione eseguita dalla pagina
	String operazione=(requestMP.getParameter(rq_operazione)!=null ? requestMP.getParameter(rq_operazione) : "");
	boolean inserimento = operazione.equals("crea");
	boolean modifica = inserimento || operazione.equals("salva");
	
	// Recupero url pagina corrente e back
	String currentServer = request.getScheme()+"://"+request.getServerName();
	CdCURLWrapper urlwrapper=new CdCURLWrapper(connPostgres, requestMP);
	CdCURLWrapper backwrapper = urlwrapper.extractURL("back");
	Set<String> parameters_filtri_dweb_tot = new CdCURLWrapper(urlwrapper).getParameters().keySet();
	
	List<DocumentoWeb<?>> ambitiPagina = urlwrapper.getDocumentoGerarchia(ForwardBehaviour.NO_FORWARD, inserimento);
	
	//String currentPage=requestMP.getServletPath();
	//String currentPageWithQS=currentPage + (requestMP.getQueryString()!=null ? requestMP.getQueryString() : "");
	
	/******************************************************************************************************************************************/
	// Parametro che esclude l'infrastruttura header/footer delle pagine diverse dalla HOME per indicizzazione con Nutch
	Boolean search_engine=(requestMP.getHeader("User-Agent")!=null && requestMP.getHeader("User-Agent").contains("Nutch-CISE-Crawler"));
	Boolean isHomePage=requestMP.getServletPath().equals("/index.htm");
	/******************************************************************************************************************************************/
	
	String head_title = "";
	if(!search_engine || isHomePage)
		head_title = "XXX";
	for (DocumentoWeb<?> p: ambitiPagina)
		head_title += " - " + p.getTitolo();

	String meta_keywords = "";
	if(!search_engine || isHomePage)
		meta_keywords = "";
	String meta_description = "";
%>