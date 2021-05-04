package it.cise.portale.cdc.documenti.pubblicazioni;

import java.util.ArrayList;
import java.util.List;

import javax.naming.OperationNotSupportedException;

import cise.utils.DateUtils;
import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.Attivita;
import it.cise.portale.cdc.Competenza;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.portale.cdc.documenti.DocumentFactory;
import it.cise.portale.cdc.documenti.DocumentoWeb;
import it.cise.portale.cdc.documenti.TipoDocumento;
import it.cise.portale.cdc.documenti.TipoSistema;
import it.cise.portale.cdc.documenti.download.Download;

public class Pubblicazione extends Attivita {

	private static final long serialVersionUID = -4248614213405070026L;
	
	private Boolean hasSistemaInformativo;
	private DocumentoWeb<?> sistemaInformativo;
	private List<Download> volumi;

	public Pubblicazione() {
		super();
	}
	public Pubblicazione(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public Pubblicazione(Record documento) {
		super(documento);
	}
	public Pubblicazione(Competenza competenza){
		super(competenza);
	}
	
	@Override
	public DocumentoWeb<?> creaFiglio(Utente proprietario, TipoSistema tipoSistema, TipoDocumento tipoDocumento, boolean inserito)
		throws OperationNotSupportedException {
		
		AbstractDocumentoWeb<?> docFiglio=(AbstractDocumentoWeb<?>)super.creaFiglio(proprietario, tipoSistema, tipoDocumento, inserito);
		if (tipoDocumento == TipoDocumento.VOLUME) {
			docFiglio.titolo = titolo + " - Nuovo volume";
			docFiglio.abstract_txt = "Pubblicato il volume di '" + titolo + "' relativo al periodo del...";
			docFiglio.update(proprietario);
		}
		if (tipoDocumento == TipoDocumento.SERVIZIO_ONLINE) {
			docFiglio.titolo = "Sistema informativo di '" + titolo + "'";
			docFiglio.update(proprietario);
		}
		return docFiglio;
	}
	
	public DocumentoWeb<?> getSistemaInformativo(){
		if (hasSistemaInformativo == null) 
			try{
				sistemaInformativo = getFigli(TipoDocumento.SERVIZIO_ONLINE).get(0);
				hasSistemaInformativo = true;
			}catch (Exception e) {
				hasSistemaInformativo = false;
			}
		return sistemaInformativo;
	}
	
	public Download ultimoVolume(){
		try {
			return volumi().get(0);
		}catch (Exception e) {
			return null;
		}
	}
	
	public List<Download> volumi(){
		if (volumi == null) 
			volumi = DocumentFactory.getAll(getFigli(TipoDocumento.VOLUME, TipoSistema.DOWNLOAD, true, true, null), Download.class);
		return volumi;
	}
	
	public List<Download> volumi(int anno){
		List<Download> numeriAnno = new ArrayList<Download>();
		for(Download numero: volumi()){
			if (anno == numero.anno_pertinenza.intValue())
				numeriAnno.add(numero);
		}
		return numeriAnno;
	}
	
	@Override
	public String getInfo() {
		return "Ultimo volume del " + DateUtils.formatDate(getPubblicazione());
	}
}
