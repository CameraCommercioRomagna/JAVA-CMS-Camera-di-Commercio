<%	PreviewQuery prev = new PreviewQuery(connNew);
	prev.setPreview("SELECT portalowner.id_utentenl.nextval FROM dual");
	Long id_utente = new Long(prev.getField(0));
	String email = (request.getParameter("email")!=null ? request.getParameter("email").trim() : "");
	String password = request.getParameter("password1").trim();
	String nome = request.getParameter("nome").trim();
	String cognome = request.getParameter("cognome").trim();
	String privacy = request.getParameter("privacy")!=null ? request.getParameter("privacy") : "0";
	String organizzazione = request.getParameter("organizzazione").trim();
	String[] id_tematica = request.getParameterValues("tematica");
	String key = request.getParameter("key").trim();
	Date data_inserimento = new Date();
	boolean insert_succeded = false;%>