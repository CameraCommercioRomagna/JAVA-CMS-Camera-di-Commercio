package it.cise.portale.cdc.documenti;

import java.util.*;

import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.referenza.Referenza;
import it.cise.portale.cdc.newsletters.NewsLetter;
import it.cise.portale.cdc.newsletters.PromozioneDocumentoWeb;
import it.cise.util.auth.Authenticable;


public interface DocumentoWeb<D extends DocumentoWeb<D>>{
	
	Long getId();
	
	String getTitolo();
	String getAbstract();
	String getInfo();
	String getIcona();
	String getImmagine();
	TipoDocumento getTipo();
	List<String> getParoleChiave();
	
	String getResourceName();
	String getAdminLink();
	String getPreviewLink();
	String getPathLink();
	String getLink();
	
	boolean isCaseOldDB();
	void setCaseOldDB(Boolean case_old_db);
	
	Visibilita getVisibilita();
	Priorita getPriorita();
	
	Utente getProprietario();
	Date getUltimaModifica();
	Date getPubblicazione();
	Date getScadenza();
	Long getAnnoPertinenza();
	Date getTemporizzazione();
	
	boolean valido();
	boolean pubblico();
	boolean scaduto();
	boolean archiviato();
	
	void setValidato(boolean validato);
	void setPriorita(Priorita priorita);
	void setVisibilita(Visibilita visibilita);
	void setPubblicazione(Date d);
	void setScadenza(Date d);
	void setAnnoPertinenza(Long a);
	void valida(Utente operatore, boolean valida);
	
	void confermaAggiornamento(Utente operatore);
	long ritardoAggiornamento();	// in millisecondi
	float indiceRitardoAggiornamento();
	float indiceRitardoAggiornamentoSezione();
	
	D copia(Utente proprietario);
	D copiaIn(Utente proprietario, DBConnectPool pool, PaginaWeb<?> padrePrincipale);
	Referenza creaNuovoLink(Utente proprietario);
	Referenza creaNuovoLinkIn(Utente proprietario, DBConnectPool pool, PaginaWeb<?> padrePrincipale);
	
	List<PromozioneDocumentoWeb> getPromozioniSuNewsletter(NewsLetter nl);
	
	boolean accessibile(Utente operatore);
	boolean modificabile(Utente operatore);
	 
	String getUploadDirectory();
	
	// TODO - Serve?
	boolean delete(Authenticable utente);
}