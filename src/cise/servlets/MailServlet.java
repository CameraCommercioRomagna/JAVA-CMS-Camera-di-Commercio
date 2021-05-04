package cise.servlets;

import java.io.IOException;
import java.util.Date;
import java.util.Enumeration;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletConfig;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import cise.db.jdbc.DBConnectPool;
import cise.db.jdbc.DBPoolManager;
import cise.portale.auth.User;
import cise.portale.auth.Utente;
import cise.utils.StringUtils;



/*******************************************************
 *											*
 * 	Esegue la spedizione di una e-mail.		*
 *											*
 *******************************************************/
 
public class MailServlet extends HttpServlet{
	
	private String SMTP_HOST;
	private String SMTP_PORT;
	
	
	@Override
	final public void init(ServletConfig config)
		throws ServletException {
		
		SMTP_HOST=config.getInitParameter("SMTP_HOST");
		SMTP_PORT=config.getInitParameter("SMTP_PORT");
	}
		
	@Override
	public void doPost(HttpServletRequest request, HttpServletResponse response){
		
		HttpSession session=request.getSession();
		
		// Ricezione di tutti i parametri dalla form
		String[] to = request.getParameterValues("to");
		String[] cc = request.getParameterValues("cc");
		String[] bcc = request.getParameterValues("bcc");
		String fromName = request.getParameter("fromName");
		String fromEmail = request.getParameter("fromEmail");
		String redirect = cise.utils.HttpUtils.extractURLFromRequest(request,"redirect");
		String subject = request.getParameter("subject");
		String message = request.getParameter("message");
		
		boolean printUser = ((request.getParameter("nouser")==null) || (!request.getParameter("nouser").equals("1")));
		boolean printDate = ((request.getParameter("nodate")==null) || (!request.getParameter("nodate").equals("1")));
		
		// Controllo dei nulli
		if (message==null)
			message="";
		if ((redirect==null)||(redirect.equals("")))
			redirect="/";
		
		if ((session.getAttribute("tokenMailServlet")==null) || (!session.getAttribute("tokenMailServlet").equals("true")) || (fromEmail==null) || (fromEmail.indexOf("@")==-1) || (fromEmail.indexOf("@")!=fromEmail.lastIndexOf("@"))){
			// Tentativo di abuso della servlet ?? più spesso sono back eseguiti dal browser
			to=new String[1];
			to[0]="abc@xxx.it";
			cc=null;
			bcc=null;
			fromEmail="abc@xxx.it";
			fromName="MailServlet";
			
			subject="MailServlet: Tentativo di spedizione non corretto";
			message="Messaggio generato automaticamente dalla servlet MailServlet:\n";
			message+="Remote Host: " + request.getRemoteHost() + "(" + request.getRemoteAddr() + ")\n";
			message+="\nParametri passati:\n";
			Enumeration e=null;
			String elem=null;
			for (e=request.getParameterNames();e.hasMoreElements();){
				elem=(String)e.nextElement();
				message+=elem + " : " + request.getParameter(elem) + "\n";
			}
			message+="\nAttributi passati:\n";
			for (e=request.getAttributeNames();e.hasMoreElements();){
				elem=(String)e.nextElement();
				message+=elem + " : " + request.getAttribute(elem) + "\n";
			}
		}
		
		boolean hasCC=(cc!=null);	
		boolean hasBCC=(bcc!=null);	
		
		session.removeAttribute("tokenMailServlet");
		
		// Modifiche del corpo del messaggio
		// 1. Eventuale scrittura della data
		String date="\n";
		if (printDate)
			date += new Date() + "\n\n";

		// 2. Eventuale scrittura dell'utente connesso
		String userInfo="";
		if (printUser){
			User user=(User)session.getAttribute("user");
			if (user!=null){
				// Preleva una connessione dal pool
				ServletContext application = session.getServletContext();
				DBPoolManager poolman=(DBPoolManager)application.getAttribute("poolmanager");
				if (poolman==null){
					poolman=DBPoolManager.getInstance();
					application.setAttribute("poolmanager",poolman);
				}
				DBConnectPool conn=poolman.getPool();

	          	Utente utente=user.getUtente(conn);
	          	userInfo="Utente portale : " + utente.getUsername() + " (" + user.getIdentita() + ")\n";
	          	userInfo+=("Azienda : " + utente.getRag_sociale() + "\n");
	          	userInfo+=("e-mail : " + utente.getEmail() + "\n");
	          	userInfo+=("indirizzo : " + utente.getIndirizzo() + "," + utente.getNum_civ() + " - " + utente.getCap() + " " + utente.getComune() + " (" + utente.getProvincia() + ") " + "\n");
	          	userInfo+=("telefono : " + utente.getTelefono() + "\n\n");
	          }  
		}

		message = date + userInfo + message;
		
		// Invio del messaggio
		try{
			
			Properties props = new Properties();
			props.put("mail.host", SMTP_HOST);
			
			//props.put("mail.user", "informatica");
			Session sendMailSession;
			sendMailSession = Session.getInstance(props);
			
			MimeMessage newMessage = new MimeMessage(sendMailSession);
			
			
			newMessage.setSubject(subject); 
			newMessage.setText(message);
			newMessage.setSentDate(new Date());
			newMessage.setHeader("Content-Transfer-Encoding", "8bit");
			newMessage.setHeader("Content-Type", "text/plain; charset=UTF-8; format=flowed");
			
			if (to!=null){
				InternetAddress[] addrTO = InternetAddress.parse(StringUtils.stringFromArray(to,","));
				newMessage.addRecipients(Message.RecipientType.TO, addrTO);
			}
			if (cc!=null){
				InternetAddress[] addrCC = InternetAddress.parse(StringUtils.stringFromArray(cc,","));
				newMessage.addRecipients(Message.RecipientType.CC, addrCC);
			}
			if (bcc!=null){
				InternetAddress[] addrBCC = InternetAddress.parse(StringUtils.stringFromArray(bcc,","));
				newMessage.addRecipients(Message.RecipientType.BCC, addrBCC);
			}
			
			InternetAddress from = new InternetAddress(fromEmail, fromName);
			newMessage.setFrom(from);			
			
			Transport.send(newMessage);
	
			response.sendRedirect(redirect);
    	
    	}catch(Exception e){
    		e.printStackTrace();
    		try{
    			response.sendRedirect("/common/htm/wrong_mail.htm?" + cise.utils.HttpUtils.createQSFromString(redirect,"pagefwd"));
    		}catch(Exception f){
    			f.printStackTrace();
    		}
		}
	}
	
	@Override
	public void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
			doPost(request,response);
	}
}
