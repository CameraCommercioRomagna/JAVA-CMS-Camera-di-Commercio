package it.cise.portale.cdc.documenti.eventi;

import java.util.Date;

import it.cise.db.Record;
import it.cise.db.jdbc.NoAssignedPoolException;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.structures.field.NullValueException;
import it.cise.util.auth.Authenticable;

public class Organizzatore extends Record implements Comparable<Organizzatore>{

	private static final long serialVersionUID = -2843104746877861698L;

	public final static String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA + ".rel_documenti_web_enti";
	
	public Long id_documento_web;
	public Long id_ente;
	public Long id_tipo_collaborazione;
	public Long ordine;

	private EdizioneInterna evento;
	private Ente ente;
	
	public Organizzatore() {
		super(NAME_TABLE);
	}
	
	public Organizzatore(EdizioneInterna evento) {
		super(NAME_TABLE);
		initialize(evento.getPool());
		this.evento=evento;
		this.id_documento_web = evento.id_documento_web;
	}
	
	public EdizioneInterna getEvento() {
		if(evento==null)
			evento = new EdizioneInterna(id_documento_web, getPool());
		return evento;
	}

	public Ente getEnte() {
		if (ente == null)
			ente = new Ente(id_ente, getPool());
		return ente;
	}
	
	public TipoCollaborazione getTipoCollaborazione() {
		return TipoCollaborazione.fromID(id_tipo_collaborazione);
	}

	Organizzatore copiaIn(Utente proprietario, EdizioneInterna nuovaEdizione) {
		Organizzatore copia=new Organizzatore(nuovaEdizione);
		copia.id_documento_web = nuovaEdizione.id_documento_web;
		copia.id_ente = id_ente;
		copia.id_tipo_collaborazione = id_tipo_collaborazione;
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
	public int compareTo(Organizzatore org){
		int check = 1;
		
		if(org!=null){
			if(ordine!=null && org.ordine!=null)
				check = ordine.compareTo(org.ordine);
			else
				check = ordine!=null ? 1 : (org.ordine!=null ? -1 : 0);
				
			if(check==0)
				check = id_ente.compareTo(org.id_ente);
		}
		
		return check;
	}
}
