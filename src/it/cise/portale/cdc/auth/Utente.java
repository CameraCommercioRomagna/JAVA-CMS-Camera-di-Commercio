package it.cise.portale.cdc.auth;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import it.cise.db.CounterRecord;
import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.sql.PreviewQuery;
import it.cise.util.auth.Authenticable;
import it.cise.util.auth.AuthenticationStatus;

public class Utente extends Record implements Authenticable{
	
	private static final long serialVersionUID = -8729434624993503938L;

	public final static String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA + ".utenti";
	
	public Long id_utente;
	public String username; 
	public String password;
	public String nome;
	public String cognome;
//	public String indirizzo;
//	public Long id_nazione;
//	public String cod_fiscale;
	public String telefono;
//	public String cellulare;
	public String email;
//	public String sesso;
//	public Date data_nascita;
	public String note;
//	public Boolean privacy_dati;
//	public Boolean privacy_mail;
	public Boolean valido;
	public Date data_register;
	public Date data_change_pwd;

	private List<Autorizzazione> enumAutorizzazioni;
	
	public Utente() {
		super(NAME_TABLE);
	}
	
	public Utente(DBConnectPool pool) {
		super(NAME_TABLE, pool);
	}
	
	public Utente(DBConnectPool pool, Long id) {
		super(NAME_TABLE, pool);
		id_utente=id;
		load();
	}
	
	
	public String getUsername(){
		return username;
	}
	
	public String getPassword(){
		return password;
	}

	public String getIdentita(){
		String identita="";
		if (nome!=null)	identita += nome;
		if (cognome!=null) identita += (!identita.equals("") ? " " : "") + cognome;
		
		if (identita.equals("")) identita=username;
		
		return identita;
	}

	public boolean authorizedFor(Autorizzazione autorizzazione){
		return getAutorizzazioni().contains(autorizzazione);
	}
	public boolean authorizedFor(Long idAuth){
		return authorizedFor(Autorizzazione.fromID(idAuth));
	}
	
	public List<Autorizzazione> getAutorizzazioni(){
		if (enumAutorizzazioni == null){
			List<AutorizzazioneRecord> autorizzazioni = loadEntitiesFromQuery("select * from " + AutorizzazioneRecord.NAME_TABLE + " a inner join " + AbstractDocumentoWeb.NAME_SCHEMA + ".rel_utenti_autorizzazioni rua on a.id_autorizzazione=rua.id_autorizzazione where rua.id_utente = " + id_utente, getPool(), AutorizzazioneRecord.class);
			
			enumAutorizzazioni = new ArrayList<Autorizzazione>();
			for (AutorizzazioneRecord auth: autorizzazioni)
				enumAutorizzazioni.add(Autorizzazione.fromID(auth.id_autorizzazione));
		}	 
		return enumAutorizzazioni;
	}
	
	
	public boolean loggedIn(){
		return isInserted();
	}
		
	public AuthenticationStatus authenticate(String user, String pwd) {
		try {
			Long p_id_utente=null;
			boolean p_valido=false;
	 		AuthenticationStatus authStatus=null;
			String queryauth ="SELECT * FROM " + NAME_TABLE + " WHERE username='" + user +"'";
			
			PreviewQuery prev = new PreviewQuery(this.getPool());
			prev.setPreview(queryauth);
			
			//cise.utils.Logger.write(this,"Query Eseguita");
			if (prev.getNumberRecords()>0){
				p_valido = prev.getField("valido").equals("true");
				if(!p_valido){
					authStatus = AuthenticationStatus.EXPIRED_USER;
				}else{
					password=prev.getField("password");
					//cise.utils.Logger.write(this,"password= " + password);
					if (password.equals(pwd)) {
						p_id_utente=new Long(prev.getField("id_utente"));
						authStatus = AuthenticationStatus.AUTHENTICATED;
						this.id_utente = p_id_utente;
						this.load();
					} else {
						cise.utils.Logger.write(this,"Password non corretta");
						authStatus = AuthenticationStatus.ERROR_WRONG_PWD;
					}
				}
			}else{
				cise.utils.Logger.write(this,"Username non corretta: " + user);
				authStatus = AuthenticationStatus.ERROR_WRONG_USERNAME;
			}
		
			return authStatus;
			
		} catch (Exception e) {
			e.printStackTrace();
			return AuthenticationStatus.LOGIN_FAILED;
		}
	}
		
	public String toString(){
		String objString=null;
		objString="{\n";
		objString+=(getIdentita() + " [id=" + id_utente + "]\n");
		objString+="}";
		
		return objString;
	}
}