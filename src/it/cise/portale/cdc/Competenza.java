package it.cise.portale.cdc;

import java.util.List;

import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.DocumentFactory;
import it.cise.portale.cdc.documenti.DocumentoWeb;
import it.cise.portale.cdc.documenti.TipoDocumento;
import it.cise.portale.cdc.documenti.TipoOrdinamentoDocumenti;
import it.cise.portale.cdc.documenti.TipoSistema;
import it.cise.portale.cdc.documenti.Visibilita;
import it.cise.portale.cdc.documenti.standard.Documento;

public class Competenza extends Documento {
	
	private static final long serialVersionUID = 1623102968768486152L;

	private AreaTematica areaTematica;
	private List<Attivita> attivita;
	
	public Competenza() {
		super();
	}
	public Competenza(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public Competenza(Record documento) {
		super(documento);
	}
	public Competenza(AreaTematica areaTematica) {
		super();
		this.areaTematica = areaTematica;
	}
	
	@Override
	public boolean isForward() {
		return super.isForward() || (
			getParagrafi().size()==0 
			&& getFigli(TipoDocumento.ATTIVITA, TipoSistema.DOCUMENTO, true, true, false, Visibilita.VISIBILE_DOVE_COLLOCATO, TipoOrdinamentoDocumenti.MANUALE).size()==1
		);
	}
	@Override
	public String linkForward() {
		if (super.isForward())
			return super.linkForward();
		else
			try {
				return getFigli(TipoDocumento.ATTIVITA, TipoSistema.DOCUMENTO, true, true, false, Visibilita.VISIBILE_DOVE_COLLOCATO, TipoOrdinamentoDocumenti.MANUALE).get(0).getLink();
			}catch(Exception e) {
				throw new IllegalStateException("Una competenza vuota deve contenere un'attività per essere visualizzata: " + this);	
			}
	}

	public AreaTematica getAreaTematica(){
		if (areaTematica == null) 
			try{
				areaTematica = (AreaTematica)getPadre();
			}catch(Exception e) {}
		
		return areaTematica;
	}
	
	public List<Attivita> getAttivita(){
		if (attivita == null)
			attivita = DocumentFactory.getAll(getFigli(TipoDocumento.ATTIVITA), Attivita.class);
		return attivita;
	}
	
	public List<DocumentoWeb<?>> getNormativa(){
		return getFigli(TipoDocumento.NORMATIVA);
	}
	
}
