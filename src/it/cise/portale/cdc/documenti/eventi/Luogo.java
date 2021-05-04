package it.cise.portale.cdc.documenti.eventi;

import it.cise.db.CounterRecord;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;

public class Luogo extends CounterRecord implements Comparable<Luogo> {
	
	private static final long serialVersionUID = 7181445693101015139L;
	
	public final static String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA + ".luoghi";
	
	public Long id_luogo;
	public String nome;
	public String indirizzo;
	public String provincia;
	public String note;
	public String citta;
	public Boolean no_gmaps;
	  
	public Luogo() {
		super(NAME_TABLE);
	}
	public Luogo(Long id, DBConnectPool pool) {
		super(NAME_TABLE, pool);
		id_luogo=id;
		load();
	}
	
	public String getUploadDirectory() {
		return "/upload/cdc_romagna/luoghi/" + id_luogo + "/";
	}
	
	public String getNome() {
		return nome;
	}
	
	public String getCitta() {
		return (citta==null || citta.trim().equals("") ? "" : citta);
	}
	
	public String getCittaENome(){
		String cittaElab=getCitta();
		return (cittaElab.equals("") ? nome : cittaElab + ", " + nome);
	}
	
	public String getLocalizzazione() {
		return (indirizzo==null || indirizzo.trim().equals("") ? "" : indirizzo + " - ") + getCittaENome();
	}
	
	public String getNomeeIndirizzo() {
		return getNome() +(indirizzo==null || indirizzo.trim().equals("") ? "" :  " - " + indirizzo );
	}
	
	public boolean isOnline() {
		return no_gmaps!=null && no_gmaps;
	}
	
	@Override
	public String toString() {
		return getCittaENome();
	}
	
	@Override
	public int compareTo(Luogo l) {
		if(!nome.equals(l.nome))
			return nome.compareTo(l.nome);
		else
			return id_luogo.compareTo(l.id_luogo);
	}
}
