<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@include file="_load_pagina.jsp" %>

<%	response.setContentType("application/vnd.ms-excel");%>

<%	PreviewQuery prev = new PreviewQuery(connPostgres);
	String query = "SELECT DISTINCT id_iscrizione, rag_sociale as \"Organizzazione\", p_iva, c_fiscale, attivita_azienda as \"Attivita\", ruolo, nome, cognome, indirizzo, num_civ, cap, comune, provincia, stato, telefono, email, incontro_relatori as \"Interessato incontro col relatore\", info_relatori as \"Nome del relatore\", interesse_atti as \"Interessato agli atti\", data_iscrizione, note, modalita_di_presenza from portalowner2.rel_documenti_web_iscrizioni where id_documento_web=" + pagina.getId();
	prev.setPreview(query);
	session.setAttribute("prevIscrizioniEvento", prev);
	response.sendRedirect("/servlet/CreateXLS?preview_xls=prevIscrizioniEvento");%>
