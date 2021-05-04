package it.cise.portale.cdc.email;

import java.util.*;

import it.cise.portale.cdc.auth.Utente;
import it.cise.portale.cdc.documenti.TipoDocumento;
import it.cise.portale.cdc.documenti.eventi.Luogo;


public interface Emailable{
	
	Long getId();
	
	String getTitolo();
	String getAbstract();
	String getInfo();
	String getIcona();
	String getImmagine();
	
	String periodoENote();
	Luogo getLuogo();
	String luogoENote();
	String getOrario();
	
	TipoDocumento getTipo();
	
	String getPathLink();
	String getLink();
	
	List<ItemEmailable> getItem();
	
	Utente getProprietario();
	
}