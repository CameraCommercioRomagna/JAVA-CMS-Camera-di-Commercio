package it.cise.servlet;

import it.cise.db.database.CdCRomagnaPostgres;

public class ExecuteMultipleUpdateServletPostgresCdC 
	extends ExecuteMultipleUpdateServletPostgres{
	
	private static final long serialVersionUID = -3630452854680932357L;

	public String getStringPoolmanager(){
		return CdCRomagnaPostgres.SESSION_PARAM_NAME;
	}
}
