<%	boolean primoAccesso=(request.getParameter("cerca")==null);
	boolean ricercaTuttiQuesitiUtente=false;
	
	String query="SELECT distinct q.id_quesito, q.rag_sociale_impresa, q.num_rea, q.id_area_interesse, q.id_utente, q.testo_quesito, q.oggetto, to_char(q.data_inserimento, 'DD-MM-YYYY HH24:MI:SS') as data_inserimento, to_char(q.data_assegnazione, 'DD-MM-YYYY HH24:MI:SS') as data_assegnazione, to_char(q.data_trattazione, 'DD-MM-YYYY HH24:MI:SS') as data_trattazione, q.id_stato, q.id_operatore, q.id_amministratore, q.id_user_smistatore, q.da_validare, to_char(q.data_chiusura_op, 'DD-MM-YYYY HH24:MI:SS') as data_chiusura_op, to_char(q.data_chiusura_admin, 'DD-MM-YYYY HH24:MI:SS') as data_chiusura_admin, q.FAQ, sq.nome, u.nome as nome_u, u.cognome as cognome_u ";
	String from = " from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_quesiti q, " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_stati_quesito sq, " + UtenteNl.NAME_TABLE + " u";
	String where = " where q.id_stato=sq.id_stato and q.id_utente=u.id_utente ";
	String order_by=" order by q.id_quesito DESC";
	
	String rag_sociale = request.getParameter("rag_sociale");
	if (rag_sociale!=null && !rag_sociale.equals("")){
		String ragSocialeQueryString = rag_sociale.toUpperCase().replaceAll("'","''").replaceAll("\\s+","%");
		where += " AND (rag_sociale_impresa ilike '%" + ragSocialeQueryString + "%' or testo_quesito ilike '%" + ragSocialeQueryString + "%' or oggetto ilike '%" + ragSocialeQueryString + "%' or q.id_quesito in (select distinct id_quesito from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_risposte where testo_risposta ilike '%" + ragSocialeQueryString + "%'))";
	}
	String n_quesito = request.getParameter("n_quesito");
	if (n_quesito!=null && !n_quesito.equals(""))
		where += " AND q.id_quesito=" + n_quesito;
	
	String email_inseritore = request.getParameter("email_inseritore");
	if (emailUtenteNLConnesso!=null || (email_inseritore!=null && !email_inseritore.equals(""))){
		if (emailUtenteNLConnesso!=null){
			email_inseritore=emailUtenteNLConnesso;
			ricercaTuttiQuesitiUtente=true;
		}
		where += " and u.email ilike '%"+email_inseritore.toUpperCase()+"%' ";
	}
	
	String[] statiArray=request.getParameterValues("stato");
	List<String> statiList=(statiArray==null ? new ArrayList<String>() : Arrays.asList(statiArray));
	String stato=(statiArray==null ? "" : StringUtils.stringFromArray(statiArray, ", "));
	if (!ricercaTuttiQuesitiUtente && (primoAccesso && (operatore!=null)) ){
		if(operatore.authorizedFor(Autorizzazione.CC_OPERATORE)){
			// Operatore
			stato="2,3,4";
		}else if(operatore.authorizedFor(Autorizzazione.CC_AMMINISTRATORE)){
			stato="1,2,3";
		}else{
			stato="1";
		}
		statiList=Arrays.asList(StringUtils.arrayFromString(stato,","));
	}
	
	if(stato!=null && !stato.equals(""))
		where+= " and q.id_stato in (" + stato + ")";
	
	String inserito_dal = request.getParameter("inserito_dal");
	if(inserito_dal!=null && !inserito_dal.equals(""))
		where+= " and date_trunc('day',q.data_inserimento) >= to_date( '" + inserito_dal +"' , 'dd/MM/yyyy')";
	
	String inserito_al = request.getParameter("inserito_al");
	if(inserito_al!=null && !inserito_al.equals(""))
		where+= " and date_trunc('day',q.data_inserimento)<= to_date( '" + inserito_al +"' , 'dd/MM/yyyy')";
	
	String assegnato_dal = request.getParameter("assegnato_dal");
	if(assegnato_dal!=null && !assegnato_dal.equals(""))
		where+= " and date_trunc('day',q.data_assegnazione) >= to_date( '" + assegnato_dal +"' , 'dd/MM/yyyy')";
	
	String assegnato_al = request.getParameter("assegnato_al");
	if(assegnato_al!=null && !assegnato_al.equals(""))
		where+= " and date_trunc('day',q.data_assegnazione)<= to_date( '" + assegnato_al +"' , 'dd/MM/yyyy')";
		
	String chiuso_dal = request.getParameter("chiuso_dal");
	if(chiuso_dal!=null && !chiuso_dal.equals(""))
		where+= " and (CASE WHEN NOT q.da_validare THEN date_trunc('day',q.data_chiusura_op) ELSE date_trunc('day',q.data_chiusura_admin) END) >= to_date( '" + chiuso_dal +"' , 'dd/MM/yyyy')";
	
	String chiuso_al = request.getParameter("chiuso_al");
	if(chiuso_al!=null && !chiuso_al.equals(""))
		where+= " and (CASE WHEN NOT q.da_validare THEN date_trunc('day',q.data_chiusura_op) ELSE date_trunc('day',q.data_chiusura_admin) END) <= to_date( '" + chiuso_al +"' , 'dd/MM/yyyy')";
		
	String user_operatore=request.getParameter("operatore");
	if (!ricercaTuttiQuesitiUtente && (primoAccesso && (operatore!=null)) ){
		if(operatore.authorizedFor(Autorizzazione.CC_OPERATORE)){
			// Operatore
			user_operatore=String.valueOf(operatore.id_utente);
		}
	}
	if(user_operatore!=null && !user_operatore.equals("")){
		where+=" and q.id_operatore=" + user_operatore;
	}

	String user_amministratore=request.getParameter("amministratore");
	if(user_amministratore!=null && !user_amministratore.equals("")){
		where+=" and q.id_amministratore=" + user_amministratore;
	}

	String user_smistatore=request.getParameter("smistatore");
	if(user_smistatore!=null && !user_smistatore.equals("")){
		where+=" and q.id_user_smistatore=" + user_smistatore;
	}
	
	query += from + where + order_by;

	QueryPager prevQuesiti = new QueryPager(connPostgres);
	prevQuesiti.set(query);
	
	Logger.write(" ** query quesiti ** " + query);
	//out.println(query);
	
	PreviewQuery prevStati = new PreviewQuery(connPostgres);
	prevStati.setPreview("select sum(CASE WHEN id_stato=1 THEN 1 ELSE 0 END) as attesa, sum(CASE WHEN id_stato=2 THEN 1 ELSE 0 END) as assegnato, sum(CASE WHEN id_stato=3 THEN 1 ELSE 0 END) as trattazione, sum(CASE WHEN id_stato=4 THEN 1 ELSE 0 END) as completato from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_quesiti");
	
	
	PreviewQuery user=new PreviewQuery(connPostgres);
	user.setPreview("select u.id_utente, u.nome, u.cognome, u.email, a.id_autorizzazione from " + Utente.NAME_TABLE + " u,  " + AbstractDocumentoWeb.NAME_SCHEMA + ".rel_utenti_autorizzazioni a where u.id_utente=a.id_utente and a.id_autorizzazione in (" + Autorizzazione.CC_AMMINISTRATORE.getId() + ", " + Autorizzazione.CC_OPERATORE.getId() + ", " + Autorizzazione.CC_SMISTATORE.getId() + ") order by u.cognome" );
	//out.println(user);
%>