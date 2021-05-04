package it.cise.portale.cdc;

import cise.utils.DateUtils;
import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;


public class Finanziamento extends Attivita {

	private static final long serialVersionUID = 4864785980849520546L;

	public Finanziamento() {
		super();
	}
	public Finanziamento(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public Finanziamento(Record documento) {
		super(documento);
	}
	public Finanziamento(Competenza competenza){
		super(competenza);
	}
	
/*	@Override
	public String getInfo() {
		return "In scadenza il " + DateUtils.formatDate(getScadenza());
	}*/
}