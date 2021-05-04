package it.cise.util.http;

public final class HttpUtils {
	
/**	Elimina/sostituisce tutti caratteri speciali con i caratteri pi� adatti ad una forma dell'URL pi� adatta per i motori di ricerca */
	public static final String getTextForWebLink(String testo){
		String nomefileClean = testo.toLowerCase().replaceAll(" ", "_");
		nomefileClean = nomefileClean.replaceAll("-+", "_");
		
		nomefileClean = nomefileClean.replaceAll("�", "a");
		nomefileClean = nomefileClean.replaceAll("�", "e");
		nomefileClean = nomefileClean.replaceAll("�", "e");
		nomefileClean = nomefileClean.replaceAll("�", "i");
		nomefileClean = nomefileClean.replaceAll("�", "o");
		
		nomefileClean = nomefileClean.replaceAll("\\W*", "");
		nomefileClean = nomefileClean.replaceAll("_+", "-");
		nomefileClean = nomefileClean.replaceAll("-+", "-");
		
		return nomefileClean;
	}
}
