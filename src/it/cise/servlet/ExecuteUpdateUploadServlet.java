package it.cise.servlet;

import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.commons.fileupload.FileItem;

import java.io.*;
import java.nio.charset.*;
import java.util.*;

import it.cise.db.*;
import it.cise.db.jdbc.*;
import it.cise.sql.PreviewQuery;
import it.cise.util.http.MultipartHttpServletRequest;
import cise.utils.*;


/******************************************************************************
 *	Servlet per l'inserimento, la modifica, la cancellazione di una tupla 
 *	all'interno di una tabella di un DB eseguita prendendo i dati da
 *	una form con enctype="multipart/form-data" predisposta quindi per l'upload
 *	di file: ne deriva che affinch avvenga l'operazione sul DB deve essere
 *	specificata una cartella di upload. Accetta i seguenti parametri 
 *	(tra parentesi quadre gli opzionali):
 *	 - [poolmanager]: il manager che gestisce il pool di connessioni al DB
 *	 - [connection]: i nomi delle classi per la connessione e l'utente al DB 
 *					separate da un "-".	Il default, in caso non sia specificato
 *					il parametro,  la connessione al portale con utente 
 *					portalowner.
 *					Es. connection=DBPopolazioneDw_server-Sysdba
 *	 - [charset]:   il charset utilizzato			
 *	 - op:			il tipo di operazione da eseguire (tipi validi: U,I,D)
 *	 - table:		la tabella su cui eseguire l'operazione
 *	 - upd:			la cartella di upload
 *	 - [upddel]:	i nomi dei campi di upload (senza prefisso) che devono 
 *					essere svuotati per simulare un'eliminazione del file 
 *					associato: in realtà il file non viene cancellato 
 *					fisicamente dal disco
 *	 - pagefwd:		la pagina a cui si viene reindirizzati al termine della
 *					servlet
 *	 - [condition]:	la condizione di filtro in caso di operazione U o D.
 *	 - i campi interessati nell'operazione: devono essere i nomi dei parametri
 *		(i cui valori sono il valore da attribuire al campo) preceduti dal 
 *		prefisso f_x_ dove x identifica il tipo di dato (n:numerico,d:data,
 *		s:stringa,f:file).
 *		Es. f_n_id_tipo=4
 *
 *	@author Elio Amadori
 *	@version 1.0
 ******************************************************************************/

public abstract class ExecuteUpdateUploadServlet 
	extends HttpServlet{
		
	static final String FIELDS_IDSTRING="f_";
	static final String FIELD_NUMERIC="n_";
	static final String FIELD_DATE="d_";
	static final String FIELD_VARCHAR="s_";
	static final String FIELD_FILE="f_";
	static final String FIELD_BOOLEAN="b_";
	static final String OPERATION_UPDATE="U";
	static final String OPERATION_INSERT="I";
	static final String OPERATION_DELETE="D";
	static final String DEL_FILE_FIELD="upddel";
	static final String DIR_UPLOAD="upd";
	static final String CHARSET="charset";
	
	//private Request uploadRequest;
	private MultipartHttpServletRequest uploadRequest;
	private Hashtable<String, String> uploadedFiles;
	String query=null;
	
/**	Crea una stringa pronta per l'inserimento nel DB per il valore specificato
 *	in input.
 *	@param type		il tipo da utilizzare per la conversione
 *	@param value	il valore da formattare
 *  @param codiceStato 
 *
 *	@return il valore trasformato in stringa per l'inserimento */
	protected abstract String getFormattedValue(String type,String value);

	public String getStringPoolmanager(){
		return "poolmanagerNew";
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		ServletContext application = session.getServletContext();
		
		try{
			// Inizializzazione della request di upload
			/*SmartUpload upObj=new SmartUpload();
			upObj.initialize(config, request, response);
			upObj.upload();
			uploadRequest=upObj.getRequest();*/
			
			uploadRequest=new MultipartHttpServletRequest(request);
			
			String uploadDir=uploadRequest.getParameter(DIR_UPLOAD);
			
			
			// Se  stata indicata una cartella di upload viene avviata l'elaborazione degli altri parametri obbligatori
			if ((uploadDir!=null) && (uploadDir.startsWith("/"))){
			
				// Costruisce il tipo di connessione da utilizzare
				String connType=uploadRequest.getParameter("connection");
				String dbinfo=null;
				String dbuser=null;
				int posMeno=-1;
				if ((connType!=null) && ((posMeno=connType.indexOf('-'))!=-1)){
					dbinfo="it.cise.db.database." + connType.substring(0,posMeno);
					dbuser="it.cise.db.user." + connType.substring(posMeno+1);
				}
		
				// Ricerca la connessione, se esiste, altrimenti la crea
				//DBPoolManager poolman=(DBPoolManager)application.getAttribute("poolmanager");
				String pool = uploadRequest.getParameter(getStringPoolmanager());
				if (pool == null || pool.equals("")){
					pool = getStringPoolmanager();
				}
				DBPoolManager poolman = (DBPoolManager)application.getAttribute(pool);
				
				if (poolman==null){
					poolman=DBPoolManager.getInstance();
					application.setAttribute(getStringPoolmanager(),poolman);
				}
				DBConnectPool conn=null;
				if ((dbinfo!=null) && (dbuser!=null))
					conn=poolman.getPool(dbinfo,dbuser);
				else
					conn=poolman.getPool();
				
				/* Esegue l'operazione */
				boolean execute=false;
				
				String condition=null;
				String pageFwd=null;
		
				// 1. reperisce il tipo
				String operation=uploadRequest.getParameter("op");
				if ((!(operation==null)) && (!operation.trim().equals(""))){
					
					// 2. reperisce le tabelle
					String table=uploadRequest.getParameter("table");
					if (!(table==null)){
						
						// 3. Controllo della sessione
						if (cise.utils.HttpUtils.checkSessionBeans(uploadRequest, session)){
						
							pageFwd=cise.utils.HttpUtils.extractURLFromRequest(uploadRequest, "pagefwd");
							condition=uploadRequest.getParameter("condition");
							
							// 4.1 Salva i file di upload e aggiunge i corrispondenti parametri della request al vettore contenente i campi da salvare...
							if (!uploadDir.endsWith("/"))
								uploadDir += "/";
							Logger.write("Uploading in directory: " + uploadDir);
							
							// INIT: Esegue il salvataggio... con pacchetto upload di apache
							// 1. crea la directory di salavtaggio
							String pathDir=uploadDir;
							java.io.File dir =  new java.io.File(application.getRealPath(pathDir));
							if (!dir.exists())
								dir.mkdir();
							
							// 2. identifica i nomi dei file cos� come li dovr� salvare su disco
							Vector<String> fld=new Vector<String>();
							uploadedFiles=new Hashtable<String, String>();
							
							List<FileItem> items=(List<FileItem>)uploadRequest.getItems();
							for (FileItem f: items){
								if (!f.isFormField()){
									boolean inseritoFile=((f.getName()!=null) && !f.getName().equals(""));
									if (inseritoFile){
										
										String nameFile=null;
										if (operation.equals(OPERATION_UPDATE)){
											PreviewQuery pagerFU=new PreviewQuery(conn);
											String dbFieldName = f.getFieldName().substring(4);
											pagerFU.setPreview("select " + dbFieldName + " as fieldfile from " + table + " where " + condition);
											if (pagerFU.getNumberRecords()==1 && !pagerFU.getField("fieldfile").equals("")){
												int posLastSlash = pagerFU.getField("fieldfile").lastIndexOf("/");
												Logger.write("posLastSlash: " + posLastSlash);
												//int posLastUnderscore = pagerFU.getField("fieldfile").lastIndexOf("_", posLastSlash);
												int posLastUnderscore = (pagerFU.getField("fieldfile").substring(posLastSlash+1)).lastIndexOf("_");
												Logger.write("posLastUnderscore: " + posLastUnderscore);
												if(posLastUnderscore==-1){
													posLastUnderscore = pagerFU.getField("fieldfile").lastIndexOf(".");
												}
												Logger.write("posLastUnderscore: " + posLastUnderscore);
												Logger.write("pagerFU.getField(\"fieldfile\"): " + pagerFU.getField("fieldfile"));
												nameFile = pagerFU.getField("fieldfile").substring(posLastSlash+1, posLastSlash+1+posLastUnderscore);
												Logger.write("nameFile: " + nameFile);
											}
										}
										
										if (nameFile==null)
											nameFile = f.getFieldName() + "_" + StringUtils.randomString(20);
										
										String estensione = (f.getName().lastIndexOf(".") != -1 ? f.getName().substring(f.getName().lastIndexOf(".")) : "");
										Logger.write("****dir: " + dir);
										Logger.write("****nameFile: " + nameFile);
										Logger.write("****estensione: " + estensione);
										String pathFileRelative=pathDir + MultipartHttpServletRequest.versionName(dir, nameFile + estensione);
										
										fld.add(f.getFieldName());
										Logger.write("putting " + f.getFieldName() + " in " +  pathFileRelative);
										uploadedFiles.put(f.getFieldName(), pathFileRelative);
									}
								}
							}
							// 3. esegue l'upload
							uploadRequest.saveFiles(uploadedFiles);
							
							
							// FINE: Esegue il salvataggio... con pacchetto upload di apache
							
							//4.2 ...ed elimina le associazioni con i file per i campi upload da resettare
							String[] fldUpdToReset=uploadRequest.getParameterValues(DEL_FILE_FIELD);
							if (fldUpdToReset!=null){
								for (int i=0; i<fldUpdToReset.length; i++){
									String fldResetting=FIELDS_IDSTRING + FIELD_FILE + fldUpdToReset[i];
									if (!fld.contains(fldResetting))
											fld.add(fldResetting);
									uploadedFiles.put(fldResetting, "");	// Se il campo era già stato inserito nella Hashtable al passo precedente, allora deve essere sovrascritto
									Logger.write(this, "upload reset for field " + fldResetting);
								}
								Logger.write(this, "resetted " + fldUpdToReset.length + " upload file.");
							}
	
							// 5. Aggiorna il vettore dei campi da salvare con i parametri della request specificati come campi
							String name=null;
							for (Enumeration<String> fldNames=(Enumeration<String>)uploadRequest.getParameterNames();fldNames.hasMoreElements();){
								name=(String)fldNames.nextElement();
								if (name.startsWith(FIELDS_IDSTRING))
									fld.add(name);
							}
			
							// 6. Crea una stringa contenente la query che rappresenta l'operazione richiesta
							if (operation.equals(OPERATION_INSERT)){
								execute=true;
								String listFields="",listValues="";
								StringBuffer currFieldName=new StringBuffer(),currFieldValue=new StringBuffer();
								
								for (int i=0;i<fld.size();i++){
									extractFieldAndValue((String)fld.get(i), currFieldName, currFieldValue);
									listFields+=(((i==0) ? "" : ",") + currFieldName);
									listValues+=(((i==0) ? "" : ",") + currFieldValue);
								}
								query="INSERT INTO " + table + "(" + listFields + ") VALUES (" + listValues + ")";
							}else if (operation.equals(OPERATION_UPDATE)){
								execute=true;
								
								String listAssignements="";
								StringBuffer currFieldName=new StringBuffer(),currFieldValue=new StringBuffer();
								
								for (int i=0;i<fld.size();i++){
									extractFieldAndValue((String)fld.get(i), currFieldName, currFieldValue);
									listAssignements+=(((i==0) ? "" : ", ") + (currFieldName + "=" + currFieldValue));
								}
			
								query="UPDATE " + table + " SET " +  listAssignements;
							}else if (operation.equals(OPERATION_DELETE)){
								execute=true;
								query="DELETE FROM " + table ;
							}else
								Logger.write(this,"operazione sconosciuta" + operation);
						}else{
							pageFwd=cise.utils.HttpUtils.extractURLFromRequest(request, "chkfailed");
							if (pageFwd==null)
								pageFwd=cise.utils.HttpUtils.extractURLFromRequest(request, "pagefwd");
						}
					}
				}
		
				// 7. Esegue la query generata
				if (execute){
		
					if (condition!=null)
						query+=(" WHERE " + condition);
					//Logger.write(this,">> " + operation + " - " + query);
					
					// Esegue la query
					/*try{
						conn.getStatement().executeUpdate(query);		
					}catch(Exception e){
						e.printStackTrace();
						Logger.write(this,"query errata in insert/update:\n" + query);
					}*/
					SQLTransactionManager sqlMan=new SQLTransactionManager(this, conn);
					sqlMan.executeCommandQuery(query);
				}
		
				response.sendRedirect(pageFwd);

			}else{
				Logger.write(this, "Non é stata specificata una cartella di upload (" + uploadDir + "): processo interrotto");
				response.sendRedirect("/");
			}
			
		}catch(Exception e){
			e.printStackTrace();
			Logger.write(this, "Processo di upload fallito");
			Logger.write(this, "Query probabilmente errata: " + query);
			response.sendRedirect("/");
		}
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {

			//doPost(request,response);
			String pageFwd=cise.utils.HttpUtils.extractURLFromRequest(request, "pagefwd");
			if (pageFwd==null)
				pageFwd="/";
			
			response.sendRedirect(pageFwd);
	}
	
	
	/* Metodi privati */
/** Converte le stringhe in input in base al Charset di riferimento 
 *	@param testo	stringa da codificare
 *	@param charset	il charset di codifica della stringa, se nullo indica di 
 *					utilizzare il charset di default*/
	private static String getStringValue(String testo, Charset charset){
		String testoInCodifica=null;
		
		Logger.write("Charset passato a getStringValue: "+charset.displayName());
		Logger.write("Stringa passata a getStringValue: "+testo);
		
		if (charset==null || charset.equals("")){
			testoInCodifica=testo;
		}else{
			Logger.write("Stringa prima in getStringValue: "+testo);
			testoInCodifica=new String(testo.getBytes(charset));
			Logger.write("Stringa dopo in getStringValue: "+testoInCodifica);
		}
		
		return testoInCodifica;
	}
	
/**	Crea una stringa pronta per l'inserimento nel DB per il valore specificato
 *	in input: se il campo  di tipo file preleva il corretto valore del campo
 *	dall'oggetto upload (il percorso del file uploadato).
 *	@param reqField		il campo da ricercare nella request
 *	@param dbFieldName	il campo del DB associato al parametro della request
 *	@param dbFieldValue	il valore del campo pronto per l'inserimento nel DB */
	private void extractFieldAndValue(String reqField,StringBuffer dbFieldName,StringBuffer dbFieldValue){
		
		String typeCurr=null;
		Charset charset = null;
		
		if (uploadRequest.getParameter(CHARSET) != null && !uploadRequest.getParameter(CHARSET).equals("")){
			charset=Charset.forName(uploadRequest.getParameter(CHARSET));
		}
		
		Logger.write("Charset DEFAULT: "+Charset.defaultCharset().displayName());
		//Logger.write("Charset passato: "+charset.displayName());
		
		dbFieldName.delete(0,dbFieldName.length());
		dbFieldValue.delete(0,dbFieldValue.length());
		
		typeCurr=reqField.substring(2,4);
		
		String value=null;
		
		if (typeCurr.equals(FIELD_FILE)){
			value=(String)uploadedFiles.get(reqField);
			typeCurr=FIELD_VARCHAR;	// Dal momento che nel DB viene salvato il percorso del file, la corretta scrittura del campo diviene la corretta scrittura do una stringa
		}else{
			Logger.write("Field prima: "+uploadRequest.getParameter(reqField));
			//value=getStringValue(uploadRequest.getParameter(reqField), charset);
			value=uploadRequest.getParameter(reqField);
			Logger.write("Field dopo: "+value);
		}
	
		dbFieldName.append(reqField.substring(4));
		dbFieldValue.append(getFormattedValue(typeCurr, value));
		//Logger.write(this,typeCurr + " : " + dbFieldName + "=" + dbFieldValue);
	}
	
	public static void main(String[] args){
		System.out.println("defaultcharset: " + Charset.defaultCharset().displayName());

		String testo="abcdìèòàù";
		
		Charset iso=Charset.forName("ISO-8859-1");
		Charset utf8=Charset.forName("UTF-8");
		Charset n=null;
		
		System.out.println("charset: " + iso.displayName());
		
		String testoISO=new String(testo.getBytes(), iso);
		System.out.println("testo in iso: " + getStringValue(testo, iso));
		System.out.println("testo in utf8: " + getStringValue(testo, utf8));
//		System.out.println("testo in n: " + getStringValue(testo, n));
		
		/*CharsetDecoder decoder = Charset.defaultCharset().newDecoder();
		CharsetEncoder encoder = utf8.newEncoder(); 
		try { 
			// Convert a string to ISO-LATIN-1 bytes in a ByteBuffer 
			// The new ByteBuffer is ready to be read. 
			ByteBuffer bbuf = encoder.encode(CharBuffer.wrap(testo)); 
			// Convert ISO-LATIN-1 bytes in a ByteBuffer to a character ByteBuffer and then to a string. 
			// The new ByteBuffer is ready to be read. 
			CharBuffer cbuf = decoder.decode(bbuf); 
			String testoUTF8=cbuf.toString();
			System.out.println("utf8: " + testoUTF8);
			
		} catch (CharacterCodingException e) {  e.printStackTrace(); } */
	
	}
}