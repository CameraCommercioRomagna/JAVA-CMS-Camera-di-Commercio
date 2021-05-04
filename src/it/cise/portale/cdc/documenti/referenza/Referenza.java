package it.cise.portale.cdc.documenti.referenza;

import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.portale.cdc.documenti.PaginaWeb;


public class Referenza extends AbstractDocumentoWeb<Referenza> {
	
	private static final long serialVersionUID = 7795840426273224363L;
	
	public String url;
	public String url_amministrazione;

	public Referenza(){
		super();
	}
	public Referenza(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public Referenza(Record documento) {
		super(documento);
	}


	@Override
	public Referenza copiaIn(Utente proprietario, DBConnectPool pool, PaginaWeb<?> padri){
		Referenza copia=super.copiaIn(proprietario, pool, padri);
		copia.url = url;
		copia.url_amministrazione = url_amministrazione;
		copia.update(proprietario);

		return copia;
	}

	@Override
	public String getResourceName(){
		String resource=null;
		try {
			resource = url.substring(url.lastIndexOf("/")+1);
		}catch(Exception e) {}
		return resource;
	}
	@Override
	public String getPathLink(){
		String externalPath=null;
		try {
			externalPath = url.substring(0, url.lastIndexOf("/"));
		}catch(Exception e) {}
		return externalPath;
	}
	@Override
	public String getLink() {
		return url;
	}
	@Override
	public String getPreviewLink() {
		return getLink();
	}
}
