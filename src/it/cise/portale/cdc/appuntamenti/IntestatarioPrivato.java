package it.cise.portale.cdc.appuntamenti;


public class IntestatarioPrivato extends Intestatario {
	
	public IntestatarioPrivato(Pratica pratica) {
		super(pratica);
	}
	
	@Override
	public String getNominativo() {
		return pratica.intestatario_nome + " " + pratica.intestatario_cognome;
	}
}
