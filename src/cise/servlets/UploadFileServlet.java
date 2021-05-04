package cise.servlets;

import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import java.io.*;
import java.util.*;
//import com.jspsmart.upload.*;


import cise.db.jdbc.*;
import cise.utils.*;
import cise.portale.generali.Parola_chiave;



/******************************************************************
 *											*
 * 	Esegue l'inserimento dei valori immessi in una form nella	*
 *	tabella relativa per la gestione a wizard				*
 *											*
 ******************************************************************/
 
@SuppressWarnings("serial")
public class UploadFileServlet extends HttpServlet{
	
	private ServletConfig config;
	private final String DEL_FILE_FIELD="upd_canc";
	
	final public void init(ServletConfig config)
		throws ServletException {
		
		this.config = config;
	}
		
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
	
		String pagefwd=null;
		
		Logger.write(" > Session upoload:" + ServletFileUpload.isMultipartContent(request));
		MultipartRequest req=new MultipartRequest(request);
		
		HttpSession session=request.getSession();
		ServletContext application = session.getServletContext();
		
		if (cise.utils.HttpUtils.checkSessionBeans(req, session)){
			// Costruisce il tipo di connessione da utilizzare
			String connType=request.getParameter("connection");
			String dbinfo=null;
			String dbuser=null;
			int posMeno=-1;
			if ((connType!=null) && ((posMeno=connType.indexOf('-'))!=-1)){
				dbinfo="cise.db.jdbc.information." + connType.substring(0,posMeno);
				dbuser="cise.db.jdbc.user." + connType.substring(posMeno+1);
			}
			// Ricerca la connessione, se esiste, altrimenti la crea
			DBPoolManager poolman=(DBPoolManager)application.getAttribute("poolmanager");
			if (poolman==null){
				poolman=DBPoolManager.getInstance();
				application.setAttribute("poolmanager",poolman);
			}
			DBConnectPool conn=null;
			if ((dbinfo!=null) && (dbuser!=null))
				conn=poolman.getPool(dbinfo,dbuser);
			else
				conn=poolman.getPool();
	
	
			DBEntity entity=(DBEntity)session.getAttribute(req.getParameter("typeEntity"));
			entity.setFields(req.getParameters());
			
			//boolean opModifica=entity.getObjectTable().isInserted();
			pagefwd=cise.utils.HttpUtils.extractURLFromRequest(req,"pagefwd");
	
			String relName=(String)req.getParameter("relation");
			boolean isMemberRelation=((relName!=null)&&(!relName.equals("")));
			
			// Analizza la stringa di richiesta per individuare eventuali parole chiave.
			// Per essere analizzate occorre che siano state immesse in un input-text-field
			// con nome 'parolechiave'
			String parolechiave=(String)req.getParameter("parolechiave");
			if (parolechiave != null){
				String[] kw=null;
				
				if (!parolechiave.equals("")){
					kw=StringParsing.extractKeyWords(parolechiave);
					if (kw != null)
						for (int k=0;k<kw.length;k++){
							Parola_chiave p=new Parola_chiave();
							p.initialize(conn);
							p.setParola(kw[k]);
					
							if (!p.Load())
								p.Insert();
							else
								System.out.print("esiste ");
							kw[k]=p.getIdentifier().toString();
							System.out.println(kw[k]);
						}
				}
				
				entity.updateRelation("generali.Parola_chiave",kw);
				
			}// End analisi parole chiave
	
			if (entity.getObjectTable().isInserted())
				entity.Update();
			else{
				// Eventualmente inserisce l'oggetto nella relazione di cui fa parte	
				if (isMemberRelation){
					DBEntity relEnt=(DBEntity)session.getAttribute(req.getParameter("relentity"));
					
					entity.setAsNewRelationRecord();
					relEnt.newMemberRelation(relName,entity);
					relEnt.Update();
				}else{
					if (!entity.Insert()){
						pagefwd="/common/jsp/message.jsp";
						String msg="4";
						session.setAttribute("messageMsg",msg);
						session.setAttribute("pagefwdMsg","http://www.xxx.it");					
					}
				}
			}
	
			// Analisi di eventuali upload
			String uploadDir=req.getParameter("upd");
			if (uploadDir!=null){
				// Stabilisce qual � l'entit� principale
				DBEntity uploadEntity=null;
				if (isMemberRelation)
					uploadEntity=(DBEntity)session.getAttribute(req.getParameter("relentity"));
				else
					uploadEntity=entity;
					
				String IDEntUpload=uploadEntity.getObjectTable().getIdentifier().toString();
				String IDDownload=entity.getObjectTable().getIdentifier().toString();

				// Crea (o reperisce se esiste gi�) la cartella in cui uploadare i file
				if (!uploadDir.endsWith("/"))
					uploadDir+="/";
				uploadDir+=(IDEntUpload + "/");
				Logger.write("Uploading in directory: " + uploadDir);
				java.io.File dir =  new java.io.File(application.getRealPath(uploadDir));
				if (!dir.exists())
					dir.mkdir();
				
				try {
					for (FileItem f: (List<FileItem>)req.getItems()){
						if (!f.isFormField()){
							boolean inseritoFile=((f.getName()!=null) && !f.getName().equals(""));
							if (inseritoFile){
								String pathDir=uploadDir;
								String nameFile="id_" + IDDownload;
								String estensione = (f.getName().lastIndexOf(".") != -1 ? f.getName().substring(f.getName().lastIndexOf(".")) : "");

								String pathFileRelative=pathDir + MultipartRequest.versionName(dir, nameFile + estensione);
								
								String pathFileAbsolute=application.getRealPath(pathFileRelative);
								java.io.File outFile=new java.io.File(pathFileAbsolute);
								f.write(outFile);
								Logger.write(" uploaded: " + f.getFieldName() + "=" + f.getName() + "(" + f.getContentType() + ") in file:" + pathFileAbsolute);
								
								entity.getObjectTable().setFieldValue(f.getFieldName(), pathFileRelative);
							}
						}
					}
				}catch (Exception e){
					e.printStackTrace();
					System.out.println("Unable to upload the file.");
				}
				// FINE: Esegue il salvataggio... con pacchetto upload di apache
				
				// ... ed elimina i files specificati
				String[] fileToDelete=req.getParameterValues(DEL_FILE_FIELD);
				if (fileToDelete!=null){
					entity.delUploadFields(fileToDelete,config);
				}
				entity.Update();
			}
		
		}else{
			pagefwd=cise.utils.HttpUtils.extractURLFromRequest(request, "chkfailed");
			if (pagefwd==null)
				pagefwd=cise.utils.HttpUtils.extractURLFromRequest(request, "pagefwd");
		}
	
		response.sendRedirect(pagefwd);
	
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
			doPost(request,response);
	}
}


class UploadFileFilter implements FileFilter{
	private String prefix;
	
	public UploadFileFilter(String prefixFile){
		prefix=prefixFile;
	}
	
	public boolean accept(java.io.File pathname){
		return pathname.getName().startsWith(prefix);
	}
}