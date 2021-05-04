package it.cise.portale.cdc.newsletters;

import it.cise.db.Record;
import it.cise.db.SQLTransactionManager;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.sql.QueryPager;
import it.cise.structures.preview.Row;
import java.util.Date;
import java.util.List;

public class UtenteNl extends Record{

	private static final long serialVersionUID = -7732226073677744238L;

	public final static String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA+".utenti_nl";
	
	public Long id_utente;
	public String email;
	public String password;
	public String nome;
	public String cognome;
	public String organizzazione;
	public String telefono;
	public Date data_inserimento;
	public Date data_attivazione;
	public Boolean privacy_dati;
	public Boolean privacy_mail;
	public Boolean valido;
	public String key;
	
	
	public UtenteNl(){
		super(NAME_TABLE);
	}
	
	public UtenteNl(DBConnectPool pool, Long id){
		super(NAME_TABLE, pool);
		this.id_utente = id;
		this.load();
	}
	
	public String getIdentita(){
		String identita="";
		if (nome!=null)	identita += nome;
		if (cognome!=null)	identita += (!identita.equals("") ? " " : "") + cognome;
		
		return identita;
	}
	
	public boolean valido(){
		return data_attivazione!=null && !data_attivazione.after(new Date()) && valido;
	}
	
	public List<TematicaNl> getTematiche(){
		return loadEntitiesFromQuery("SELECT t.* FROM " + AbstractDocumentoWeb.NAME_SCHEMA +".rel_utenti_tematiche_nl ut inner join " + TematicaNl.NAME_TABLE + " t on ut.id_tematica=t.id_tematica WHERE id_utente=" + id_utente, getPool(), TematicaNl.class);
	}
	
	public void associaAreeTematiche(List<TematicaNl> areeTematiche){
		SQLTransactionManager sqlMan = new SQLTransactionManager(this, getPool());
		QueryPager pager = new QueryPager(getPool());
		
		try{
			pager.set("SELECT id_tematica FROM " + TematicaNl.NAME_TABLE + " ORDER BY id_tematica");
			for (Row<String> rs : pager){
				if (areeTematiche.contains(new TematicaNl(getPool(), new Long(rs.getField("id_tematica"))))){
					sqlMan.executeCommandQuery(null, "INSERT INTO " + AbstractDocumentoWeb.NAME_SCHEMA  + ".rel_utenti_tematiche_nl (id_utente, id_tematica) VALUES ("+this.id_utente+", "+rs.getField("id_tematica")+")");
				}else{
					sqlMan.executeCommandQuery(null, "DELETE FROM " + AbstractDocumentoWeb.NAME_SCHEMA  + ".rel_utenti_tematiche_nl WHERE id_utente="+this.id_utente+" AND id_tematica="+rs.getField("id_tematica"));
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
}
