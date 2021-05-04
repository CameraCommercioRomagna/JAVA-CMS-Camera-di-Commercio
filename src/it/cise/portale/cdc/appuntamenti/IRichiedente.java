package it.cise.portale.cdc.appuntamenti;

import java.util.Date;
import java.util.List;

public interface IRichiedente {
	
	boolean isAzienda();	// Se rappresenta un'impresa
	
	String getNomeCognome();
	String getEmail();
	String getTelefono();
	String getCodiceFiscale();
	
	List<Appuntamento> getAppuntamenti();
	List<Appuntamento> getAppuntamenti(Date giorno);
	List<Appuntamento> getAppuntamenti(Servizio servizio, Date giorno);
	List<Appuntamento> getAppuntamenti(Date dal, Date al);
	List<Appuntamento> getAppuntamenti(Servizio servizio, Date dal, Date al);
	
	boolean ammissibile(Date giorno);
	boolean ammissibile(Servizio servizio, Date giorno);
}
