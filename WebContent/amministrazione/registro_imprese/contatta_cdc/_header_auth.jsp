<%	// siamo costretti ad utilizzare il controllo "(utenteLoggato && ..." perchè questo include èutilizzato nel sito pubblico (nella visualizzazione di tutti i quesiti di un utente)
	boolean amministratoreQuesiti=utenteLoggato && operatore.authorizedFor(Autorizzazione.CC_AMMINISTRATORE);
	boolean smistatoreQuesiti=amministratoreQuesiti || (utenteLoggato && operatore.authorizedFor(Autorizzazione.CC_SMISTATORE));
	boolean operatoreQuesiti=smistatoreQuesiti || (utenteLoggato && operatore.authorizedFor(Autorizzazione.CC_OPERATORE));

	boolean demoMode=false;
%>