package it.cise.servlet;

import javax.servlet.*;
import javax.servlet.http.*;
import java.io.*;

import it.cise.db.Record;
import it.cise.db.jdbc.*;

import it.cise.util.auth.*;
import cise.utils.*;


/**	Servlet che gestisce il processo di login.
 * 
 * */
public class LoginServlet<T extends Record & Authenticable> extends HttpServlet{
	
	private static final long serialVersionUID = 3298806009763169489L;


	public String getDBInfo(){
		return "it.cise.db.database.DBPortalCISE";
	}
	
	public String getDBUser(){
		return "it.cise.db.user.Postgres";
	}
	
	public String getStringPoolmanager(){
		return "poolmanagerNew";
	}
	
	public T getUtente(DBConnectPool conn) {
		return (T) new it.cise.portale.auth.Utente(conn);
	}

	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
	
		// Preleva una connessione dal pool
		HttpSession session=request.getSession();
		ServletContext application = session.getServletContext();
		DBPoolManager poolman=(DBPoolManager)application.getAttribute(getStringPoolmanager());
		if (poolman==null){
			poolman=DBPoolManager.getInstance();
			application.setAttribute(getStringPoolmanager(),poolman);
		}

		DBConnectPool conn=poolman.getPool(getDBInfo(), getDBUser());
		
		// Controlla in quale lingua si sta navigando il sito
		String sessionLang=(String)session.getAttribute("lang");
		String pathLang="";
		if ((sessionLang!=null) && (!sessionLang.equals("ITA")))
			pathLang="/lang/" + sessionLang + "/";

		String fwd=cise.utils.HttpUtils.extractURLFromRequest(request,"pagefwd");
		String parameterMsg=cise.utils.HttpUtils.createQSFromString(fwd,"pagefwd");
		if ((fwd==null) || (fwd.equals("")))
			fwd=parameterMsg="/";

		String username=request.getParameter("username");
		String password=request.getParameter("password");
		String page_template=request.getParameter("page_template");
		
		T objUtente = null;
		objUtente= getUtente(conn);
		
		session.setAttribute("user",objUtente);		
		
		AuthenticationStatus authStatus=objUtente.authenticate(username,password);	// Se l'utente viene autenticato SOVRASCRIVE l'utente precedente
		
		boolean isReturnSecure=false;
		
		
		if (authStatus.compareTo(AuthenticationStatus.AUTHENTICATED)==0){
			Logger.write(this,"LoginServlet: LOGIN UTENTE " + objUtente.getUsername() + " (" + objUtente.getIdentita() + ")");
			isReturnSecure=((request.getParameter("tret")!=null) && (request.getParameter("tret").equals("sec")));
			if ((fwd==null)||(fwd.equals("")))// Nel caso non sia stato specificato alcun URL di ritorno
				fwd=pathLang + "/";
		}else{
			String msg=authStatus.getIdStatus().toString();
			session.setAttribute("messageMsg",msg);
			session.setAttribute("pagefwdMsg",fwd);
			fwd=pathLang + "/common/jsp/message.jsp?messageMsg="+ msg + "&pagefwdMsg="+ fwd + (page_template!=null ? "&page_template="+page_template : "");
		}
		
		if (!objUtente.loggedIn())
			// Se non vi è alcun utente loggato elimina l'oggetto
			session.removeAttribute("user");
		
		response.sendRedirect(cise.utils.HttpUtils.createURLComplete(request,fwd,isReturnSecure));
	}
	
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
			doPost(request,response);
	}
}
