package it.cise.portale.cdc;

import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.standard.Documento;

public class HomePage extends Documento {

	private static final long serialVersionUID = 8017033652688659848L;

	public HomePage() {
		super();
	}
	public HomePage(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public HomePage(Record documento) {
		super(documento);
	}
	
	@Override
	public String getLink(){
		return getPathLink() + "index.htm";
	}
}

