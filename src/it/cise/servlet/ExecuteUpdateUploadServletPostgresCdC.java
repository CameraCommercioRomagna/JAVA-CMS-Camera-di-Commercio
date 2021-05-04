package it.cise.servlet;

import it.cise.db.database.CdCRomagnaPostgres;

public class ExecuteUpdateUploadServletPostgresCdC 
	extends ExecuteUpdateUploadServletPostgres{
	
	private static final long serialVersionUID = 8664258244982855758L;

	public String getStringPoolmanager(){
		return CdCRomagnaPostgres.SESSION_PARAM_NAME;
	}
}
