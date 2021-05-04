package it.cise.portale.cdc;

import java.util.List;

import cise.utils.Logger;
import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.portale.cdc.documenti.DocumentFactory;
import it.cise.portale.cdc.documenti.TipoDocumento;
import it.cise.portale.cdc.documenti.TipoOrdinamentoDocumenti;
import it.cise.portale.cdc.documenti.TipoSistema;
import it.cise.portale.cdc.documenti.Visibilita;
import it.cise.portale.cdc.documenti.standard.Documento;

public class AreaTematica extends Documento {
	
	private static final long serialVersionUID = -1830274076864261026L;

	private List<Competenza> competenze;
	
	public AreaTematica() {
		super();
	}
	public AreaTematica(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public AreaTematica(Record documento) {
		super(documento);
	}
	
	public List<Competenza> getCompetenze(){
		if (competenze == null)
			competenze = DocumentFactory.getAll(getFigli(TipoDocumento.COMPETENZA, TipoSistema.DOCUMENTO), Competenza.class);
		return competenze;
	}
	
	@Override
	public boolean isForward() {
		return super.isForward() || (
			getParagrafi().size()==0 
			&& getFigli(TipoDocumento.COMPETENZA, TipoSistema.DOCUMENTO, true, true, false, Visibilita.VISIBILE_DOVE_COLLOCATO, TipoOrdinamentoDocumenti.MANUALE).size()==1
		);
	}
	@Override
	public String linkForward() {
		if (super.isForward())
			return super.linkForward();
		else
			try {
				return getFigli(TipoDocumento.COMPETENZA, TipoSistema.DOCUMENTO, true, true, false, Visibilita.VISIBILE_DOVE_COLLOCATO, TipoOrdinamentoDocumenti.MANUALE).get(0).getLink();
			}catch(Exception e) {
				throw new IllegalStateException("Un'area tematica vuota deve contenere una competenza per essere visualizzata: " + this);	
			}
	}
	
	public static void main(String[] args) throws Exception{
		it.cise.db.jdbc.DBConnectPool connPostgres=new it.cise.db.jdbc.DBConnectPool(new it.cise.db.database.PostgreSQLDatabase("dbportal_cdc"),new it.cise.db.user.Postgres(), 5, 15, 1);
		
		Record recordAT=new Record(AbstractDocumentoWeb.NAME_SCHEMA + ".documenti_web", connPostgres);
		recordAT.setField("id_documento_web", 2554l);
		recordAT.load();
		Logger.write("**********Record AT " + recordAT);
		
		AreaTematica areaTematica=(AreaTematica)DocumentFactory.cast(recordAT);
		
		/*AreaTematica areaTematica=new AreaTematica();
		areaTematica.initialize(connPostgres);
		areaTematica.id_documento_web=2554l;
		areaTematica.load();*/

		Logger.write("**********AT " + areaTematica);
		Logger.write("**********competenze " + areaTematica.getCompetenze());
	}

}
