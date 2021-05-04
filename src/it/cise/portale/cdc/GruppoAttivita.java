package it.cise.portale.cdc;

import java.util.List;

import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.DocumentFactory;
import it.cise.portale.cdc.documenti.TipoDocumento;

public class GruppoAttivita extends Attivita {

	private static final long serialVersionUID = -2747291886512496547L;
	
	private List<Attivita> sottoAttivita;
	
	public GruppoAttivita() {
		super();
	}
	public GruppoAttivita(Long id, DBConnectPool pool) {
		super(id, pool);
	}
	public GruppoAttivita(Record documento) {
		super(documento);
	}
	public GruppoAttivita(Competenza competenza) {
		super(competenza);
	}

	public List<Attivita> getSottoAttivita(){
		if (sottoAttivita == null)
			sottoAttivita = DocumentFactory.getAll(getFigli(TipoDocumento.ATTIVITA), Attivita.class);
		return sottoAttivita;
	}

}
