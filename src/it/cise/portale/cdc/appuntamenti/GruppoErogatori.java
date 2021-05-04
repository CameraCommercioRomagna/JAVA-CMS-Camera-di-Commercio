package it.cise.portale.cdc.appuntamenti;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


public enum GruppoErogatori {
	UFF_DIGITALIZZAZIONE("DIG","Ufficio Digitalizzazione d'Impresa"), UFF_REGISTROIMPRESE("RIM","Registro Imprese");
	
	private String codice;
	private String nome;
	private List<Sede> sedi=new ArrayList<Sede>();
	
	private List<Servizio> servizi = new ArrayList<Servizio>();
	
	private GruppoErogatori(String codice, String nome) {
		this.codice=codice;
		this.nome=nome;
	}
	
	public String getCodice() {
		return codice;
	}
	
	public String getNome() {
		return nome;
	}
	
	void addSede(Sede sede) {
		sedi.add(sede);
	}
	
	void addServizi(Servizio servizio) {
		servizi.add(servizio);
	}
	
	public List<Sede> getSedi() {
		return sedi;
	}
	
	public static GruppoErogatori fromID(String codice) {
		GruppoErogatori eFound=null;
		for (GruppoErogatori e: values())
			if (e.codice.equals(codice))
				eFound=e;			
		
		return eFound;
	}
	
	public List<Servizio> getServizi(){
		return servizi;
	}
	
	public String getServiziString(){
		String servizi_str = "";
		for(Servizio s: getServizi()) {
			servizi_str += (servizi_str.equals("")?"":",") + s.getId();
		}
		return servizi_str;
	}


}
