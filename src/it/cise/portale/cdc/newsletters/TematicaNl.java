package it.cise.portale.cdc.newsletters;

import it.cise.db.CounterRecord;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import java.util.List;


public class TematicaNl extends CounterRecord{
	
	private static final long serialVersionUID = -3989020923241908563L;

	public final static String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA+".tematiche_nl";
	
	public Long id_tematica;
	public String nome;
	public String id_plp;
	
	
	public TematicaNl(){
		super(NAME_TABLE);
	}
	
	public TematicaNl(DBConnectPool pool){
		super(NAME_TABLE, pool);
	}
	
	public TematicaNl(DBConnectPool pool, Long id){
		super(NAME_TABLE, pool);
		this.id_tematica = id;
		this.load();
	}
	
	public static List<TematicaNl> getTematiche(DBConnectPool pool){
		return loadEntitiesFromQuery("SELECT * FROM " + TematicaNl.NAME_TABLE + " ORDER BY nome", pool, TematicaNl.class);
	}
	
}
