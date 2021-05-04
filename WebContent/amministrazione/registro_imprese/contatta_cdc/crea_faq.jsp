<%@include file="/amministrazione/common/include/begin.jsp" %>

<%	String ID_quesito=request.getParameter("ID_q");
	if(ID_quesito!=null && !ID_quesito.equals("")){
		PreviewQuery dati_quesito=new PreviewQuery(connPostgres);
		dati_quesito.setPreview("select id_quesito, oggetto, testo_quesito, id_area_servizio, id_area_interesse from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_quesiti where id_quesito=" + ID_quesito);
		out.println(dati_quesito);
		PreviewQuery risposta_quesito=new PreviewQuery(connPostgres);
		risposta_quesito.setPreview("select id_quesito, id_risposta, testo_risposta from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_risposte where id_quesito=" + ID_quesito + " order by id_risposta");
		
		try{
			//padre = AREA TEMATICA: Registro Imprese/ COMPETENZA: Atti societari e bilanci/ Procedimento 11: Guide
			AbstractDocumentoWeb padre = (AbstractDocumentoWeb<?>)DocumentFactory.load(connPostgres, 11l);
			AbstractDocumentoWeb doc_faq = (AbstractDocumentoWeb<?>)padre.creaFiglio(operatore, TipoSistema.DOCUMENTO, TipoDocumento.FAQ, false);
		}catch(Exception e){
			e.printStackTrace();
		}
		
		doc_faq.titolo = dati_quesito.getField("oggetto");
		doc_faq.abstract_txt = "Quesito riguardante";
		doc_faq.data_pubblicazione = new Date();
		doc_faq.data_scadenza=DateUtils.addDays(new Date(), 365);
		doc_faq.update();
		
		
		Paragrafo paragrafo_curr1 = new Paragrafo(doc_faq);
		paragrafo_curr1.testo="<b>" + dati_quesito.getField("testo_quesito") + "</b>";
		paragrafo_curr1.ordine = 0l;
		paragrafo_curr1.insert();
		
		for (int j=1; j<=risposta_quesito.getNumberRecords(); j++){
			Paragrafo paragrafo_curr_j = new Paragrafo(doc_faq);
			paragrafo_curr_j.testo=risposta_quesito.getField("testo_risposta");
			paragrafo_curr_j.ordine = j;
			paragrafo_curr_j.insert();
			risposta_quesito.nextRecord();
		}
		
		SQLTransactionManager sqlUpdate = new SQLTransactionManager(this, connPostgres);
		sqlUpdate.executeCommandQuery("update " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_quesiti set FAQ="+doc_faq.id_documento_web+" where id_quesito= "+ID_quesito) ;

		response.sendRedirect("/amministrazione/?"+rq_documento+"="+doc_faq.id_documento_web);

		
	}
%>
