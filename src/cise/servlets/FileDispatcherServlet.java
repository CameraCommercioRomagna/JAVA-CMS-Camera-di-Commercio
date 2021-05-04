package cise.servlets;

import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.io.*;

import cise.db.jdbc.*;
import cise.utils.*;
import cise.portale.auth.*;
import cise.portale.generali.*;



/******************************************************************
 *	
 *	Servlet per la trasmissione protetta e controllata di file, il cui URL 
 *	� salvato in una tabella del DB. 
 *	
 *	PROTETTA PERCHE':
 * 	Trasmette il file in modo da non visualizzarne il percorso in cui � 
 *	salvato fisicamente; l'operazione viene eseguita se l'espensione del file �
 *	appartenente ad uno dei mime-type ammessi nella configurazione della servlet.
 *	CONTROLLATA PERCHE':
 *	Il trasferimento del file viene consentito solo agli utenti loggati
 *	(viene salvata nel log l'associazione utente file scaricato) e che sono 
 *	acceduti al download tramite una pagina che inserisce in sessione un
 *	particolare token.
 *	
 *	Parametri passati nella request:
 *	 - ID			valore dell'identificatore del download
 *	 - [CID]		nome del campo identificatore del download
 *	 - [pack]		il servizio a cui � associato l'ID: determina la classe
 *					da utilizzare per reperire l'URL del file: per poter essere
 *					utilizzata la classe deve implementare l'interfaccia
 *					cise.portale.generali.FileDownload
 *
 *					Es. http://...?...&pack=download
 *						=> f(download)=cise.portale.template.Download
 *						utilizza la classe cise.portale.etica.Download
 *					
 *					L'elenco dei servizi disponibili � specificato nei parametri
 *					di init della servlet. Nel caso in cui questo parametro 
 *					non sia specificato, viene utilizzato il servizio "download"
 *	 - [connection]	la connessione al DB da utilizzare
 *	
 *	Ritorna il file o in caso di errore redirige l'output verso una pagina
 *	HTML di errore del sito (PAGINA SCADUTA)
 *
 *	@see	cise.portale.generali.FileDownload
 *	@author	Elio Amadori
 *	@version 1.1
 *											
 ******************************************************************/
 
public class FileDispatcherServlet extends HttpServlet{
		
	private ServletConfig config;
	private Hashtable validExtensions;
	private Hashtable classDownload;
	
	final public void init(ServletConfig config)
		throws ServletException {
		
		this.config = config;
		
		// Carica le estensioni ammesse per il download
		validExtensions=new Hashtable();
		classDownload=new Hashtable();

		final String parExtStartStr="extension - ";
		final String parClassStartStr="class - ";
		
		for (Enumeration e=config.getInitParameterNames();e.hasMoreElements();){
			String namePar=(String)e.nextElement();
			
			if (namePar.startsWith(parExtStartStr))
				validExtensions.put(namePar.substring(parExtStartStr.length()), config.getInitParameter(namePar));
			if (namePar.startsWith(parClassStartStr))
				classDownload.put(namePar.substring(parClassStartStr.length()), config.getInitParameter(namePar));
		}
	}
		
	public void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
	
		HttpSession session=request.getSession();
		ServletContext application = session.getServletContext();
		
		try{
			// Traccia l'utente che tenta il download
			User user=(User)session.getAttribute("user");
			if (user!=null){
				// Determina il package da cui prelevare la classe Download
				String service=request.getParameter("pack");
				String className=null;
				if (service==null){
					className=(String)classDownload.get("download");
				}else{
					className=(String)classDownload.get(service);
					if (className==null)
						throw new Exception("Specificato ambiente non valido per il download: " + service);
				}
				Logger.write(this, "Download protetto => USER = " + user.getID_Utente() + "(" + user.getIdentita() + ") service=" + service + "/" + className);
				
				String token=(String)session.getAttribute("tokenDownload");
				if ((token!=null) && (token.equals("download_file"))){
				
					session.removeAttribute("tokenDownload");
					
					boolean oldVersionClasses=((request.getParameter("ver")==null) || (request.getParameter("ver").equals("old")));
					
					String connType=request.getParameter("connection");
					String dbinfo=null;
					String dbuser=null;
					int posMeno=-1;
					if ((connType!=null) && ((posMeno=connType.indexOf('-'))!=-1)){
						dbinfo=connType.substring(0,posMeno);
						dbuser=connType.substring(posMeno+1);
					}

					// Reperisce le informazioni sul file...
					boolean existDownload;
					String urlFromClass;
					
					if (oldVersionClasses){	
						// ...CON LE VECCHIE CLASSI
						
						long idDownload=Long.parseLong(request.getParameter("ID"));
						Logger.write(this, "Download protetto => USER = " + user.getID_Utente() + "(" + user.getIdentita() + ") service=" + service + "/" + className + " - id=" + idDownload);
						
						// Ricerca la connessione, se esiste, altrimenti la crea
						DBPoolManager poolman=(DBPoolManager)application.getAttribute("poolmanager");
						if (poolman==null){
							poolman=DBPoolManager.getInstance();
							application.setAttribute("poolmanager",poolman);
						}
						DBConnectPool conn=null;
						if ((dbinfo!=null) && (dbuser!=null))
							conn=poolman.getPool("cise.db.jdbc.information." + dbinfo, "cise.db.jdbc.user." + dbuser);
						else
							conn=poolman.getPool();
						
						// Reperisce le informazioni sul file
						Class classDownload=Class.forName(className);
						DBTable d = (DBTable)classDownload.newInstance();
						d.initialize(conn);
						d.Load(idDownload);
						
						existDownload=d.isInserted();
						urlFromClass=((FileDownload)d).getUrl_file();
					}else{
						// ...CON LE NUOVE CLASSI
						String tableName=className;
						String[] fieldKey=request.getParameterValues("fkey");
						String fieldUrl=request.getParameter("furl");
						Logger.write(this, "Download protetto => USER = " + user.getID_Utente() + "(" + user.getIdentita() + ") service=" + service + "/" + className + " - " + (new Vector()).add(fieldKey));
					
						it.cise.db.jdbc.DBPoolManager poolmanNew=(it.cise.db.jdbc.DBPoolManager)application.getAttribute("poolmanagerNew");
						if (poolmanNew==null){
							poolmanNew=it.cise.db.jdbc.DBPoolManager.getInstance();
							application.setAttribute("poolmanagerNew",poolmanNew);
						}
						it.cise.db.jdbc.DBConnectPool connNew=null;
						if ((dbinfo!=null) && (dbuser!=null))
							connNew=poolmanNew.getPool("it.cise.db.database." + dbinfo, "it.cise.db.user." + dbuser);
						else
							connNew=poolmanNew.getPool("it.cise.db.database.DBPortal", "it.cise.db.user.Portalowner");
						
						// Reperisce le informazioni sul file
						it.cise.db.Record r = new it.cise.db.Record(tableName, connNew);
						String nomeParID=null;
						try{
							for (String fk: fieldKey){
								nomeParID=fk;
								r.setField(nomeParID, request.getParameter(nomeParID));
							}
						}catch(NoSuchFieldException nsfe){
							nsfe.printStackTrace();
							Logger.write(this, "Impossibile inizializzare il download " + r + " con campo chiave " + nomeParID);
						}
						r.load();

						existDownload=r.isInserted();
						urlFromClass="";
						try{
							urlFromClass=(String)r.getField(fieldUrl).getValue();
						}catch(NoSuchFieldException nsfe){
							nsfe.printStackTrace();
							Logger.write(this, "Impossibile reperire il campo url " + fieldUrl + " nel download " + r);
						}
					}
					
					String path=application.getRealPath(urlFromClass);
					if (existDownload && (path!=null) && (!path.trim().equals(""))){
						String estensione=path.substring(path.lastIndexOf(".") + 1);
						String mimeType=null;
						if ((estensione!=null) && (!estensione.trim().equals("")) && ((mimeType=(String)validExtensions.get(estensione.toLowerCase()))!=null)){
							// Trasferimento del file
							response.setContentType(mimeType);
							
							BufferedInputStream fis=new BufferedInputStream(new FileInputStream(path));
							BufferedOutputStream fos=new BufferedOutputStream(response.getOutputStream());
							
							final int LBUF=1024;
							byte[] b=new byte[LBUF];
							int nc=0;
							while ((nc=fis.read(b, 0, LBUF))!=-1)
								fos.write(b, 0, nc);
							
							fos.flush();
							fis.close();
						}else
							throw new Exception("Estensione non valida: " + mimeType);
					}else
						throw new Exception("File non valido");
				}else
					throw new Exception("Token per il download non valido in sessione: " + token);
			}else
				throw new Exception("Download protetto tentato da utente non (pi�) loggato");
				
		}catch(Exception e){
			// Reindirizzamento alla pagina di errore
			e.printStackTrace();
			response.sendRedirect("/common/htm/scaduta.htm");
		}
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
			doPost(request,response);
	}
}