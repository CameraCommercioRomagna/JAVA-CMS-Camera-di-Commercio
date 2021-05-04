package it.cise.portale.cdc.email;


public interface ItemEmailable{
	
	Long getId();
	
	String getTitolo();
	String getTesto();
	String getImmagine();
	
	String getInfoTempo();
	String getData() ;
	String getOrario();

}