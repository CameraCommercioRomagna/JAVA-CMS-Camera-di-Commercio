package it.cise.portale.cdc.appuntamenti;

import java.util.Date;
import java.util.List;

import cise.portale.auth.Gruppo;
import cise.utils.DateUtils;
import it.cise.db.Record;

public class Richiedente implements IRichiedente {
	
	public static final int MAX_APPUNTAMENTI_MESE = 1;
	public static final int MAX_APPUNTAMENTI_GIORNO = 1;
	
	private Appuntamento appuntamento;
	
	Richiedente(Appuntamento a) {
		appuntamento=a;
	}
	
	void setIntermediario(Intermediario intermediario) {
		if (intermediario != null) {
			appuntamento.id_intermediario = intermediario.id_intermediario;
			setNome(intermediario.nome);
			setCognome(intermediario.cognome);
			setEmail(intermediario.email);
			setCodiceFiscale(intermediario.codice_fiscale);
		}
	}
	public void setNome(String nome) {
		appuntamento.nome = nome;
	}
	public void setCognome(String cognome) {
		appuntamento.cognome = cognome;
	}
	public void setEmail(String email) {
		appuntamento.email = email;
	}
	public void setTelefono(String telefono) {
		appuntamento.telefono = telefono;
	}
	public void setCodiceFiscale(String cf) {
		appuntamento.codice_fiscale = cf;
	}

	@Override
	public boolean isAzienda() {
		return (appuntamento.nome == null && appuntamento.cognome!=null);
	}
	
	public Appuntamento getAppuntamento() {
		return appuntamento;
	}

	@Override
	public String getNomeCognome() {
		return (!isAzienda() ? appuntamento.nome + " " : "") + appuntamento.cognome;
	}
	@Override
	public String getTelefono() {
		return appuntamento.telefono;
	}
	@Override
	public String getEmail() {
		return appuntamento.email;
	}
	@Override
	public String getCodiceFiscale() {
		return appuntamento.codice_fiscale;
	}
	
	@Override
	public List<Appuntamento> getAppuntamenti(){
		return getAppuntamenti(null);
	}
	@Override
	public List<Appuntamento> getAppuntamenti(Date giorno){
		return getAppuntamenti(giorno, giorno);
	}
	@Override
	public List<Appuntamento> getAppuntamenti(Servizio servizio, Date giorno){
		return getAppuntamenti(servizio, giorno, giorno);
	}
	@Override
	public List<Appuntamento> getAppuntamenti(Date dal, Date al){
		return getAppuntamenti(null, dal, al);
	}
	@Override
	public List<Appuntamento> getAppuntamenti(Servizio servizio, Date dal, Date al){
		String query = "select a.* from " + Appuntamento.NAME_TABLE + " a " +
			"where data_garbage_collection is null and data_cancellazione is null and data_prenotazione is not null";
		
		if(getCodiceFiscale()==null || getCodiceFiscale().equals("00000000000")){
			query += " and trim(email) ilike '" + getEmail() + "'";
		}else{		
			query += " and trim(upper(codice_fiscale)) ilike '" + getCodiceFiscale().toUpperCase() + "'";
		}
		
		if(servizio!=null) {
			if(servizio.getFiltroAmmissibilita()!=null) {
				switch (servizio.getFiltroAmmissibilita()) {
					case GRUPPO_EROGATORI:
						if(servizio.getGruppo()!=null) {
							query += " and a.id_servizio in (" + servizio.getGruppo().getServiziString() + ")";
						}
						break;
					case SERVIZIO:
						query += " and a.id_servizio in (" + servizio.getId() + ")";
						break;
				};		
			}
		}
			
		if (dal!=null)
			query += " and date_trunc('day', inizio) >= '" + DateUtils.formatDate(dal, "yyyyMMdd")+ "'";
		if (al!=null)
			query += " and date_trunc('day', inizio) <= '" + DateUtils.formatDate(al, "yyyyMMdd")+ "'";
		
		return Record.loadEntitiesFromQuery(query, appuntamento.getPool(), Appuntamento.class);
	}
	
	@Override
	public boolean ammissibile(Date giorno) {
		return ammissibile(null, giorno);
	}
	
	@Override
	public boolean ammissibile(Servizio servizio, Date giorno) {
		if(getCodiceFiscale()==null || getCodiceFiscale().equals("00000000000")){
			return getAppuntamenti(servizio, giorno).size() < MAX_APPUNTAMENTI_GIORNO;
		}else if(!getCodiceFiscale().equals("04283130401")){
			return getAppuntamenti(servizio, DateUtils.addDays(giorno, -15), DateUtils.addDays(giorno, 15)).size() < MAX_APPUNTAMENTI_MESE;
		}else{
			return true;/*Gli operatori camerali possono inserire le chiusure senza limitazioni*/
		}
	}
	
	@Override
	public String toString() {
		return getNomeCognome() + " (T " + getTelefono() + " - E " + getEmail() + ")";
	}
}
