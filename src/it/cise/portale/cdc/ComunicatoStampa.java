package it.cise.portale.cdc;

import cise.utils.DateUtils;
import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;


public class ComunicatoStampa extends Attivita {

	private static final long serialVersionUID = 4864785980849520546L;

	public ComunicatoStampa() {
		super();
	}
	public ComunicatoStampa(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public ComunicatoStampa(Record documento) {
		super(documento);
	}
	
	@Override
	public String getInfo() {
		return "Pubblicato il " + DateUtils.formatDate(getPubblicazione());
	}
}
