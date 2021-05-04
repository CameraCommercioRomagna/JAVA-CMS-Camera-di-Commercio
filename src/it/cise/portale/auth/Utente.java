package it.cise.portale.auth;

import java.util.*;

import it.cise.db.*;
import it.cise.db.jdbc.*;
import it.cise.sql.*;
import it.cise.structures.preview.*;
import it.cise.util.auth.Authenticable;
import it.cise.util.auth.AuthenticationStatus;
import cise.utils.*;

public class Utente extends CounterRecord implements Authenticable{

	public static final String TABELLA = "portalowner.utenti";
	
	//	Attributi
	public	Number id_utente;
	public	String username;
	public	String password;
	public	String nome;
	public	String cognome;
	/*public	String professione;*/
	public	String indirizzo;
	public	String num_civ;
	public	String comune;
	public	String provincia;
	public	String cap;
	public	String stato;
/*	public	String partita_iva;*/
	public	String cod_fiscale;	
	public	String telefono;
	public	String fax;
	public	String cellulare;
	public	String email;
	/*public	String email_ref;
	public	String classe_fatt;
	public	String attivita;*/
	public	String sesso;
	public	Date data_nascita;
/*	public	String interesse;
	public	String stato_civile;
	public	String titolo_studio;
	public	Long num_dipendenti;*/
	public	String privacy;
	public	String privacy_sped;
	public	String rag_sociale;
	public	String tipo_utente;
	/*public	String note;
	
	public Long id_faziendale;
	public Long id_cfatturato;
	public Long id_tattivita;*/
	public Date data_register;
	public Number id_area_servizio;	// L'ID dell'area di servizio di primo livello da cui l'utente ha eseguito il processo di registrazione
	public Number valido;
	
	public Utente(){
		super("portalowner.utenti");
	}
	
	public Utente(DBConnectPool pool){
		super("portalowner.utenti", pool);
	}
	
	public Utente(Record r){
		super("portalowner.utenti",r);
	}

	public Utente(String pref_user,int lungPwd){
		super("portalowner.utenti");
		setUserPwdUtente(pref_user,lungPwd);
	}	


	// Inserisce l'utente appena creato e setta lo username con il prefisso pref_user e password alfanumerica random di lunghezza lungPwd
	// FUNZIONA SOLO SE L'UTENTE NON E' INSERITO!!!!!
	public void setUserPwdUtente(String pref_user,int lungPwd){
		if (!isInserted()) {
			insert();
			username = pref_user + (id_utente).toString();
			password = get_newPwd(lungPwd);
			update();
		}
	}	
	
	// Interfaccia
	public void setUsername(String username_in){
		username=username_in;
	}
	public void setPassword(String password_in){
		password=password_in;
	}
	public void setNome(String nome_in){
		nome=nome_in;
	}
	public void setCognome(String cognome_in){
		cognome=cognome_in;
	}
	public void setCap(String cap_in){
		cap=cap_in;
	}
	public void setCod_fiscale(String cod_fiscale_in){
		cod_fiscale=cod_fiscale_in;
	}
	public void setFax(String fax_in){
		fax=fax_in;
	}
	public void setEmail(String email_in){
		email=email_in;	
	}
	public void setPrivacy(String privacy_in){
		privacy=privacy_in;
	}
	public void setPrivacy_sped(String s){
		privacy_sped=s;	
	}
	public void setTipo_utente(String tipo_utente_in){
		tipo_utente=tipo_utente_in;	
	}
	public void setRag_sociale(String rag_sociale_in){
		rag_sociale=rag_sociale_in;	
	}

	public void setId_area_servizio(Number i){
		id_area_servizio=i;
	}
	public void setValido(Number v){
		valido=v;	
	}

// *************************** GET

	public String getUsername(){
		return username;
	}
	public String getPassword(){
		return password;
	}
	public String getNome(){
		return nome;
	}
	public String getCognome(){
		return cognome;
	}
	public String getCod_fiscale(){
		return cod_fiscale;
	}
	public String getEmail(){
		return email;
	}
	
	// Metodi pubblici di utilit

	public String getIdentita(){
		String identita="";
		if (nome!=null)	identita += nome;
		if (cognome!=null)	identita += (!identita.equals("") ? " " : "") + cognome;
		
		return identita;
	}

	private String get_newPwd(int n){
		return StringUtils.randomString(n);
	}
	
	public static String nextUsernamePadding(DBConnectPool pool, String prefix){
		String newUN="";
		String counterString="";
		try{
			QueryPager pUser=new QueryPager(pool);
			pUser.set("select username from portalowner.utenti where username like '" + prefix + "%' order by username desc");
			if (pUser.getNumberRecords() > 0){
				try{
					String lastCounter=pUser.iterator().next().getField("username").substring(prefix.length());
					int counter=Integer.parseInt(lastCounter);
					counter++;
					counterString=String.valueOf(counter);
					for (int i=counterString.length(); i<2; i++)
						counterString = "0" + counterString;
				}catch(IndexOutOfBoundsException ie){
					counterString = "01";
				}
			}else
				counterString = "01";
			
			newUN = prefix + counterString;
		
		}catch(Exception e){
			e.printStackTrace();
			newUN=null;
		}
		
		return newUN;
	}
	
	public static List<String> suggestFreeUsername(DBConnectPool pool, String nome, String cognome){
		
		List<String> usernames=new ArrayList<String>();
		usernames.add(nome.substring(0,1)+cognome);
		usernames.add(nome.substring(0,1)+"."+cognome);
		usernames.add(nome+"."+cognome);
		usernames.add(nome+cognome);
		usernames.add(nome+"_"+cognome);
		usernames.add(nome.substring(0,1)+"_"+cognome);
		usernames.add(cognome);
		
		String listUsernames="'";
		for (String s: usernames)
			listUsernames += ((listUsernames.equals("") ? "" : "', '") + StringUtils.replaceAll(s, "'", "''"));
		listUsernames += "'";
		
		QueryPager pagerUsernameUsed=new QueryPager(pool);
		try{
			pagerUsernameUsed.set("select username from portalowner.utenti where username in (" + listUsernames + ")");
			for (Row<String> usernameUsed: pagerUsernameUsed)
				usernames.remove(usernameUsed.getField("username"));
				
		}catch(java.sql.SQLException se){
			se.printStackTrace();
			usernames=null;
		}catch(NoSuchFieldException fe){
			fe.printStackTrace();
			usernames=null;
		}
		
		return usernames;
	}
	
	public static String nextUsername(DBConnectPool pool, String projectPrefix){
		
		String username=null;
		boolean error=false;
		long progProf=1;

		QueryPager systemUsernamePager=new QueryPager(pool);
		try{
			systemUsernamePager.set("select to_number(substr(username," + (projectPrefix.length()+1)+ ")) as ultimo from portalowner.utenti where username like '" + projectPrefix + "%' order by ultimo desc");
			progProf=Long.parseLong(systemUsernamePager.iterator().next().getField("ultimo"))+1;
		}catch(java.sql.SQLException sqle){
			sqle.printStackTrace();
			error=true;
		}catch(NoSuchFieldException nsfe){
			nsfe.printStackTrace();
			error=true;
		}catch(Exception e){
			// Non è un errore, è il caso del primo username per il prefisso dato...
		}
		
		if (!error)
			username=projectPrefix+progProf;
		
		return username;
	}
	
	public static Long availableID(DBConnectPool pool){
		QueryPager idPager=new QueryPager(pool);
		try{
			idPager.set("select portalowner.id_utente.nextval as id from dual");
			return new Long(idPager.iterator().next().getField("id"));
		}catch(java.sql.SQLException sqle){
			sqle.printStackTrace();
			return null;
		}catch(NoSuchFieldException nsfe){
			nsfe.printStackTrace();
			return null;
		}
	}
	
	public boolean addGroup(Long idGruppo){
		it.cise.db.SQLTransactionManager offMan=new it.cise.db.SQLTransactionManager(this, getPool());
		return offMan.executeCommandQuery("insert into portalowner.rel_utenti_gruppi(id_utente, id_gruppo) values (" + id_utente + ", " + idGruppo + ")");
	}
	public boolean addAreaServizi(Long idArea){
		it.cise.db.SQLTransactionManager offMan=new it.cise.db.SQLTransactionManager(this, getPool());
		return offMan.executeCommandQuery("insert into portalowner.rel_utenti_as_servizi(id_utente, id_area_servizio) values (" + id_utente + ", " + idArea + ")");
	}
	
	public List<Long> getAutorizzazioni(){
		ArrayList<Long> auths=new ArrayList<Long>();
		try{
			QueryPager pagerAuth=new QueryPager(getPool());
			pagerAuth.set("select id_autorizzazione from portalowner.rel_utenti_gruppi g, portalowner.rel_gruppi_autorizzazioni a where g.id_gruppo=a.id_gruppo and g.id_utente=" + id_utente);
			for (Row<String> auth: pagerAuth)
				auths.add(new Long(auth.getField("id_autorizzazione")));
		}catch(Exception e){
			e.printStackTrace();
			auths=null;
		}
		
		return auths;
	}
	public boolean authorizedFor(Long idAuth){
		return getAutorizzazioni().contains(idAuth);
	}
	
	public boolean loggedIn(){
		return isInserted();
	}
	

	public AuthenticationStatus authenticate(String user, String pwd) {
		try {
			Long p_id_utente=null;
			boolean p_valido=false;
	 		AuthenticationStatus authStatus=null;
			String queryauth ="SELECT * FROM " + TABELLA + " WHERE username='" + user +"'";
			
			PreviewQuery prev = new PreviewQuery(this.getPool());
			prev.setPreview(queryauth);
			
			//cise.utils.Logger.write(this,"Query Eseguita");
			if (prev.getNumberRecords()>0){
				p_valido = prev.getField("valido").equals("1");
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
	
	/**	Stampa i dati sullo User */
	public String toString(){
		String objString=null;
		objString="{\n";
		objString+=(getIdentita() + " [id=" + id_utente + "]\n");
		objString+="}";
		
		return objString;
	}

}	