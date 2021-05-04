package it.cise.portale.cdc;


import java.util.List;

import javax.naming.OperationNotSupportedException;

import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.portale.cdc.documenti.DocumentFactory;
import it.cise.portale.cdc.documenti.DocumentoWeb;
import it.cise.portale.cdc.documenti.TipoDocumento;
import it.cise.portale.cdc.documenti.TipoOrdinamentoDocumenti;
import it.cise.portale.cdc.documenti.TipoSistema;
import it.cise.portale.cdc.documenti.Visibilita;
import it.cise.portale.cdc.documenti.eventi.Edizione;
import it.cise.portale.cdc.documenti.standard.Documento;

public class Attivita extends Documento {
	
	private static final long serialVersionUID = 7777500659518203877L;
	private Competenza competenza;
	
	public Attivita() {
		super();
	}
	public Attivita(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public Attivita(Record documento) {
		super(documento);
	}
	public Attivita(Competenza competenza){
		super();
		initialize(competenza.getPool());
		
		this.competenza = competenza;
	}
	
	@Override
	public DocumentoWeb<?> creaFiglio(Utente proprietario, TipoSistema tipoSistema, TipoDocumento tipoDocumento, boolean inserito)
		throws OperationNotSupportedException {
		
		AbstractDocumentoWeb<?> docFiglio=(AbstractDocumentoWeb<?>)super.creaFiglio(proprietario, tipoSistema, tipoDocumento, inserito);
		if (tipoSistema == TipoSistema.EVENTO) {
			docFiglio.titolo = titolo;
			docFiglio.abstract_txt = abstract_txt;
			docFiglio.icona = icona;
			
			if (inserito)
				docFiglio.update(proprietario);
		}
		return docFiglio;
	}

	public Competenza getCompetenza(){
		if (competenza == null) 
			try{
				competenza = (Competenza)getPadre();
			}catch(Exception e) {}
		
		return competenza;
	}
	
	
	public List<DocumentoWeb<?>> getNormativa(){
		return getFigli(TipoDocumento.NORMATIVA);
	}
	
	public List<DocumentoWeb<?>> getModulistica(){
		return getFigli(TipoDocumento.GUIDE_E_MODULI);
	}
	
	public List<Edizione> getEdizioni(){
		return getEdizioni(true, true, false);
	}
	public List<Edizione> getEdizioni(Boolean validati, Boolean pubblicati, Boolean scaduti){
		return DocumentFactory.getAll(getSottoalbero(TipoDocumento.EDIZIONE_EVENTO, null, validati, pubblicati, scaduti, Visibilita.VISIBILE_DOVE_COLLOCATO), Edizione.class);
	}

}
