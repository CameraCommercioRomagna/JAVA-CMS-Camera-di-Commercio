package it.cise.util.http;

public final class HttpUtils {
	
/**	Elimina/sostituisce tutti caratteri speciali con i caratteri più adatti ad una forma dell'URL più adatta per i motori di ricerca */
	public static final String getTextForWebLink(String testo){
		String nomefileClean = testo.toLowerCase().replaceAll(" ", "_");
		nomefileClean = nomefileClean.replaceAll("-+", "_");
		
		nomefileClean = nomefileClean.replaceAll("à", "a");
		nomefileClean = nomefileClean.replaceAll("è", "e");
		nomefileClean = nomefileClean.replaceAll("é", "e");
		nomefileClean = nomefileClean.replaceAll("ì", "i");
		nomefileClean = nomefileClean.replaceAll("ò", "o");
		
		nomefileClean = nomefileClean.replaceAll("\\W*", "");
		nomefileClean = nomefileClean.replaceAll("_+", "-");
		nomefileClean = nomefileClean.replaceAll("-+", "-");
		
		return nomefileClean;
	}
}
