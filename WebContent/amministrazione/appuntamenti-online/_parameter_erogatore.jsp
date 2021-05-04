<%	String erogatoreString = request.getParameter("erogatore"); 
	try{
		erogatore=Sede.valueOf(erogatoreString);
	}catch(Exception eValue){
		try{
			erogatore=Sportello.valueOf(erogatoreString);
		}catch(Exception eValue1){
			
			try{
				// Passaggi necessari per converire i parametri passati da FullCalendar da UTF-8 -> ISO_8859
				byte[] bytesErogatoreString = erogatoreString.getBytes(java.nio.charset.StandardCharsets.ISO_8859_1);
				erogatoreString = new String(bytesErogatoreString, java.nio.charset.StandardCharsets.UTF_8);
				erogatore=Sede.valueOf(erogatoreString);
			}catch(Exception eValue2){
				try{
					erogatore=Sportello.valueOf(erogatoreString);
				}catch(Exception eValue3){}
			}
		}
	}
%>