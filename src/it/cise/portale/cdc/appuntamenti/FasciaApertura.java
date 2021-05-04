package it.cise.portale.cdc.appuntamenti;

import it.cise.db.Record;

public class FasciaApertura extends Record {
	
	private static final long serialVersionUID = 8519176177795988322L;

	static final String NAME_TABLE = Appuntamento.NAME_SCHEMA + ".fasce_apertura";
	
	public Long id_fascia_apertura;
	public String cod_sportello;
	public String pattern;
	public String note;
	public Boolean attiva;
	
	public FasciaApertura() {
		super(NAME_TABLE);
	}
}
