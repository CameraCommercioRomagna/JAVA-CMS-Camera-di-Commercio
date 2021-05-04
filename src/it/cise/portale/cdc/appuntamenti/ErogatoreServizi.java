package it.cise.portale.cdc.appuntamenti;

import java.util.Date;
import java.util.List;

import it.cise.portale.cdc.auth.Utente;

public interface ErogatoreServizi {
	
	String getNome();
	Sede getSede();
	List<Servizio> getServizi();
	
	List<Appuntamento> getAppuntamenti(Date giorno);
	List<Appuntamento> getAppuntamenti(Date dal, Date al);
	List<Annotazione> getAnnotazioni(Date giorno);
	List<Annotazione> getAnnotazioni(Date dal, Date al);
	List<Date> giorniChiusura(Date dateStart, Date dateEnd);
	
	List<Date> fasceApertura(Servizio servizio, Date giorno);
	List<Date> fasceApertura(Servizio servizio, Date dateStart, Date dateEnd);

	boolean disponibile(Date giorno, Servizio servizio);
	List<Date> fasceDisponibilita(Servizio servizio, Date giorno);
	List<Date> fasceDisponibilita(Servizio servizio, Date dateStart, Date dateEnd);
	Appuntamento opziona(Date inizio, Servizio servizio, Utente operatore);
	
	Boolean inGruppoErogatori(GruppoErogatori gruppo);
	GruppoErogatori getGruppoErogatori();
}
