package it.cise.portale.cdc.documenti.eventi;

import java.util.Date;

import cise.utils.DateUtils;
import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.PaginaWeb;
import it.cise.portale.cdc.documenti.eventi.Luogo;
import it.cise.portale.cdc.documenti.referenza.Referenza;
import it.cise.portale.cdc.email.EmailPunto;
import it.cise.portale.cdc.email.EmailWeb;

public class EdizioneEsterna extends Referenza implements Edizione<Referenza> {

	private static final long serialVersionUID = 5264155517961009029L;

	public Date dal;
	public Date al;
	public String note_periodo;
	public Long id_luogo;
	public String note_luogo;
	public String indicazione_orario;
	public String iscrizione_online_url_ext;
	
	private Luogo luogo;
	
	public EdizioneEsterna() {
		super();
	}

	public EdizioneEsterna(Long id, DBConnectPool pool) {
		super(id, pool);
	}

	public EdizioneEsterna(Record documento) {
		super(documento);
	}

	@Override
	public Date getDal() {
		return dal;
	}
	@Override
	public Date getAl() {
		return al;
	}

	@Override
	public Date getTemporizzazione(){
		return dal;
	}
	
	@Override
	public String getNoteLuogo(){
		return note_luogo;
	}
	@Override
	public Luogo getLuogo() {
		if (id_luogo!=null && luogo == null)
			luogo = new Luogo(id_luogo, getPool());
		
		return luogo;
	}
	@Override
	public String luogo(){
		String luogoStr="";
		
		if (getLuogo()!=null)
			luogoStr = luogo.getCittaENome();
		
		return luogoStr;
	}
	@Override
	public String luogoENote(){
		String luogoStr = luogo();
		
		if (note_luogo!=null && !note_luogo.equals("") && !luogoStr.equals(note_luogo)) {
			if (!luogoStr.equals(""))
				luogoStr += " - ";
			luogoStr += note_luogo;
		}
		return luogoStr;
	}
	
	@Override
	public Long getAnnoPertinenza() {
		return (anno_pertinenza!=null ? 
				anno_pertinenza : 
					(dal!=null ? new Long(DateUtils.getYear(dal)) : super.getAnnoPertinenza())
				);
	}

	@Override
	public String getNotePeriodo(){
		return note_periodo;
	}
	@Override
	public String periodo(){
		String data="";
		if (dal!=null && al!=null){
			if (dal.equals(al))
				data += DateUtils.formatDate(dal);
			else
				data += DateUtils.formatDate(dal) + " - " + DateUtils.formatDate(al);
		}
		return data;
	}
	@Override
	public String periodoENote(){
		String data=periodo();
		
		if (note_periodo != null && !note_periodo.equals("")) {
			if (!data.equals(""))
				data += " - ";
			data += note_periodo;
		}
		return data;
	}
	
	
	@Override
	public String getOrario(){
		return indicazione_orario;
	}
	
	@Override
	public String getInfo() {
		String luogo=luogo();
		String periodo=periodo();
		
		if ((luogo==null || luogo.equals("")) && periodo!=null)
			return periodo;
		else if ((luogo!=null && !luogo.equals("")) && periodo!=null)
			return luogo + ", " + periodo;
		else if ((luogo!=null && !luogo.equals("")) && periodo==null)
			return luogo;
		else
			return "";
	}
	
	public String getLinkIscrizione(){
		return iscrizione_online_url_ext;
	}
	
	@Override
	public EmailWeb creaEmailWeb(Utente proprietario, boolean inserito) {
		
		EmailWeb emailFiglia = super.creaEmailWeb(proprietario, inserito);
		emailFiglia.dal = dal;
		emailFiglia.al = al;
		emailFiglia.note_periodo = note_periodo;
		emailFiglia.id_luogo = id_luogo;
		emailFiglia.note_luogo = note_luogo;
		
		emailFiglia.update();
		
		return emailFiglia;	
	}
	
	@Override
	public EdizioneEsterna copiaIn(Utente proprietario, DBConnectPool pool, PaginaWeb<?> padri){
		EdizioneEsterna copia=(EdizioneEsterna)super.copiaIn(proprietario, pool, padri);
		copia.dal = dal;
		copia.al = al;
		copia.id_luogo = id_luogo;
		copia.update(proprietario);

		return copia;
	}

}
