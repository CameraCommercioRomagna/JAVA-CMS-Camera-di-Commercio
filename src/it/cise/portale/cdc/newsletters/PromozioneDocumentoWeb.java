package it.cise.portale.cdc.newsletters;

import java.util.Date;

import it.cise.db.CounterRecord;
import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.portale.cdc.documenti.DocumentFactory;
import it.cise.portale.cdc.documenti.DocumentoWeb;

public class PromozioneDocumentoWeb extends CounterRecord 
	implements Comparable<PromozioneDocumentoWeb> {
	
	private static final long serialVersionUID = 4330822406935705665L;

	public static final String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA+".nl_pubblicazioni";
	
	public Long id_nl_pubblicazione;
	public Long id_nl_numero;
	public Long id_nl_tipo;
	public Date data;
	public String sezione;
	public Long id_documento_web;
	public Long ordine;
	public Date data_validazione;
	public Date data_richiesta;
	
	private NumeroNewsLetter numeroNewsletter;
	private DocumentoWeb<?> documento;
	
	
	public PromozioneDocumentoWeb(){
		super(NAME_TABLE);
	}
	
	public PromozioneDocumentoWeb(DocumentoWeb<?> d){
		super(NAME_TABLE, ((Record)d).getPool());
		setDocumento(d);
	}
	
	public PromozioneDocumentoWeb(Long id, DBConnectPool pool){
		super(NAME_TABLE, pool);
		this.id_nl_pubblicazione = id;
		load();
	}
	
	protected void setDocumento(DocumentoWeb<?> d) {
		documento=d;
		if (id_documento_web==null)
			id_documento_web = d.getId();
	}
	
	protected int contaPubblicazioniIn(NewsLetter nl) {
		return getDocumento().getPromozioniSuNewsletter(nl).size();
	}
	
	public NumeroNewsLetter getNumeroNewsletter() {
		if (numeroNewsletter==null && id_nl_numero!=null)
			numeroNewsletter = new NumeroNewsLetter(id_nl_numero, getPool());
		return numeroNewsletter;
	}
	
	public void setApprovazione(Utente operatore, boolean approva, Long posizione){
		if (isInserted()){
			if (approva == !isApprovato()){
				ordine=posizione;
				data_validazione=(approva ? new Date() : null);
			}else if (ordine!=posizione)
				ordine=posizione;
			update(operatore);
		}else
			throw new IllegalStateException("Impossibile approvare un documento non ancora associato: " + documento);
	}
	
	public boolean isApprovato() {
		return data_validazione!=null;
	}

	public DocumentoWeb<?> getDocumento() {
		if(documento==null && id_documento_web!=null)
			documento = DocumentFactory.load(getPool(), id_documento_web);
		return documento;
	}

	public boolean associa(Utente operatore, NumeroNewsLetter nnl, String sezione) {
		if (!nnl.isPubblicato()){
			if (!isInserted()){
				NewsLetter nl = nnl.getNewsLetter();
				int maxPubblicazioni = nl.num_max_numeri.intValue();
				if (contaPubblicazioniIn(nl)<maxPubblicazioni){ 
					setNumeroNewsLetter(nnl, sezione);
					data_richiesta=new Date();
					return insert(operatore);
				}else
					throw new IllegalArgumentException("Impossibile associare il documento " + documento + " più di " + maxPubblicazioni + " volte al numero newsletter ID=" + nnl.id_nl_numero);
			}else
				throw new IllegalStateException("Documento " + documento + " già associato alla newsLetter " + numeroNewsletter);
		}else
			return false;
	}
	
	public boolean disassocia(Utente operatore) {
		if (!getNumeroNewsletter().isPubblicato()){
			if (isInserted()){
				return delete(operatore);
			}else
				throw new IllegalStateException("Documento " + documento + " non ancora associato ad una newsLetter");
		}else
			return false;
	}


	private void setNumeroNewsLetter(NumeroNewsLetter numero, String sezione) {
		if (numero!=null){
			numeroNewsletter=numero;
			this.id_nl_numero=numero.id_nl_numero;
			this.id_nl_tipo=numero.id_nl_tipo;
			this.data=numero.data;
			this.sezione=sezione;
		}
	}

	@Override
	public int compareTo(PromozioneDocumentoWeb o) {
		int ordineResult=0;
		if (ordine!=null){
			if (o.ordine!=null)
				ordineResult=(ordine.compareTo(o.ordine));
			else
				ordineResult=-1;
		}else{
			if (o.ordine!=null)
				ordineResult=1;
		}
		
		if (ordineResult==0)
			ordineResult=id_nl_pubblicazione.compareTo(o.id_nl_pubblicazione);
		
		return ordineResult;
	}
}
