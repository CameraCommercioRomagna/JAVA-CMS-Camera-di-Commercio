package it.cise.portale.cdc.documenti.standard;

import java.util.ArrayList;
import java.util.List;

import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.PaginaWeb;
import it.cise.portale.cdc.documenti.TipoDocumento;
import it.cise.portale.cdc.email.EmailPunto;
import it.cise.portale.cdc.email.EmailWeb;
import it.cise.portale.cdc.email.ItemEmailable;
import it.cise.util.auth.Authenticable;


public class Documento
	extends PaginaWeb<Documento>{
	
	private static final long serialVersionUID = -2110425910752098953L;
	
	public final static String REF_PARAGRAFI = "paragrafi_id_documento_web_fkey";
	
	public Boolean visualizza_indice;	// Indice se deve essere presentato l'indice dei paragrafi ad inizio pagina
	// Campi utilizzati solo se il documento è di tipo=SERVIZIO_ONLINE
	public String url;
	public String url_amministrazione;

	private List<Paragrafo> paragrafi;
	
	public Documento() {
		super();
	}
	public Documento(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public Documento(Record documento) {
		super(documento);
	}
	
	public List<Paragrafo> getParagrafi(){
		if (paragrafi==null)
			paragrafi = getRelation(REF_PARAGRAFI, Paragrafo.class, this).getRecords();
		
		return paragrafi;
	}
	
	@Override
	public EmailWeb creaEmailWeb(Utente proprietario, boolean inserito) {
		
		EmailWeb emailFiglia = super.creaEmailWeb(proprietario, inserito);
		
		for (Paragrafo p: getParagrafi()) {
			EmailPunto ep = new EmailPunto(emailFiglia);
			ep.titolo = p.titolo;
			ep.testo = p.testo;
			ep.img_path = p.img_path;
			ep.img_url = p.img_url;
			ep.ordine = p.ordine;
			ep.insert(proprietario);
		}	
		
		return emailFiglia;	
	}
	
	@Override
	public Documento copiaIn(Utente proprietario, DBConnectPool pool, PaginaWeb<?> padri){
		Documento copia=super.copiaIn(proprietario, pool, padri);

		// Elimina eventuali paragrafi creati in automatico a seguito della insert (vedi StrutturaCamerale)..
		for (Paragrafo pNew: copia.getParagrafi())
			pNew.delete(proprietario);
		// ..ed aggiunge quelli del documento originale	
		for (Paragrafo p: getParagrafi())
			p.copiaIn(proprietario, copia);
		
		if (getTipo() == TipoDocumento.SERVIZIO_ONLINE) {
			copia.url = url;
			copia.url_amministrazione = url_amministrazione;
			copia.update(proprietario);
		}
		return copia;
	}
	
	@Override
	public boolean delete(Authenticable utente) {
		boolean success=true;
		for (Paragrafo p: getParagrafi())
			if (success)
				success = success && p.delete(utente);
		if (success)
			success = super.delete(utente);
		return success;
	}
	
	@Override
	public boolean isForward() {
		return (url!=null);
	}
	@Override
	public String linkForward() {
		return (isForward() ? url : super.linkForward());
	}
	
	@Override
	public List<ItemEmailable> getItem(){
		getParagrafi();
		List<ItemEmailable> items = new ArrayList<ItemEmailable>();
		if(paragrafi!=null && paragrafi.size()>0)
			items.addAll(paragrafi);
		return items;
	}
}