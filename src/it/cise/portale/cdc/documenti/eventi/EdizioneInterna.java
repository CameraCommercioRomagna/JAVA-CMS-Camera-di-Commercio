package it.cise.portale.cdc.documenti.eventi;

import java.util.*;

import javax.naming.OperationNotSupportedException;

import cise.utils.DateUtils;
import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.portale.cdc.documenti.DocumentFactory;
import it.cise.portale.cdc.documenti.DocumentoWeb;
import it.cise.portale.cdc.documenti.PaginaWeb;
import it.cise.portale.cdc.documenti.TipoDocumento;
import it.cise.portale.cdc.documenti.TipoOrdinamentoDocumenti;
import it.cise.portale.cdc.documenti.TipoSistema;
import it.cise.portale.cdc.documenti.Visibilita;
import it.cise.portale.cdc.email.EmailPunto;
import it.cise.portale.cdc.email.EmailWeb;
import it.cise.portale.cdc.email.ItemEmailable;
import it.cise.util.auth.Authenticable;


public class EdizioneInterna extends PaginaWeb<EdizioneInterna> implements Edizione<EdizioneInterna> {
	
	private static final long serialVersionUID = -2884848876969463836L;
	
	public final static String REF_DOC_LUOGO = "documenti_web_id_luogo";
	public final static String REF_PROGRAMMA = "punti_programma_id_documento_web_fkey";
	private static final String REF_ORGANIZZATORI = "rel_documenti_web_enti_id_documento_web_fkey";

	public Date dal;
	public Date al;
	public String note_periodo;
	public Long id_luogo;
	public String note_luogo;
	public Boolean a_pagamento;
	public Boolean da_confermare;
	public Boolean confermato;
	public Boolean iscrizione_online;
	public Date data_scadenza_iscr;
	public Boolean incontro_relatore;
	public Boolean disponibilita_atti;
	public Boolean paperless;
	public String indicazione_orario;
	public String conf_iscr_note;
	public String conf_iscr_privacy;
	public Boolean abilita_modalita_mista;
	public String iscrizione_online_url_ext;
	
	//private Date dataTemporizzazione;
	
	private Luogo luogo;
	private List<PuntoProgramma> programma;
	private List<Organizzatore> organizzatori;
	private Map<TipoCollaborazione, List<Organizzatore>> mapOrganizzatori;
	
	public EdizioneInterna(){
		super();
	}
	public EdizioneInterna(Long id, DBConnectPool pool){
		super(id, pool);
	}
	public EdizioneInterna(Record documento) {
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
		
		if (getLuogo()!=null) {
			luogoStr = luogo.getCittaENome();
		}else
			luogoStr = (note_luogo!=null ? note_luogo : "");
		
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
	
	public String getLinkIscrizione(){
		if(iscrizione_online_url_ext!=null && !iscrizione_online_url_ext.equals(""))
			return iscrizione_online_url_ext;
		else
			return getPathLink() + "iscrizione-evento.htm?" + PARAMETER_ID + "=" + id_documento_web;
	}

	public Date getDataScadenzaIscrizione(){
		if(iscrizione_online){
			return (data_scadenza_iscr!=null ? data_scadenza_iscr : dal);
		}else{
			throw new RuntimeException("Impossibile richiedere la data di scadenza per un evento senza iscrizione online");
		}
	}
	
	@Override
	public Date getTemporizzazione(){
		/*	20190107 - Semplificata gestione ereditata dal sito ponte
		if (dataTemporizzazione==null){
			List<Date> dateUtili=new ArrayList<Date>();
			
			dateUtili.add(data_pubblicazione);
						
			if (data_scadenza_iscr!=null && !data_scadenza_iscr.before(new Date()))
				dateUtili.add(data_scadenza_iscr);
			
			if (dal!=null)
				dateUtili.add(dal);
			
			dataTemporizzazione=DateUtils.closedToToday(dateUtili);
		}
		return dataTemporizzazione;*/
		return dal;
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
	
	@Override
	public String getOrario(){
		return indicazione_orario;
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
		
		for (PuntoProgramma p: getProgramma()) {
			EmailPunto ep = new EmailPunto(emailFiglia);
			ep.info_data = p.info_data;
			ep.info_ora_fine = p.info_ora_fine;
			ep.info_ora_inizio = p.info_ora_inizio;
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
	public EdizioneInterna copiaIn(Utente proprietario, DBConnectPool pool, PaginaWeb<?> padri){
		EdizioneInterna copia=super.copiaIn(proprietario, pool, padri);
		copia.dal = dal;
		copia.al = al;
		copia.note_periodo = note_periodo;
		copia.id_luogo = id_luogo;
		copia.note_luogo = note_luogo;
		copia.a_pagamento = a_pagamento;
		copia.da_confermare = da_confermare;
		copia.confermato = false;
		copia.iscrizione_online = iscrizione_online;
		copia.data_scadenza_iscr = data_scadenza_iscr;
		copia.incontro_relatore = incontro_relatore;
		copia.disponibilita_atti = disponibilita_atti;
		copia.paperless = paperless;
		copia.update(proprietario);

		// Elimina eventuali punti/organizzatori creati in automatico a seguito della insert..
		for (PuntoProgramma pNew: copia.getProgramma())
			pNew.delete(proprietario);
		for (Organizzatore oNew: copia.getOrganizzatori())
			oNew.delete(proprietario);
				
		for (PuntoProgramma pp: getProgramma())
			pp.copiaIn(proprietario, copia);
		for (Organizzatore o: getOrganizzatori())
			o.copiaIn(proprietario, copia);
		
		return copia;
	}

	@Override
	public boolean delete(Authenticable utente) {
		boolean success=true;
		for (PuntoProgramma p: getProgramma())
			if (success)
				success = success && p.delete(utente);
		for (Organizzatore o: getOrganizzatori())
			if (success)
				success = success && o.delete(utente);
		for (Iscrizione i: getIscritti())
			if (success)
				success = success && i.delete(utente);
		if (success)
			success = super.delete(utente);
		return success;
	}
	
	public PaginaWeb<?> getDescrizione(){
		return getPadre();
	}
	
	public List<Organizzatore> getOrganizzatori(){
		if (organizzatori==null) {
			organizzatori = getRelation(REF_ORGANIZZATORI, Organizzatore.class, this).getRecords();
			
			mapOrganizzatori = new HashMap<TipoCollaborazione, List<Organizzatore>>();
			for (Organizzatore o: organizzatori) {
				List<Organizzatore> listaTipo=mapOrganizzatori.get(o.getTipoCollaborazione());
				if (listaTipo==null) {
					listaTipo = new ArrayList<Organizzatore>();
					mapOrganizzatori.put(o.getTipoCollaborazione(), listaTipo);
				}
				listaTipo.add(o);
			}
		}
		return organizzatori;
	}
	public List<Organizzatore> getOrganizzatori(TipoCollaborazione collaborazione){
		getOrganizzatori();
		List<Organizzatore> listaTipo=mapOrganizzatori.get(collaborazione);
		if (listaTipo == null)
			listaTipo = new ArrayList<Organizzatore>();
		return listaTipo;
	}
	
	@Override
	public DocumentoWeb<?> creaFiglio(Utente proprietario, TipoSistema tipoSistema, TipoDocumento tipoDocumento, boolean inserito)
		throws OperationNotSupportedException {
		
		AbstractDocumentoWeb<?> docFiglio=(AbstractDocumentoWeb<?>)super.creaFiglio(proprietario, tipoSistema, tipoDocumento, inserito);
		if (tipoDocumento == TipoDocumento.ATTO_EVENTO) {
			docFiglio.titolo = "Atti di '" + titolo + "'";
			docFiglio.abstract_txt = "Pubblicati gli atti dell'evento '" + titolo + "'";
			
			String periodo=periodo();
			if (!periodo.equals(""))
				docFiglio.abstract_txt += " del " + periodo;

			if (getLuogo()!=null) {
				String citta=luogo.getCitta();
				if (!citta.equals(""))
					docFiglio.abstract_txt += " tenutosi a " + citta;
			}
			if (inserito)
				docFiglio.update(proprietario);
		}
		return docFiglio;
	}
	
	public List<PuntoProgramma> getProgramma(){
		if (programma==null)
			programma = getRelation(REF_PROGRAMMA, PuntoProgramma.class, this).getRecords();
		
		return programma;
	}
	
	public List<Iscrizione> getIscritti() {
		return loadEntitiesFromQuery("select i.* from " + AbstractDocumentoWeb.NAME_SCHEMA + ".rel_documenti_web_iscrizioni i where id_documento_web=" + id_documento_web, getPool(), Iscrizione.class, this);
	}

	public List<AttoEvento> getAtti(){
		return DocumentFactory.getAll(getFigli(TipoDocumento.ATTO_EVENTO, null, true, true, null, Visibilita.VISIBILE_DOVE_COLLOCATO, TipoOrdinamentoDocumenti.MANUALE), AttoEvento.class);
	}
	
	@Override
	public List<ItemEmailable> getItem(){
		getProgramma();
		List<ItemEmailable> items = new ArrayList<ItemEmailable>();
		if(programma!=null && programma.size()>0)
			items.addAll(programma);
		return items;
	}
}
