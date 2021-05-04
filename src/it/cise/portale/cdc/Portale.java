package it.cise.portale.cdc;

import java.io.InputStream;
import java.util.Properties;

import cise.utils.Logger;
import it.cise.db.Database;
import it.cise.db.User;
import it.cise.db.jdbc.DBConnectPool;

public final class Portale {
	private static DBConnectPool pool;
	private static Properties defaultProperties;
	
	static {
		defaultProperties = new Properties();
		String fileProperties="init.properties";
		try {
			InputStream fileIS=Thread.currentThread().getContextClassLoader().getResourceAsStream(fileProperties);
			defaultProperties.load(fileIS);
		} catch (Exception e) {
			e.printStackTrace();
			Logger.write("INIT FROM FILE: Nessun file di inizializzazione " + fileProperties + " trovato, utilizzati valori di default");
		}	
	}
	
	public static void setPool(DBConnectPool p) {
		pool = p;
	}
	
	public static void setPool(Database database, User user) {
		pool = new DBConnectPool(database, user, 5, 15, 1);
	}
	
	public static DBConnectPool getPool() {
		if (pool==null)
			throw new IllegalStateException("Pool non ancora inizializzato");
		return pool;
	}
	
	public static Properties getProperties() {
		return defaultProperties;
	}
}
