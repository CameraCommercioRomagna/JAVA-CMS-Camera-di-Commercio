<%	EmailWeb email = null;
	Long id_email = null;
	try{
		id_email = Long.parseLong(requestMP.getParameter(rq_email));
		email = new EmailWeb(id_email, connPostgres);
	}catch(Exception eID){
	}
	
	if(id_email==null){
		List<EmailWeb> email_list = ((PaginaWeb)pagina).getEmailweb();
		Logger.write("**********************CCCCCCCCCCCCCCCCC************************");
		if(email_list.size()>0)
			email = email_list.get(0);
	}
	
	if(email==null)
		email = pagina.creaEmailWeb(operatore, true);
	Logger.write("**************emailemail************" + email);
	backwrapper = new CdCURLWrapper(connPostgres, new URL(currentServer + email.getLink()));
	%>