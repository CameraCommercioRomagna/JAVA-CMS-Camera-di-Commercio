package it.cise.portale.cdc.documenti.eventi;

import java.util.Date;

import it.cise.portale.cdc.documenti.DocumentoWeb;

public interface Edizione<D extends DocumentoWeb<D>> extends DocumentoWeb<D>{
	
	Date getDal();
	Date getAl();
	String periodo();
	String getNotePeriodo();
	String periodoENote();
	String getOrario();
	
	Luogo getLuogo();
	String luogo();
	String getNoteLuogo();
	String luogoENote();
	
	String getLinkIscrizione();
}
