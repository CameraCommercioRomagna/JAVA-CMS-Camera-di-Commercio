package it.cise.portale.cdc.appuntamenti;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;
import java.util.Map;

import cise.utils.DateUtils;
import cise.utils.Logger;
import it.cise.db.Record;
import it.cise.portale.cdc.Portale;
import it.cise.portale.cdc.auth.Utente;
import it.cise.sql.QueryPager;
import it.cise.structures.preview.Row;

public enum Sportello implements ErogatoreServizi {
	FO01("Forlì - 01", Sede.FORLÌ),
	CE01("Cesena - 01", Sede.CESENA),
	RN01("Rimini - 01", Sede.RIMINI),
	RN02("Rimini - 02", Sede.RIMINI),
	FO_RI01("Forlì - RI01", Sede.RI_FORLÌ),
	FO_RI02("Forlì - RI02", Sede.RI_FORLÌ),
	CE_RI01("Cesena - RI01", Sede.RI_CESENA),
	CE_RI02("Cesena - RI02", Sede.RI_CESENA),
	RN_RI01("Rimini - RI01", Sede.RI_RIMINI),
	RN_RI02("Rimini - RI02", Sede.RI_RIMINI);
	
	private String nome;
	private Sede sede;
	
	private List<Servizio> servizi;
	private List<OpeningRule> regoleApertura;
	

	private Sportello(String nome, Sede sede){
		this.nome=nome;
		this.sede=sede;
		sede.addSportello(this);
	}
	
	public String getCodice(){
		return name();
	}
		
	@Override
	public String getNome() {
		return nome;
	}
	@Override
	public Sede getSede() {
		return sede;
	}
	
	
	public static Sportello getSportello(String codice){
		Sportello pFound=null;
		for (Sportello p: values())
			if (p.getCodice().equals(codice))
				pFound=p;
				
		if (pFound==null)
			throw new IllegalArgumentException("Servizio non corrispondente al valore passatpo in input: " + codice);
		
		return pFound;
	}
	
	@Override
	public Boolean inGruppoErogatori(GruppoErogatori gruppo) {
		return getSede().inGruppoErogatori(gruppo);
	}
	
	@Override
	public GruppoErogatori getGruppoErogatori() {
		return getSede().getGruppoErogatori();
	}
	
	@Override
	public List<Servizio> getServizi() {
		if (servizi == null) {
			servizi=new ArrayList<Servizio>();
			try {
				QueryPager pager=new QueryPager(Portale.getPool());
				pager.set("select id_servizio from " + Appuntamento.NAME_SCHEMA + ".rel_sportelli_servizi where cod_sportello='" + getCodice() + "'");
				for (Row<String> riga: pager)
					servizi.add(Servizio.getServizio(Long.parseLong(riga.getField("id_servizio"))));
			}catch(Exception e){}	
		}
		
		return servizi;
	}
	
	@Override
	public List<Date> giorniChiusura(Date dateStart, Date dateEnd){
		List<Date> chiusure=new ArrayList<Date>();
		for (Annotazione giorno: getAnnotazioni(dateStart, dateEnd)) 
			if (giorno.isChiuso())
				chiusure.add(giorno.getData());
		return chiusure;
	}
	
	public List<Appuntamento> getAppuntamenti(Date giorno) {
		return getAppuntamenti(giorno, giorno);
	}
	public List<Appuntamento> getAppuntamenti(Date dal, Date al) {
		
		rimuoviMancatePrenotazioni();
		
		return Record.loadEntitiesFromQuery("select * from " + Appuntamento.NAME_TABLE + " where data_garbage_collection is null and data_cancellazione is null"
				+ " and cod_sportello='" + getCodice() + "' and"
				+ " (inizio between '" + DateUtils.formatDate(dal, "yyyy-MM-dd") + " 000000' and '" + DateUtils.formatDate(al, "yyyy-MM-dd") + " 235959'"
				+ " or fine between '" + DateUtils.formatDate(dal, "yyyy-MM-dd") + " 000000' and '" + DateUtils.formatDate(al, "yyyy-MM-dd") + " 235959')",
				Portale.getPool(), Appuntamento.class);
	}
	
	public List<Annotazione> getAnnotazioni(Date giorno) {
		return getAnnotazioni(giorno, giorno);
	}
	public List<Annotazione> getAnnotazioni(Date dal, Date al) {
		return Record.loadEntitiesFromQuery("select * from " + Annotazione.NAME_TABLE + " where"
				+ " cod_sportello='" + getCodice() + "' and"
				+ " data between '" + DateUtils.formatDate(dal, "yyyy-MM-dd") + "' and '" + DateUtils.formatDate(al, "yyyy-MM-dd") + "'",
				Portale.getPool(), Annotazione.class);
	}

	public List<OpeningRule> regoleApertura(){
		if (regoleApertura == null) {
			/* TEST con:
			List<String> regexps=Arrays.asList(
				"!HH:mm[16:00-17:00]",
				"u[1-5] HH:mm[09:00-12:00]",
				"u[2,4] HH:mm[14:00-16:00]"
			);
			*/
			List<String> regexps = new ArrayList<String>();
			for (FasciaApertura fa: Record.loadEntitiesFromQuery("select * from " + FasciaApertura.NAME_TABLE + " where attiva and cod_sportello='" + getCodice() + "'", Portale.getPool(), FasciaApertura.class))
				regexps.add(fa.pattern);
			
			regoleApertura=new ArrayList<OpeningRule>();
			if (regexps!=null) 
				for (String regexp: regexps){
					regexp=regexp.trim();
					if (!regexp.equals("")) {
						OpeningRule regola=new OpeningRule();
						String[] rulesRegexp=regexp.split(" ");
						for (String ruleRE: rulesRegexp)
							regola.add(new RulePattern(ruleRE.trim()));
						regoleApertura.add(regola);
					}
				}
		}
		return regoleApertura;
	}
	
	public String getInfoAperture() {
		String info = "";
		if(regoleApertura()!=null) {
			info = regoleApertura().toString();
			info = " - " + info;
			info = info.replaceAll("u\\[1\\],", "lun:");
			info = info.replaceAll("u\\[2\\],", "mar:");
			info = info.replaceAll("u\\[3\\],", "mer:");
			info = info.replaceAll("u\\[4\\],", "gio:");
			info = info.replaceAll("u\\[5\\],", "ven:");
			info = info.replaceAll("u\\[1-5\\],", "lun-ven:");
			info = info.replaceAll("u\\[1-4\\],", "lun-gio:");
			info = info.replaceAll("u\\[1-2\\],", "lun-mar:");
			info = info.replaceAll("u\\[4-5\\],", "gio-ven:");
			info = info.replaceAll("u\\[2-5\\],", "mar-ven:");
			info = info.replaceAll("HH_mm\\[", " ");
			info = info.replaceAll("\\[", "");
			info = info.replaceAll("\\]", "");
		}		
		return info;
	}
	
	@Override
	public List<Date> fasceApertura(Servizio servizio, Date giorno){
		return fasceApertura(servizio, giorno, giorno);
	}
	@Override
	public List<Date> fasceApertura(Servizio servizio, Date dateStart, Date dateEnd){
		
		rimuoviMancatePrenotazioni();
		
		List<Date> fasce=new ArrayList<Date>();
		
		if (regoleApertura().size()>0 && getServizi().contains(servizio)) {	// Se lo sportello ha aperture e il servizio è tra quelli previsti...
			dateStart=DateUtils.trunc(dateStart);
			dateEnd=DateUtils.addDays(DateUtils.trunc(dateEnd), 1);
			
			Date slotStart = dateStart;
			Date slotEnd = null;
			
			List<Date> chiusure=giorniChiusura(dateStart, dateEnd);

			boolean dateInRange=true;
			do {
				if (!chiusure.contains(DateUtils.trunc(slotStart))) {	// ...esclusi i giorni di chiusura...
					slotEnd = servizio.termina(slotStart);
					if (!slotEnd.after(dateEnd)) {
						// ... uno slot è utilizzabile se...
						// ... matcha almeno una regola di apertura
						for(OpeningRule r: regoleApertura()) {
							if (r.match(slotStart) && r.match(slotEnd))
								fasce.add(slotStart);
						}
						
						slotStart = slotEnd;
					}else
						dateInRange=false;
				}else
					slotStart=DateUtils.addDays(slotStart, 1);

			} while (dateInRange);			
		}
		
		return fasce;
	}
	
	@Override
	public List<Date> fasceDisponibilita(Servizio servizio, Date giorno){
		return fasceDisponibilita(servizio, giorno, giorno);
	}
	@Override
	public List<Date> fasceDisponibilita(Servizio servizio, Date dateStart, Date dateEnd){
		
		List<Appuntamento> appuntamenti=getAppuntamenti(dateStart, dateEnd);
		
		List<Date> fasce=new ArrayList<Date>();
		for (Date slotStart: fasceApertura(servizio, dateStart, dateEnd)) {
			
			boolean occupato=false;
			Date slotEnd = servizio.termina(slotStart);
			
			// Uno slot è disponibile se non esiste un appuntamento che inizia o finisce all'interno dello slot
			openingLoop:
			for (Appuntamento a: appuntamenti)
				if ((!a.getInizio().before(slotStart) && a.getInizio().before(slotEnd))	// La data di inizio dell'appuntamento è contenuta all'interno dello slot (Ai in [Ss;Se[)...
					|| (a.getFine().after(slotStart) && !a.getFine().after(slotEnd))) {	// ...oppure la data di fine dell'appuntamento è contenuta all'interno dello slot (Af in ]Ss;Se])
					
					occupato=true;
					break openingLoop;
				}
			
			if (!occupato)
				fasce.add(slotStart);
		}
		
		return fasce;
	}
	
	@Override
	public boolean disponibile(Date giorno, Servizio servizio) {
		return fasceDisponibilita(servizio, giorno).contains(giorno);
	}
	
	private synchronized void rimuoviMancatePrenotazioni() {
		String query = "select * from " + Appuntamento.NAME_TABLE + " where data_garbage_collection is null and data_cancellazione is null "
				+ " and data_prenotazione is null and (now() - data_inserimento) > interval '" + Appuntamento.TIME_LIMIT_PRENOTAZIONE + " minutes'";
		List<Appuntamento> appuntamentiNonPrenotati=Record.loadEntitiesFromQuery(query, Portale.getPool(), Appuntamento.class);
		
		for (Appuntamento a: appuntamentiNonPrenotati) {
			a.data_garbage_collection = new Date();
			a.update();
		}
	}
	@Override
	public synchronized Appuntamento opziona(Date inizio, Servizio servizio, Utente operatore) {
		
		Appuntamento appuntamento=null;
		if (disponibile(inizio, servizio)) {
			appuntamento = new Appuntamento();
			appuntamento.initialize(Portale.getPool());
			appuntamento.id_servizio = servizio.getId();
			appuntamento.cod_sportello = getCodice();
			appuntamento.inizio = inizio;
			appuntamento.fine = servizio.termina(inizio);
			appuntamento.data_inserimento = new Date();
			appuntamento.insert(operatore);
		}
		return appuntamento;
	}
	
	
	public static void main(String[] args){
		//it.cise.db.jdbc.DBConnectPool connPostgres=new it.cise.db.jdbc.DBConnectPool(new it.cise.db.database.PostgreSQLDatabase("dbportal_cdc_test"),new it.cise.db.user.Postgres(), 5, 15, 1);
		it.cise.db.jdbc.DBConnectPool connPostgres=new it.cise.db.jdbc.DBConnectPool(new it.cise.db.database.PostgreSQLDatabase("dbportal_cdc"),new it.cise.db.user.Postgres(), 5, 15, 1);
		Portale.setPool(connPostgres);
		
		/*int numTest=100;
		for (int i=0; i<numTest; i++) {
			Servizio servizio=Servizio.getServizi(true).get((int)(Math.random() * Servizio.getServizi(true).size()));
			Date domani=DateUtils.addDays(new Date(), (int)(Math.random() * 7));
			Logger.write(" *** AVVIO STEP " + i + " per: "+ domani + " " + servizio);
			//Servizio servizio=Servizio.CARTA_TACHIGRAFICA_AZIENDA;
			//Date domani=DateUtils.addDays(new Date(), 1);
			
			//Map<Sportello, List<Date>> disponibilita=servizio.accessibile(domani);
			Map<Sede, List<Date>> disponibilita=servizio.accessibile(Sede.class, domani);
			Logger.write(" *** disponibità " + disponibilita);
			
			if (disponibilita.size()>0) {
				//for (ErogatoreServizi erogatore: disponibilita.keySet()) {
				ErogatoreServizi erogatore = new ArrayList<ErogatoreServizi>(disponibilita.keySet()).get((int)(Math.random() * disponibilita.keySet().size()));
					
					List<Date> fasceLibere=disponibilita.get(erogatore);
					
					//Date data = fasceLibere.get(0);
					Date data = fasceLibere.get((int)(Math.random() * fasceLibere.size()));
					Logger.write(" *** Richiesta prenotazione " + data + " " + servizio);
					Appuntamento a=erogatore.opziona(data, servizio, null);
					
					if (a!=null) {
						Richiedente richiedente=(Richiedente)a.addRichiedente();
						richiedente.setNome("Mauro");
						richiedente.setCognome("Zamagni");
						richiedente.setIntermediario(null);
						richiedente.setEmail("prova@prova.it");
						richiedente.setTelefono("0543/");
						
						Pratica p=a.addPratica();
						p.intestatario_cf="xyz";
						a.prenota(null);
						Logger.write(" *** Prenotato " + data + " " + a.getSportello());
					}else
						Logger.write(" *** Impossibile prenotare " + data + " " + servizio);
				//}
			}else
				Logger.write(" *** Impossibile prenotare (nessuna disponibilità) " + domani + " " + servizio);
		}*/
		
		/*Date di=DateUtils.stringToDate("20/05/2019","dd/MM/yyyy");
		Date df=DateUtils.stringToDate("21/05/2019","dd/MM/yyyy");
		Map<Sede, List<Date>> disponibilita=Servizio.SPID.accessibile(Sede.class, di, df);
		Logger.write(" ** " + disponibilita);*/
		
		/*Logger.write(" ** " + Sportello.FO01.regoleApertura());
		Logger.write(" ** " + Sportello.FO01.fasceDisponibilita(Servizio.CNS));*/
	}

}

class OpeningRule extends ArrayList<RulePattern>{
	private static final long serialVersionUID = -5018970528990235545L;

	public boolean match(Date giorno) {
		boolean esito=true;
		for (RulePattern rp: this)
			esito = esito && rp.match(giorno);
		return esito;
	}
}

class RulePattern{
	private static final String NEGATIVE_PATTERN="!";
	
	private boolean negative;	// indica se il pattern deve essere negato
	private Rule pattern;
	private RuleType type;
	private List<String> matchElements;
	
	public RulePattern(String dateTimePattern) {
		parse(dateTimePattern);
	}

	/** Verifica se la data in input matcha il pattern */
	public boolean match(Date giorno) {
		boolean esito=false;
		
		String dPatternValue = DateUtils.formatDate(giorno, pattern.getPattern());
		switch (type) {
			case INTERVAL:
				String lowerLimit=matchElements.get(0);
				String upperLimit=matchElements.get(1);
				esito=dPatternValue.compareTo(lowerLimit)>=0 && dPatternValue.compareTo(upperLimit)<=0;
				break;
			case LIST:
			default:
				esito=matchElements.contains(dPatternValue);
				break;
		}
		return (negative ? !esito : esito);
	}
	
	private void parse(String dateTimePattern) {
		try {
			if (dateTimePattern.startsWith(NEGATIVE_PATTERN)) {
				negative=true;
				dateTimePattern=dateTimePattern.substring(NEGATIVE_PATTERN.length());
			}
		
			String elements=null;
			int initBracket = dateTimePattern.indexOf("[");
			if (initBracket != -1) {
				int endBracket = dateTimePattern.indexOf("]");
				elements = dateTimePattern.substring(initBracket+1, endBracket);
				dateTimePattern=dateTimePattern.substring(0, initBracket);
			}
			
			try {
				pattern = DayRule.fromPattern(dateTimePattern);
			}catch(IllegalArgumentException iae){
				pattern = HourRule.fromPattern(dateTimePattern);
			}
			
			findMatchElements(elements);
		}catch(Exception e) {
			e.printStackTrace();
			throw new IllegalArgumentException("Impossibile parsare il pattern: " + dateTimePattern);
		}
	}
	
	private void findMatchElements(String elements) {
		if (elements!=null){
			for (RuleType t: RuleType.values())
				if (elements.contains(t.getSplitCharacter())){
					type = t;
					
					matchElements = new ArrayList<String>();
					for (String e: elements.split(t.getSplitCharacter()))
						matchElements.add(e.trim()); 
				}
			
			if (matchElements==null) {
				type = RuleType.LIST;
				matchElements = Arrays.asList(elements.trim());
			}
		}
	}
	
	@Override
	public String toString() {
		String testo = (negative ? NEGATIVE_PATTERN : "") + pattern;
		testo += "[";
		int i=0;
		for (String e: matchElements) {
			testo += ((i==0 ? "" : type.getSplitCharacter()) + e);
			i++;
		}
		testo += "]";
		return testo; 
	}
}

interface Rule {
	String getPattern();
}

enum DayRule implements Rule {
	G("G"), //Era designator	Text	AD
	yyyy("yyyy"), //Year	Year	1996; 96
	Y("Y"), //Week year	Year	2009; 09
	MM("MM"), //Month in year	Month	July; Jul; 07
	w("w"), //Week in year	Number	27
	W("W"), //Week in month	Number	2
	D("D"), //Day in year	Number	189
	d("d"), //Day in month	Number	10
	F("F"), //Day of week in month	Number	2
	E("E"), //Day name in week	Text	Tuesday; Tue
	u("u"), //Day number of week (1 = Monday, ..., 7 = Sunday)	Number	1
	a("a"); //Am/pm marker	Text	PM

	private String pattern;

	
	private DayRule(String pattern){
		this.pattern = pattern;
	}
	
	@Override
	public String getPattern() {
		return pattern;
	}
	
	public static Rule fromPattern(String pattern) {
		for (DayRule dr: values())
			if (dr.getPattern().equals(pattern))
				return dr;
		
		throw new IllegalArgumentException("Impossibile trovare una DayRule per il pattern = " + pattern);
	}
}

enum HourRule implements Rule {
	HH_mm("HH:mm"),
	H("H"), //Hour in day (0-23)	Number	0
	k("k"), //Hour in day (1-24)	Number	24
	K("K"), //Hour in am/pm (0-11)	Number	0
	h("h"), //Hour in am/pm (1-12)	Number	12
	m("m"), //Minute in hour	Number	30
	s("s"), //Second in minute	Number	55
	S("S"), //Millisecond	Number	978
	z("z"), //Time zone	General time zone	Pacific Standard Time; PST; GMT-08:00
	Z("Z"), //Time zone	RFC 822 time zone	-0800
	X("X"); //Time zone	

	private String pattern;
	
	
	private HourRule(String pattern){
		this.pattern = pattern;
	}
	
	@Override
	public String getPattern() {
		return pattern;
	}
	
	public static Rule fromPattern(String pattern) {
		for (HourRule hr: values())
			if (hr.getPattern().equals(pattern))
				return hr;
		
		throw new IllegalArgumentException("Impossibile trovare un'HourRule per il pattern = " + pattern);
	}
}

enum RuleType {
	INTERVAL("-"), LIST(",");
	
	private String splitChar;
	
	private RuleType(String splitChar) {
		this.splitChar = splitChar;
	}
	
	public String getSplitCharacter(){
		return splitChar;
	}
}