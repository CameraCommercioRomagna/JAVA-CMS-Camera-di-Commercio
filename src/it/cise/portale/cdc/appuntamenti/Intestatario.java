package it.cise.portale.cdc.appuntamenti;

import java.util.Date;

public abstract class Intestatario {
	
	protected Pratica pratica;
	
	public abstract String getNominativo();
	
	public Intestatario(Pratica pratica) {
		this.pratica=pratica;
	}
	
	public String getCodiceFiscale() {
		return pratica.intestatario_cf;
	}
	
	@Override
	public String toString() {
		return	getNominativo() + " (" + getCodiceFiscale() + ")";
	}
}
