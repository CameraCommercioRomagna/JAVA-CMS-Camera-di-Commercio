package it.cise.portale.cdc.documenti.eventi;

import it.cise.db.CounterRecord;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.db.jdbc.NoAssignedPoolException;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.portale.cdc.email.ItemEmailable;
import it.cise.structures.field.NullValueException;
import it.cise.util.auth.Authenticable;

public class PuntoProgramma extends CounterRecord implements ItemEmailable, Comparable<PuntoProgramma>{
	
	private static final long serialVersionUID = -979416547727653495L;

	public final static String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA + ".punti_programma";
	
	public Long id_punto;
	public Long id_documento_web;
	public String info_data;
	public String info_ora_inizio;
	public String info_ora_fine; 
	public String titolo;
	public String testo;
	public String img_path; 
	public String img_url;
	public Long ordine;
	
	private EdizioneInterna evento;
	
	
	public PuntoProgramma() {
		super(NAME_TABLE);
	}
	
	public PuntoProgramma(EdizioneInterna evento) {
		this();
		initialize(evento.getPool());
		this.evento = evento;
		this.id_documento_web = evento.id_documento_web;
	}
	
	public PuntoProgramma(Long id, DBConnectPool pool) {
		super(NAME_TABLE, pool);
		this.id_punto = id;
		load();
	}
	
	public EdizioneInterna getEvento() {
		return evento;
	}
	
	public String getInfoTitolo() {
		String temp=getOrario();
		if (titolo!=null && !titolo.equals("")) 
			temp += (!temp.equals("") ? " - " : "") + titolo;
		return temp;
	}
	
	public String getInfoTempo(){
		String temp=getData();
		String orario=getOrario();
		if (orario!=null && !orario.equals("")) 
			temp += (!temp.equals("") ? " - " : "") + orario;
		return temp;
	}
	
	public String getData() {
		return (info_data!=null ? info_data : "");
	}
	
	public String getOrario(){
		String temp="";
		
		if (info_ora_inizio!=null && !info_ora_inizio.equals(""))
			temp += info_ora_inizio;
		if (!temp.equals(""))
			if (info_ora_fine!=null && !info_ora_fine.equals(""))
				temp += "-" + info_ora_fine;
		return temp;
	}
	
	PuntoProgramma copiaIn(Utente proprietario, EdizioneInterna nuovaEdizione) {
		PuntoProgramma copia=new PuntoProgramma(nuovaEdizione);
		copia.id_documento_web = nuovaEdizione.id_documento_web;
		copia.info_data = info_data;
		copia.info_ora_inizio = info_ora_inizio;
		copia.info_ora_fine = info_ora_fine;
		copia.titolo = titolo;
		copia.testo = testo;
		copia.img_path = img_path;
		copia.img_url = img_url;
		copia.ordine = ordine;
		copia.insert(proprietario);
		
		return copia;
	}
	
	@Override
	public boolean insert(Authenticable utente)
		throws NoAssignedPoolException, NullValueException {
		
		boolean esito=super.insert(utente);
		if (esito)
			getEvento().setUltimaModifica(utente);
		return esito;
	}
	@Override
	public boolean update(Authenticable utente) throws NoAssignedPoolException, NullValueException {
		
		boolean esito=super.update(utente);
		if (esito)
			getEvento().setUltimaModifica(utente);
		return esito;
	}
	@Override
	public boolean delete(Authenticable utente) throws NoAssignedPoolException, NullValueException {
		
		boolean esito=super.delete(utente);
		if (esito)
			getEvento().setUltimaModifica(utente);
		return esito;
	}

	@Override
	public int compareTo(PuntoProgramma altroPunto) {
		int check = 1;
		
		if(altroPunto!=null){
			if(ordine!=null && altroPunto.ordine!=null)
				check = ordine.compareTo(altroPunto.ordine);
			else
				check = ordine!=null ? 1 : (altroPunto.ordine!=null ? -1 : 0);
				
			if(check==0)
				check = id_punto.compareTo(altroPunto.id_punto);
		}
		
		return check;
	}

	public Long getId() {
		return id_punto;
	}

	public String getTitolo() {
		return titolo;
	}

	public String getImmagine() {
		return img_path;
	}

	public String getTesto() {
		return testo;
	}
}

