package it.cise.portale.cdc.newsletters;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.naming.OperationNotSupportedException;

import cise.utils.DateUtils;
import cise.utils.Logger;
import it.cise.db.CounterRecord;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.portale.cdc.documenti.DocumentFactory;
import it.cise.portale.cdc.documenti.DocumentoWeb;
import it.cise.portale.cdc.documenti.Priorita;
import it.cise.portale.cdc.documenti.TipoDocumento;
import it.cise.portale.cdc.documenti.TipoSistema;
import it.cise.portale.cdc.documenti.Visibilita;
import it.cise.portale.cdc.documenti.referenza.Referenza;
import it.cise.portale.cdc.documenti.standard.Documento;

public class NumeroNewsLetter extends CounterRecord {
	
	private static final long serialVersionUID = -5939669196660340217L;

	public static final String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA+".nl_numeri";
	public final static String PARAMETER_ID="ID_NLNUMERO";
	
	public Long id_nl_numero;
	public Long id_nl_tipo;
	public Date data;
	public Date data_pubblicazione;
	public Long numero;
	
	private NewsLetter newsLetter;
	
	public NumeroNewsLetter(){
		super(NAME_TABLE);
	}
	
	public NumeroNewsLetter(NewsLetter nl, Long num, Date d){
		super(NAME_TABLE, nl.getPool());
		this.newsLetter=nl;
		this.numero=num;
		this.data=d;
	}
	
	public NumeroNewsLetter(Long id, DBConnectPool pool){
		super(NAME_TABLE, pool);
		this.id_nl_numero=id;
		load();
	}

	public NewsLetter getNewsLetter() {
		if (newsLetter==null)
			newsLetter = new NewsLetter(id_nl_tipo, getPool());
		return newsLetter;
	}
	
	public String getLink() {
		return getNewsLetter().url_pubblico + "?" + PARAMETER_ID + "=" + id_nl_numero;
	}
	
	public boolean associa(Utente operatore, DocumentoWeb<?> d, String sezione){
		if (isPubblicato())
			throw new IllegalStateException("Impossibile associare documenti ad un numero di newsletter già pubblicato");
		if (!isModificabile())
			throw new IllegalStateException("Termine ultimo di presentazione dei documenti superato");
		else{
			PromozioneDocumentoWeb dPubblicabile=search(d);
			if (dPubblicabile==null){
				dPubblicabile=new PromozioneDocumentoWeb(d);
				dPubblicabile.associa(operatore, this, sezione);
				return true;
			}else{
				if (dPubblicabile.sezione.equals(sezione))
					return false;
				else{
					dPubblicabile.sezione=sezione;
					dPubblicabile.update(operatore);
					return true;
				}
			}
		}
	}
	
	public boolean disassocia(Utente operatore, DocumentoWeb<?> d){
		if (isPubblicato())
			throw new IllegalStateException("Impossibile disassociare documenti ad un numero di newsletter già pubblicato");
		if (!isModificabile())
			throw new IllegalStateException("Termine ultimo di eliminazione dei documenti superato");
		else{
			PromozioneDocumentoWeb dPubblicabile=search(d);
			if (dPubblicabile!=null)
				return dPubblicabile.disassocia(operatore);
			else
				return false;
		}
	}
	
	public boolean isModificabile(){
		return (!isPubblicato() && DateUtils.addDays(new Date(), getNewsLetter().gg_associa_entro.intValue()-1).before(data));	// il -1 occorre per simulare il <=
	}
	
	public PromozioneDocumentoWeb search(DocumentoWeb<?> d) {
		PromozioneDocumentoWeb dFound=null;
		for(PromozioneDocumentoWeb dwp: getDocumentiPubblicabili()){
			if (dwp.getDocumento().getId().compareTo(d.getId())==0)
				dFound=dwp;
		}
		return dFound;
	}
	
	public List<DocumentoWeb<?>> getDocumenti(){
		return getDocumenti(null);
	}
	public List<DocumentoWeb<?>> getDocumenti(Boolean approvati){
		List<DocumentoWeb<?>> sottoElenco=new ArrayList<DocumentoWeb<?>>();
		for (PromozioneDocumentoWeb d: getDocumentiPubblicabili())
			if (approvati==null
					|| (approvati && d.isApprovato())
					|| (!approvati && !d.isApprovato()))
				sottoElenco.add(d.getDocumento());
				
		return sottoElenco;
	}
	
	public List<PromozioneDocumentoWeb> getDocumentiPubblicabili(){
		
		List<PromozioneDocumentoWeb> elenco=new ArrayList<PromozioneDocumentoWeb>();
		for (Sezione sezione: getNewsLetter().getSezioni())
			elenco.addAll(getDocumentiPubblicabili(sezione));
		
		return elenco;
	}
	public List<PromozioneDocumentoWeb> getDocumentiPubblicabili(Sezione s){
		return loadEntitiesFromQuery("select * from " + PromozioneDocumentoWeb.NAME_TABLE + " where id_nl_numero=" + id_nl_numero + (s!=null ? " and sezione='"+s.nome+"'" : "") + " order by ordine", getPool(), PromozioneDocumentoWeb.class);
	}

	public String getTitolo(){
		return getNewsLetter().getNome() + (numero!=null ? " n." + numero + " " : "") + " del " + DateUtils.formatDate(data);
	}
	
	public void pubblica(Utente operatore){
		if (!isPubblicato()){
			data_pubblicazione = new Date();
			update(operatore);
			
			/*Referenza linkPubblico=new Referenza();
			linkPubblico.initialize(getPool());

			linkPubblico.titolo=getTitolo();
			linkPubblico.abstract_txt=newsLetter.descrizione;
			linkPubblico.url=NewsLetter.LINKWEB + "?" + PARAMETER_ID + "=" + id_nl_numero;
			linkPubblico.id_proprietario=operatore.id_utente;

			linkPubblico.id_tipo_documento_web=newsLetter.id_tipo_documento_web;
			linkPubblico.id_tipo_sistema=TipoSistema.LINK.getId();
			linkPubblico.priorita=Priorita.MEDIA.getValore();
			linkPubblico.punteggio=Visibilita.VISIBILE_HOME_PAGE.getValore();
			
			linkPubblico.data_inserimento=new Date();
			linkPubblico.data_pubblicazione=linkPubblico.data_inserimento;
			linkPubblico.data_scadenza=DateUtils.addDays(linkPubblico.data_pubblicazione, 14);
			linkPubblico.data_modifica=linkPubblico.data_inserimento;
			linkPubblico.anno_pertinenza=Long.parseLong(DateUtils.formatDate(data, "yyyy"));
			
			linkPubblico.validato=true;
			linkPubblico.data_validazione=new Date();
			linkPubblico.data_ultimo_aggiornamento=linkPubblico.data_validazione;
			linkPubblico.insert(operatore);*/
			
			try {
				Documento homeNotiziario=(Documento)DocumentFactory.loadAll(getPool(), TipoDocumento.HOME_PAGE_NOTIZIARIO, null, null, null, null).get(0);
				Referenza linkPubblico = (Referenza)homeNotiziario.creaFiglio(operatore, TipoSistema.LINK, TipoDocumento.NOTIZIARIO, false);
				
				linkPubblico.titolo=getTitolo();
				linkPubblico.abstract_txt=newsLetter.descrizione;
				linkPubblico.url=getLink();

				linkPubblico.punteggio=Visibilita.VISIBILE_HOME_PAGE.getValore();
				
				linkPubblico.data_inserimento=new Date();
				linkPubblico.data_pubblicazione=linkPubblico.data_inserimento;
				linkPubblico.data_scadenza=DateUtils.addDays(linkPubblico.data_pubblicazione, 14);
				linkPubblico.data_modifica=linkPubblico.data_inserimento;
				linkPubblico.anno_pertinenza=Long.parseLong(DateUtils.formatDate(data, "yyyy"));
				
				linkPubblico.validato=true;
				linkPubblico.data_validazione=new Date();
				linkPubblico.data_ultimo_aggiornamento=linkPubblico.data_validazione;
				linkPubblico.insert(operatore);
				
				Logger.write(" ** Validata newsletter : " + this);
				Logger.write(" ** Validata newsletter su url : " + linkPubblico.url);
			} catch (OperationNotSupportedException e) {
				Logger.write("Errore nella creazione del link al notiziario (vedi stack seguente)");
				e.printStackTrace();
			}
		}
	}
	public boolean isPubblicato() {
		return isInserted() && data_pubblicazione!=null;
	}
	
	public String toString(){
		String output="\n" + getTitolo();
		output += (isPubblicato() ? " -> PUBBLICATA IL " + data_pubblicazione : "");
		
		String sez="";
		for (PromozioneDocumentoWeb dwp: getDocumentiPubblicabili()){
			String currSez=dwp.sezione;
			if (!sez.equals(currSez)){
				output += "\n* " + currSez + " *";
				sez=currSez;
			}
			output += "\n - " + dwp.getDocumento().getTitolo() + " - inserito il " + dwp.data_richiesta + (dwp.isApprovato() ? " APPROVATO IL " +dwp.data_validazione : " NON APPROVATO");
		}
		return output;
	}
	
}
