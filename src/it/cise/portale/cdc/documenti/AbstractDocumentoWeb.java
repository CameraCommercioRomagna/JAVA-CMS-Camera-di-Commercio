package it.cise.portale.cdc.documenti;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import javax.naming.OperationNotSupportedException;

import cise.utils.DateUtils;
import cise.utils.Logger;
import cise.utils.StringUtils;
import it.cise.db.*;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.Visibilita;
import it.cise.portale.cdc.documenti.referenza.Referenza;
import it.cise.portale.cdc.email.EmailWeb;
import it.cise.portale.cdc.newsletters.NewsLetter;
import it.cise.portale.cdc.newsletters.NumeroNewsLetter;
import it.cise.portale.cdc.newsletters.PromozioneDocumentoWeb;
import it.cise.sql.PreviewQuery;
import it.cise.util.auth.Authenticable;
import it.cise.util.http.HttpUtils;


public abstract class AbstractDocumentoWeb<D extends DocumentoWeb<D>>
	extends CounterRecord
	implements DocumentoWeb<D>, Comparable<AbstractDocumentoWeb<D>> {
	
	private static final long serialVersionUID = -1202822498033883620L;
	
	public final static String NAME_SCHEMA="portalowner2";
	public final static String NAME_SCHEMA_OLD="portalowner_old";
	public final static String NAME_TABLE = NAME_SCHEMA + ".documenti_web";
	public final static String NAME_TABLE_OLD = NAME_SCHEMA_OLD + ".documenti_web";
	private final static String NAME_TABLE_DWEB_PADRI_FIGLI = NAME_SCHEMA + ".rel_documenti_web_documenti";
	private final static String NAME_TABLE_DWEB_PADRI_FIGLI_OLD = NAME_SCHEMA_OLD + ".rel_documenti_web_documenti";
			
	public final static String REF_DOC_AUTH = "documenti_web_id_autorizzazione";
	public final static String REF_DOC_PROPRIETARIO = "documenti_web_id_proprietario";
	public final static String REF_DOC_TIPO_DOC = "documenti_web_id_tipo_documento_web_fkey";
	public final static String REF_DOC_TIPO_SISTEMA = "documenti_web_id_tipo_sistema_fkey";
	
	public final static String UPLOAD_ROOT_DIRECTORY = "/upload/cdc_romagna/dweb/";
	
	public final static long AGGIORNAMENTO_RITARDO_MESI = 12l;
	public final static long AGGIORNAMENTO_RITARDO_MESI_MILLIS = AGGIORNAMENTO_RITARDO_MESI * 30 * 24 * 60 * 60 * 1000;

	public final static String PARAMETER_ID="ID_D";
	public final static String PARAMETER_PAGE="PAGE";
	public final static String PARAMETER_PREVIEW="preview";
	public final static String PARAMETER_PREVIEW_VALUE="yes";

	public Long id_documento_web;
	public Long id_tipo_sistema;
	public Long id_tipo_documento_web;
	public String titolo;
	public String abstract_txt;
	public String icona;
	
	public Long id_autorizzazione;
	
	public Long id_proprietario;
	public String parole_chiave;
	
	public String alias;	// Rappresenta un alias utilizzabile come URL
	public Date data_inserimento;
	public Date data_pubblicazione;
	public Date data_scadenza;
	public Date data_validazione;
	public Boolean validato;
	public Long anno_pertinenza;
	public Date data_modifica;
	public Long punteggio;
	public Long priorita;
	public Date data_ultimo_aggiornamento;
	
	public Float score;

	private Utente proprietario;
	protected Boolean case_old_db = false;
	
	private PaginaWeb<?> paginaPadre; 

	/* Campi utilizzati per il salvataggio dei padri nel caso in cui l'oggetto non sia ancora inserito a DB*/
	private List<PaginaWeb<?>> bupInsertPadri;
	private PaginaWeb<?> bupInsertPadrePrincipale;
	/* FINE campi salvataggio dei padri */

	
	protected AbstractDocumentoWeb() {
		super(NAME_TABLE);
	}
	
	protected AbstractDocumentoWeb(Long id, DBConnectPool pool) {
		super(NAME_TABLE, pool);
		this.id_documento_web = id;
		load();
	}
	protected AbstractDocumentoWeb(Boolean b_case_old_db) {
		super(b_case_old_db!=null && b_case_old_db ? NAME_TABLE_OLD : NAME_TABLE);
		this.case_old_db = b_case_old_db;
	}
	
	protected AbstractDocumentoWeb(Long id, DBConnectPool pool, Boolean b_case_old_db) {
		super(b_case_old_db!=null && b_case_old_db ? NAME_TABLE_OLD : NAME_TABLE, pool);
		this.id_documento_web = id;
		this.case_old_db = b_case_old_db;
		load();
	}
	protected AbstractDocumentoWeb(Record documento) {
		super(documento);
	}
	
	
	/* 	Interfaccia: DocumentoWeb */
	@Override
	public Long getId() {
		return id_documento_web;
	}
	@Override
	public String getTitolo() {
		return titolo;
	}
	@Override
	public String getAbstract() {
		return abstract_txt;
	}
	
	@Override
	public Utente getProprietario() {
		if (proprietario == null)
			proprietario = new Utente(getPool(), id_proprietario);
		return proprietario;
	}
	
	@Override
	public Date getTemporizzazione(){
		List<Date> dateUtili=new ArrayList<Date>();
		dateUtili.add(data_pubblicazione);
		
		return DateUtils.closedToToday(dateUtili);
	}

	@Override
	public boolean insert(Authenticable utente){
		/*if (priorita==null)
			priorita = Priorita.MEDIA.getValore();*/
		boolean eseguito=super.insert(utente);
		if (eseguito)
			setUltimaModifica(utente);
		
		if (eseguito && bupInsertPadri!=null) {
			// Recupera l'assegnazione del padre che era stata attributita all'oggetto
			assegnaPadri(((Utente)utente), this, bupInsertPadri, bupInsertPadrePrincipale, false);
			
			// svuota i valori utilizzati per il backup
			bupInsertPadri=null;
			bupInsertPadrePrincipale=null;
		}
		
		return eseguito;
	}
	@Override
	public boolean update(Authenticable utente){
		/*if (priorita==null)
			priorita = Priorita.MEDIA.getValore();*/
		boolean setUltimaModifica = true;
		try {
			setUltimaModifica = !getField("data_ultimo_aggiornamento").isModified();
		} catch (NoSuchFieldException e) {}
		
		boolean eseguito=super.update(utente);
		if (eseguito && setUltimaModifica)
			setUltimaModifica(utente);
		
		return eseguito;
	}
	
	public void setUltimaModifica(Authenticable utente){
		data_modifica=new Date();
		super.update(utente);
	}
	@Override
	public Date getUltimaModifica() {
		if (data_modifica == null){
			Date oggi=new Date();
			return (oggi.before(getScadenza()) ? oggi : getScadenza());
		}else
			return data_modifica;
	}


	@Override
	public Long getAnnoPertinenza() {
		return (anno_pertinenza!=null ? 
				anno_pertinenza : 
					(data_pubblicazione!=null ? new Long(DateUtils.getYear(data_pubblicazione)) : null)
				);
	}

	@Override
	public boolean pubblico() {
		Date oggi = DateUtils.stringToDate(DateUtils.formatDate(new Date(),"dd/MM/yyyy"));
		// Per il corretto funzionamento dei confronti è necessario che 
		// i metodi getPubblicazione() e getScadenza() abbiano come ore, minuti, secondi
		// la mezzanotte!!
		return (valido() && !getPubblicazione().after(oggi) && !getScadenza().before(oggi));
	}

	@Override
	public boolean archiviato() {
		Date oggi = DateUtils.stringToDate(DateUtils.formatDate(new Date(),"dd/MM/yyyy"));
		// Per il corretto funzionamento dei confronti è necessario che 
		// i metodi getPubblicazione() e getScadenza() abbiano come ore, minuti, secondi
		// la mezzanotte!!
		return (valido() && !getPubblicazione().after(oggi) && getScadenza().before(oggi));
	}

	@Override
	public boolean valido() {
		return validato!=null && validato;
	}
	
	@Override
	public boolean scaduto() {
		Date oggi = DateUtils.stringToDate(DateUtils.formatDate(new Date(),"dd/MM/yyyy"));
		return (valido() && !getPubblicazione().after(oggi) && getScadenza().before(oggi));
	}
	
	@Override
	public Priorita getPriorita(){
		return Priorita.getPriorita(priorita);
	}
	@Override
	public void setPriorita(Priorita priorita) {
		this.priorita=priorita.getValore();
	}
	
	@Override
	public void setPubblicazione(Date d){
		data_pubblicazione=d;
	}
	@Override
	public void setScadenza(Date d){
		data_scadenza=d;
	}
	@Override
	public void setAnnoPertinenza(Long a) {
		if (a==null && data_pubblicazione!=null)
			anno_pertinenza=new Long(DateUtils.getYear(data_pubblicazione));
		else
			anno_pertinenza=a;
	}
	@Override
	public void setValidato(boolean validato){
		this.validato=validato;
	}
	
	@Override
	public void valida(Utente operatore, boolean valida){
		this.validato=valida;
		data_validazione = (valida ? new Date() : null);
		update(operatore);
		
		if (valida && data_ultimo_aggiornamento == null)
			confermaAggiornamento(operatore);
	}
	
	@Override
	public void confermaAggiornamento(Utente operatore) {
		if (valido()) {
			data_ultimo_aggiornamento = new Date();
			update(operatore);
		}else
			throw new IllegalStateException("Impossibile confermare l'aggiornamento per un documento non valido: " + this);
	}
	@Override
	public long ritardoAggiornamento() {
		if (pubblico()) {
			if (data_ultimo_aggiornamento != null) {
				long diffDate = new Date().getTime() - data_ultimo_aggiornamento.getTime();
				return (diffDate > 0 ? diffDate : 0l);
			}else
				throw new IllegalStateException("Un documento pubblico DEVE avere la data_ultimo_aggiornamento settata: " + this);
		}else
			throw new IllegalStateException("Impossibile calcolare il ritardo di aggiornamento per un documento non pubblico: " + this);
	}
	@Override
	public float indiceRitardoAggiornamento() {
		if (pubblico()) {
			float indice = ritardoAggiornamento() / ((float)AGGIORNAMENTO_RITARDO_MESI_MILLIS);
			if (indice > 1)
				indice = 1;
			return indice;
		}else
			throw new IllegalStateException("Impossibile calcolare il ritardo di aggiornamento per un documento non pubblico: " + this);
	}
	
	protected List<Float> indiciRitardoAggiornamentoSezione() {
		List<Float> indici = new ArrayList<>();
		
		indici.add(indiceRitardoAggiornamento());
		for (DocumentoWeb<?> f: getFigli())
			indici.addAll(((AbstractDocumentoWeb<?>)f).indiciRitardoAggiornamentoSezione());
		
		return indici;
	}
	
	@Override
	public float indiceRitardoAggiornamentoSezione() {
		if (pubblico()) {
			/* Modalità 1
			List<Float> indici = new ArrayList<>();
			
			indici.add(indiceRitardoAggiornamento());
			for (DocumentoWeb<?> f: getFigli())
				indici.add(f.indiceRitardoAggiornamentoSezione());*/
			List<Float> indici = indiciRitardoAggiornamentoSezione();
			
			float indice = 0f;
		    for (Float i : indici)
		    	indice += i;
		    
		    return indice / indici.size();
		}else
			throw new IllegalStateException("Impossibile calcolare il ritardo di aggiornamento per un documento non pubblico: " + this);
	}
	
	@Override
	public String getPathLink(){
		String pathPadre=null;
		try {
			pathPadre = getPadre().getPathLink();
		}catch(Exception e) {
			pathPadre = "/";
		}
		return (isCaseOldDB() && (pathPadre==null || !pathPadre.startsWith("/archive/")) ? "/archive" : "") + pathPadre + (getTipo()==TipoDocumento.HOME_PAGE ? "" : HttpUtils.getTextForWebLink(getTitolo()) + "/");
	}
	
	@Override
	public String getLink(){
		return getPathLink() + getResourceName() + "?" + PARAMETER_ID + "=" + id_documento_web;
	}
	
	@Override
	public String getPreviewLink(){
		return getLink() + "&" + PARAMETER_PREVIEW + "=" + PARAMETER_PREVIEW_VALUE;
	}
	
	@Override
	public String getAdminLink(){
		return "/amministrazione/index.htm?" + PARAMETER_ID + "=" + id_documento_web;
	}
	
	@Override
	public boolean isCaseOldDB() {
		return case_old_db!=null && case_old_db;
	}
	
	@Override
	public void setCaseOldDB(Boolean case_old_db_b) {
		this.case_old_db = case_old_db_b;
	}
	
	@Override
	public String getInfo() {
		return "Aggiornato al " + DateUtils.formatDate(data_ultimo_aggiornamento);
	}
	
	@Override
	public Date getPubblicazione(){
		return data_pubblicazione;
	}
	
	@Override
	public Date getScadenza() {
		return data_scadenza;
	}
	
	@Override
	public String getIcona() {
		return (icona!=null ? icona : getTipo().getIcona());	
	}
	@Override
	public String getImmagine() {
		return icona;	
	}
	
	@Override
	public TipoDocumento getTipo(){
		return TipoDocumento.fromID(id_tipo_documento_web);
	}
	
	@Override
	public boolean accessibile(Utente operatore){
		return getTipo().accessibile(operatore);
	}
	@Override
	public boolean modificabile(Utente operatore){
		return accessibile(operatore) && getTipo().modificabile(operatore);
	}
	
	@Override
	public Visibilita getVisibilita(){
		return Visibilita.getVisibilita(punteggio);
	}
	@Override
	public void setVisibilita(Visibilita visibilita) {
		punteggio=visibilita.getValore();
	}

	private void initAbstractInformation(Utente proprietario, AbstractDocumentoWeb<?> nuovoDocumento, DBConnectPool pool) {
		nuovoDocumento.initialize(pool);
		
		nuovoDocumento.titolo="Copia di " + titolo;
		nuovoDocumento.abstract_txt=abstract_txt;
		nuovoDocumento.icona=icona;
		nuovoDocumento.id_tipo_documento_web = id_tipo_documento_web;
		nuovoDocumento.id_tipo_sistema = id_tipo_sistema;
		nuovoDocumento.priorita=priorita;
		nuovoDocumento.punteggio=punteggio;
		
		nuovoDocumento.data_inserimento = new Date();
		nuovoDocumento.data_pubblicazione = data_pubblicazione;
		nuovoDocumento.data_scadenza = data_scadenza;
		nuovoDocumento.anno_pertinenza = anno_pertinenza;
		nuovoDocumento.validato = false;
		nuovoDocumento.anno_pertinenza = null;
		nuovoDocumento.data_modifica = nuovoDocumento.data_inserimento;
		nuovoDocumento.data_ultimo_aggiornamento = null;
		
		nuovoDocumento.parole_chiave = parole_chiave;
		nuovoDocumento.id_proprietario = (Long) proprietario.id_utente;
	}

	public void assegnaPadre(Utente proprietario, PaginaWeb<?> padrePrincipale){
		List<PaginaWeb<?>> padri = new ArrayList<PaginaWeb<?>>();
		padri.add(padrePrincipale);
		assegnaPadri(proprietario, padri, padrePrincipale);
	}
	public void assegnaPadri(Utente proprietario, List<PaginaWeb<?>> padri, PaginaWeb<?> padrePrincipale){
		assegnaPadri(proprietario, this, padri, padrePrincipale, true);
	}
	protected static void assegnaPadri(Utente proprietario, DocumentoWeb<?> documento, List<PaginaWeb<?>> padri, PaginaWeb<?> padrePrincipale, boolean clean){
		AbstractDocumentoWeb<?> documentoAbs = (AbstractDocumentoWeb<?>)documento;
		if (documentoAbs!=null) {
			if (documentoAbs.isInserted()) {
				// Analizza i padri per mantenere solo quelli "leciti" nella gerarchia dei tipi
				List<TipoDocumento> tipiPadri=documentoAbs.getTipo().getPadri();
				for (PaginaWeb<?> p: new ArrayList<PaginaWeb<?>>(padri))
					if (!tipiPadri.contains(p.getTipo()))
						padri.remove(p);

				SQLTransactionManager queryManager=new SQLTransactionManager(documentoAbs, documentoAbs.getPool());
				if (clean) 
					queryManager.executeCommandQuery(proprietario, "delete from " + NAME_TABLE_DWEB_PADRI_FIGLI  + " WHERE id_documento_web_figlio=" + documentoAbs.id_documento_web);
				
				if (padri != null) {
					for (PaginaWeb<?> p: padri) {
						// La logica dell'ordinamento nasce per ordinare i figli tra di loro -> inizializzo a null  
						queryManager.executeCommandQuery(
							proprietario, 
							"insert into " + NAME_TABLE_DWEB_PADRI_FIGLI  + "(id_documento_web_padre, id_documento_web_figlio, padre_principale, ordine) " + 
								"VALUES(" + p.id_documento_web + ", " + documentoAbs.id_documento_web + ", " + (p.id_documento_web.equals(padrePrincipale.id_documento_web)) + ", null)"
						);
					}
				}
			} else {
				// salva i dati in attesa che l'oggetto sia inserito (il metodo insert() li recupererà)
				documentoAbs.bupInsertPadri = padri;
				documentoAbs.bupInsertPadrePrincipale = padrePrincipale;
			}
		}
	}
	
/*
 * Duplica il documento ed il suo collegamento con i padri: non duplica, cioè, i suoi figli!
 * Il duplicato viene assegnato a tutte le aree del documento originale
 */
	@Override
	public D copia(Utente proprietario){
		D copia = copiaIn(proprietario, getPool(), getPadre());
		List<PaginaWeb<?>> padri = getPadri(false, null, null, null, null, null);
		assegnaPadri(proprietario, copia, padri, getPadre(), true);
		return copia;
	}
/*	
 * Duplica il documento e lo assegna ad una nuova rea (che, quindi, è anche principale)
 */
	@Override
	@SuppressWarnings("unchecked")
	public D copiaIn(Utente proprietario, DBConnectPool pool, PaginaWeb<?> padrePrincipale){
		
		AbstractDocumentoWeb<D> copia = null;
		try {
			copia = (AbstractDocumentoWeb<D>)getClass().newInstance();
			initAbstractInformation(proprietario, copia, pool);
			
			copia.insert(proprietario);
			
			List<PaginaWeb<?>> listaPadre = Arrays.asList(padrePrincipale);
			assegnaPadri(proprietario, copia, listaPadre, padrePrincipale, false);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return (D)copia;
	}
	
	@Override
	public Referenza creaNuovoLink(Utente proprietario){
		return creaNuovoLinkIn(proprietario, getPool(), getPadre());
	}

	@Override
	public Referenza creaNuovoLinkIn(Utente proprietario, DBConnectPool pool, PaginaWeb<?> padrePrincipale){
		Referenza refLink=new Referenza();
		
		initAbstractInformation(proprietario, refLink, pool);
		// Resetta alcune informazioni impostate dal metodo precedente...
		refLink.titolo = "Collegamento a " + getTitolo();
		refLink.id_tipo_sistema = TipoSistema.LINK.getId();
		refLink.setPriorita(Priorita.MEDIA);
		refLink.setVisibilita(Visibilita.NON_VISIBILE);
		refLink.data_pubblicazione = data_pubblicazione;
		refLink.data_scadenza = data_scadenza;
		if(refLink.data_pubblicazione!=null)
			refLink.anno_pertinenza = new Long(DateUtils.getYear(refLink.data_pubblicazione));
		
		// ...e setta le informazioni tipiche della referenza
		refLink.url = getLink();
		refLink.id_tipo_documento_web = getTipo().getId();
		refLink.insert(proprietario);
		
		List<PaginaWeb<?>> listaPadre = Arrays.asList(padrePrincipale);
		assegnaPadri(proprietario, refLink, listaPadre, padrePrincipale, false);
		
		return refLink;
	}
	
	@Override
	public boolean delete(Authenticable utente) {
		boolean success = true;
		for (DocumentoWeb<?> f: getFigli()) {
			/* TODO deve prima eliminare la relazione padre figlio */
			if (success)
				success = success && f.delete(utente);
		}
		if (success)
			success = super.delete(utente);
		return success;
	}
	
	@Override
	public List<String> getParoleChiave(){
		return (parole_chiave!=null ?
			Arrays.asList(parole_chiave.split(",")) :
			new ArrayList<String>());
	}
	
	
	public EmailWeb creaEmailWeb(Utente proprietario, boolean inserito) {
			
			EmailWeb emailFiglia = new EmailWeb(getPool());
			emailFiglia.titolo = titolo;
			emailFiglia.abstract_txt=abstract_txt;
			emailFiglia.icona=icona;
			
			emailFiglia.id_proprietario = proprietario.id_utente;
			emailFiglia.id_documento_web = id_documento_web;
			emailFiglia.data_inserimento = new Date();
			
			if (inserito) 
				emailFiglia.insert(proprietario);
			
			return emailFiglia;	
		}
	

	public DocumentoWeb<?> creaFiglio(Utente proprietario, TipoSistema tipoSistema, TipoDocumento tipoDocumento, boolean inserito)
		throws OperationNotSupportedException {
		
		if (this instanceof PaginaWeb<?>) {
			PaginaWeb<?> paginaCorrente = (PaginaWeb<?>)this;
			
			AbstractDocumentoWeb<?> docFiglio=(AbstractDocumentoWeb<?>)DocumentFactory.create(getPool(), tipoSistema, tipoDocumento);
			docFiglio.titolo = "Nuova pagina web - " + tipoDocumento;
			docFiglio.id_proprietario = proprietario.id_utente;
			
			docFiglio.id_tipo_documento_web = tipoDocumento.getId();
			docFiglio.id_tipo_sistema = tipoSistema.getId();
			docFiglio.priorita=Priorita.MEDIA.getValore();
			docFiglio.punteggio=Visibilita.VISIBILE_DOVE_COLLOCATO.getValore();
			
			docFiglio.data_inserimento = new Date();
			docFiglio.data_pubblicazione = new Date();
			docFiglio.data_scadenza = data_scadenza;
			docFiglio.anno_pertinenza = anno_pertinenza;
			docFiglio.validato = false;
			docFiglio.data_modifica = data_inserimento;
			
			if (inserito) 
				docFiglio.insert(proprietario);
			
			List<PaginaWeb<?>> listaPadre = Arrays.asList(paginaCorrente);
			assegnaPadri(proprietario, docFiglio, listaPadre, paginaCorrente, false);
			
			return docFiglio;	
		}else
			throw new OperationNotSupportedException(getClass() + " non può creare documenti figli");
	}
	
	public List<DocumentoWeb<?>> getFigli(){
		return getFigli(null, null, true, true, false, Visibilita.VISIBILE_DOVE_COLLOCATO, TipoOrdinamentoDocumenti.MANUALE);
	}
	public List<DocumentoWeb<?>> getFigli(TipoDocumento tipiDocumento){
		return getFigli(tipiDocumento, null, true, true, false, Visibilita.VISIBILE_DOVE_COLLOCATO, TipoOrdinamentoDocumenti.MANUALE);
	}
	protected List<DocumentoWeb<?>> getFigli(TipoDocumento tipiDocumento, TipoSistema tipiSistema){
		return getFigli(tipiDocumento, tipiSistema, true, true, false, Visibilita.VISIBILE_DOVE_COLLOCATO, TipoOrdinamentoDocumenti.MANUALE);
	}
	public List<DocumentoWeb<?>> getFigli(TipoDocumento tipiDocumento, Visibilita visibilita){
		return getFigli(tipiDocumento, null, true, true, false, visibilita, TipoOrdinamentoDocumenti.MANUALE);
	}
	public List<DocumentoWeb<?>> getFigli(TipoDocumento tipiDocumento, TipoSistema tipiSistema, Boolean validati, Boolean pubblicati, Boolean scaduti){
		return getFigli(tipiDocumento, tipiSistema, validati, pubblicati, scaduti, Visibilita.VISIBILE_DOVE_COLLOCATO, TipoOrdinamentoDocumenti.MANUALE);
	}
	public List<DocumentoWeb<?>> getFigli(TipoDocumento tipiDocumento, TipoSistema tipiSistema, Boolean validati, Boolean pubblicati, Boolean scaduti, Visibilita visibilita, TipoOrdinamentoDocumenti ordine){
		return getFigli(tipiDocumento, tipiSistema, validati, pubblicati, scaduti, visibilita, ordine, null);
	}
	public List<DocumentoWeb<?>> getFigli(TipoDocumento tipiDocumento, TipoSistema tipiSistema, Boolean validati, Boolean pubblicati, Boolean scaduti, Visibilita visibilita, TipoOrdinamentoDocumenti ordine, Map<String, Object> altriParametri){
		
		String listaIDTipiDoc="";
		if (tipiDocumento!=null) {
			List<TipoDocumento> tipiDaRicercare=tipiDocumento.getEstensioni();
			if (tipiDaRicercare.size() == 0)
				tipiDaRicercare = Arrays.asList(tipiDocumento);
			
			for (TipoDocumento tf: tipiDaRicercare)
				listaIDTipiDoc += ((!listaIDTipiDoc.equals("") ? ", " : "") + tf.getId());
		}
		
		String titolo=null, username_proprietario=null;
		if (altriParametri != null) {
			titolo = (String)altriParametri.get("titolo");
			username_proprietario = (String)altriParametri.get("username_proprietario");
		}
		
		String queryFigli = ""+
				"	SELECT "
				+ "		d.* "
				+ "	FROM "
				+ "		" + (case_old_db!=null && case_old_db ? NAME_TABLE_OLD : NAME_TABLE) + " d"
				+ "		INNER JOIN " + (case_old_db!=null && case_old_db ? NAME_TABLE_DWEB_PADRI_FIGLI_OLD : NAME_TABLE_DWEB_PADRI_FIGLI) + " reld ON (d.id_documento_web=reld.id_documento_web_figlio)"
				+ "	WHERE "
				+ " 	reld.id_documento_web_padre=" + id_documento_web
				+ (tipiDocumento!=null ? 
					"	AND d.id_tipo_documento_web in (" + listaIDTipiDoc + ")" : "" )
				+ (tipiSistema!=null ? 
					"	AND d.id_tipo_sistema=" + tipiSistema.getId() : "" )
				+ (validati!=null ? 
					"	AND " + (validati ? "" : "not ") + "d.validato" : "" )
				+ (pubblicati!=null ? 
					"	AND d.data_pubblicazione " + (pubblicati ? "<=" : ">") + " current_date": "" )
				+ (scaduti!=null ? 
						"	AND d.data_scadenza " + (scaduti ? "<" : ">=") + " current_date": "" )
				+ (visibilita!=null ? 
						(visibilita==Visibilita.NON_VISIBILE ?
								"	AND d.punteggio = " + visibilita.getValore() :
								"	AND d.punteggio between " + visibilita.getValore() + " and "+ Visibilita.VISIBILE_HOME_PAGE.getValore())
						: "")
				+ (titolo!=null && !titolo.trim().equals("") ?
						" AND (d.id_documento_web::text = '" + StringUtils.doubleQuotes(titolo) + "' or d.titolo ilike '%" + StringUtils.doubleQuotes(titolo) + "%')" : "")
				+ (username_proprietario!=null && !username_proprietario.trim().equals("") ?
						" AND id_proprietario in (select id_utente from " + Utente.NAME_TABLE  + " where username ilike '%" + username_proprietario + "%' ) " : "")
				+ (ordine==TipoOrdinamentoDocumenti.MANUALE ?
				  " ORDER BY reld.ordine ASC NULLS FIRST, d.id_documento_web DESC" : "");
		
		List<CounterRecord> recordDocumenti=loadEntitiesFromQuery(queryFigli, getPool(), CounterRecord.class, (case_old_db!=null && case_old_db ? NAME_TABLE_OLD : NAME_TABLE));
		List<DocumentoWeb<?>> documenti=DocumentFactory.castAll(recordDocumenti, case_old_db);
		
		if (ordine == TipoOrdinamentoDocumenti.TEMPORALE) {
			TreeSet<DocumentoWeb<?>> documentiOrdinati=new TreeSet<DocumentoWeb<?>>(documenti);
			documenti = new ArrayList<DocumentoWeb<?>>(documentiOrdinati);
		}
		return documenti;
	}
	
	public List<DocumentoWeb<?>> getSottoalbero(){
		return getSottoalbero(null, null);
	}
	public List<DocumentoWeb<?>> getSottoalbero(TipoDocumento tipiDocumento){
		return getSottoalbero(tipiDocumento, null);
	}
	public List<DocumentoWeb<?>> getSottoalbero(TipoDocumento tipiDocumento, TipoSistema tipiSistema){
		return getSottoalbero(tipiDocumento, tipiSistema, true, true, false, Visibilita.VISIBILE_DOVE_COLLOCATO);
	}
	public List<DocumentoWeb<?>> getSottoalbero(TipoDocumento tipiDocumento, TipoSistema tipiSistema, Boolean validati, Boolean pubblicati, Boolean scaduti, Visibilita visibilita){
		List<DocumentoWeb<?>> documenti=getFigli(tipiDocumento, tipiSistema, validati, pubblicati, scaduti, visibilita, TipoOrdinamentoDocumenti.TEMPORALE);
		Set<DocumentoWeb<?>> documentiOrdinati = new TreeSet<DocumentoWeb<?>>(documenti);
		
		for (DocumentoWeb<?> f: getFigli(null, null, validati, pubblicati, scaduti, visibilita, TipoOrdinamentoDocumenti.TEMPORALE))
			documentiOrdinati.addAll(((AbstractDocumentoWeb<?>)f).getSottoalbero(tipiDocumento, tipiSistema, validati, pubblicati, scaduti, visibilita));
		
		return new ArrayList<DocumentoWeb<?>>(documentiOrdinati);
	}
	
	public List<PaginaWeb<?>> getPadri(boolean principale, TipoDocumento tipiDocumento, TipoSistema tipiSistema, Boolean validati, Boolean pubblicati, Boolean scaduti){
		
		String queryPadri = ""+
				"	SELECT "
				+ "		d.* "
				+ "	FROM "
				+ "		" + (case_old_db!=null && case_old_db ? NAME_TABLE_OLD : NAME_TABLE) + " d"
				+ "		INNER JOIN " + (case_old_db!=null && case_old_db ? NAME_TABLE_DWEB_PADRI_FIGLI_OLD : NAME_TABLE_DWEB_PADRI_FIGLI) + " reld ON (d.id_documento_web=reld.id_documento_web_padre)"
				+ "	WHERE "
				+ " 	reld.id_documento_web_figlio=" + id_documento_web
				+ (principale ? 
					"	AND reld.padre_principale " :
					""	// se non viene richiesto solo il padre principale, allora li prende tutti (e NON solo i NON principali)
				)
				+ (tipiDocumento!=null ? 
					"	AND d.id_tipo_documento_web = " + tipiDocumento.getId() : "" )
				+ (tipiSistema!=null ? 
					"	AND d.id_tipo_sistema=" + tipiSistema.getId() : "" )
				+ (validati!=null ? 
					"	AND " + (validati ? "" : "not ") + "d.validato" : "" )
				+ (pubblicati!=null ? 
					"	AND d.data_pubblicazione " + (pubblicati ? "<=" : ">") + " current_date": "" )
				+ (scaduti!=null ? 
					"	AND d.data_scadenza " + (scaduti ? "<" : ">=") + " current_date": "" );
		
		List<CounterRecord> recordDocumenti=loadEntitiesFromQuery(queryPadri, getPool(), CounterRecord.class, (case_old_db!=null && case_old_db ? NAME_TABLE_OLD : NAME_TABLE));
		List<DocumentoWeb<?>> documenti=DocumentFactory.castAll(recordDocumenti, case_old_db);
		
		TreeSet<PaginaWeb<?>> documentiOrdinati=new TreeSet<PaginaWeb<?>>();
		for (DocumentoWeb<?> d: documenti)
			if (d instanceof PaginaWeb<?>)
				documentiOrdinati.add((PaginaWeb<?>)d);
		
		return new ArrayList<PaginaWeb<?>>(documentiOrdinati);
	}
	
	protected List<PaginaWeb<?>> getPadri(TipoDocumento tipiDocumento, TipoSistema tipiSistema){
		return getPadri(false, tipiDocumento, tipiSistema, true, true, false);
	}

	public PaginaWeb<?> getPadre(){
		if (paginaPadre == null)
			try {
				paginaPadre=getPadri(true, null, null, null, null, null).get(0);
			}catch (Exception e) {}
		
		return paginaPadre;
	}
	
	public Long getOrdineInPadre(PaginaWeb<?> padre) {
		Long ordine = null;
		if(padre!=null) {
			PreviewQuery prevOrdine = new PreviewQuery(getPool());
			prevOrdine.setPreview("select ordine from " + NAME_SCHEMA + ".rel_documenti_web_documenti where id_documento_web_padre=" + padre.id_documento_web + " and id_documento_web_figlio=" + this.id_documento_web);
			try {
				ordine = Long.parseLong(prevOrdine.getField(0));
			}catch(Exception e) {}
		}
		return ordine;
	}
	
	public void setOrdineInPadre(PaginaWeb<?> padre, Long ordine) {
		if(padre!=null) {
			SQLTransactionManager sqlMan = new SQLTransactionManager(this, getPool());
			sqlMan.executeCommandQuery("update " + NAME_SCHEMA + ".rel_documenti_web_documenti set ordine=" + ordine + " where id_documento_web_padre=" + padre.id_documento_web + " and id_documento_web_figlio=" + this.id_documento_web);
		}
	}
	
	@Override
	public String getUploadDirectory() {
		Long id = getId();
		if (!isInserted() && (id == null))
			try {
				// Se l'id non è ancora stato inizializzato, allora lo prebnde dalla sequenza
				((CounterTableRecord)getStruttura()).getCounter().setValue();
			} catch (CounterException e) {
				e.printStackTrace();
			}
		return UPLOAD_ROOT_DIRECTORY + getId() + "/";
	}

	@Override
	public List<PromozioneDocumentoWeb> getPromozioniSuNewsletter(NewsLetter nl) {
		return loadEntitiesFromQuery("select p.* from " + PromozioneDocumentoWeb.NAME_TABLE + " p inner join " + NumeroNewsLetter.NAME_TABLE + " n on (p.id_nl_numero=n.id_nl_numero) where p.id_documento_web="+id_documento_web + " and p.id_nl_tipo="+nl.id_nl_tipo + " order by n.data", nl.getPool(), PromozioneDocumentoWeb.class, this);
	}
	
	
	public static String stampaAlberatura(DBConnectPool pool) {
		String alberoStr = "";
		for (TipoDocumento t: TipoDocumento.values()) {
			if (t.getPadri().size()==0 && t.estende()==null) {
				for (DocumentoWeb<?> docRoot: DocumentFactory.loadAll(pool, t, null, null, null, null))
					alberoStr += "\r\n"+((AbstractDocumentoWeb<?>)docRoot).alberatura(StileAlberatura.CSV, 1);
			}
		}
		return alberoStr;
	}
	private String alberatura(StileAlberatura stile, int livello) {
		final String SEPARATORE_CSV = "|";
		String livellatura = " " + StringUtils.rpad("", "*", livello) + SEPARATORE_CSV;
		
		livello++;
		String alberoStrFigli = "";
		List<DocumentoWeb<?>> figli=getFigli(null, null, null, null, null, null, TipoOrdinamentoDocumenti.MANUALE);
		int figliValidati=0;
		for (DocumentoWeb<?> f: figli) {
			alberoStrFigli += ((AbstractDocumentoWeb<?>)f).alberatura(stile, livello);
			if (f.valido())
				figliValidati++;
		}
		String alberoStr = "";
		switch (stile){
			case CSV:
				alberoStr += livellatura + getTipo() + SEPARATORE_CSV + getId() + (getPadre()!=null ? SEPARATORE_CSV+"padre="+SEPARATORE_CSV + getPadre().getId() : SEPARATORE_CSV+SEPARATORE_CSV) + SEPARATORE_CSV + getTitolo() + SEPARATORE_CSV +  getProprietario().getUsername()+ SEPARATORE_CSV + (valido() ? "" : "non ") + "validato"+SEPARATORE_CSV + DateUtils.formatDate(getPubblicazione()) + SEPARATORE_CSV + DateUtils.formatDate(getScadenza()) + SEPARATORE_CSV;
				alberoStr += figli.size() + SEPARATORE_CSV +"figli" + SEPARATORE_CSV + figliValidati + SEPARATORE_CSV + "validati";
				alberoStr += SEPARATORE_CSV + getLink();
				/*new*/ 
				alberoStr += SEPARATORE_CSV + getAbstract().replaceAll("\\r\\n", "");
				alberoStr += SEPARATORE_CSV + getParoleChiave() + SEPARATORE_CSV + getAnnoPertinenza() + SEPARATORE_CSV + getVisibilita();
				break;
			case FOLDER:
			default:
				alberoStr = livellatura + getTipo() + " " + getId() + ": " + getTitolo() + " (" +  getProprietario().getUsername()+ ", " + (valido() ? "" : " non") + " validato, pubblico [" + DateUtils.formatDate(getPubblicazione()) + "; " + DateUtils.formatDate(getScadenza()) + "])";
		}
		alberoStr += "\r\n";
		alberoStr += alberoStrFigli;
		
		return alberoStr;
	}
	
	public int compareTo(AbstractDocumentoWeb<D> o) {
		// 1. confronta le priorità
		int compareValue=o.getPriorita().compareTo(getPriorita());
		
		if (compareValue==0){
			// 2. confronta le data di riferimento
			compareValue=o.getTemporizzazione().compareTo(getTemporizzazione());
			
			if (compareValue==0){
				// 3. confronta gli ID
				compareValue=id_documento_web.compareTo(o.id_documento_web);
			}
		}
		return compareValue;
	}
	
	
	public static void main(String[] args) throws Exception{
		//it.cise.db.jdbc.DBConnectPool connPostgres=new it.cise.db.jdbc.DBConnectPool(new it.cise.db.database.PostgreSQLDatabase("dbportal_cdc_test"),new it.cise.db.user.Postgres(), 5, 15, 1);
		it.cise.db.jdbc.DBConnectPool connPostgres=new it.cise.db.jdbc.DBConnectPool(new it.cise.db.database.PostgreSQLDatabase("dbportal_cdc"),new it.cise.db.user.Postgres(), 5, 15, 1);
        /*PaginaWeb<?> d = (PaginaWeb<?>)DocumentFactory.load(connPostgres, 554l);
        Logger.write("d=" + d);
        Logger.write("d=" + ((Edizione)d).getAtti());*/
		Logger.write(stampaAlberatura(connPostgres));
		/*Competenza competenza=new Competenza(233l, connPostgres);
		Logger.write(""+competenza.getAttivita());*/		
		/*NumeroNewsLetter numero = new NumeroNewsLetter(39l, connPostgres);
		numero.pubblica(new Utente(connPostgres, 9007l));*/
    }
}

enum StileAlberatura {
	FOLDER, CSV;
}