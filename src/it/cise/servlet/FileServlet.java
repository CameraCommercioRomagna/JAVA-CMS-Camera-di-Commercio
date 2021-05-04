package it.cise.servlet;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.*;

import cise.utils.Logger;
import it.cise.db.Record;
import it.cise.db.jdbc.*;
import it.cise.util.auth.*;
import it.cise.util.dweb.DownlodableObject;


public class FileServlet<T extends Record & DownlodableObject> extends HttpServlet {
	
	private static final long serialVersionUID = 5824878971989867421L;
	
	protected Hashtable<String, String> validExtensions;
	
	final public void init(ServletConfig config)
		throws ServletException {
		
		// Carica le estensioni ammesse per il download
		validExtensions=new Hashtable<String, String>();
	
		final String parExtStartStr="extension - ";
		
		for (Enumeration e=config.getInitParameterNames();e.hasMoreElements();){
			String namePar=(String)e.nextElement();
			
			if (namePar.startsWith(parExtStartStr))
				validExtensions.put(namePar.substring(parExtStartStr.length()), config.getInitParameter(namePar));
		}
	}
	
	
	public String getDBInfo(){
		return "it.cise.db.database.DBPortal";
	}
	
	public String getDBUser(){
		return "it.cise.db.user.Portalowner";
	}
	
	public String getStringPoolmanager(){
		return "poolmanagerNew";
	}
	
	public T getDownload() {
		return null;
	}
	
	public String getParameterPreview(){
		return "PRV_DOC";
	}
	
	public String getParameterPreviewValue(){
		return "yes";
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		
		boolean error=false;
		String messageError="";
		
		//String pageError="http://" + request.getServerName();
		String pageError="/common/htm/scaduta.htm";
		T d=null;
		
		try{
			HttpSession session = request.getSession();
			ServletContext application = session.getServletContext();
			
			// Costruisce il tipo di connessione da utilizzare
			String dbinfo=getDBInfo();
			String dbuser=getDBUser();
			
			DBPoolManager poolmanNew=(DBPoolManager)application.getAttribute(getStringPoolmanager());
			if (poolmanNew==null){
				poolmanNew=DBPoolManager.getInstance();
				application.setAttribute(getStringPoolmanager(), poolmanNew);
			}
			
			//DBConnectPool connNew=poolmanNew.getPool("it.cise.db.database.DBPortal","it.cise.db.user.Portalowner");
			it.cise.db.jdbc.DBConnectPool connNew=null;
			if ((dbinfo!=null) && (dbuser!=null))
				connNew=poolmanNew.getPool(dbinfo,dbuser);
			else
				throw new ServletException("dbinfo: " + dbinfo + " dbuser: " + dbuser);
			
			Long id=null;
			try{
				id=new Long(request.getParameter("DWN"));
			}catch(Exception e){
				response.sendRedirect(pageError);
			}
			
			d=getDownload();
			d.initialize(connNew);
			/*Hashtable pkey = new Hashtable<String, Long>();
			pkey.put(d.getIdNameField(), id);
			d.setPrimaryKey(pkey);
			d.load();*/
			d.setField(d.getIdNameField(), id);
			d.load();
			Logger.write("FileServlet log1 d " + d);
			if (d.isInserted()){
				Authenticable operatore=(Authenticable)session.getAttribute("user");
				Logger.write("FileServlet log2 operatore " + operatore);
				boolean isPreview = operatore!=null && request.getParameter(getParameterPreview())!=null && request.getParameter(getParameterPreview()).equals(getParameterPreviewValue());
				
				if (d.valido() || isPreview){
					if (d.accessibile(operatore)){
						
						String path=application.getRealPath(d.getUrlFile());
						String estensione=path.substring(path.lastIndexOf(".") + 1);
						String mimeType=null;
						if ((estensione!=null) && ((mimeType=validExtensions.get(estensione.toLowerCase()))!=null)){
							
							File downloadFile=new File(path);

							response.setContentType(mimeType);
							response.setHeader("Content-Length", String.valueOf(downloadFile.length()));
							response.setHeader("Cache-Control", "no-store");
							
							BufferedInputStream fis=new BufferedInputStream(new FileInputStream(downloadFile));
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
						
					}else{
						error=true;
						messageError="Download non accessibile all'operatore";
					}
					
				}else{
					error=true;
					messageError="Download non validato";
				}
				
			}else{
				error=true;
				messageError="Download non ancora inserito";
			}
			
		}catch(Exception e){
			e.printStackTrace();
			error=true;
			messageError="Errore generico intercettato (vedi stacktrace precedente)";
		}
		
		if (error){
			Logger.write(this, "Request(DWN=" + request.getParameter("DWN") + ") - Errore nell'upload del download: " + d + ": " + messageError);
			// Reindirizzamento alla pagina di scaduta
			if (response.isCommitted())
				Logger.write("Pagina già committata impossibile redirezionare");
			else
				response.sendRedirect(pageError);
		}
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request,response);
	}
}
