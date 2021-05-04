package it.cise.servlet;

import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.portale.cdc.documenti.download.Download;

@SuppressWarnings("serial")
public class FileServletDBPortalCdCOldDB extends FileServlet {
	
	@Override
	public String getDBInfo(){
		return "it.cise.db.database.DBPortalCdCRomagnaPostgres";
	}
	
	@Override
	public String getDBUser(){
		return "it.cise.db.user.Postgres";
	}
	
	@Override
	public Download getDownload() {
		return new Download(true);
	}
	
	@Override
	public String getParameterPreview(){
		return AbstractDocumentoWeb.PARAMETER_PREVIEW;
	}
	
	@Override
	public String getParameterPreviewValue(){
		return AbstractDocumentoWeb.PARAMETER_PREVIEW_VALUE;
	}
}
