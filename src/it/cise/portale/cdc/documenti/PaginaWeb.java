package it.cise.portale.cdc.documenti;

import java.util.List;

import javax.naming.OperationNotSupportedException;

import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.Immagine;
import it.cise.portale.cdc.StrutturaCamerale;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.eventi.Luogo;
import it.cise.portale.cdc.email.EmailWeb;
import it.cise.portale.cdc.email.Emailable;

public abstract class PaginaWeb<D extends PaginaWeb<D>>
	extends AbstractDocumentoWeb<D> implements Emailable{

	private static final long serialVersionUID = -5888144916669305618L;
	
	public PaginaWeb() {
		super();
	}
	public PaginaWeb(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public PaginaWeb(Record documento) {
		super(documento);
	}
	
	@Override
	public String periodoENote() {
		return null;
	}
	@Override
	public Luogo getLuogo() {
		return null;
	}
	@Override
	public String luogoENote() {
		return null;
	}
	@Override
	public String getOrario(){
		return null;
	}
	
	public boolean isForward() {
		return false;
	}
	public String linkForward() {
		if (isForward())
			throw new IllegalStateException("Link di ridirezione non definito per una pagina per cui è previsto: " + this);
		else
			throw new IllegalStateException("Impossibile ricercare il link di ridirezione per una pagina per cui non è prevista: " + this);
	}
	
	public String getPathLink(){
		try {
			return (
				!isForward() 
				? super.getPathLink() 
				: getPadre().getPathLink()
			);
		}catch(Exception e) {
			return "/";	// Se non esiste il padre
		}
	}
	
	@Override
	public String getResourceName(){
		return "index.htm";
	}
	
	@Override
	public String getLink(){
		return (isForward() ? linkForward() : super.getLink());
	}
	
	@Override
	public DocumentoWeb<?> creaFiglio(Utente proprietario, TipoSistema tipoSistema, TipoDocumento tipoDocumento, boolean inserito)
			throws OperationNotSupportedException {
		
		if (tipoDocumento == TipoDocumento.STRUTTURA_CAMERALE) {
			if (!(this instanceof StrutturaCamerale)) {
				AbstractDocumentoWeb<?> strutturaFiglia = (AbstractDocumentoWeb<?>)super.creaFiglio(proprietario, tipoSistema, tipoDocumento, inserito);
				
				StrutturaCamerale strutturaPadre=getStrutturaCamerale();
				if (strutturaPadre!=null) {
					strutturaFiglia.titolo = strutturaPadre.titolo;
					strutturaFiglia.abstract_txt = strutturaPadre.abstract_txt;
				}else {
					strutturaFiglia.titolo = "Inserire nome delle struttura / ufficio";
					strutturaFiglia.abstract_txt = "Struttura camerale che gestisce '" + getTitolo() + "'";
				}
				return strutturaFiglia;
			}else
				throw new OperationNotSupportedException("Impossibile generare una STRUTTURA a partire da un'altra STRUTTURA: " + this);
		}else{
			return super.creaFiglio(proprietario, tipoSistema, tipoDocumento, inserito);
		}
	}
	
	public StrutturaCamerale getStrutturaCamerale(){
		StrutturaCamerale struttura = null;
		try {
			struttura = (StrutturaCamerale)getFigli(TipoDocumento.STRUTTURA_CAMERALE).get(0);
		}catch (Exception e) {
			if (getPadre() != null)
				struttura = getPadre().getStrutturaCamerale();
		}
		
		return struttura;
	}
	
	public List<DocumentoWeb<?>> getServiziOnline(){
		List<DocumentoWeb<?>> documenti=getSottoalbero(TipoDocumento.SERVIZIO_ONLINE);
		if (getPadre() != null)
			documenti.addAll(getPadre().getFigli(TipoDocumento.SERVIZIO_ONLINE));
		return documenti;
	}
	
	
	// Metodo da usare solo per Edizione evento, Comunicazione e Attivita
	public List<DocumentoWeb<?>> getFileUtili(){
		return getFigli(TipoDocumento.FILE_UTILE);
	}
	
	public List<DocumentoWeb<?>> getLinkUtili(){
		List<DocumentoWeb<?>> documenti=getSottoalbero(TipoDocumento.LINK_UTILE);
		if (getPadre() != null)
			documenti.addAll(getPadre().getFigli(TipoDocumento.LINK_UTILE));
		return documenti;
	}
	
	// Metodi da usare solo per Comunicato stampa, Edizione evento e Iniziativa
	public List<Immagine> getImmagini(){
		return DocumentFactory.getAll(getFigli(TipoDocumento.IMMAGINE), Immagine.class);
	}
	
	// Metodi da usare solo per Edizione evento e Iniziativa
	//public List<Immagine> getVideo(){
	public List<DocumentoWeb<?>> getVideo(){
		//return DocumentFactory.getAll(getFigli(TipoDocumento.VIDEO, null), Video.class);
		return getFigli(TipoDocumento.VIDEO);
	}
	
	
	public List<DocumentoWeb<?>> getNotizie(){
		return getSottoalbero(TipoDocumento.COMUNICAZIONE);
	}
	
	public List<EmailWeb> getEmailweb(){
		return loadEntitiesFromQuery("select * from " + EmailWeb.NAME_TABLE + " where id_documento_web=" + getId() + " order by id_email_web", getPool(), EmailWeb.class);
	}
}
