package it.cise.servlet;

import javax.servlet.*;
import javax.servlet.http.*;

import java.io.*;
import java.util.*;
import java.math.*;
import java.sql.*;

import it.cise.db.jdbc.*;
import cise.utils.*;


/******************************************************************************
 *	Servlet per l'inserimento o la modifica di pi� tuple all'interno di una 
 *	tabella di un DB. Questa classe � astratta perch� la
 *	stringa con cui rappresentare un tipo di dato deve essere definita 
 *	esplicitamente per ogni tipologia di DB (Oracle, Interbase, ...).
 *	
 *	NB. Se specificato, la servlet esegue il controllo dello stato degli oggetti
 *		di sessione indicati in input, passando come valori di confronto i dati
 *		contenuti in alcuni parametri: tali oggetti devono implementare 
 *		l'interfaccia cise.beans.CheckableBean.
 *
 *	Accetta i seguenti parametri (tra parentesi quadre gli opzionali):
 *	 - [connection]:i nomi delle classi per la connessione e l'utente al DB 
 *					separate da un "-".	Il default, in caso non sia specificato
 *					il parametro, � la connessione al portale con utente 
 *					portalowner.
 *					Es. connection=DBPopolazioneDw_server-Sysdba
 *
 *	 - op:			il tipo di operazione da eseguire (tipi validi: U,I)
 *	 - table:		la tabella su cui eseguire l'operazione
 *	 - pagefwd:		la pagina a cui si viene reindirizzati al termine della
 *					servlet
 *	 - [pagefwderr]:la pagina a cui si viene reindirizzati al termine della
 *					servlet se la query genera un errore (nel caso non sia 
 *					passato il parametro viene utilizzato il parametro pagefwd)
 *	 - [condition]:	la condizione di filtro in caso di operazione U.
 *	 - i campi interessati nell'operazione: devono essere i nomi dei parametri
 *		(i cui valori sono il valore da attribuire al campo) preceduti dal 
 *		prefisso f_x_ dove x identifica il tipo di dato (n:numerico,d:data,
 *		s:stringa). Inoltre i campi si distinguono in 2 tipologie:
 *			1. campi che assumono lo stesso valore per ogni record inserito, per 
 *				cui basta la descrizione precedente;
 *				Es. f_n_id_geografia=4
 *			2. campi dinamici, cio� che assumono valori diversi per ogni record 
 *				inserito; tra questi si distinguono:
 *			2.a i campi chiave, cio� che determinano anche la scelta degli altri
 *				campi dinamici, per cui basta la descrizione precedente;
 *				Es. f_n_id_luogo=4
 *			2.b i campi derivati, cio� quelli che sono da inserire esattamente
 *				nel record indicato dai loro campi chiave; la loro forma si 
 *				ottiene dalla descrizione precedente appendendo il suffisso dato
 *				dai valori dei campi chiave separati da "_".
 *				Es. f_n_IMMIGRATI4=5 (4 � il valore di id_luogo, unico campo 
 *										chiave per immigrati)
 *	 - fld:			elenco dei campi dinamici, cio� tutti i campi descritti al 
 *					punto 2	della sezione precedente, sottoinsime dei nomi di 
 *					campo passati alla servlet e scritti secondo le convezioni 
 *					descritte nella	sezione stessa. 
 *	 - [fld_dep]:	elenco dei campi chiave (punto 2.b della sezione precedente)
 *					sottoinsieme di fld.
 *	 - [chk_on]:	indica la pagina (l'URL) che richiede il controllo 
 *					dei parametri di sessione: OBBLIGATORIO se si intende 
 *					procedere all'analisi dei parametri di sessione
 *	 - [chkobj]:	i nomi con cui sono salvati nella sessione gli oggetti su
 *					cui si vuole eseguire il controllo
 *	 - [chkfailed]:	l'URL della pagina in cui viene rediretta la navigazione se
 *					il check fallisce
 *	 - [I parametri da passare ai vari chkobj(i) del punto precedente. Sono
 *		passati nella forma <valoredi(chkobj(i))>_<nome_parametro>=value.
 *		Es.	...chkobj=pop&chkobj=temp&chkobj=trova&pop_i=1&pop_j=2&temp_x=a
 *		all'oggetto pop vengono passati i=1 e j=2
 *		all'oggetto temp viene passato x=a
 *		all'oggetto trova non viene passato nulla 
 *		]
 *
 *	@see cise.beans.CheckableBean
 *	@author Elio Amadori
 *	@version 1.0
 ******************************************************************************/
 
public abstract class ExecuteMultipleUpdateServlet 
	extends HttpServlet{
		
	static final String FIELDS_IDSTRING="f_";
	static final String FIELD_NUMERIC="n_";
	static final String FIELD_DATE="d_";
	static final String FIELD_VARCHAR="s_";
	static final String FIELD_BOOLEAN="b_";
	static final String OPERATION_UPDATE="U";
	static final String OPERATION_INSERT="I";
	static final String OPERATION_DELETE="D";
	
/**	Crea una stringa pronta per l'inserimento nel DB per il valore specificato
 *	in input.
 *	@param type		il tipo da utilizzare per la conversione
 *	@param value	il valore da formattare
 *
 *	@return il valore trasformato in stringa per l'inserimento */
	protected abstract String getFormattedValue(String type,String value);
	
	public String getStringPoolmanager(){
		return getStringPoolmanager();
	}
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		
		HttpSession session=request.getSession();
		ServletContext application = session.getServletContext();
		
		// Costruisce il tipo di connessione da utilizzare
		String connType=request.getParameter("connection");
		String dbinfo=null;
		String dbuser=null;
		int posMeno=-1;
		if ((connType!=null) && ((posMeno=connType.indexOf('-'))!=-1)){
			dbinfo="it.cise.db.database." + connType.substring(0,posMeno);
			dbuser="it.cise.db.user." + connType.substring(posMeno+1);
		}

		// Ricerca la connessione, se esiste, altrimenti la crea
		DBPoolManager poolman=(DBPoolManager)application.getAttribute(getStringPoolmanager());
		
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
		boolean queryEseguita=true;
		String querySelect=null, queryInsert=null, queryUpdate=null;
		String pageFwd=null;
		String pageFwdErr=null;
		String condition=null;
		String fldsVariables[]=null;
		String fldsType[]=null;
		String fldsDeps[]=null;
		String valuesDepsVariables[][]=null;
		
		// 1. reperisce il tipo
		String operation=request.getParameter("op");
		if ((!(operation==null)) && (!operation.trim().equals(""))){
			
			// 2. reperisce le tabelle
			String table=request.getParameter("table");
			if (!(table==null)){
				
				// 3. Controllo della sessione
				if (cise.utils.HttpUtils.checkSessionBeans(request, session)){
				
					/* TEST: scrive tutti i parametri in input */
					for (Enumeration fnEnum=request.getParameterNames();fnEnum.hasMoreElements();){
						String fname=(String)fnEnum.nextElement();
						String[] fvalues=request.getParameterValues(fname);
						for (int zz=0;zz<fvalues.length;zz++)
							Logger.write("request(" + fname + ") = " + fvalues[zz]);
					}
					/* FINE TEST */
					
					pageFwd=cise.utils.HttpUtils.extractURLFromRequest(request, "pagefwd");
					pageFwdErr=cise.utils.HttpUtils.extractURLFromRequest(request, "pagefwderr");
					if (pageFwdErr == null)
						pageFwdErr = pageFwd;
					condition=request.getParameter("condition");
					
					// 4.1 Inizializza le variabili che andranno a riempire la query dinamicamente:
					//	- fldsVariables : elenco dei campi dinamici
					//	- valuesDepsVariables : elenco dei valori associati ai campi
					//	- fldsType : elenco dei tipi dei campi
					//	- fldsDeps : elenco dei campi da cui dipendono i campi variabili
					fldsVariables=request.getParameterValues("fld");
					fldsType=new String[fldsVariables.length];
					fldsDeps=request.getParameterValues("fld_dep");
					
					valuesDepsVariables=new String[fldsDeps.length][];
					int lengthArrays=-1;
					for (int i=0;i<fldsDeps.length;i++){
						valuesDepsVariables[i]=request.getParameterValues(fldsDeps[i]);
						
						// Controlla che tutti gli array di valori contangano lo stesso numero di elementi
						if (lengthArrays == -1)
							lengthArrays=valuesDepsVariables[i].length;
						else
							if (lengthArrays!=valuesDepsVariables[i].length)
								Logger.write(this,"Un array di valori [" + fldsDeps[i] + "]non ha lo stesso numero di elementi degli altri " + lengthArrays + " a " + valuesDepsVariables[i].length);
					}
					
					// 4.3 Crea un vettore con i parametri della request specificati come campi
					Vector fld=new Vector();
					String name=null;
					for (Enumeration fldNames=request.getParameterNames();fldNames.hasMoreElements();){
						name=(String)fldNames.nextElement();
						if ((name.startsWith(FIELDS_IDSTRING)) && (!StringUtils.startsWith(name,fldsVariables)))
							fld.add(name);
					}
					
					// 5. Crea una stringa contenente la query che rappresenta l'operazione richiesta
					if ((operation.equals(OPERATION_INSERT)) || (operation.equals(OPERATION_UPDATE))){
						execute=true;
						String listFields="",listValues="";
						StringBuffer currFieldName=new StringBuffer(),currFieldValue=new StringBuffer(),currFieldType=new StringBuffer();
						String currField=null;
						
						for (int i=0;i<fld.size();i++){
							currField=(String)fld.get(i);
							extractFieldAndValue(request, currField, currFieldName, currFieldValue);
							listFields+=(((i==0) ? "" : ",") + currFieldName);
							listValues+=(((i==0) ? "" : ",") + currFieldValue);
						}
						for (int i=0;i<fldsVariables.length;i++){
							currField=fldsVariables[i];
							extractFieldAndType(request, currField, currFieldName, currFieldType);
							listFields+=(((listFields.length()==0) ? "" : ",") + currFieldName);
							listValues+=(((listValues.length()==0) ? "" : ",") + "?");
							
							fldsType[i]=new String(currFieldType);
						}
	
						queryInsert = "INSERT INTO " + table + "(" + listFields + ") VALUES (" + listValues + ")";
					}
					
					if (operation.equals(OPERATION_UPDATE)){
						execute=true;
						String listAssignements="",listDeps="";
						StringBuffer currFieldName=new StringBuffer(),currFieldValue=new StringBuffer(),currFieldType=new StringBuffer();
						String currField=null;
						
						for (int i=0;i<fld.size();i++){
							extractFieldAndValue(request, (String)fld.get(i), currFieldName, currFieldValue);
							listDeps+=(((i==0) ? "" : " AND ") + (currFieldName + "=" + currFieldValue));
						}
						for (int i=0;i<fldsDeps.length;i++){
							extractFieldAndValue(request, fldsDeps[i], currFieldName, currFieldValue);
							listDeps+=((((i==0)&&(listDeps.equals(""))) ? "" : " AND ") + (currFieldName + "= ?"));
						}
	
						querySelect = "SELECT * FROM " + table + " WHERE " + listDeps;
	
						for (int i=0;i<fldsVariables.length;i++){
							if ((StringUtils.stringInArray(fldsDeps,fldsVariables[i]))==-1){
								currField=fldsVariables[i];
								extractFieldAndValue(request, currField, currFieldName, currFieldValue);
								listAssignements+=(((i==0) ? "" : ", ") + (currFieldName + " = ?"));
							}
						}
	
						queryUpdate = "UPDATE " + table + " SET " +  listAssignements + " WHERE " + listDeps;
					}
				}else{
					pageFwd=cise.utils.HttpUtils.extractURLFromRequest(request, "chkfailed");
					if (pageFwd==null)
						pageFwd=cise.utils.HttpUtils.extractURLFromRequest(request, "pagefwd");
				}
			}
		}
		
		// 6. Esegue la query generata
		if (execute){
			if (condition!=null){
				if (queryInsert!=null)
					queryInsert+=(" WHERE " + condition);
				if (queryUpdate!=null)
					queryUpdate+=(" WHERE " + condition);
			}

			if (querySelect!=null)
				Logger.write(querySelect);
			if (queryInsert!=null)
				Logger.write(queryInsert);
			if (queryUpdate!=null)
				Logger.write(queryUpdate);
			
			PreparedStatement pStatSelect=null;
			PreparedStatement pStatInsert=null;
			PreparedStatement pStatUpdate=null;

			DBConnect dbConn=conn.get();
			try{
				if (operation.equals(OPERATION_INSERT)){
					pStatInsert=dbConn.getConnection().prepareStatement(queryInsert);
				}else if (operation.equals(OPERATION_UPDATE)){
					pStatSelect=dbConn.getConnection().prepareStatement(querySelect);
					pStatUpdate=dbConn.getConnection().prepareStatement(queryUpdate);
					pStatInsert=dbConn.getConnection().prepareStatement(queryInsert);
				}
				
				String value=null;
				int pos=-1;
				
				for (int j=0;j<valuesDepsVariables[0].length;j++){
					for (int k=0;k<fldsVariables.length;k++){
						// Sostituisce le variabili
						if ((pos=StringUtils.stringInArray(fldsDeps,fldsVariables[k]))!=-1)
							value=valuesDepsVariables[pos][j];
						else{
							String fldMultiDep=fldsVariables[k];
							for (int i=0;i<fldsDeps.length;i++)
								fldMultiDep+=(((i==0) ? "" : "_") + valuesDepsVariables[i][j]);
							value=request.getParameter(fldMultiDep);
						}
						
						System.out.println("Sostituzione : " + fldsVariables[k] + " = " + value);
						
						if (fldsType[k].equals(FIELD_NUMERIC)){	
							if (operation.equals(OPERATION_INSERT)){
								pStatInsert.setBigDecimal(k+1,new BigDecimal(value));
							}else if (operation.equals(OPERATION_UPDATE)){
								if (pos!=-1)
									pStatSelect.setBigDecimal(pos+1,new BigDecimal(value));
								pStatUpdate.setBigDecimal(k+1,new BigDecimal(value));
								pStatInsert.setBigDecimal(k+1,new BigDecimal(value));
							}
						}else if(fldsType[k].equals(FIELD_VARCHAR)){
							if (operation.equals(OPERATION_INSERT)){
								pStatInsert.setString(k+1,value);
							}else if (operation.equals(OPERATION_UPDATE)){
								if (pos!=-1)
									pStatSelect.setString(pos+1,value);
								pStatUpdate.setString(k+1,value);
								pStatInsert.setString(k+1,value);
							}

						}else if (fldsType[k].equals(FIELD_DATE)){
							if (operation.equals(OPERATION_INSERT)){
								pStatInsert.setDate(k+1,new java.sql.Date(DateUtils.stringToDate(value).getTime()));
							}else if (operation.equals(OPERATION_UPDATE)){
								if (pos!=-1)
									pStatSelect.setDate(pos+1,new java.sql.Date(DateUtils.stringToDate(value).getTime()));
								pStatUpdate.setDate(k+1,new java.sql.Date(DateUtils.stringToDate(value).getTime()));
								pStatInsert.setDate(k+1,new java.sql.Date(DateUtils.stringToDate(value).getTime()));
							}
						}else if (fldsType[k].equals(FIELD_BOOLEAN)){
							if (operation.equals(OPERATION_INSERT)){
								pStatInsert.setBoolean(k+1,new Boolean(value));
							}else if (operation.equals(OPERATION_UPDATE)){
								if (pos!=-1)
									pStatSelect.setBoolean(pos+1,new Boolean(value));
								pStatUpdate.setBoolean(k+1,new Boolean(value));
								pStatInsert.setBoolean(k+1,new Boolean(value));
							}
						}else
							Logger.write(this,"Errore di tipo nel sostituire la varibile [" + fldsVariables[j] + "] del PreparedStatement (" + fldsType[j] + ")");
					}
					
					// Esegue l'operazione
					try{
						if (operation.equals(OPERATION_INSERT)){
							pStatInsert.executeQuery();
							
							pStatInsert.clearParameters();
						}else if (operation.equals(OPERATION_UPDATE)){
							ResultSet rst=pStatSelect.executeQuery();
							if (rst.next())
								pStatUpdate.executeUpdate();
							else
								pStatInsert.executeUpdate();

							rst.close();
							
							pStatSelect.clearParameters();
							pStatUpdate.clearParameters();
							pStatInsert.clearParameters();
						}
					}catch(Exception e){
						e.printStackTrace();
						Logger.write("Errore nell'eseguire la serie di update");
						queryEseguita=false;
					}
					
					System.out.println(j + " di " + valuesDepsVariables[0].length);
				}

			}catch(Exception e){
				e.printStackTrace();
				Logger.write(this,"query errata in insert/update:\n");
				queryEseguita=false;
			}
			
			try{
				pStatInsert.close();
				if (operation.equals(OPERATION_UPDATE)){
					pStatSelect.close();
					pStatUpdate.close();
				}
			}catch(SQLException e){
				e.printStackTrace();
				Logger.write(this,"Errore in chiusura statements:\n");
			}

			// Libera la connessione
			try{
				conn.free(dbConn);
			}catch(Exception e){
				e.printStackTrace();
				Logger.write(this, "Impossibile ritornare la connessione al pool -> " + conn);
			}
		}
			
		response.sendRedirect( (queryEseguita ? pageFwd : pageFwdErr) );
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
	private void extractFieldAndType(HttpServletRequest request,String reqField,StringBuffer dbFieldName,StringBuffer dbFieldType){
		dbFieldType.delete(0,dbFieldType.length());
		dbFieldName.delete(0,dbFieldName.length());

		dbFieldType.append(reqField.substring(2,4));
		dbFieldName.append(reqField.substring(4));
	}
	
/**	Crea una stringa pronta per l'inserimento nel DB per il valore specificato
 *	in input.
 *	@param request		la richiesta da cui estrarre le informazioni
 *	@param reqField		il campo da ricercare nella request
 *	@param dbFieldName	il campo del DB associato al parametro della request
 *	@param dbFieldValue	il valore del campo pronto per l'inserimento nel DB */
	private void extractFieldAndValue(HttpServletRequest request,String reqField,StringBuffer dbFieldName,StringBuffer dbFieldValue){
		String typeCurr=null;
		
		dbFieldName.delete(0,dbFieldName.length());
		dbFieldValue.delete(0,dbFieldValue.length());
		
		typeCurr=reqField.substring(2,4);
		dbFieldName.append(reqField.substring(4));
		Logger.write(typeCurr + " - " + reqField + " - " + request.getParameter(reqField));
		dbFieldValue.append(getFormattedValue(typeCurr, request.getParameter(reqField)));
		//Logger.write(this,typeCurr + " : " + dbFieldName + "=" + dbFieldValue);
	}
}
