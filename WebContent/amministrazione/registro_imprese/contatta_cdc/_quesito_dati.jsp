<h3>Dati del quesito</h3>
<p class="alert alert-info" style="font-size:0.9rem">
	N.<%=id_quesito%>
<%	PreviewQuery ins_user=new PreviewQuery(connPostgres);
	ins_user.setPreview("select id_utente, nome, cognome, email, telefono from " + UtenteNl.NAME_TABLE + " where id_utente=" + quesitoPrev.getField(5));%>
	Inserito da <%=ins_user.getField(1)%> <%=ins_user.getField(2)%></b> (<%=(ins_user.getField("telefono").equals("") ? "" : ins_user.getField("telefono") + " - ") %><a href="mailto:<%=ins_user.getField(3)%>"><%=ins_user.getField(3)%></a>) per conto di <%=quesitoPrev.getField("rag_sociale_impresa")%><br/>
	[<span class="glyphicon glyphicon-list-alt" aria-hidden="true" style="margin-right:10px;"></span><a href="/contatta_camera/utente/quesiti.htm?email_utente_quesito=<%=ins_user.getField(3)%>&<%=urlwrapper.toQueryString("back") %>" title="Accedi ai questiti già inviati" target="_blank">Accedi all'elenco dei questiti precedentemente inviati dall'utente</a>]<br/>
	
	<b>Data inserimento:</b> <%=quesitoPrev.getField("data_inserimento")%><br/>
	<%	if((quesitoPrev.getField("num_rea")!=null)&&(!quesitoPrev.getField("num_rea").equals(""))){%>
		<b>Numero REA:</b> <%=quesitoPrev.getField("num_rea")%><br/>
	<%	}else{%>
		<b>Nuova Impresa</b><br/>
		
	<%	}%>
<%	if((quesitoPrev.getField("id_cc_argomento")!=null)&&(!quesitoPrev.getField("id_cc_argomento").equals(""))){
		PreviewQuery prevInteressi=new PreviewQuery(connPostgres);
		prevInteressi.setPreview("select id_cc_argomento, descrizione from " + AbstractDocumentoWeb.NAME_SCHEMA + ".cc_argomenti where id_cc_argomento=" + quesitoPrev.getField("id_cc_argomento"));
		//out.println(prevInteressi);
	%>
		<b>Area Interessi:</b> <%=prevInteressi.getField(1)%><br/>
	<%}%>
	<b>Oggetto del quesito:</b> <%=org.apache.commons.lang.StringEscapeUtils.unescapeHtml(quesitoPrev.getField("oggetto"))%><br/>
	<b>Quesito:</b> <%=org.apache.commons.lang.StringEscapeUtils.unescapeHtml(quesitoPrev.getField("testo_quesito"))%><%=(quesitoPrev.getField("testo_quesito_1").equals("") ? "" : org.apache.commons.lang.StringEscapeUtils.unescapeHtml(quesitoPrev.getField("testo_quesito_1"))) %><%=(quesitoPrev.getField("testo_quesito_2").equals("") ? "" : org.apache.commons.lang.StringEscapeUtils.unescapeHtml(quesitoPrev.getField("testo_quesito_2"))) %><br/>
</p>
<%	if((!quesitoPrev.getField("allegato_f0").equals(""))||(!quesitoPrev.getField("allegato_f1").equals(""))||(!quesitoPrev.getField("allegato_f2").equals(""))){%>
<h3 class="gray-colored">Allegati inseriti</h3>
	<ul style="font-size:1rem;">
		<%if(!quesitoPrev.getField("allegato_f0").equals("")){%><li><a href="<%=quesitoPrev.getField("allegato_f0")%>" target="_blank">Visualizza allegato 1</a></li><%}%>
		<%if(!quesitoPrev.getField("allegato_f1").equals("")){%><li><a href="<%=quesitoPrev.getField("allegato_f1")%>" target="_blank">Visualizza allegato 2</a></li><%}%>
		<%if(!quesitoPrev.getField("allegato_f2").equals("")){%><li><a href="<%=quesitoPrev.getField("allegato_f2")%>" target="_blank">Visualizza allegato 3</a></li><%}%>
	</ul>
<%	}%>
