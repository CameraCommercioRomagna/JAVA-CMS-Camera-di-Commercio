package it.cise.portale.cdc;

import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.PaginaWeb;
import it.cise.portale.cdc.documenti.standard.Documento;
import it.cise.portale.cdc.documenti.standard.Paragrafo;
import it.cise.util.auth.Authenticable;

public class StrutturaCamerale extends Documento {
	
	private static final long serialVersionUID = 6911056713019698489L;
	
	private PaginaWeb<?> paginaWeb;
	
	public StrutturaCamerale() {
		super();
	}
	public StrutturaCamerale(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public StrutturaCamerale(Record documento) {
		super(documento);
	}
	public StrutturaCamerale(PaginaWeb<?> documento){
		super();
		initialize(documento.getPool());
		
		this.paginaWeb=documento;
	}

	public PaginaWeb<?> getPaginaWeb() {
		return paginaWeb;
	}

	@Override
	public boolean insert(Authenticable utente) {
		boolean eseguito = super.insert(utente);
		if (eseguito) {
			StrutturaCamerale strutturaPadre=getPadre().getStrutturaCamerale();
			
			if (strutturaPadre!=null) {
				// copia i paragrafi dalla struttura del padre
				for (Paragrafo p: strutturaPadre.getParagrafi())
					p.copiaIn(((Utente)utente), this);
			}else {
				// Crea il primo paragrafo, con la struttura di default
				Paragrafo paragrafoContatti=new Paragrafo(this);
				paragrafoContatti.testo = "Inserire breve descrizione (solo se necessaria)<br/>" + 
						"<br/>" + 
						"Inserire email alias di gruppo (evitare gli indirizzi personali)<br/>" + 
						"Inserire telefono di gruppo (evitare gli interni diretti)<br/>" + 
						"<br/>" + 
						"Inserire eventuali info su indirizzo, piano, stanza (se necessari e diversi da quelli generali)<br/>" + 
						"<br/>" + 
						"Orari di sportello:<br/>" + 
						"dal lunedì al venerdì dalle 9 alle 12.30";
				paragrafoContatti.insert(utente);
			}
		}
		return eseguito;
	}
}
