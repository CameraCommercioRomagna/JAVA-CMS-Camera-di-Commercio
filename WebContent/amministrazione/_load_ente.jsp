<%	boolean inserimento_ente = operazione.equals("crea_ente");
	boolean modifica_ente = inserimento || operazione.equals("salva_ente");
	
	// 1. Prova a caricare l'ente a partire dall'ID
	Ente ente=null;

	try{
		Long id = Long.parseLong(requestMP.getParameter(rq_ente));
		ente = new Ente(id, connPostgres);
	}catch(Exception e){}
	
	// 2. Verifica se si sta creando un nuovo ente
	if (inserimento_ente){
		ente = new Ente();
		ente.initialize(connPostgres);
	}
%>