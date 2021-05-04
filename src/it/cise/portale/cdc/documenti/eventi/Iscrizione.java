package it.cise.portale.cdc.documenti.eventi;

import java.util.Date;

import it.cise.db.CounterRecord;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.util.http.HttpUtils;

public class Iscrizione extends CounterRecord{
	
	private static final long serialVersionUID = 3178723598301528846L;

	public final static String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA + ".rel_documenti_web_iscrizioni"; 
	
	public Long id_iscrizione;
	public Long id_documento_web;
	public Date data_iscrizione;
	public String nome;
	public String cognome;
	public String indirizzo;
	public String cap;
	public String comune;
	public String provincia;
	public String stato;
	public String telefono;
	public String email;
	public String num_civ;
	public String rag_sociale;
	public String ruolo;
	public String attivita_azienda;
	public String p_iva;
	public String c_fiscale;
	public String email_fatturazione;
	public String note;
	public Boolean incontro_relatori;
	public String  info_relatori;
	public Boolean interesse_atti;
	public Boolean pagamento_online;
	public Boolean privacy_dati;
	public Boolean privacy_mail;
	public String modalita_di_presenza;
	
	private EdizioneInterna evento;

	
	public Iscrizione() {
		super(NAME_TABLE);
	}
	
	public Iscrizione(EdizioneInterna evento) {
		this();
		initialize(evento.getPool());
		this.evento = evento;
		this.id_documento_web = evento.id_documento_web;
	}
	
	public Iscrizione(Long id, DBConnectPool pool) {
		super(NAME_TABLE, pool);
		this.id_iscrizione = id;
		load();
	}
	
	public EdizioneInterna getEvento() {
		return evento;
	}
}
