<%	boolean inserimento_luogo = operazione.equals("crea_luogo");
	boolean modifica_luogo = inserimento || operazione.equals("salva_luogo");
	
	// 1. Prova a caricare il luogo a partire dall'ID
	Luogo luogo=null;

	try{
		Long id = Long.parseLong(requestMP.getParameter(rq_luogo));
		luogo = new Luogo(id, connPostgres);
	}catch(Exception e){}
	
	// 2. Verifica se si sta creando un nuovo luogo
	if (inserimento_luogo){
		luogo = new Luogo();
		luogo.initialize(connPostgres);
	}
%>