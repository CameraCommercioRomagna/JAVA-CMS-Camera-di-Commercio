package it.cise.portale.cdc.documenti.eventi;

public enum TipoCollaborazione {
	ORGANIZZATORE(1l, "Organizzato da"), CONTRIBUTORE(2l, "Con il contributo di"), SOSTENITORE(3l, "Con il sostegno di"), PATROCINATORE(5l, "Con il patrocinio di"),
	COLLABORATORE(5l, "In collaborazione con"), SPONSOR(6l, "Sponsor"), SPONSOR_TECNICO(7l, "Sponsor Tecnici"), MEDIA_PARTNER(8l, "Media partner"), PARTNER(9l, "Partner");
	
	private Long id_tipo_collaborazione;
	private String titoloSezioneEvento; 
	
	TipoCollaborazione(Long id, String titoloSezioneEvento){
		id_tipo_collaborazione=id;
		this.titoloSezioneEvento=titoloSezioneEvento;
	}
	
	public Long getId() {
		return id_tipo_collaborazione;
	}
	
	public static TipoCollaborazione fromID(Long id) {
		TipoCollaborazione cFound=null;
		for (TipoCollaborazione c: values())
			if (c.id_tipo_collaborazione.equals(id))
				cFound=c;			
		
		return cFound;
	}
	
	public String getTitoloSezioneEvento() {
		return (titoloSezioneEvento!=null ? titoloSezioneEvento : toString());
	}
	
	@Override
	public String toString() {
		return name().toLowerCase().replaceAll("_", " ");
	}
}
