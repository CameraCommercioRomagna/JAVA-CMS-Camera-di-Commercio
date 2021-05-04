package it.cise.portale.cdc.documenti;

public enum Visibilita {
	NON_VISIBILE(-2l),
	VISIBILE_SOLO_COLLETTORI(-1l),
	VISIBILE_DOVE_COLLOCATO(0l),
	VISIBILE_HOME_PAGE(1l);
	
	private Long valore;
	
	Visibilita(Long valore){
		this.valore=valore;
	}
	
	public Long getValore(){
		return valore;
	}
	
	public static Visibilita getVisibilita(Long valore){
		Visibilita pFound=null;
		for (Visibilita p: values())
			if (p.getValore().equals(valore))
				pFound=p;
				
		if (pFound==null)
			throw new IllegalArgumentException("Visibilità non corrispondente al valore passatpo in input: " + valore);
		
		return pFound;
	}
}
