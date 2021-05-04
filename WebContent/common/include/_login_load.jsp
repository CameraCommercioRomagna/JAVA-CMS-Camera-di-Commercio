<%	if (utenteLoggato){
		root = operatore.authorizedFor(Autorizzazione.ROOT);
		operatoreAmministrazione = root || operatore.authorizedFor(Autorizzazione.DWEB_OPERATORE);
		operatoreComitatoDiRedazione = root || operatore.authorizedFor(Autorizzazione.DWEB_AMMINISTRATORE);
		
		// Area riservata Giunta / Consiglio / Revisori
		membroGiuntaConsiglioRevisori = operatore.authorizedFor(Autorizzazione.DWEB_RISERVATI_GIUNTA) || operatore.authorizedFor(Autorizzazione.DWEB_RISERVATI_CONSIGLIO) || operatore.authorizedFor(Autorizzazione.DWEB_RISERVATI_REVISORI);
		operatoreDocumentiRiservatiGiuntaConsiglioRevisori = root || (operatoreAmministrazione && membroGiuntaConsiglioRevisori);
		
		// Aree riservate servizi
		operatoreContattaCamera = root || operatore.authorizedFor(Autorizzazione.CC_AMMINISTRATORE) || operatore.authorizedFor(Autorizzazione.CC_SMISTATORE) || operatore.authorizedFor(Autorizzazione.CC_OPERATORE);
		//operatoreCongiuntura = root || operatore.authorizedFor(Autorizzazione.CONG_AMMINISTRATORE) || operatore.authorizedFor(Autorizzazione.CONG_OPERATORE);
		operatoreNotiziario = root || operatore.authorizedFor(Autorizzazione.NOTIZIARIO_AMMINISTRATORE);
		operatoreAppuntamentiOnline = root || operatore.authorizedFor(Autorizzazione.APPUNTAMENTI_AMMINISTRATORE) || operatore.authorizedFor(Autorizzazione.APPUNTAMENTI_OPERATORE);
	}%>