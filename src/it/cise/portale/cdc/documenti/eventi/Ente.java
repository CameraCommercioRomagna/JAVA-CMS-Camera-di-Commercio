package it.cise.portale.cdc.documenti.eventi;

import it.cise.db.CounterRecord;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;

public class Ente extends CounterRecord implements Comparable<Ente> {
	
	private static final long serialVersionUID = 7082516421491823309L;

	public final static String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA + ".enti";
	
	public Long id_ente;
	public String nome;
	public String indirizzo;
	public String provincia;
	public String nazione;
	public String tel;
	public String email;
	public String url;
	public String img_path;
	public String note;

	public Ente() {
		super(NAME_TABLE);
	}
	public Ente(Long id, DBConnectPool pool) {
		super(NAME_TABLE, pool);
		
		this.id_ente = id;
		load();
	}
	
	public String getUploadDirectory() {
		return "/upload/cdc_romagna/enti/" + id_ente + "/";
	}
	
	public String getLocalizzazione() {
		String indirizzo_c = indirizzo;
		if (provincia!=null && !provincia.equals(""))
			indirizzo_c += " (" + provincia + ") ";
		
		if (nazione!=null && !nazione.equals("") && !nazione.equals("Italia"))
			indirizzo_c += " - " + nazione;
		
		return indirizzo_c;
	}
	
	
	@Override
	public int compareTo(Ente e) {
		
		if(!nome.equals(e.nome))
			return nome.compareTo(e.nome);
		else
			return id_ente.compareTo(e.id_ente);
	}
}
