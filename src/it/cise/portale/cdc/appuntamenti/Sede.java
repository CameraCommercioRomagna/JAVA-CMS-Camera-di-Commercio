package it.cise.portale.cdc.appuntamenti;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import cise.utils.Logger;
import it.cise.portale.cdc.auth.Utente;

public enum Sede implements ErogatoreServizi {
	FORLÌ("Corso della Repubblica 5", GruppoErogatori.UFF_DIGITALIZZAZIONE), CESENA("Via Gaspare Finali 32", GruppoErogatori.UFF_DIGITALIZZAZIONE), RIMINI("Viale Vespucci 58", GruppoErogatori.UFF_DIGITALIZZAZIONE),
	RI_FORLÌ("Corso della Repubblica 5", GruppoErogatori.UFF_REGISTROIMPRESE), RI_CESENA("Via Gaspare Finali 32", GruppoErogatori.UFF_REGISTROIMPRESE), RI_RIMINI("Viale Vespucci 58", GruppoErogatori.UFF_REGISTROIMPRESE);
	
	private String indirizzo;
	private GruppoErogatori gruppo;
	private List<Sportello> sportelli=new ArrayList<Sportello>();
	
	private Sede(String indirizzo, GruppoErogatori gruppo) {
		this.indirizzo=indirizzo;
		this.gruppo=gruppo;
		gruppo.addSede(this);
	}
	
	void addSportello(Sportello sportello) {
		sportelli.add(sportello);
	}
	
	@Override
	public String toString() {
		String label=name().toLowerCase().replaceAll("RI_", " ");
		label=label.replaceAll("_", " ");
		label = Character.toUpperCase(label.charAt(0)) + label.substring(1);
		return label;
	}

	@Override
	public String getNome() {
		return toString();
	}
	
	public String getIndirizzo() {
		return toString() + " - " + indirizzo;
	}

	@Override
	public Sede getSede() {
		return this;
	}
	
	public List<Sportello> getSportelli() {
		return sportelli;
	}

	@Override
	public Boolean inGruppoErogatori(GruppoErogatori gruppo) {
		return getGruppoErogatori().compareTo(gruppo)==0;
	}
	
	@Override
	public GruppoErogatori getGruppoErogatori() {
		return this.gruppo;
	}
	
	@Override
	public List<Servizio> getServizi() {
		Set<Servizio> servizi=new HashSet<Servizio>();
		for (Sportello sportello: sportelli)
			servizi.addAll(sportello.getServizi());
		return new ArrayList<Servizio>(servizi);
	}

	@Override
	public List<Date> giorniChiusura(Date dal, Date al){
		List<Date> chiusure=new ArrayList<Date>();
		for (Sportello sportello: sportelli)
			chiusure.addAll(sportello.giorniChiusura(dal, al)); 
		
		int numSportelli=sportelli.size();
		if (numSportelli > 1) {
			List<Date> chiusureSoloSportello=new ArrayList<Date>();
			for (Date d: chiusure) {
				boolean chiusuraSede=true;
				for (Sportello sportello: sportelli) {
					if (chiusuraSede && !sportello.giorniChiusura(dal, al).contains(d)) {
						chiusureSoloSportello.add(d);
						chiusuraSede=false;
					}
				}
			}
			chiusure.removeAll(chiusureSoloSportello);
		}
		return chiusure;
	}
	
	@Override
	public List<Appuntamento> getAppuntamenti(Date giorno) {
		return getAppuntamenti(giorno, giorno);
	}
	@Override
	public List<Appuntamento> getAppuntamenti(Date dal, Date al) {
		List<Appuntamento> appuntamenti=new ArrayList<Appuntamento>();
		for (Sportello sportello: sportelli)
			appuntamenti.addAll(sportello.getAppuntamenti(dal, al));
		return appuntamenti;
	}

	@Override
	public List<Annotazione> getAnnotazioni(Date giorno) {
		return getAnnotazioni(giorno, giorno);
	}
	@Override
	public List<Annotazione> getAnnotazioni(Date dal, Date al) {
		List<Annotazione> annotazioni=new ArrayList<Annotazione>();
		for (Sportello sportello: sportelli)
			annotazioni.addAll(sportello.getAnnotazioni(dal, al));
		return annotazioni;
	}
	
	@Override
	public boolean disponibile(Date giorno, Servizio servizio) {
		for (Sportello sportello: sportelli)
			if (sportello.disponibile(giorno, servizio))
				return true;
		return false;
	}

	@Override
	public List<Date> fasceApertura(Servizio servizio, Date giorno) {
		Set<Date> fasce=new TreeSet<Date>();
		for (Sportello sportello: sportelli)
			fasce.addAll(sportello.fasceApertura(servizio, giorno));
		return new ArrayList<Date>(fasce);
	}

	@Override
	public List<Date> fasceApertura(Servizio servizio, Date dateStart, Date dateEnd) {
		Set<Date> fasce=new TreeSet<Date>();
		for (Sportello sportello: sportelli)
			fasce.addAll(sportello.fasceApertura(servizio, dateStart, dateEnd));
		return new ArrayList<Date>(fasce);
	}
	
	@Override
	public List<Date> fasceDisponibilita(Servizio servizio, Date giorno) {
		Set<Date> fasce=new TreeSet<Date>();
		for (Sportello sportello: sportelli)
			fasce.addAll(sportello.fasceDisponibilita(servizio, giorno));
		return new ArrayList<Date>(fasce);
	}

	@Override
	public List<Date> fasceDisponibilita(Servizio servizio, Date dateStart, Date dateEnd) {
		Set<Date> fasce=new TreeSet<Date>();
		for (Sportello sportello: sportelli)
			fasce.addAll(sportello.fasceDisponibilita(servizio, dateStart, dateEnd));
		return new ArrayList<Date>(fasce);
	}

	@Override
	public Appuntamento opziona(final Date inizio, Servizio servizio, Utente operatore) {
		Logger.write(sportelli);
		Set<Sportello> sportelliOrdinati=new TreeSet<Sportello>(new Comparator<Sportello>(){
			@Override
			public int compare(Sportello sportello, Sportello sportello1) {
				int result=Integer.signum(sportello.getAppuntamenti(inizio).size()-sportello1.getAppuntamenti(inizio).size());
				if (result==0)
					return sportello.compareTo(sportello1);
				else
					return result;
			}
		});
		sportelliOrdinati.addAll(sportelli);
		
		Appuntamento appuntamento=null;
		for (Sportello sportello: sportelliOrdinati) {
			appuntamento=sportello.opziona(inizio, servizio, operatore);
			if (appuntamento!=null)
				break;
		}
		return appuntamento;
	}
}
