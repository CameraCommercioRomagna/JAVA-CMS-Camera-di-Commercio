package it.cise.portale.cdc.appuntamenti;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import cise.utils.DateUtils;
import it.cise.db.CounterRecord;
import it.cise.db.Record;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.Portale;

public class Intermediario extends CounterRecord implements IRichiedente {
	
	private static final long serialVersionUID = 9035136598621357302L;

	public static final String NAME_TABLE = Appuntamento.NAME_SCHEMA + ".intermediari";
	public static final int MAX_APPUNTAMENTI_GIORNO = 2;

	public Long id_intermediario;
	public String nome;
	public String cognome;
	public String codice_fiscale;
	public String partita_iva;
	public String email;
	public String telefono;
	public String organizzazione;
	public Boolean attivo;
	
	private List<Intermediario> colleghi;
	
	public Intermediario() {
		super(NAME_TABLE);
	}
	public Intermediario(DBConnectPool conn, Long id) {
		super(NAME_TABLE, conn);
		id_intermediario = id;
		load();
	}

	@Override
	public boolean isAzienda() {
		return true;
	}
	

	public static Intermediario fromCodiceFiscale(String cf) {
		List<Intermediario> intermediari=Record.loadEntitiesFromQuery("select * from " + NAME_TABLE + " where attivo and upper(codice_fiscale) = '" + cf.toUpperCase() + "'", Portale.getPool(), Intermediario.class);
		return (intermediari.size()==1 ? intermediari.get(0) : null);
	}
	
	public String getCognomeNome() {
		return cognome + (nome==null ? "" : (" " + nome));
	}

	@Override
	public String getNomeCognome() {
		return (nome==null ? "" : (nome + " ")) + cognome;
	}
	
	@Override
	public String getEmail() {
		return email;
	}
	@Override
	public String getTelefono() {
		return telefono;
	}
	@Override
	public String getCodiceFiscale() {
		return codice_fiscale;
	}
	
	public String getOrganizzazione() {
		return organizzazione;
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
			"where data_garbage_collection is null and data_cancellazione is null and data_prenotazione is not null" +
			" and id_intermediario=" + id_intermediario;
		
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
		
		return Record.loadEntitiesFromQuery(query, getPool(), Appuntamento.class);
	}
	
	@Override
	public boolean ammissibile(Date giorno) {
		return ammissibile(null, giorno);
	}
	@Override
	public boolean ammissibile(Servizio servizio, Date giorno) {
		List<Appuntamento> appuntamenti=new ArrayList<Appuntamento>();
		boolean overbooking=false;
		for (Intermediario i: colleghi()) {
			appuntamenti.addAll(i.getAppuntamenti(giorno));
			overbooking = appuntamenti.size() >= MAX_APPUNTAMENTI_GIORNO;
			if (overbooking)
				break;
		}
		return !overbooking;
	}
	
	public List<Intermediario> colleghi(){
		if (colleghi==null)
			colleghi = (organizzazione!=null ?
				loadEntitiesFromQuery("select i.* from " + NAME_TABLE + " i where organizzazione='" + organizzazione + "'", getPool(), Intermediario.class) :
				new ArrayList<Intermediario>()
			);
		return colleghi;
	}
	
	@Override
	public String toString() {
		return getNomeCognome() + " intermediario per " + getOrganizzazione() + " (E " + getEmail() + ")";
	}
	
}
