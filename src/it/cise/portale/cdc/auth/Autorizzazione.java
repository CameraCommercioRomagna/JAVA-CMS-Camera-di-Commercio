package it.cise.portale.cdc.auth;

public enum Autorizzazione {

	ROOT(0l), 
	DWEB_OPERATORE(1l), DWEB_AMMINISTRATORE(2l),
	DWEB_RISERVATI_GIUNTA(4l), DWEB_RISERVATI_CONSIGLIO(5l), DWEB_RISERVATI_REVISORI(6l),
	CC_AMMINISTRATORE(7l), CC_OPERATORE(8l), CC_SMISTATORE(9l),	CC_RIAPERTURA_QUESITI(15l),// Contatta Camera
	APPUNTAMENTI_AMMINISTRATORE(13l), APPUNTAMENTI_OPERATORE(14l),
	CONG_OPERATORE(10l), CONG_AMMINISTRATORE(11l),
	NOTIZIARIO_AMMINISTRATORE(12l);
	
	private Long id_autorizzazione;
	
	private Autorizzazione(Long id) {
		id_autorizzazione = id;
	}

	public Long getId() {
		return id_autorizzazione;
	}
	public static Autorizzazione fromID(Long id) {
		Autorizzazione aFound=null;
		for (Autorizzazione a: values())
			if (a.id_autorizzazione.equals(id))
				aFound=a;			
		
		return aFound;
	}
	

}