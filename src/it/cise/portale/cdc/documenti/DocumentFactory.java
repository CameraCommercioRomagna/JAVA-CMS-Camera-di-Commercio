package it.cise.portale.cdc.documenti;

import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import cise.utils.DateUtils;
import cise.utils.Logger;
import cise.utils.StringUtils;
import it.cise.db.CounterRecord;
import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.download.Download;
import it.cise.util.http.CdCURLWrapper;
import it.cise.util.http.URLWrapper;

public final class DocumentFactory {
	
	static DocumentoWeb<?> create(DBConnectPool pool, TipoSistema tipoSistema, TipoDocumento tipoDocumento){
		AbstractDocumentoWeb<?> d;
		try {
			// Prova a generare la classe relativa al tipo documento
			d = (AbstractDocumentoWeb<?>)tipoDocumento.getGeneratedClass().getConstructor().newInstance();
			d.initialize(pool);
		} catch (Exception e) {
			try {
				// Prova a generare la classe relativa al tipo sistema
				d = (AbstractDocumentoWeb<?>)tipoSistema.getDefaultGeneratedClass().getConstructor().newInstance();
				d.initialize(pool);
			} catch (Exception e1) {
				e1.printStackTrace();
				throw new IllegalArgumentException("impossibile creare un documento di TipoSistema " + tipoSistema);
			}
		}
		
		return d;
	}
	
	public static DocumentoWeb<?> newInstance(DBConnectPool pool, Utente proprietario, TipoSistema tipoSistema, TipoDocumento tipoDocumento){
		AbstractDocumentoWeb<?> d = (AbstractDocumentoWeb<?>)create(pool, tipoSistema, tipoDocumento);
		
		d.titolo="Nuovo documento " + tipoDocumento.toString();
		d.id_tipo_documento_web=tipoDocumento.getId();
		d.id_tipo_sistema = tipoSistema.getId();
		d.id_proprietario=proprietario.id_utente;
		d.priorita=Priorita.MEDIA.getValore();
		d.punteggio=Visibilita.VISIBILE_DOVE_COLLOCATO.getValore();
		
		Date ora=new Date();
		d.data_inserimento = ora;
		d.data_pubblicazione = ora;
		d.data_scadenza = ora;
		d.anno_pertinenza = new Long(DateUtils.getYear(ora));
		d.validato = false;
		d.data_modifica = null;
		d.data_ultimo_aggiornamento = null;

		return d;
	}
	
	public static DocumentoWeb<?> fromString(DBConnectPool pool, String docString){
		return fromString(pool, docString, null);
	}
	
	public static DocumentoWeb<?> fromString(DBConnectPool pool, String docString, Boolean case_old_db){
		Long id=null;
		if (docString != null) {
			docString = docString.trim();
			try {
				// 1. Prova ad interpretare la stringa come l'ID
				id = Long.parseLong(docString);
			}catch (Exception e) {
				try {
					// 2. Prova ad interpretare la stringa come un url del sito (sia pubblico che amministrazione)...
					URLWrapper wrapper=new CdCURLWrapper(pool, new URL(docString));
					try {
						id = Long.parseLong(wrapper.getParameter(AbstractDocumentoWeb.PARAMETER_ID).get(0));// ...1.1. come ID documento
					}catch (Exception e2) {
						id = Long.parseLong(wrapper.getParameter(Download.REQUEST_DOWNLOAD).get(0));		// ...2.2. come ID download
					}
				}catch (Exception e1) {}	
			}
		}
		if (id != null)
			return load(pool, id, case_old_db);
		else {
			try {
				// 3. Prova ad interpretare la stringa come un url associato ad un documento
				return fromURL(pool, docString, case_old_db);
			}catch (Exception e3) {
				throw new IllegalArgumentException("Impossibile caricare un documento a partire dalla stringa: " + docString);				
			}
		}	
	}
	
	public static DocumentoWeb<?> fromURL(DBConnectPool pool, URLWrapper wrapper){
		return fromURL(pool, wrapper.getPercorsoWeb(false));
	}
	public static DocumentoWeb<?> fromURL(DBConnectPool pool, String url){
		return fromURL(pool, url, null);
	}
	public static DocumentoWeb<?> fromURL(DBConnectPool pool, String url, Boolean b_case_old_db){
		List<DocumentoWeb<?>> documentiPapabili=fromQuery(pool, "select d.* from " + (b_case_old_db!=null && b_case_old_db ? AbstractDocumentoWeb.NAME_TABLE_OLD : AbstractDocumentoWeb.NAME_TABLE) + " d where alias='" + url + "'");
		if (documentiPapabili.size() == 1)
			return documentiPapabili.get(0);
		else
			throw new IllegalArgumentException("Impossibile trovare un documento unico (trovati " + documentiPapabili.size() + ") associato all'URL=" + url + (b_case_old_db!=null && b_case_old_db ? " caso portalowner_old" : ""));
	}
	
	public static List<DocumentoWeb<?>> fromQuery(DBConnectPool pool, String query){
		return fromQuery(pool, query, null);
	}
	
	public static List<DocumentoWeb<?>> fromQuery(DBConnectPool pool, String query, Boolean b_case_old_db){
		List<CounterRecord> recordDocumenti=Record.loadEntitiesFromQuery(query, pool, CounterRecord.class, b_case_old_db!=null && b_case_old_db ? AbstractDocumentoWeb.NAME_TABLE_OLD : AbstractDocumentoWeb.NAME_TABLE);
		
		return castAll(recordDocumenti);
	}
	

	public static DocumentoWeb<?> load(DBConnectPool pool, Long id){
		return load(pool, id, null);
	}
	
	public static DocumentoWeb<?> load(DBConnectPool pool, Long id, Boolean b_case_old_db){
		DocumentoWeb<?> documento=null;
		Record rDoc=null;
		try {
			rDoc=new Record(b_case_old_db!=null && b_case_old_db ? AbstractDocumentoWeb.NAME_TABLE_OLD : AbstractDocumentoWeb.NAME_TABLE, pool);
			rDoc.setField("id_documento_web", id);
			if (!rDoc.load())
				rDoc=null;
		}catch (Exception e) {
			e.printStackTrace();
			rDoc=null;
		}
		
		if (rDoc != null) {
			documento = cast(rDoc, b_case_old_db);
		}
			
		if (documento==null)
			throw new IllegalArgumentException("Impossibile creare oggetto con ID=" + id);
		
		return documento;
	}
	
	public static DocumentoWeb<?> load(DBConnectPool pool, TipoSistema t, Long id){
		AbstractDocumentoWeb<?> d = (AbstractDocumentoWeb<?>)create(pool, t, null);
		d.id_documento_web=id;
		try{	
			d.load();
		}catch(NullPointerException e){
			throw new IllegalArgumentException(e.getMessage());
		}
	
		return d;
	}
	
	public static List<DocumentoWeb<?>> loadAll(DBConnectPool pool, TipoDocumento tipiDocumento){
		return loadAll(pool, tipiDocumento, null, true, true, false, null, null);
	}
	public static List<DocumentoWeb<?>> loadAll(DBConnectPool pool, TipoDocumento tipiDocumento, Visibilita visibilita){
		return loadAll(pool, tipiDocumento, null, true, true, false, visibilita, null);
	}
	public static List<DocumentoWeb<?>> loadAll(DBConnectPool pool, TipoDocumento tipiDocumento, TipoSistema tipiSistema, Boolean validati, Boolean pubblicati, Boolean scaduti){
		return loadAll(pool, tipiDocumento, tipiSistema, validati, pubblicati, scaduti, null, null);
	}
	public static List<DocumentoWeb<?>> loadAll(DBConnectPool pool, TipoDocumento tipiDocumento, TipoSistema tipiSistema, Boolean validati, Boolean pubblicati, Boolean scaduti, Visibilita visibilita){
		return loadAll(pool, tipiDocumento, tipiSistema, validati, pubblicati, scaduti, visibilita, null);
	}
	public static List<DocumentoWeb<?>> loadAll(DBConnectPool pool, TipoDocumento tipiDocumento, TipoSistema tipiSistema, Boolean validati, Boolean pubblicati, Boolean scaduti, Visibilita visibilita, Map<String, Object> altriParametri) {
		
		String listaIDTipiDoc="";
		if (tipiDocumento!=null) {
			List<TipoDocumento> tipiDaRicercare=tipiDocumento.getEstensioni();
			if (tipiDaRicercare.size() == 0)
				tipiDaRicercare = Arrays.asList(tipiDocumento);
			
			for (TipoDocumento tf: tipiDaRicercare)
				listaIDTipiDoc += ((!listaIDTipiDoc.equals("") ? ", " : "") + tf.getId());
		}
		
		String titolo=null, username_proprietario=null;
		Priorita priorita=null;
		if (altriParametri != null) {
			titolo = (String)altriParametri.get("titolo");
			username_proprietario = (String)altriParametri.get("username_proprietario");
			priorita = (Priorita)altriParametri.get("priorita");
		}
		
		Logger.write(priorita);
		String queryFigli = ""+
				"	SELECT "
				+ "		d.* "
				+ "	FROM "
				+ "		" + AbstractDocumentoWeb.NAME_TABLE + " d"
				+ "	WHERE "
				+ " 	true"
				+ (tipiDocumento!=null ? 
					"	AND d.id_tipo_documento_web in (" + listaIDTipiDoc + ")" : "" )
				+ (tipiSistema!=null ? 
					"	AND d.id_tipo_sistema=" + tipiSistema.getId() : "" )
				+ (validati!=null ? 
					"	AND " + (validati ? "" : "not ") + "d.validato" : "" )
				+ (pubblicati!=null ? 
					"	AND d.data_pubblicazione " + (pubblicati ? "<=" : ">") + " current_date": "" )
				+ (scaduti!=null ? 
					"	AND d.data_scadenza " + (scaduti ? "<" : ">=") + " current_date": "" )
				+ (titolo!=null && !(titolo.trim().equals("")) ? 
						"	AND (d.id_documento_web::text = '" + StringUtils.doubleQuotes(titolo) + "' or d.titolo ilike '%" + StringUtils.doubleQuotes(titolo) + "%')" : "")
				+ (username_proprietario!=null && !username_proprietario.trim().equals("") ?
						" AND id_proprietario in (select id_utente from " + Utente.NAME_TABLE  + " where username ilike '%" + username_proprietario + "%' ) " : "")
				+ (visibilita!=null ? 
						(visibilita==Visibilita.NON_VISIBILE ?
								"	AND d.punteggio = " + visibilita.getValore() :
								"	AND d.punteggio between " + visibilita.getValore() + " and "+ Visibilita.VISIBILE_HOME_PAGE.getValore())
						: "")
				+ (priorita!=null ? 
						"	AND d.priorita=" + priorita.getValore() : "" );
		Logger.write(queryFigli);
		List<DocumentoWeb<?>> documenti = fromQuery(pool, queryFigli);
		TreeSet<DocumentoWeb<?>> documentiOrdinati=new TreeSet<DocumentoWeb<?>>(documenti);
		
		return new ArrayList<DocumentoWeb<?>>(documentiOrdinati);
	}
	
	public static List<DocumentoWeb<?>> castAll(List<? extends Record> documenti){
		return castAll(documenti, null);
	}
	
	public static List<DocumentoWeb<?>> castAll(List<? extends Record> documenti, Boolean case_old_db_b){
		List<DocumentoWeb<?>> listaCastati=new ArrayList<DocumentoWeb<?>>();
		try {
			for (Record d: documenti) {
				listaCastati.add(cast(d, case_old_db_b));
			}
		}catch(Exception e) {
			e.printStackTrace();
			Logger.write("A causa dell'erorre precedente svuotata lista castati");
			listaCastati=new ArrayList<DocumentoWeb<?>>();
		}
		return listaCastati;
	}
	
	public static DocumentoWeb<?> cast(Record documento){
		return cast(documento, null);
	}
	
	public static DocumentoWeb<?> cast(Record documento, Boolean case_old_db_b){
		DocumentoWeb<?> docCasted=null;
		TipoDocumento tipoDocumentoCast=null;
		try {
			Long id_tipo_documento=(Long)documento.getField("id_tipo_documento_web").getValue();
			tipoDocumentoCast = TipoDocumento.fromID(id_tipo_documento);
		}catch (Exception e) {
			Logger.write("Impossibile estrarre il TipoDocumento documento dal record in input : " + documento);
		}
		
		if (tipoDocumentoCast != null) {
			Class<? extends DocumentoWeb<?>> classToGenerate=tipoDocumentoCast.getGeneratedClass();
			if (classToGenerate == null) 
				try{
					Long id_tipo_sistema=(Long)documento.getField("id_tipo_sistema").getValue();
					TipoSistema tipoSistemaCast = TipoSistema.fromID(id_tipo_sistema);
					classToGenerate = tipoSistemaCast.getDefaultGeneratedClass();
				}catch (NoSuchFieldException e) {
					Logger.write("Impossibile estrarre il TipoSistema documento dal record in input : " + documento);
				}
			
			try{
				docCasted = (classToGenerate.isInstance(documento) ? 
						(DocumentoWeb<?>)documento :
						classToGenerate.getConstructor(Record.class).newInstance(documento)
				);
				docCasted.setCaseOldDB(case_old_db_b);
			}catch (Exception e) {
				Logger.write("Impossibile trasformare " + documento + " in " + classToGenerate + " (vedi stack seguente)");
				e.printStackTrace();
			}
		}
		
		if (docCasted==null)
			throw new ClassCastException("Trying to convert " + documento);
		
		return docCasted;
	}
	
	@SuppressWarnings("unchecked")
	public static <R extends DocumentoWeb<?>> List<R> getAll(List<DocumentoWeb<?>> documenti, Class<R> type){
		List<R> documentiOfType=new ArrayList<R>();
		for (DocumentoWeb<?> documento: documenti)
			if (type.isInstance(documento))
				documentiOfType.add((R)documento);
		
		return documentiOfType;
	}
	
	public static List<?> exportField(Collection<DocumentoWeb<?>> documents, String nameField){
		List<Object> exportField=null;
		if (documents != null) {
			exportField=new ArrayList<Object>();
			for (DocumentoWeb<?> d: documents)
				try {
					exportField.add(((AbstractDocumentoWeb<?>)d).getField(nameField).getValue());
				} catch (NoSuchFieldException e) {
					Logger.write("L'errore seguente si genera solo se il campo fornito in input non è presente nel documento: " + d);
					e.printStackTrace();
				}
		}
		return exportField;
	}
	
	public static void main(String[] args){
		it.cise.db.jdbc.DBConnectPool connPostgres=new it.cise.db.jdbc.DBConnectPool(new it.cise.db.database.PostgreSQLDatabase("dbportal_cdc"),new it.cise.db.user.Postgres(), 5, 15, 1);
		
		Map<String, Object> altriParametri=new HashMap<String, Object>();
		altriParametri.put("priorita", Priorita.MASSIMA);
		DocumentFactory.loadAll(connPostgres, null, null, true, true, false, null, altriParametri);
		
	}
	
}
