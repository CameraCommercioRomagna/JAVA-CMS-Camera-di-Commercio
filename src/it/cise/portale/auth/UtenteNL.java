package it.cise.portale.auth;

import it.cise.db.CounterRecord;
import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;

import java.util.Date;


public class UtenteNL extends CounterRecord {

	//	Attributi
	public Long id_utente;
	public String email;
	public String password;
	public Date data_inserimento;
	public Date data_attivazione;
	public String nome;
	public String cognome;
	public String azienda;
	public String telefono;
	public String ruolo;
	public String sito_web;
	
	
	public UtenteNL(){
		super("portalowner.utenti_nl");
	}
	public UtenteNL(Record r){
		super("portalowner.utenti_nl",r);
	}
	public UtenteNL(Long id_utente, DBConnectPool pool){
		super("portalowner.utenti_nl");
		this.initialize(pool);
		this.id_utente=id_utente;
		this.load();
	}
	
	public boolean attivo(){
		if (data_attivazione!=null && (data_attivazione.before(new Date()) || data_attivazione.equals(new Date()))){
			return true;
		}else{
			return false;
		}
	}
	
	public String getIdentita(){
		String identita="";
		if (nome!=null)	identita += nome;
		if (cognome!=null)	identita += (!identita.equals("") ? " " : "") + cognome;
		
		return identita;
	}
	
}