<%!
	/*	Estrae i primi nChar caratteri della stringa s e vi aggiunge i puntini di
		sospensione se la stringa era più lunga. */
	private String extractInitChars(String s, int nChar){
		String sRes="";
		
		if (s!=null){
			int sLung=s.length();
		
			sRes=s.substring(0,(sLung < nChar ? sLung : nChar));
			if (sLung>nChar)
				sRes+=" ...";
		}
		
		return sRes;
	}
%>
