package it.cise.servlet;

import javax.servlet.*;
import javax.servlet.http.*;

import java.io.*;
import java.util.*;

import it.cise.db.SQLTransactionManager;
import it.cise.db.jdbc.*;
import cise.utils.*;


/******************************************************************************
 *	Servlet per l'inserimento, la modifica, la cancellazione di una tupla 
 *	all'interno di una tabella di un DB Oracle. Accetta i seguenti parametri 
 *	(tra parentesi quadre gli opzionali):
 *	 - [connection]:i nomi delle classi per la connessione e l'utente al DB 
 *					separate da un "-".	Il default, in caso non sia specificato
 *					il parametro, � la connessione al portale con utente 
 *					portalowner.
 *					Es. connection=DBPopolazioneDw_server-Sysdba
 *
 *	 - op:			il tipo di operazione da eseguire (tipi validi: U,I,D)
 *	 - table:		la tabella su cui eseguire l'operazione
 *	 - pagefwd:		la pagina a cui si viene reindirizzati al termine della
 *					servlet
 *	 - [pagefwderr]:la pagina a cui si viene reindirizzati al termine della
 *					servlet se la query genera un errore (nel caso non sia 
 *					passato il parametro viene utilizzato il parametro pagefwd)
 *	 - [condition]:	la condizione di filtro in caso di operazione U o D.
 *	 - i campi interessati nell'operazione: devono essere i nomi dei parametri
 *		(i cui valori sono il valore da attribuire al campo) preceduti dal 
 *		prefisso f_x_ dove x identifica il tipo di dato (n:numerico,d:data,
 *		s:stringa).
 *		Es. f_n_id_tipo=4
 *
 *	@author Elio Amadori
 *	@version 1.0
 ******************************************************************************/

public abstract class ExecuteUpdateServlet 
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
		return "poolmanagerNew";
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
		boolean queryEseguita=false;
		String query=null;
		String condition=null;
		String pageFwd=null;
		String pageFwdErr=null;

		// 1. reperisce il tipo
		String operation=request.getParameter("op");
		if ((!(operation==null)) && (!operation.trim().equals(""))){
	
			// 2. reperisce le tabelle
			String table=request.getParameter("table");
			if (!(table==null)){
	
				// 3. Controllo della sessione
				if (cise.utils.HttpUtils.checkSessionBeans(request, session)){
	
					pageFwd=cise.utils.HttpUtils.extractURLFromRequest(request, "pagefwd");
					pageFwdErr=cise.utils.HttpUtils.extractURLFromRequest(request, "pagefwderr");
					if (pageFwdErr == null)
						pageFwdErr = pageFwd;
					
					condition=request.getParameter("condition");
	
					// 4. Crea un vettore con i parametri della request specificati come campi
					Vector fld=new Vector();
					String name=null;
					for (Enumeration fldNames=request.getParameterNames();fldNames.hasMoreElements();){
						name=(String)fldNames.nextElement();
						if (name.startsWith(FIELDS_IDSTRING))
							fld.add(name);
					}
	
					// 5. Crea una stringa contenente la query che rappresenta l'operazione richiesta
					if (operation.equals(OPERATION_INSERT)){
						execute=true;
						String listFields="",listValues="";
						StringBuffer currFieldName=new StringBuffer(),currFieldValue=new StringBuffer();
						
						for (int i=0;i<fld.size();i++){
							extractFieldAndValue(request, (String)fld.get(i), currFieldName, currFieldValue);
							listFields+=(((i==0) ? "" : ",") + currFieldName);
							listValues+=(((i==0) ? "" : ",") + currFieldValue);
						}
						query="INSERT INTO " + table + "(" + listFields + ") VALUES (" + listValues + ")";
					}else if (operation.equals(OPERATION_UPDATE)){
						execute=true;
						
						String listAssignements="";
						StringBuffer currFieldName=new StringBuffer(),currFieldValue=new StringBuffer();
						
						for (int i=0;i<fld.size();i++){
							extractFieldAndValue(request, (String)fld.get(i), currFieldName, currFieldValue);
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
	

		// 6. Esegue la query generata
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
			queryEseguita=sqlMan.executeCommandQuery(query);
			Logger.write(this, "Query comando (" + (queryEseguita ? "ESEGUITA" : "FALLITA") + "): " + query);
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
		dbFieldValue.append(getFormattedValue(typeCurr, request.getParameter(reqField)));
		//Logger.write(this,typeCurr + " : " + dbFieldName + "=" + dbFieldValue);
	}

}
