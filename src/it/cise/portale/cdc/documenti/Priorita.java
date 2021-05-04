package it.cise.portale.cdc.documenti;

public enum Priorita {
	NULLA(0), BASSA(1), MEDIA(2), ALTA(3), MASSIMA(4);
	
	private Long valore;
	
	Priorita(int valore){
		this.valore=new Long(valore);
	}
	
	public Long getValore(){
		return valore;
	}
	
	public static Priorita getPriorita(Long valPriorita){
		Priorita pFound=null;
		
		if (valPriorita == null) {
			pFound = MEDIA;
		}else {
			for (Priorita p: values())
				if (p.getValore().compareTo(valPriorita)==0)
					pFound=p;
					
			if (pFound==null){
				if (valPriorita!=null && valPriorita < NULLA.getValore())
					pFound = NULLA;
				else if (valPriorita!=null && valPriorita > MASSIMA.getValore())
					pFound = MASSIMA;
				else
					throw new IllegalArgumentException("Priorità non corrispondente al valore passato in input: " + valPriorita);
			}
		}
		return pFound;
	}
}
