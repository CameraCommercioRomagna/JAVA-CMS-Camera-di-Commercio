package it.cise.portale.cdc.email;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import cise.utils.DateUtils;
import it.cise.db.*;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.DocumentFactory;
import it.cise.portale.cdc.documenti.PaginaWeb;
import it.cise.portale.cdc.documenti.TipoDocumento;
import it.cise.portale.cdc.documenti.eventi.Luogo;
import it.cise.util.auth.Authenticable;


public class EmailWeb
	extends CounterRecord
	implements Emailable, Comparable<EmailWeb> {
	
	private static final long serialVersionUID = -459361126154794327L;
	
	public final static String NAME_SCHEMA="portalowner2";
	public final static String NAME_TABLE = NAME_SCHEMA + ".email_web";
	
	public final static String REF_EMAIL_PROPRIETARIO = "email_web_id_proprietario";
	public final static String REF_EMAIL_DOC = "email_web_id_documento_web_fkey";
	public final static String REF_EMAIL_PUNTI = "email_punti_id_email_web_fkey";
	
	
	public final static String UPLOAD_ROOT_DIRECTORY = "/upload/cdc_romagna/email/";
	
	public final static String PARAMETER_ID="ID_E";

	public Long id_email_web;
	public Long id_documento_web;
	public String titolo;
	public String abstract_txt;
	public String icona;
	
	public Date dal;
	public Date al;
	public String note_periodo;
	public String indicazione_orario;
	public Long id_luogo;
	public String note_luogo;
	
	public Long id_proprietario;
	public Date data_inserimento;
	
	private Utente proprietario;
	private Luogo luogo;
	private PaginaWeb<?> paginaPadre;
	private List<EmailPunto> punti;

	public EmailWeb() {
		super(NAME_TABLE);
	}
	
	public EmailWeb(DBConnectPool pool) {
		super(NAME_TABLE, pool);
	}
	
	public EmailWeb(Long id, DBConnectPool pool) {
		super(NAME_TABLE, pool);
		this.id_email_web = id;
		load();
	}
	
	public EmailWeb(Record email) {
		super(email);
	}
	
	public Long getId() {
		return id_email_web;
	}
	public String getTitolo() {
		return titolo;
	}
	public String getAbstract() {
		return abstract_txt;
	}
	
	public Utente getProprietario() {
		if (proprietario == null)
			proprietario = new Utente(getPool(), id_proprietario);
		return proprietario;
	}
	 
	public String periodoENote(){
		String data="";
		if (dal!=null && al!=null){
			if (dal.equals(al))
				data += DateUtils.formatDate(dal);
			else
				data += DateUtils.formatDate(dal) + " - " + DateUtils.formatDate(al);
		}
		
		if (note_periodo != null && !note_periodo.equals("")) {
			if (!data.equals(""))
				data += " - ";
			data += note_periodo;
		}
		return data;
	}
	
	public String getOrario(){
		return indicazione_orario;
	}
	
	public Luogo getLuogo() {
		if (id_luogo!=null && luogo == null)
			luogo = new Luogo(id_luogo, getPool());
		
		return luogo;
	}
	
	public String luogoENote(){
		String luogoStr = getLuogo()!=null ? luogo.getCittaENome() : "";
		
		if (note_luogo!=null && !note_luogo.equals("")) {
			if (!luogoStr.equals(""))
				luogoStr += " - ";
			luogoStr += note_luogo;
		}
		return luogoStr;
	}
	
	public PaginaWeb<?> getPadre(){
		if (paginaPadre == null)
			try {
				paginaPadre = (PaginaWeb<?>)DocumentFactory.load(getPool(), id_documento_web);
			}catch (Exception e) {}
		
		return paginaPadre;
	}
	
	public List<EmailPunto> getPunti(){
		if (punti==null) 
			punti = getRelation(REF_EMAIL_PUNTI, EmailPunto.class, this).getRecords();
		
		return punti;
	}
	
	public List<ItemEmailable> getItem(){
		getPunti();
		List<ItemEmailable> items = new ArrayList<ItemEmailable>();
		if(punti!=null && punti.size()>0)
			items.addAll(punti);
		return items;
	}

	@Override
	public boolean insert(Authenticable utente){
		boolean eseguito=super.insert(utente);
		return eseguito;
	}
	@Override
	public boolean update(Authenticable utente){
		boolean eseguito=super.update(utente);
		return eseguito;
	}
	
	public String getPathLink(){
		return "/amministrazione/mail/";
	}
	
	public String getLink(){
		return getPathLink() + "email_customized.htm" + "?" + PARAMETER_ID + "=" + id_email_web;
	}
	
	public String getInfo() {
		return "Creata il " + DateUtils.formatDate(data_inserimento);
	}
	
	public String getIcona() {
		return (icona!=null ? icona : "");	
	}
	
	public String getImmagine() {
		return icona;	
	}
	
	public TipoDocumento getTipo(){
		return getPadre().getTipo();
	}

	private void initAbstractInformation(Utente proprietario, EmailWeb nuovaEmail, DBConnectPool pool) {
		nuovaEmail.initialize(pool);
		
		nuovaEmail.titolo="Copia di " + titolo;
		nuovaEmail.abstract_txt=abstract_txt;
		nuovaEmail.icona=icona;
		
		nuovaEmail.dal = dal;
		nuovaEmail.al = al;
		nuovaEmail.note_periodo = note_periodo;
		nuovaEmail.id_luogo = id_luogo;
		nuovaEmail.note_luogo = note_luogo;

		nuovaEmail.id_documento_web = id_documento_web;
		nuovaEmail.data_inserimento = new Date();
		
		nuovaEmail.id_proprietario = (Long) proprietario.id_utente;
	}
	
	public EmailWeb copia(Utente proprietario){
		
		EmailWeb copiaE = null;
		try {
			copiaE = new EmailWeb();
			initAbstractInformation(proprietario, copiaE, getPool());
			copiaE.insert(proprietario);
			
			List<EmailPunto> copia_punti = copiaE.getPunti();
			for (EmailPunto pNew: copia_punti)
				pNew.delete(proprietario);
			
			for (EmailPunto p: getPunti())
				p.copiaIn(proprietario, copiaE);
			
		} catch (Exception e) {
			e.printStackTrace();
		}

		return copiaE;
	}
	
	@Override
	public boolean delete(Authenticable utente) {
		boolean success=true;
		for (EmailPunto p: getPunti())
			if (success)
				success = success && p.delete(utente);
		if (success)
			success = super.delete(utente);
		return success;
	}
	
	public String getUploadDirectory() {
		Long id = getId();
		if (!isInserted() && (id == null))
			try {
				// Se l'id non è ancora stato inizializzato, allora lo prebnde dalla sequenza
				((CounterTableRecord)getStruttura()).getCounter().setValue();
			} catch (CounterException e) {
				e.printStackTrace();
			}
		return UPLOAD_ROOT_DIRECTORY + getId() + "/";
	}
	
	public int compareTo(EmailWeb o) {
		int compareValue=o.data_inserimento.compareTo(data_inserimento);
		if (compareValue==0)
			compareValue=id_email_web.compareTo(o.id_email_web);

		return compareValue;
	}
	
}