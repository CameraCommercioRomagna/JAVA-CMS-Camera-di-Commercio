package it.cise.servlet;

import it.cise.db.database.CdCRomagnaPostgres;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.auth.Utente;

public class LoginServletDBPortalCdC extends LoginServlet<Utente> {

	private static final long serialVersionUID = 93584257388936797L;

	@Override
	public String getDBInfo(){
		return "it.cise.db.database.DBPortalCdCRomagnaPostgres";
	}
	
	@Override
	public String getDBUser(){
		return "it.cise.db.user.Postgres";
	}
	
	@Override
	public String getStringPoolmanager(){
		return CdCRomagnaPostgres.SESSION_PARAM_NAME;
	}
	
	@Override
	public Utente getUtente(DBConnectPool conn) {
		return new Utente(conn);
	}

}
