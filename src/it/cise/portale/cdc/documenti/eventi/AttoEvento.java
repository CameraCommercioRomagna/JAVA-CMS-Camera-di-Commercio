package it.cise.portale.cdc.documenti.eventi;

import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.download.Download;

public class AttoEvento extends Download {

	private static final long serialVersionUID = 2934176007889216868L;

	public AttoEvento() {
		super();
	}
	public AttoEvento(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public AttoEvento(Record documento) {
		super(documento);
	}
	
	@Override
	public String getIcona() {
		return (isInserted() && getPadre()!=null ? getPadre().getIcona() : null);
	}
}
