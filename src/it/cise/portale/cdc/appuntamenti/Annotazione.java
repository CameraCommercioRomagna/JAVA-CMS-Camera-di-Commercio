package it.cise.portale.cdc.appuntamenti;

import java.util.Date;

import it.cise.db.CounterRecord;
import it.cise.db.jdbc.DBConnectPool;

public class Annotazione extends CounterRecord {
	
	private static final long serialVersionUID = -2581296881902322212L;
	public static final String NAME_TABLE = Appuntamento.NAME_SCHEMA + ".annotazioni";
	
	public Long id_annotazione;
	public Date data;
	public String cod_sportello;
	public String note_riservate;
	public Boolean chiuso;
	
	public Annotazione() {
		super(NAME_TABLE);
	}
	public Annotazione(DBConnectPool pool, Long id) {
		this();
		initialize(pool);
		id_annotazione = id;
		load();
	}
	
	public Date getData() {
		return data;
	}
	public Sportello getSportello(){
		return Sportello.getSportello(cod_sportello);
	}
	public String getNoteRiservate() {
		return note_riservate;
	}
	public Boolean isChiuso() {
		return (chiuso==null ? false : chiuso);
	}
	
	public String getDescrizione() {
		return (isChiuso() ? "Sportello " + getSportello() + " chiuso" : getSportello() + ": " + note_riservate);
	}
}
