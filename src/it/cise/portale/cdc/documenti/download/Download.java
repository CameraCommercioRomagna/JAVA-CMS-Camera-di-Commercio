package it.cise.portale.cdc.documenti.download;

import it.cise.util.auth.Authenticable;
import it.cise.util.dweb.DownlodableObject;
import it.cise.util.http.HttpUtils;

import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.portale.cdc.documenti.PaginaWeb;


public class Download
	extends AbstractDocumentoWeb<Download> implements DownlodableObject{
	
	private static final long serialVersionUID = -6087031734444857785L;

	public String url;
	
	public static final String DOWNLOAD_PATH_PREFIX = "/download";
	public static final String DOWNLOAD_PATH_PREFIX_OLD = "/download_archive";
	public static final String REQUEST_DOWNLOAD = "DWN";
	
	public Download(){
		super();
	}
	public Download(Boolean case_old_db_b){
		super(case_old_db_b);
	}
	public Download(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public Download(Record documento) {
		super(documento);
	}
	
	
	@Override
	public String getIdNameField() {
		return "id_documento_web";
	}
	@Override
	public String getUrlFile() {
		return url;
	}
	@Override
	public boolean accessibile(Authenticable operatore) {
		return true;
	}
	
	
	public String getEstensione(){
		return url.substring(url.lastIndexOf(".") + 1);	
	}

	@Override
	public String getPathLink(){
		return (isCaseOldDB() ? DOWNLOAD_PATH_PREFIX_OLD : DOWNLOAD_PATH_PREFIX) + super.getPathLink();
	}
	
	@Override
	public String getResourceName(){
		return HttpUtils.getTextForWebLink(titolo) + "." + getEstensione();
	}
	
	@Override
	public String getLink() {
		return getPathLink() + getResourceName() + "?" + REQUEST_DOWNLOAD + "=" + id_documento_web;
	}
	
	
	@Override
	public Download copiaIn(Utente proprietario, DBConnectPool pool, PaginaWeb<?> padri){
		Download copia=super.copiaIn(proprietario, pool, padri);
		copia.url = url;
		copia.update(proprietario);

		return copia;
	}
	
	/*TODO*/
/*	@Override
	public boolean delete(){
		try{
			return super.delete();
		}catch (Exception e) {
			Logger.write("* ERROR * Impossibile cancellare completamente l'oggetto " + this);
			return false;
		}
	}*/
	
}
