package it.cise.portale.cdc.newsletters;

import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;

public class Sezione extends Record 
	implements Comparable<Sezione> {

	private static final long serialVersionUID = -896782434154315873L;

	public static final String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA+".nl_sezioni";
	
	public Long id_nl_tipo;
	public String nome;
	public Long ordine;
	public String icona;
	public Boolean valida;

	private NewsLetter newsLetter;
	
	public Sezione(NewsLetter n){
		super(NAME_TABLE);
		newsLetter=n;
	}
	
	public Sezione(Long id, String sez, DBConnectPool pool){
		super(NAME_TABLE, pool);
		this.id_nl_tipo = id;
		this.nome = sez;
		load();
		newsLetter=getNewsLetter();
	}

	public NewsLetter getNewsLetter() {
		if(newsLetter==null)
			newsLetter = new NewsLetter(id_nl_tipo, getPool());
		return newsLetter;
	}
	
	public boolean isValida() {
		return valida!=null && valida; 
	}
	
	@Override
	public int compareTo(Sezione o) {
		return ordine.compareTo(o.ordine);
	}
}