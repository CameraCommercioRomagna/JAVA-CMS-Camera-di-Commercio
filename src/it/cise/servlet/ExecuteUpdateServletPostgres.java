package it.cise.servlet;

import javax.servlet.*;
import javax.servlet.http.*;

import java.io.*;
import java.util.*;

import cise.db.jdbc.*;
import cise.utils.*;
import cise.db.constants.*;

/******************************************************************************
 *	Servlet per l'inserimento, la modifica, la cancellazione di una tupla 
 *	all'interno di una tabella di un DB Postgres. Sottoclasse della classe 
 *	astratta ExecuteUpdateServlet, ne implementa le funzioni astratte secondo
 *	le specifiche relative ad Oracle.
 *
 *	@author Elio Amadori
 *	@version 1.0
 *	@see it.cise.servlets.ExecuteUpdateServlet
 ******************************************************************************/

public class ExecuteUpdateServletPostgres 
	extends ExecuteUpdateServlet{
	
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
