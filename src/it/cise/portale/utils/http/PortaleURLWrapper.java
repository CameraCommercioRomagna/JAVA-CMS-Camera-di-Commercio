package it.cise.portale.utils.http;

import java.net.URL;

import cise.utils.Logger;

import it.cise.util.http.URLWrapper;

public class PortaleURLWrapper extends URLWrapper {
	
	private final String PARAMETER_SEZIONE="sez"; 
	
	public PortaleURLWrapper(URL url) {
		super(url);
		
		try{
			String sezionePar=getParameter(PARAMETER_SEZIONE).get(0);
			String newPath=adjustPath(sezionePar)+getResourcePath().substring(1);
			setResourcePath(newPath);
			removeParameter(PARAMETER_SEZIONE);
		}catch (NullPointerException e) {
			// se esiste è uno, altrimenti non ci sono azioni da fare
		}
	}
	
	public static void main(String[] args) throws Exception{
		URL url=new URL("http://demo.fo.camcom.it/pubblicazioni/scheda.htm?sez=prezzi&ID_P=124");
		PortaleURLWrapper wrapper=new PortaleURLWrapper(url);
		Logger.write(wrapper);
		/*wrapper.setResourceFile("pippo.htm");
		Logger.write(wrapper);
		wrapper.setResourcePath("/sezione");
		Logger.write(wrapper);*/
	}
}
