<%	//tipo_newsLetter
	// 1. Prova a caricare il numero della newsletter a partire dall'ID
	NumeroNewsLetter numero_nl=null;

	try{
		Long id = Long.parseLong(requestMP.getParameter(rq_numero_newsLetter));
		numero_nl = new NumeroNewsLetter(id, connPostgres);
	}catch(Exception e){}
%>