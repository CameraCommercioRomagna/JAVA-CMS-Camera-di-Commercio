package it.cise.portale.cdc.auth;

import it.cise.db.CounterRecord;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;

public class AutorizzazioneRecord extends CounterRecord {
	
	private static final long serialVersionUID = 536716713280040708L;
	
	public Long id_autorizzazione;
	public String nome;
	public String descrizione;
	public Boolean per_documenti_web;
	
	public final static String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA + ".autorizzazioni";
	
	
	public AutorizzazioneRecord() {
		super(NAME_TABLE);
	}
	
	public AutorizzazioneRecord(Long id, DBConnectPool pool) {
		super(NAME_TABLE, pool);
		this.id_autorizzazione = id;
		load();
	}
	
	public boolean isPer_documenti_web() {
		return per_documenti_web!=null && per_documenti_web;
	}
	
}
