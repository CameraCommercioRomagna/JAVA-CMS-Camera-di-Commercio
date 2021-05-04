package it.cise.portale.cdc.appuntamenti;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import cise.utils.DateUtils;
import cise.utils.StringUtils;
import it.cise.db.CounterRecord;
import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.mailing.MailPending;
import it.cise.portale.cdc.Portale;
import it.cise.portale.cdc.auth.Utente;
import it.cise.util.auth.Authenticable;

public class Appuntamento extends CounterRecord {
	
	private static final long serialVersionUID = -1277566979434272617L;

	public static final String NAME_SCHEMA="appuntamenti";
	public static final String NAME_TABLE=NAME_SCHEMA + ".appuntamenti";
	private static final String CONSTRINT_PRATICHE="pratica_id_appuntamento_fkey";
	
	public static final long TIME_LIMIT_PRENOTAZIONE=20l;	// Espresso in minuti
	public static final long TIME_LIMIT_PRENOTAZIONE_MILLIS=TIME_LIMIT_PRENOTAZIONE * 60 * 1000;	// Espresso in millisecondi
	
	public Long id_appuntamento;
	public String codice;
	public String cod_sportello;
	public Long id_servizio;
	public Date inizio;
	public Date fine;
	public Long id_intermediario;
	public String nome;
	public String cognome;
	public String email;
	public String telefono;
	public String codice_fiscale;
	public String note;
	public Long id_utente;
	public Date data_inserimento;
	public Date data_prenotazione;
	public Date data_cancellazione;
	public Date data_garbage_collection;
	
	private IRichiedente richiedente;
	private boolean utenteCaricato=false;
	private Utente utente;
	private List<Pratica> pratiche;
	
	public Appuntamento() {
		super(NAME_TABLE);
	}
	public Appuntamento(DBConnectPool pool, Long id) {
		this();
		initialize(pool);
		id_appuntamento = id;
		load();
	}
	
	public static Appuntamento fromCodice(String codice) {
		return Record.loadEntitiesFromQuery("select a.* from " + NAME_TABLE + " a where a.codice='" + codice + "' and a.inizio >= now()", Portale.getPool(), Appuntamento.class).get(0);
	}
	
	@Override
	public boolean insert(Authenticable utente) {
		codice = StringUtils.randomString(25);
		return super.insert(utente);
	}
	
	public AppuntamentoStatoInserimento getStatoInserimento() {
		if (!isInserted())
			return null;
		else if (cancellato() || mancataPrenotazione())
			return AppuntamentoStatoInserimento.ANNULLATO;
		else if (prenotato())
			return AppuntamentoStatoInserimento.PRENOTATO;
		else if (opzionato() && (getPratiche() != null && getPratiche().size()>0))
			return AppuntamentoStatoInserimento.OPZIONATO_PRATICHE;
		else if (opzionato() && (getRichiedente() != null))
			return AppuntamentoStatoInserimento.OPZIONATO_RICHIDENTE;
		else if (opzionato())
			return AppuntamentoStatoInserimento.OPZIONATO;
		else
			throw new IllegalStateException("Stato dell'appuntamentonon gestito... controllare il motivo");
	}
	
	public boolean mancataPrenotazione() {
		return isInserted() && data_garbage_collection!=null;
	}
	
	public void cancella(Utente operatore) {
		if (!cancellato() && prenotato()) {
			data_cancellazione=new Date();
			update(operatore);
		}
	}

	public boolean cancellato() {
		return isInserted() && data_cancellazione!=null;
	}
	
	public boolean opzionato() {
		return (isInserted() && !mancataPrenotazione() && !cancellato() && !prenotato());
	}
	
	public boolean prenotato() {
		return data_prenotazione!=null;
	}
	
	public boolean passato() {
		return prenotato() && fine.before(new Date());
	}
	
	
	public boolean prenota(Utente operatore) {
		boolean esito=false;
		if (opzionato() && !prenotato() && prenotazioneInTempo() && getRichiedente().ammissibile(getServizio(), inizio)) {
			id_utente = (operatore!=null ? operatore.id_utente : null);
			data_prenotazione = new Date();
			esito=update(operatore);
		}
		return esito;
	}

	private boolean prenotazioneInTempo() {
		return new Date().getTime() - data_inserimento.getTime() <= TIME_LIMIT_PRENOTAZIONE_MILLIS;
		//return true;
	}
	
	public IRichiedente addRichiedente() {
		if (opzionato()) {
			return new Richiedente(this);
		}else
			throw new IllegalStateException("Impossibile creare un nuovo richiedente per un appuntamento già prenotato: " + this);
	}
	public IRichiedente addRichiedente(Intermediario intermediario) {
		if (opzionato()) {
			Richiedente richiedente=(Richiedente)addRichiedente();
			if (intermediario != null) {
				richiedente.setIntermediario(intermediario);
				return intermediario;
			}else
				return richiedente;
		}else
			throw new IllegalStateException("Impossibile creare un nuovo richiedente per un appuntamento già prenotato: " + this);
	}
	
	public IRichiedente getRichiedente() {
		if (isInserted() && (opzionato() || prenotato()))
			if (richiedente==null)
				richiedente = (
					id_intermediario!=null
					? new Intermediario(getPool(), id_intermediario)
					: (
						email==null || email.equals("")
						? null 
						: new Richiedente(this)
					)
				);

		return richiedente;
	}

	public Pratica addPratica() {
		Pratica pratica=null;
		
		if (opzionato()) {
			if (getRichiedente() != null) {
				int numeroPratiche = getPratiche().size();

				if ((getRichiedente() instanceof Intermediario) && (numeroPratiche < getServizio().getNumeroPraticheIntermediario()))
					pratica = new Pratica(this);
				else if (!(getRichiedente() instanceof Intermediario) && numeroPratiche == 0)
					pratica = new Pratica((Richiedente)getRichiedente());
				else
					throw new IllegalStateException("Impossibile creare una nuova pratica per un appuntamento con un numero massimo di pratiche già inserite" + this);
				
				pratiche.add(pratica);
				return pratica;
			}else
				throw new IllegalStateException("Impossibile creare una nuova pratica per un appuntamento senza richiedente: " + this);
		}else
			throw new IllegalStateException("Impossibile creare una nuova pratica per un appuntamento già prenotato: " + this);
	}
	
	public List<Pratica> getPratiche(){
		if (pratiche == null)
			pratiche = getRelation(CONSTRINT_PRATICHE, Pratica.class, this).getRecords();
		return pratiche;
	}
	
	public Servizio getServizio(){
		return Servizio.getServizio(id_servizio);
	}
	
	public Date getInizio(){
		return inizio;
	}
	
	public Date getFine(){
		return fine;
	}
	
	public Sportello getSportello(){
		return Sportello.getSportello(cod_sportello);
	}
	
	public Utente getInseritore(){
		if (!utenteCaricato) {
			utenteCaricato = true;
			if (id_utente != null)
				utente = new Utente(getPool(), id_utente);
		}
		return utente;
		
	}
	public String getNote(){
		return note;
	}
	
	private static List<Appuntamento> getAppuntamenti(Date domani) {
		List<Appuntamento> appuntamenti=new ArrayList<Appuntamento>();
		for (Sportello sportello: Sportello.values())
			appuntamenti.addAll(sportello.getAppuntamenti(domani));
		return appuntamenti;
	}

	
	public static void main(String[] args) {
		it.cise.db.jdbc.DBConnectPool connPostgres=new it.cise.db.jdbc.DBConnectPool(new it.cise.db.database.PostgreSQLDatabase("dbportal_cdc"),new it.cise.db.user.Postgres(), 5, 15, 1);
		Portale.setPool(connPostgres);
		
		String emailHeader="";
		String emailFooter="";
		
		Date domani = DateUtils.addDays(new Date(), 1);
		for (Appuntamento appuntamento: Appuntamento.getAppuntamenti(domani)) {
			String pratiche="";
			for(Pratica p: appuntamento.getPratiche())
				pratiche+="<li>" + p +" </li>";

			MailPending mail = new MailPending();
			mail.i_from="noreply@xxx.it";
			mail.i_bcc="test@xxx.it";
			mail.i_to=appuntamento.email;
			mail.subject="XXX - Remember appuntamento n." + appuntamento.id_appuntamento;
			mail.contenttype="text/html; charset=utf-8";
			mail.body=emailHeader + "Gentile " + appuntamento.getRichiedente().getNomeCognome() + ",<br/><br/>le ricordiamo l'appuntamento del " + DateUtils.formatDate(appuntamento.getInizio(), "dd/MM/yyyy") + " alle ore " + DateUtils.formatDate(appuntamento.getInizio(), "HH:mm") + " per le seguenti pratiche:<ul>" + pratiche + "</ul>presso lo sportello di " + appuntamento.getSportello().getSede().getIndirizzo() + ".<ol type=\"A\"><li>Per disdire l'appuntamento clicca <a href=\"http://www.xxx.it/appuntamenti-online/disdici.htm?appc=" + appuntamento.codice + "\">qui</a></li><li>Per cambiare la data / ora dell'appuntamento è necessario prima disdire quello già fissato (cliccando nella parte riguardante la disdetta) e solo successivamente prenotare una nuova data / ora tra quelle ancora disponibili</li></ol> Per eventuali informazioni rimane attiva la casella di posta elettronica: abc@xxx.it. <br/><br/>Cordiali saluti,<br/>XXX<br/>" + emailFooter;
			mail.page_ins="ISCREV";
			mail.submit();
		}
	}
	
}
