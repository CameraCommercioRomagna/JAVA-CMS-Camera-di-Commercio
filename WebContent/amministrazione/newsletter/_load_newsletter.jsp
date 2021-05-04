<%	NewsLetter tipo_newsLetter=null;

	try{
		Long id = Long.parseLong(requestMP.getParameter(rq_tipo_newsLetter));
		tipo_newsLetter = new NewsLetter(id, connPostgres);
	}catch(Exception e){
		//se non mi viene passato alcun id carico il notiziario quindicinale
		tipo_newsLetter = new NewsLetter(new Long(1l), connPostgres);
	}
%>