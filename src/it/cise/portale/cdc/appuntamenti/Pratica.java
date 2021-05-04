package it.cise.portale.cdc.appuntamenti;

import it.cise.db.CounterRecord;
import it.cise.db.jdbc.DBConnectPool;

public class Pratica extends CounterRecord{
	
	private static final long serialVersionUID = 9035136598621357302L;

	public static final String NAME_TABLE=Appuntamento.NAME_SCHEMA + ".pratiche";

	public Long id_pratica;
	public Long id_appuntamento;
	public Long id_servizio;
	public Boolean utenza_privato;
	
	public String tipo_pratica;
	
	public String intestatario_nome;
	public String intestatario_cognome;
	public String intestatario_ragione_sociale;
	public String intestatario_cf;
	
	public String referente_nome;
	public String referente_cognome;
	public String referente_cf;
	
	private Intestatario intestatario;
	private Appuntamento appuntamento;
	
	Pratica(DBConnectPool conn, Long id) {
		super(NAME_TABLE, conn);
		id_pratica = id;
		load();
	}
	public Pratica(Appuntamento appuntamento) {
		super(NAME_TABLE);
		initialize(appuntamento.getPool());
		this.id_appuntamento=appuntamento.id_appuntamento;
		this.id_servizio=appuntamento.id_servizio;
		this.appuntamento=appuntamento;
	}
	public Pratica(Richiedente richiedente) {
		this(richiedente.getAppuntamento());
		this.utenza_privato=true;

		if (appuntamento.nome != null) {
			// Il richiedente è una persona
			this.intestatario_nome=appuntamento.nome;
			this.intestatario_cognome=appuntamento.cognome;
			this.intestatario_ragione_sociale=null;
		}else {
			// Il richiedente è un'azienda, la cui denominazine è salvata nel cognome
			this.intestatario_nome=null;
			this.intestatario_cognome=null;
			this.intestatario_ragione_sociale=appuntamento.cognome;
		}
	}
	
	
	private Intestatario newInstanceIntestatario() {
		return (utenza_privato==null || utenza_privato ? new IntestatarioPrivato(this) : new IntestatarioImpresa(this));
	}

	public Intestatario getIntestatario() {
		if (intestatario==null && isInserted())
			intestatario =  newInstanceIntestatario();
		return intestatario;
	}
	
	public Appuntamento getAppuntamento() {
		if(appuntamento==null)
			appuntamento= new Appuntamento(getPool(), id_appuntamento);
		return appuntamento;
	}
	
	public Servizio getServizio(){
		return Servizio.getServizio(id_servizio);
	}
	
	public void setServizio(Servizio servizio) {
		if (servizio!=null) {
			Servizio currentServizio=getServizio();
			boolean esegui = currentServizio==null;
			if (!esegui) 
				esegui = currentServizio.getFigli().contains(servizio);
			
			if (esegui)
				id_servizio=servizio.getId();
		}
	}
	
	public String toString() {
		return 
			(tipo_pratica!=null ? TipoPratica.getTipoPratica(tipo_pratica).getDescrizione() + " per " : (getServizio()!=getAppuntamento().getServizio() ? getServizio() + " per " :"")) 
			+  getIntestatario().toString();
	}
}
