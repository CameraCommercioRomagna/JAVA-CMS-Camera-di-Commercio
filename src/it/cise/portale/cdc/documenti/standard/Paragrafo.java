package it.cise.portale.cdc.documenti.standard;

import it.cise.db.CounterRecord;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.db.jdbc.NoAssignedPoolException;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.portale.cdc.email.ItemEmailable;
import it.cise.structures.field.NullValueException;
import it.cise.util.auth.Authenticable;

public class Paragrafo extends CounterRecord implements ItemEmailable, Comparable<Paragrafo>{
	
	private static final long serialVersionUID = 2833823491673864263L;
	
	public final static String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA + ".paragrafi";
	public final static String NAME_TABLE_OLD = AbstractDocumentoWeb.NAME_SCHEMA_OLD + ".paragrafi";
	
	public Long id_paragrafo;
	public Long id_documento_web;
	public String titolo;
	public String testo;
	public String img_path; 
	public String img_url;
	public Long ordine;
	
	private Documento documento;
	private Boolean case_old_db;
	
	
	public Paragrafo() {
		super(NAME_TABLE);
	}
	
	protected Paragrafo(Boolean b_case_old_db) {
		super(b_case_old_db!=null && b_case_old_db ? NAME_TABLE_OLD : NAME_TABLE);
		this.case_old_db = b_case_old_db;
	}
	
	public Paragrafo(Documento documento) {
		this();
		initialize(documento.getPool());
		this.documento = documento;
		this.id_documento_web = documento.id_documento_web;
	}
	
	public Paragrafo(Documento documento, Boolean b_case_old_db) {
		this(b_case_old_db);
		initialize(documento.getPool());
		this.documento = documento;
		this.id_documento_web = documento.id_documento_web;
	}
	
	public Paragrafo(Long id, DBConnectPool pool) {
		super(NAME_TABLE, pool);
		this.id_paragrafo = id;
		load();
	}
	
	public Paragrafo(Long id, DBConnectPool pool, Boolean b_case_old_db) {
		super(b_case_old_db!=null && b_case_old_db ? NAME_TABLE_OLD : NAME_TABLE, pool);
		this.id_paragrafo = id;
		this.case_old_db = b_case_old_db;
		load();
	}

	
	public Documento getDocumento() {
		return documento;
	}
	
	public Paragrafo copiaIn(Utente proprietario, Documento nuovoDocumento) {
		Paragrafo copia=new Paragrafo(nuovoDocumento);
		copia.id_documento_web = nuovoDocumento.id_documento_web;
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
			getDocumento().setUltimaModifica(utente);
		return esito;
	}
	@Override
	public boolean update(Authenticable utente) throws NoAssignedPoolException, NullValueException {
		
		boolean esito=super.update(utente);
		if (esito)
			getDocumento().setUltimaModifica(utente);
		return esito;
	}
	@Override
	public boolean delete(Authenticable utente) throws NoAssignedPoolException, NullValueException {
		
		boolean esito=super.delete(utente);
		if (esito)
			getDocumento().setUltimaModifica(utente);
		return esito;
	}

	@Override
	public int compareTo(Paragrafo altroParagrafo){
		int check = 1;
		
		if(altroParagrafo!=null){
			if(ordine!=null && altroParagrafo.ordine!=null)
				check = ordine.compareTo(altroParagrafo.ordine);
			else
				check = ordine!=null ? 1 : (altroParagrafo.ordine!=null ? -1 : 0);
				
			if(check==0)
				check = id_paragrafo.compareTo(altroParagrafo.id_paragrafo);
		}
		
		return check;
	}

	public Long getId() {
		return id_paragrafo;
	}

	public String getTitolo() {
		return titolo;
	}
	
	public String getTesto() {
		return testo;
	}

	public String getImmagine() {
		return img_path;
	}

	public String getInfoTempo() {
		return null;
	}

	public String getData() {
		return null;
	}

	public String getOrario() {
		return null;
	}

}
