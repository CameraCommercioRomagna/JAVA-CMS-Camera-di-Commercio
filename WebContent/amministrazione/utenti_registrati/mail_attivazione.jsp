<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@include file="/amministrazione/_load_pagina.jsp" %>

<%@include file="/common/include/_email_headerfooter.jsp" %>

<%	String email = (request.getParameter("email")!=null ? request.getParameter("email").trim() : "");
	String password = request.getParameter("password");
	String key = request.getParameter("key");
	
	MailPending mail = new MailPending();
	mail.contenttype="text/html; charset=utf-8";
	mail.i_from="abc@xxx.it";
	mail.i_replyto="abc@xxx.it";
	mail.i_to=email;
	mail.subject="Richiesta di iscrizione ai servizi online della XXX";		  
	mail.body = emailHeader + "Ci &egrave; giunta la richiesta di iscrizione ai servizi online della XXX per l'indirizzo: <b>"+email+"</b>.<br />La password da utilizzare per l'accesso &egrave;: <b>"+password+"</b>.<br /><br />Per confermare l'iscrizione clicca su questo link: <a href='http://www.xxx.it/newsletter/conferma.jsp?key="+key+"&email="+email+"'>http://www.xxx.it/newsletter/conferma.jsp?key="+key+"&email="+email+"</a><br />(Se il link non dovesse funzionare correttamente, si prega di provare copiando e incollando tutta la riga nel proprio browser)<br /><br />Hai 7 giorni di tempo per confermare la tua iscrizione.<br /><br />Ai sensi del D. Lgs. 30/06/2003 n.196, i dati saranno oggetto di trattamento informatico e manuale, ai fini della trasmissione, da parte della XXX, di comunicazioni riguardanti l'attivit&agrave; istituzionale.<br />"+emailFooter;
	mail.page_ins="ATTNL";
	//out.print(mail.body);
	mail.submit();
	response.sendRedirect("/amministrazione/utenti_registrati/");
	%>