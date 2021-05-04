package it.cise.servlet;

import javax.servlet.*;
import javax.servlet.http.*;

import java.io.*;

import cise.utils.*;
import it.cise.util.auth.Authenticable;

public class LogoutServlet extends HttpServlet{
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
	
		HttpSession session=request.getSession();
		
		Authenticable userLogged=(Authenticable)session.getAttribute("user");
		
		if (userLogged!=null){
			session.removeAttribute("user");
			Logger.write("Disconnesso utente: " + userLogged.getIdentita());
		}
		
		// Determina la pagina di ritorno
		String fwd=cise.utils.HttpUtils.extractURLFromRequest(request,"pagefwd");
		if ((fwd==null) || (fwd.equals("")))
			fwd="/";

		response.sendRedirect(fwd);
	}
	
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
			doPost(request,response);
	}
}
