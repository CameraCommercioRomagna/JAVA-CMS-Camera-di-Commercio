package it.cise.portale.cdc;

import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.download.Download;

public class Immagine extends Download {

	private static final long serialVersionUID = 3308482370612666120L;
	
	public Immagine() {
		super();
	}
	public Immagine(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public Immagine(Record documento) {
		super(documento);
	}
	
	@Override
	public String getIcona() {
		return url;
	}
}
