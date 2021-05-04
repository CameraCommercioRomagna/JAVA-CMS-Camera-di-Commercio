package it.cise.portale.cdc.documenti;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Hashtable;
import java.util.List;
import java.util.Map;

import cise.utils.Logger;
import cise.utils.StringUtils;
import it.cise.util.http.HttpUtils;
import it.cise.portale.cdc.*;
import it.cise.portale.cdc.auth.Autorizzazione;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.eventi.EdizioneInterna;
import it.cise.portale.cdc.documenti.eventi.AttoEvento;
import it.cise.portale.cdc.documenti.pubblicazioni.Pubblicazione;
import it.cise.portale.cdc.documenti.eventi.EdizioneEsterna;

public enum TipoDocumento {
	// ***NB: Ultimo id utilizzato: 53 -> Consigli Camerali
	STRUTTURA_CAMERALE(16l, null, StrutturaCamerale.class, "info-sign", null, null, null, null, null, null),
	FILE_UTILE(17l, "File utili", null, "download-alt", null, null, null, null, null, null),
	LINK_UTILE(52l, "Link utili", null, "globe", null, null, null, null, null, null),
	
	// Albero secondario: Albo online
	FILE_ALLEGATO(47l, "File allegati", null, "download-alt", null, null, null, null, null, null),	// NOTA BENE: questa tipologia è da utilizzare solo per l'Albo online!!
	AFFISSIONE(43l, "Affissioni", null, "inbox", null, null, null, null, 
			null, 
			Arrays.asList(FILE_ALLEGATO)),
	PUBBLICITA_LEGALE(42l, null, null, "bullhorn", null, null, null, null, 
			null, 
			Arrays.asList(FILE_ALLEGATO)),
	ALBO_ONLINE(41l, null, null, "briefcase", null, 
			null, null, null, 
			null, Arrays.asList(PUBBLICITA_LEGALE, AFFISSIONE, STRUTTURA_CAMERALE)),
	// Albero secondario: Notiziario quindicinale
	NOTIZIARIO(38l, null, null, "send", "notiziario.png", null, null, null, null, null),
	HOME_PAGE_NOTIZIARIO(37l, null, null, "send", "notiziario.png", null, 
			null, null, null, 
			Arrays.asList(NOTIZIARIO)),
	// Albero secondario: Documentazione riservata Amministratori
	DOCUMENTO_RISERVATO_REVISORI(40l, null, null, "eye-close", null, 
			Arrays.asList(Autorizzazione.DWEB_RISERVATI_REVISORI), null, null, 
			null, null),
	DOCUMENTO_RISERVATO_GIUNTA(36l, null, null, "lock", null,
			Arrays.asList(Autorizzazione.DWEB_RISERVATI_GIUNTA),  null, null, 
			null, null),
	DOCUMENTO_RISERVATO_CONSIGLIO(35l, null, null, "lock", null,
			Arrays.asList(Autorizzazione.DWEB_RISERVATI_CONSIGLIO), null, null, 
			null, null),
	
	/**GIUNTA_CAMERALE(34l, null, null, "lock", null,
			Arrays.asList(Autorizzazione.DWEB_RISERVATI_GIUNTA, Autorizzazione.DWEB_RISERVATI_REVISORI), null, null, 
			null, null),**/
	GIUNTA_CAMERALE(34l, null, null, "lock", null,
			Arrays.asList(Autorizzazione.DWEB_RISERVATI_GIUNTA, Autorizzazione.DWEB_RISERVATI_REVISORI), null, null, 
			null, Arrays.asList(DOCUMENTO_RISERVATO_GIUNTA, DOCUMENTO_RISERVATO_REVISORI)),
	/**GRUPPO_GIUNTE_CAMERALI(50l,null, null, "lock", null, Arrays.asList(Autorizzazione.DWEB_RISERVATI_GIUNTA, Autorizzazione.DWEB_RISERVATI_REVISORI),
			null, null, null, null),**/
	GRUPPO_GIUNTE_CAMERALI(50l,null, null, "lock", null, Arrays.asList(Autorizzazione.DWEB_RISERVATI_GIUNTA, Autorizzazione.DWEB_RISERVATI_REVISORI),
			null, null, null, Arrays.asList(GIUNTA_CAMERALE)),
	/**GIUNTE_CAMERALI(52l, null,null, "lock", null, 
			Arrays.asList(Autorizzazione.DWEB_RISERVATI_GIUNTA, Autorizzazione.DWEB_RISERVATI_REVISORI), null, null, 
			Arrays.asList(GIUNTA_CAMERALE, GRUPPO_GIUNTE_CAMERALI), Arrays.asList(DOCUMENTO_RISERVATO_GIUNTA, DOCUMENTO_RISERVATO_REVISORI)),**/
	/**CONSIGLIO_CAMERALE(33l, null, null, "lock", null, 
			Arrays.asList(Autorizzazione.DWEB_RISERVATI_CONSIGLIO, Autorizzazione.DWEB_RISERVATI_REVISORI), null, null,
			null, null),**/
	CONSIGLIO_CAMERALE(33l, null, null, "lock", null, 
			Arrays.asList(Autorizzazione.DWEB_RISERVATI_CONSIGLIO, Autorizzazione.DWEB_RISERVATI_REVISORI), null, null,
			null,Arrays.asList(DOCUMENTO_RISERVATO_CONSIGLIO, DOCUMENTO_RISERVATO_REVISORI)),
	/**GRUPPO_CONSIGLI_CAMERALI(51l,null, null, "lock", null, Arrays.asList(Autorizzazione.DWEB_RISERVATI_CONSIGLIO, Autorizzazione.DWEB_RISERVATI_REVISORI),
			null, null, null, null),**/
	GRUPPO_CONSIGLI_CAMERALI(51l,null, null, "lock", null, Arrays.asList(Autorizzazione.DWEB_RISERVATI_CONSIGLIO, Autorizzazione.DWEB_RISERVATI_REVISORI),
			null, null, null, Arrays.asList(CONSIGLIO_CAMERALE)),
	/**CONSIGLI_CAMERALI(53l, null,null, "lock", null, 
			Arrays.asList(Autorizzazione.DWEB_RISERVATI_CONSIGLIO, Autorizzazione.DWEB_RISERVATI_REVISORI), null, null, 
			Arrays.asList(CONSIGLIO_CAMERALE, GRUPPO_CONSIGLI_CAMERALI), Arrays.asList(DOCUMENTO_RISERVATO_CONSIGLIO, DOCUMENTO_RISERVATO_REVISORI)),**/
	
	/**SEZIONE_RISERVATA_AMMINISTRATORI(32l, null, null, "inbox", null, 
			Arrays.asList(Autorizzazione.DWEB_RISERVATI_GIUNTA, Autorizzazione.DWEB_RISERVATI_CONSIGLIO, Autorizzazione.DWEB_RISERVATI_REVISORI), null, null,  
			null, Arrays.asList(GIUNTE_CAMERALI, CONSIGLI_CAMERALI, STRUTTURA_CAMERALE)),**/
	SEZIONE_RISERVATA_AMMINISTRATORI(32l, null, null, "inbox", null, 
			Arrays.asList(Autorizzazione.DWEB_RISERVATI_GIUNTA, Autorizzazione.DWEB_RISERVATI_CONSIGLIO, Autorizzazione.DWEB_RISERVATI_REVISORI), null, null,  
			null, Arrays.asList(GRUPPO_GIUNTE_CAMERALI, GRUPPO_CONSIGLI_CAMERALI, STRUTTURA_CAMERALE)),
	
	// Albero secondario: Amministrazione trasparente
	DOCUMENTO_AMMINISTRAZIONE_TRASPARENTE(31l, "Documenti", null, "file", "amministrazione-trasparente.png", null, null, null, 
			null, 
			Arrays.asList(FILE_UTILE)),
	SEZIONE_AMMINISTRAZIONE_TRASPARENTE(30l, "Sottosezioni", null, "folder-open", "amministrazione-trasparente.png", 
			null, Arrays.asList(Autorizzazione.ROOT), Arrays.asList(Autorizzazione.ROOT), 
			null, 
			Arrays.asList(DOCUMENTO_AMMINISTRAZIONE_TRASPARENTE)),
	AMMINISTRAZIONE_TRASPARENTE(29l, null, null, "file", "amministrazione-trasparente.png", 
			null, Arrays.asList(Autorizzazione.ROOT), Arrays.asList(Autorizzazione.ROOT),
			null, 
			Arrays.asList(SEZIONE_AMMINISTRAZIONE_TRASPARENTE, STRUTTURA_CAMERALE)),
	// Albero principale dei documenti del portale
	VOLUME(26l, "Volumi", null, "book", null, null, null, null, null, null),
	VIDEO(44l, null, null, "film", null, null, null, null, null, null),
	IMMAGINE(25l, "Immagini", Immagine.class, "picture", null, null, null, null, null, null),
	ATTO_EVENTO(24l, "Atti", AttoEvento.class, "file", null, null, null, null, null, null),
	FAQ(14l, null, null, "question-sign", null, null, null, null, null, null),
	GUIDA(13l, null, null, "book", null, null, null, null, null, null),
	MODULISTICA(12l, null, null, "duplicate", null, null, null, null, null, null),
	GUIDE_E_MODULI(23l, "Guide e moduli", null, "copy", null, null, null, null, 
			Arrays.asList(MODULISTICA, GUIDA, FAQ), 
			null),
	EDIZIONE_EVENTO_CISE(49l, null, EdizioneEsterna.class, "calendar", null, 
			null, Arrays.asList(Autorizzazione.ROOT), Arrays.asList(Autorizzazione.ROOT),
			null, null),
	EDIZIONE_EVENTO_CAMERA(27l, null, EdizioneInterna.class, "calendar", null, null, null, null, null, null),
	EDIZIONE_EVENTO(48l, "Agenda", null, "calendar", null, null, null, null, 
			Arrays.asList(EDIZIONE_EVENTO_CAMERA, EDIZIONE_EVENTO_CISE), 
			Arrays.asList(ATTO_EVENTO, IMMAGINE, VIDEO, FILE_UTILE, LINK_UTILE, STRUTTURA_CAMERALE)),
	COMUNICATO_STAMPA(18l, "Comunicati stampa", ComunicatoStampa.class, "bullhorn", "comunicati-stampa.png", null, null, null, 
			null, 
			Arrays.asList(IMMAGINE)),
	NOTIZIA_DALLA_CAMERA(19l, null, null, "list-alt", "news-camera.png", null, null, null, null, null),
	NOTIZIA_DAL_TERRITORIO(39l, null, null, "list-alt", "news-territorio.png", null, null, null, null, null),
	COMUNICAZIONE(20l, "In primo piano", null, "tags", "comunicazione.png", null, null, null, 
			Arrays.asList(COMUNICATO_STAMPA, NOTIZIA_DALLA_CAMERA, NOTIZIA_DAL_TERRITORIO), 
			Arrays.asList(FILE_UTILE)),
	INIZIATIVA(6l, "Iniziative", null, "flag", "iniziative.png", null, null, null, 
			null, 
			Arrays.asList(IMMAGINE, VIDEO)),
	SERVIZIO_ONLINE(15l, "Servizi online", null, "globe", "servizi-online.png", null, null, null, null, null),
	NORMATIVA(11l, null, null, "education", null, null, null, null, null, null),
	ATTIVITA_FORMATIVA(9l, "Attività formative", null, "education", null, null, null, null, null, null),
	PUBBLICAZIONE(8l, "Pubblicazioni", Pubblicazione.class, "book", "pubblicazioni.png", null, null, null, 
			null, 
			Arrays.asList(VOLUME)),
	FINANZIAMENTO(7l, "Finanziamenti", Finanziamento.class, "euro", "finanziamenti.png", null, null, null, null, null), 
	PROCEDIMENTO(4l, null, null, "object-align-bottom", null, null, null, null, null, null), 
	GRUPPO_ATTIVITA(45l, null, GruppoAttivita.class, "th", null, 
			null, Arrays.asList(Autorizzazione.ROOT), null, 
			null, null),
	ATTIVITA(3l, null, Attivita.class, "th-large", null, null, null, null, 
			Arrays.asList(PROCEDIMENTO, INIZIATIVA, FINANZIAMENTO, PUBBLICAZIONE, ATTIVITA_FORMATIVA, GRUPPO_ATTIVITA), 
			Arrays.asList(NORMATIVA, SERVIZIO_ONLINE, STRUTTURA_CAMERALE, EDIZIONE_EVENTO, COMUNICAZIONE, GUIDE_E_MODULI, FILE_UTILE, LINK_UTILE)),
	COMPETENZA(2l, null, Competenza.class, "tag", null, null, null, null,
			null, 
			Arrays.asList(ATTIVITA, NORMATIVA, SERVIZIO_ONLINE, STRUTTURA_CAMERALE, LINK_UTILE, COMUNICAZIONE)), 
	AREA_TEMATICA(1l, null, AreaTematica.class, "apple", null, 
			null, Arrays.asList(Autorizzazione.ROOT), null, 
			null, 
			Arrays.asList(COMPETENZA, SERVIZIO_ONLINE, STRUTTURA_CAMERALE)),
	CAROUSEL(46l, null, null, "info-sign", null, 
			Arrays.asList(Autorizzazione.ROOT), Arrays.asList(Autorizzazione.ROOT), Arrays.asList(Autorizzazione.ROOT), 
			null, null),
	HOME_PAGE(0l, "Home aree tematiche", HomePage.class, "info-sign", null, 
			null, Arrays.asList(Autorizzazione.ROOT), Arrays.asList(Autorizzazione.ROOT),
			null,
			Arrays.asList(AREA_TEMATICA, CAROUSEL));
	
	public final static String PARAMETER_ID="ID_T";
	public final static String PARAMETER_WEB_NAME="TP";
	
	private Long id_tipo_documento_web;
	private String nomePlurale;
	private String glyphicon;
	private String immagine;
	private List<Autorizzazione> accessibileA;
	private List<Autorizzazione> inseribileDa;
	private List<Autorizzazione> modificabileDa;
	private Class<? extends DocumentoWeb<?>> generatedClass;
	private List<TipoDocumento> estensioni; 
	private List<TipoDocumento> figli; 
	private List<TipoDocumento> padri;
	private Boolean hasPadre;
	
	private boolean searchGeneratedClass;
	private boolean searchEstensionePadre;
	private boolean searchEstensioni;
	private boolean searchFigli;
	private TipoDocumento estensione;
	
	private boolean autorizzazioniLetturaInizializzate; 
	private boolean autorizzazioniInserimentoInizializzate; 
	private boolean autorizzazioniScritturaInizializzate;
	
	/**
	 * @param id
	 * @param generatedClass	classe associata al tipo documento
	 * @param accessibileA		autorizzazioni necessarie ad un utente per visualizzare il tipo documento
	 * @param modificabileDa	autorizzazioni necessarie ad un utente per modificare il tipo documento
	 * @param estensioni		tipologie di documento che estendono il tipo corrente
	 * @param figli				tipologie di documento che possono essere generate come figlie di un documento del ipo corrente
	 */
	private TipoDocumento(
			Long id, String nomePlurale, Class<? extends DocumentoWeb<?>> generatedClass, String glyphicon, String immagine,
			List<Autorizzazione> accessibileA, List<Autorizzazione> inseribileDa, List<Autorizzazione> modificabileDa, 
			List<TipoDocumento> estensioni, List<TipoDocumento> figli) {
		
		this.id_tipo_documento_web = id;
		this.nomePlurale = nomePlurale;
		this.accessibileA = (accessibileA!=null ? accessibileA : new ArrayList<Autorizzazione>());
		this.inseribileDa = (inseribileDa!=null ? inseribileDa : new ArrayList<Autorizzazione>());
		this.modificabileDa = (modificabileDa!=null ? modificabileDa : new ArrayList<Autorizzazione>());
		this.generatedClass = generatedClass;
		this.glyphicon = (glyphicon!=null ? glyphicon : "");
		this.immagine = (immagine!=null ? immagine : "");

		this.estensioni = (estensioni!=null ? new ArrayList<TipoDocumento>(estensioni) : new ArrayList<TipoDocumento>());
		searchEstensioni=true;
		
		this.figli = (figli!=null ? new ArrayList<TipoDocumento>(figli) : new ArrayList<TipoDocumento>());
		searchFigli=true;
		
		searchEstensionePadre=true;
		searchGeneratedClass=true;
		
		autorizzazioniLetturaInizializzate = (this.accessibileA.size() > 0); 
		autorizzazioniInserimentoInizializzate = (this.inseribileDa.size() > 0); 
		autorizzazioniScritturaInizializzate = (this.modificabileDa.size() > 0);
	}
	
	public Long getId() {
		return id_tipo_documento_web;
	}
	
	public String getNomePlurale() {
		return (nomePlurale!=null ? nomePlurale : toString());
	}
	
	public String getWebName() {
		return HttpUtils.getTextForWebLink(getNomePlurale());
	}
	
	public String getWebPage() {
		return "/" + getWebName() + ".htm";
	}
	
	public static TipoDocumento fromWebName(String text) {
		TipoDocumento tFound=null;
		if (text!=null && !text.equals("")) {
			for (TipoDocumento t: values())
				if (text.equals(t.getWebName())) {
					tFound = t;
					break;
				}
		}
		return tFound;
	}
	
	public Class<? extends DocumentoWeb<?>> getGeneratedClass() {
		if (searchGeneratedClass && generatedClass==null) {
			if (estende()!=null)
				generatedClass = estende().getGeneratedClass();
			searchGeneratedClass=false;
		}
		return generatedClass;
	}
	
	public static TipoDocumento fromID(Long id) {
		TipoDocumento eFound=null;
		for (TipoDocumento e: values())
			if (e.id_tipo_documento_web.equals(id))
				eFound=e;			
		
		return eFound;
	}
	
	public TipoDocumento estende(){
		if (searchEstensionePadre && estensione==null) {
			for (TipoDocumento t: values()) {
				List<TipoDocumento> tExt = t.getEstensioni();
				if (tExt!=null && tExt.contains(this)) {
					estensione=t;
					break;
				}
			}
			searchEstensionePadre=false;
		}
		
		return estensione;
	}
	public List<TipoDocumento> getEstensioni(){
		if (searchEstensioni) {
			for (TipoDocumento e: new ArrayList<TipoDocumento>(estensioni)) {
				List<TipoDocumento> estensioniList=e.getEstensioni();
				if (estensioniList.size()>0) {
					estensioni.remove(e);
					estensioni.addAll(estensioniList);
				}
			}
			searchEstensioni=false;
		}
		
		return estensioni;
	}
	public boolean instanceOf(TipoDocumento tipo) {
		return (tipo==this || tipo.getEstensioni().contains(this));
	}
	
	public List<TipoDocumento> getFigli(){
		if (searchFigli) {
			if (estende()!=null)
				figli.addAll(estende().getFigli());
			searchFigli=false;

			// Gestisce il caso particolare della SEZIONE_AMMINISTRAZIONE_TRASPARENTE e del GRUPPO_ATTIVITA che puà generare se stessa
			/**/if (this == SEZIONE_AMMINISTRAZIONE_TRASPARENTE)
				figli.add(0, SEZIONE_AMMINISTRAZIONE_TRASPARENTE);
			else if (this == GRUPPO_ATTIVITA)
				figli.add(0, ATTIVITA);/**/
			/**else if (this == GRUPPO_GIUNTE_CAMERALI)
				figli.add(0, GIUNTE_CAMERALI);
			else if (this == GRUPPO_CONSIGLI_CAMERALI)
				figli.add(0, CONSIGLI_CAMERALI);**/
		}
		
		return figli;
	}
	
	public List<TipoDocumento> getPadri(){
		if(hasPadre==null) {
			padri = new ArrayList<TipoDocumento>();
			for (TipoDocumento td : TipoDocumento.values())
				if (td.getFigli()!=null && td.getFigli().indexOf(this)>-1)
					padri.add(td);
			
			if (estende() != null)
				padri.addAll(estende().getPadri());
			
			hasPadre = padri.size()>0;
		}
		
		return padri;
	}
	
	public static Map<TipoDocumento, List<TipoDocumento>> organizza(List<TipoDocumento> listaTipi){
		Map<TipoDocumento, List<TipoDocumento>> mappaTipi = new Hashtable<TipoDocumento, List<TipoDocumento>>();
		for (TipoDocumento tipo: listaTipi){
			TipoDocumento padre=tipo.estende();
			if (padre==null)
				padre=tipo;
			
			List<TipoDocumento> tipiAggregati=mappaTipi.get(padre);
			if (tipiAggregati == null) {
				tipiAggregati=new ArrayList<TipoDocumento>();
				mappaTipi.put(padre, tipiAggregati);
			}
			tipiAggregati.add(tipo);
		}
		
		return mappaTipi;
	}
	
	public static Map<TipoDocumento, List<DocumentoWeb<?>>> organizzaDocumenti(List<DocumentoWeb<?>> documenti){
		Map<TipoDocumento, List<DocumentoWeb<?>>> mappaDoc = new Hashtable<TipoDocumento, List<DocumentoWeb<?>>>();
		for (DocumentoWeb<?> doc: documenti){
			TipoDocumento padre=doc.getTipo().estende();
			if (padre==null)
				padre=doc.getTipo();
			
			List<DocumentoWeb<?>> docAggregati=mappaDoc.get(padre);
			if (docAggregati == null) {
				docAggregati=new ArrayList<DocumentoWeb<?>>();
				mappaDoc.put(padre, docAggregati);
			}
			docAggregati.add(doc);
		}
		
		return mappaDoc;
	}
	
	public String getIcona() {
		return "/imgs/tipi_documento_web/" + immagine;
	}
	
	public List<Autorizzazione> getAccessibileA(){
		if (!autorizzazioniLetturaInizializzate) {
			/*// Aggiunge le autorizzazioni di default 
			List<TipoDocumento> tipiSenzaAuthOperatore = Arrays.asList(SEZIONE_RISERVATA_AMMINISTRATORI, CONSIGLIO_CAMERALE, GIUNTA_CAMERALE, DOCUMENTO_RISERVATO_CONSIGLIO, DOCUMENTO_RISERVATO_GIUNTA, DOCUMENTO_RISERVATO_REVISORI);
			if (!tipiSenzaAuthOperatore.contains(this))	// Esclude i documenti riservati amministratori camerali 
				accessibileA.add(Autorizzazione.DWEB_OPERATORE);*/
			autorizzazioniLetturaInizializzate=true;
		}
		return accessibileA;
	}
	public List<Autorizzazione> getInseribileDa(){
		if (!autorizzazioniInserimentoInizializzate) {
			// Aggiunge le autorizzazioni di default 
			inseribileDa.add(Autorizzazione.DWEB_OPERATORE);
			autorizzazioniInserimentoInizializzate=true;
		}
		return inseribileDa;
	}
	public List<Autorizzazione> getModificabileDa(){
		if (!autorizzazioniScritturaInizializzate) {
			// Aggiunge le autorizzazioni di default 
			modificabileDa.add(Autorizzazione.DWEB_OPERATORE);
			autorizzazioniScritturaInizializzate=true;
		}
		return modificabileDa;
	}
	
	public boolean accessibile(Utente operatore) {
		boolean accessibile = (getAccessibileA().size() == 0);
		if (!accessibile && operatore!=null) {
			accessibile = operatore.authorizedFor(Autorizzazione.ROOT);
			if (!accessibile)
				for (Autorizzazione auth: getAccessibileA())
					if (operatore.getAutorizzazioni().contains(auth)) {
						accessibile=true;
						break;
					}
		}
		return accessibile;
	}
	public boolean modificabile(Utente operatore) {
		boolean modificabile = false;
		if (operatore!=null){
			modificabile = operatore.authorizedFor(Autorizzazione.ROOT);
			if (!modificabile && accessibile(operatore)) {
				modificabile = (getModificabileDa().size() == 0);
				if (!modificabile)
					for (Autorizzazione auth: getModificabileDa())
						if (operatore.getAutorizzazioni().contains(auth)) {
							modificabile=true;
							break;
						}
			}
		}
		return modificabile;
	}
	public boolean inseribile(Utente operatore) {
		boolean inseribile = false;
		if (operatore!=null){
			inseribile = operatore.authorizedFor(Autorizzazione.ROOT);
			if (!inseribile && accessibile(operatore)) {
				inseribile = (getInseribileDa().size() == 0);
				if (!inseribile)
					for (Autorizzazione auth: getInseribileDa())
						if (operatore.getAutorizzazioni().contains(auth)) {
							inseribile=true;
							break;
						}
			}
		}
		return inseribile;
	}
	
	public static List<TipoDocumento> tipiRadice(){
		List<TipoDocumento> radici=new ArrayList<TipoDocumento>();
		for (TipoDocumento t: values())
			if (t.getPadri().size()==0 && t.estende()==null)
				radici.add(t);
		return radici;
	}
/*	Per poter eseguire il metodo senza che si inlooppi, occorre commenatre le righe di codice indicate nel commento seguente:
 *  "Gestisce il caso particolare della SEZIONE_AMMINISTRAZIONE_TRASPARENTE che può generare se stessa"
 */
	public static String stampaAlberatura() {
		String alberoStr = "";
		for (TipoDocumento t: tipiRadice())
			alberoStr += "\r\n"+t.alberatura(1);
		return alberoStr;
	}
	public String alberatura(int livello) {
		String livellatura = " " + StringUtils.rpad("", "*", livello) + " ";
		String alberoStr = livellatura + (estende()!=null ? estende()+": " : "") + this + "\r\n";
		
		livello++;
		for (TipoDocumento f: getFigli())
			if (f.getEstensioni().size()==0)
				alberoStr += f.alberatura(livello);
			else {
				for (TipoDocumento e: f.getEstensioni())
					alberoStr += e.alberatura(livello);
			}
		
		return alberoStr;
	}
	
	public String getGlyphicon() {
		return glyphicon;
	}
	
	
	@Override
	public String toString() {
		String label=name().toLowerCase().replaceAll("_", " ");
		label = Character.toUpperCase(label.charAt(0)) + label.substring(1);
		return label;
	}
	
	public static void main(String args[]) {
		//Logger.write(organizza(Arrays.asList(PROCEDIMENTO, GUIDA, MODULISTICA, PUBBLICAZIONE, COMPETENZA, ATTO_EVENTO)));
		//Logger.write(SEZIONE_AMMINISTRAZIONE_TRASPARENTE.getFigli());
		Logger.write(stampaAlberatura());
		/*for (TipoDocumento t: values()) 
			Logger.write(t + ": " + t.getWebName() + " -> " + t.getWebPage());
		Logger.write(""+fromWebName("pubblicazione"));*/
	}
}
