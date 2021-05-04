<%	boolean utenteLoggato = (operatore!=null);

	boolean root = false;
	boolean operatoreAmministrazione = false;
	boolean operatoreComitatoDiRedazione = false;
	
	// Area riservata Giunta / Consiglio / Revisori
	boolean operatoreDocumentiRiservatiGiuntaConsiglioRevisori = false;
	boolean membroGiuntaConsiglioRevisori = false;
	
	// Aree riservate servizi
	boolean operatoreContattaCamera = true;
	boolean operatoreListinoPrezzi = true;
	boolean operatoreCongiuntura = operatore!=null && (operatore.authorizedFor(10l) || operatore.authorizedFor(11l)); //congiuntura operatore || congiuntura admin
	boolean operatoreNotiziario = true;
	boolean operatoreAppuntamentiOnline = false;
%>