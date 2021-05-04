<%	boolean amministratoreAppuntamenti=utenteLoggato && (root || operatore.authorizedFor(Autorizzazione.APPUNTAMENTI_AMMINISTRATORE));
	boolean operatoreAppuntamenti=amministratoreAppuntamenti && operatore.authorizedFor(Autorizzazione.APPUNTAMENTI_OPERATORE);
	
/*	if (!operatoreAppuntamenti)
		response.sendRedirect(HOME);*/
%>