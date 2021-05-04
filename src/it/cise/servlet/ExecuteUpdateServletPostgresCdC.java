package it.cise.servlet;

import it.cise.db.database.CdCRomagnaPostgres;

public class ExecuteUpdateServletPostgresCdC 
	extends ExecuteUpdateServletPostgres{
	
	private static final long serialVersionUID = 6084672151656855833L;

	public String getStringPoolmanager(){
		return CdCRomagnaPostgres.SESSION_PARAM_NAME;
	}
}
