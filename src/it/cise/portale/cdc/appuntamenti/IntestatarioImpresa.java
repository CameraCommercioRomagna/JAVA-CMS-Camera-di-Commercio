package it.cise.portale.cdc.appuntamenti;

public class IntestatarioImpresa extends Intestatario {
	
	public IntestatarioImpresa(Pratica pratica) {
		super(pratica);
	}
	
	@Override
	public String getNominativo() {
		return pratica.intestatario_ragione_sociale;
	}
	
	public String getReferente() {
		return pratica.referente_nome + " " + pratica.referente_cognome + " (" + pratica.referente_cf + ")";
	}
	
	@Override
	public String toString() {
		return super.toString() + " - Referente: " + getReferente();
	}
}
