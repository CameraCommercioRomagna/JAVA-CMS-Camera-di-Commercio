package it.cise.db.database;

import it.cise.db.Database;
import it.cise.db.dbms.DWSimet;

public class CdCRomagnaPostgres extends Database {

	private static final String DB_NAME = "dbportal_cdc";
	public static final String SESSION_PARAM_NAME = "poolmanagerCdCNew";

	public CdCRomagnaPostgres(){
		super(new DWSimet(), DB_NAME);
	}

}
