<%@page import="org.apache.commons.lang.StringEscapeUtils" %>

<%--!	public static String encodeHTML(String s)
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
}--%>
<%	boolean visualLogout=true;

	//identificativi per le request
	/*String rq_area_servizio = "ID_AS";
	String rq_area_interessi = "ID_AI";
	String rq_area_tematica = "AT";
	String rq_page = "T_PAGE";
	String rq_utente = "ID_U";
	String rq_documento = it.cise.portale.documenti.standard.Documento.REQUEST_DOCUMENTO;
	String rq_download = it.cise.portale.documenti.download.Download.REQUEST_DOWNLOAD;
	String rq_evento = it.cise.portale.documenti.eventi.Evento.REQUEST_EVENTO;
	String rq_referenza = it.cise.portale.documenti.referenza.Referenza.REQUEST_REFERENZA;
	String rq_banner = it.cise.portale.documenti.banner.Banner.REQUEST_BANNER;
	String rq_newsletter="ID_N";
	String rq_admin_preview = "PRV_DOC";
	String rq_session4template = "RQ_C";
	String rq_ambiti = "sez";
	String rq_cssStyle = "cssStyle";
	//String rq_tipodocumento = "doc";
	String rq_pubblicazione = "ID_P";
	String rq_cod_pubblicazione = "pubbl";*/
	String rq_documento = AbstractDocumentoWeb.PARAMETER_ID;
	
	//String area_tematica_curr = request.getParameter(rq_area_tematica);
	
	// Consente di impostare il css-screen da request
/*	String cssScreenFile=request.getParameter(rq_cssStyle);
	if (cssScreenFile==null)
		cssScreenFile=(session.getAttribute(rq_cssStyle)!=null ? (String)session.getAttribute(rq_cssStyle) : "portale_struttura");
	session.setAttribute(rq_cssStyle, cssScreenFile);*/
	
	// Oggetti di "sistema"
	/*List<Ambito> ambitiPagina=new ArrayList<Ambito>();
	AreaServizio _area_servizio=null;
	AreaInteresse _area_interesse=null;
	Long id_area_servizio = null;	//l'ultima area di servizio inviduata negli ambiti della pagina
	Long id_area_interessi = null;	//l'ultima area di interesse inviduata negli ambiti della pagina*/
	List<PaginaWeb<?>> ambitiPagina=new ArrayList<PaginaWeb<?>>();
	boolean inAreaCamera = false; //mi trovo nella root e quindi sotto all'unica area di servizio della Camera
	boolean inAreaAdmin = false; //per identificare l'area di Amministrazione
	
	String name_page = "";
	
	/**/
	/*String paramAmbiti = request.getParameter(rq_ambiti);
	boolean hasParamAmbiti = paramAmbiti!=null && !paramAmbiti.equals("") && !paramAmbiti.equals("/");*/
	String currentServer = request.getScheme()+"://"+request.getServerName();
	String currentURL = currentServer;
	currentURL += request.getServletPath();
	
	//currentURL += (request.getQueryString()!=null ? "?" + request.getQueryString() : "");
	if (request.getQueryString()!=null && !request.getQueryString().equals(""))	// Verifica parametri prima in get (è più facile)...
		currentURL += "?" + request.getQueryString();
	else{
		// ...e poi in post
		String postQueryString="";
		Map<String, String[]> parMap = request.getParameterMap();
		if (parMap.size()>0){
			for (String par: parMap.keySet())
				for (String value: parMap.get(par))
					postQueryString += (postQueryString.equals("") ? "?" : "&") + par+"="+value.replaceAll("&"," e ");	// Sarebbe meglio fare funzionare il seguente: postQueryString += (postQueryString.equals("") ? "?" : "&") + par+"="+StringEscapeUtils.escapeHtml(value);
		}
		currentURL += postQueryString;
	}
		
	//boolean pagina_comunicazione = currentURL.indexOf("doc=comunicazione")>-1 || currentURL.indexOf("doc=notiziarioquindicinale")>-1 || currentURL.indexOf("doc=comunicatostampa")>-1 || currentURL.indexOf("rassegnastampa")>-1 || currentURL.indexOf("doc=camerasegnala")>-1;
	CdCURLWrapper urlwrapper=new CdCURLWrapper(new java.net.URL(currentURL));
	//if (hasParamAmbiti) urlwrapper.removeParameter(rq_ambiti);
	//out.println(urlwrapper.getURL());
	URLWrapper backwrapper = urlwrapper.extractURL("back");
	if (backwrapper==null) backwrapper=urlwrapper.extractURL("pagefwd");
	if (backwrapper==null) backwrapper=new CdCURLWrapper(new java.net.URL(currentServer+"/"));
	ambitiPagina=urlwrapper.getAmbiti(connPostgres);
	
	String currentPage=request.getServletPath();
	String currentPageWithQS=currentPage + (request.getQueryString()!=null ? request.getQueryString() : "");
	
	/******************************************************************************************************************************************/
	// Parametro che esclude l'infrastruttura header/footer delle pagine diverse dalla HOME per indicizzazione con Nutch
	Boolean search_engine=(request.getHeader("User-Agent")!=null && request.getHeader("User-Agent").contains("Nutch-CISE-Crawler"));
	Boolean isHomePage=request.getServletPath().equals("/index.htm");
	/******************************************************************************************************************************************/
	
	String head_title = "";
	if(!search_engine || isHomePage)
		head_title = "Camera di Commercio della Romagna - Forlì-Cesena e Rimini";
	for (PaginaWeb<?> p: ambitiPagina)
		head_title += " - " + p.getTitolo();

	String meta_keywords = "";
	if(!search_engine || isHomePage)
		meta_keywords = "camera, commercio, camera di commercio, camera di commercio della romagna, romagna, forli, forlì, cesena, forlì-cesena, rimini, forlì-cesena e rimini, servizi, industria, artigianato, agricoltura, bandi, finanziamenti, eventi";
	String meta_description = "";
	
	//tipi di documenti/eventi di cui abbiamo esplicitato le icone
	String tipi_documenti_abilitati = "eventi,link,faq,modulistica,pubblicazione,legge,bando,bandogara,comunicatostampa,finanziamento,informazione,regolamentocamerale";
%>
	
	