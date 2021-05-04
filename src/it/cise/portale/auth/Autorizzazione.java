package it.cise.portale.auth;

import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;

public class Autorizzazione extends Record {
	public Number id_autorizzazione;
	public String nome_autorizzazione;
	public String desc_autorizzazione;
	public Long fordocuments;
	
	public Autorizzazione(){
		super("portalowner.autorizzazioni");
	}
	
	public Autorizzazione(String table){
		super(table);
	}
	
	public static void main(String[] args){
		DBConnectPool pool=new DBConnectPool("it.cise.db.database.DBPortal", "it.cise.db.user.Portalowner", 1, 5, 1);
		Autorizzazione auth=new Autorizzazione();
		auth.initialize(pool);
		auth.id_autorizzazione=new Double(5);
		auth.load();
		cise.utils.Logger.write(auth);
	}

}
