package it.cise.servlet;

import cise.db.constants.FieldConstants;
import cise.utils.*;


/******************************************************************************
 *	Servlet per l'inserimento o la modifica di più tuple all'interno di una 
 *	tabella di un DB Postgres. Sottoclasse della classe astratta 
 *	ExecuteMultipleUpdateServlet, ne implementa le funzioni astratte secondo
 *	le specifiche relative a Postgres.
 *
 *	@author Elio Amadori
 *	@version 1.0
 *	@see it.cise.servlets.ExecuteMultipleUpdateServlet
 ******************************************************************************/
 
public class ExecuteUpdateUploadServletPostgres 
	extends ExecuteUpdateUploadServlet{

/**	Crea una stringa pronta per l'inserimento nel DB per il valore specificato
 *	in input.
 *	@param type		il tipo da utilizzare per la conversione
 *	@param value	il valore da formattare
 *
 *	@return il valore trasformato in stringa per l'inserimento */
	protected String getFormattedValue(String type,String value){
		String vfinal=null;
		
		if (type==null)
			Logger.write(this,"getFormattedValue : il tipo è NULL");
		else{
			if (type.equals(FIELD_NUMERIC) || type.equals(FIELD_BOOLEAN))
				vfinal=(((value==null) || value.equals("")) ? null : value);
			else if(type.equals(FIELD_VARCHAR)){
				vfinal=StringUtils.doubleQuotes(value);
				if(vfinal.equals(""))
					vfinal=null;
				if (vfinal!=null)
					vfinal="'" + vfinal + "'";
			}else if (type.equals(FIELD_DATE))
				vfinal=((value == null) ? null : "TO_DATE('" + value + "'," + FieldConstants.FORMAT_DATE_POSTGRES + ")");
			else
				Logger.write(this,"getFormattedValue : il tipo non è tra quelli specificati");
		}
			
		return vfinal;
	}
	
	public String getStringPoolmanager(){
		return "poolmanagerNew";
	}
}
