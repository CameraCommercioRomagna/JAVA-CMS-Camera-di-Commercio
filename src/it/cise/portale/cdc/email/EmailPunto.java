package it.cise.portale.cdc.email;

import it.cise.db.CounterRecord;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.db.jdbc.NoAssignedPoolException;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.structures.field.NullValueException;
import it.cise.util.auth.Authenticable;

public class EmailPunto extends CounterRecord implements ItemEmailable, Comparable<EmailPunto>{
	
	private static final long serialVersionUID = 2272174726621749660L;

	public final static String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA + ".email_punti";
	
	public Long id_email_punto;
	public Long id_email_web;
	public String info_data;
	public String info_ora_inizio;
	public String info_ora_fine;
	public String titolo;
	public String testo;
	public String img_path; 
	public String img_url;
	public Long ordine;
    
	private EmailWeb email;
	
	
	public EmailPunto() {
		super(NAME_TABLE);
	}
	
	public EmailPunto(EmailWeb email) {
		this();
		initialize(email.getPool());
		this.email = email;
		this.id_email_web = email.id_email_web;
	}
	
	public EmailPunto(Long id, DBConnectPool pool) {
		super(NAME_TABLE, pool);
		this.id_email_punto = id;
		load();
	}
	
	public EmailWeb getEmail() {
		return email;
	}
	
	public Long getId() {
		return id_email_punto;
	}
	public String getTitolo() {
		return titolo;
	}
	public String getTesto() {
		return testo;
	}
	
	public String getImmagine() {
		return img_path;	
	}
	
	public String getInfoTempo(){
		String temp=getData();
		String orario=getOrario();
		if (orario!=null && !orario.equals("")) 
			temp += (!temp.equals("") ? " - " : "") + orario;
		return temp;
	}
	
	public String getData() {
		return (info_data!=null ? info_data : "");
	}
	
	public String getOrario(){
		String temp="";
		
		if (info_ora_inizio!=null && !info_ora_inizio.equals(""))
			temp += info_ora_inizio;
		if (!temp.equals(""))
			if (info_ora_fine!=null && !info_ora_fine.equals(""))
				temp += "-" + info_ora_fine;
		return temp;
	}
	
	public EmailPunto copiaIn(Utente proprietario, EmailWeb nuovaEmail) {
		EmailPunto copia=new EmailPunto(nuovaEmail);
		copia.id_email_web = nuovaEmail.id_email_web;
		copia.info_data = info_data;
		copia.info_ora_fine = info_ora_fine;
		copia.info_ora_inizio = info_ora_inizio;
		copia.titolo = titolo;
		copia.testo = testo;
		copia.img_path = img_path;
		copia.img_url = img_url;
		copia.ordine = ordine;
		copia.insert(proprietario);
		
		return copia;
	}
	
	@Override
	public boolean insert(Authenticable utente)
		throws NoAssignedPoolException, NullValueException {
		boolean esito=super.insert(utente);
		return esito;
	}
	@Override
	public boolean update(Authenticable utente) throws NoAssignedPoolException, NullValueException {
		boolean esito=super.update(utente);
		return esito;
	}
	@Override
	public boolean delete(Authenticable utente) throws NoAssignedPoolException, NullValueException {
		boolean esito=super.delete(utente);
		return esito;
	}

	@Override
	public int compareTo(EmailPunto altraEmail){
		int check = 1;
		
		if(altraEmail!=null){
			if(ordine!=null && altraEmail.ordine!=null)
				check = ordine.compareTo(altraEmail.ordine);
			else
				check = ordine!=null ? 1 : (altraEmail.ordine!=null ? -1 : 0);
				
			if(check==0)
				check = id_email_web.compareTo(altraEmail.id_email_web);
		}
		
		return check;
	}

}
