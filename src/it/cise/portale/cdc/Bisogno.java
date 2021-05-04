package it.cise.portale.cdc;

import java.util.ArrayList;
import java.util.List;

import it.cise.db.CounterRecord;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.portale.cdc.documenti.DocumentFactory;
import it.cise.portale.cdc.documenti.DocumentoWeb;

public class Bisogno extends CounterRecord implements Comparable<Bisogno> {
	
	private static final long serialVersionUID = 3474703476988729297L;
	
	public Long id_bisogno;
	public String nome;
	public String url;
	public Long id_bisogno_padre;
	public Long ordine;
	public Boolean attivo;
	  
	public final static String NAME_TABLE=AbstractDocumentoWeb.NAME_SCHEMA + ".bisogni";
	public final static String NAME_TABLE_REL_DOCUMENTS=AbstractDocumentoWeb.NAME_SCHEMA + ".rel_documenti_web_bisogni";
	
	private Bisogno padre;
	private List<Bisogno> figli;
	private List<DocumentoWeb<?>> documenti;
	
	
	public Bisogno() {
		super(NAME_TABLE);
	}
	
	public Bisogno(Long id, DBConnectPool pool) {
		super(NAME_TABLE, pool);
		
		this.id_bisogno = id;
		load();
	}
	
	public Bisogno getPadre(){
		if(padre==null && id_bisogno_padre!=null) 
			padre = new Bisogno(id_bisogno_padre, getPool());
		return padre;
	}
	
	public List<Bisogno> getFigli(){
		if(figli==null) 
			figli = Bisogno.loadEntitiesFromQuery("select * from " + NAME_TABLE + " where attivo and id_bisogno_padre = " + id_bisogno + " order by ordine", getPool(), Bisogno.class);;
		return figli;
	}
	
	public static List<Bisogno> loadAll(DBConnectPool pool){
		return loadAll(pool, true);
	}

	public static List<Bisogno> loadAll(DBConnectPool pool, boolean onlyRoot){
		return Bisogno.loadEntitiesFromQuery("select * from " + NAME_TABLE + " where attivo" + (onlyRoot ? " and id_bisogno_padre is null " : "") + " order by ordine", pool, Bisogno.class);
	}
	
	public List<DocumentoWeb<?>> getDocumenti(){
		if (documenti == null) {
			documenti = new ArrayList<DocumentoWeb<?>>();
			String query = "select d.* from " + NAME_TABLE_REL_DOCUMENTS + " rdoc inner join " + AbstractDocumentoWeb.NAME_TABLE + " d on (rdoc.id_documento_web=d.id_documento_web) where rdoc.id_bisogno=" + id_bisogno + " order by rdoc.ordine";
			for (DocumentoWeb<?> d: DocumentFactory.fromQuery(getPool(), query))
				if (d.pubblico())
					documenti.add(d);
		}
		return documenti;
	}
	
	@Override
	public int compareTo(Bisogno b) {
		int check = 1; 
		
		if(b!=null) {
			check = ordine.compareTo(b.ordine);
			if(check==0)
				check =  id_bisogno.compareTo(b.id_bisogno);
		}
		
		return check;
	}
	
}
