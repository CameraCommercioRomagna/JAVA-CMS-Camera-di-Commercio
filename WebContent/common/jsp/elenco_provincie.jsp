<%--	NOTA che: 	
		- Necessita di una select che inglobi le options
		- Necessita di ua variabile prov che includa il valore corrente della provincia 
			o che corrisponda alla stringa vuota se non c'è selezione--%>
<%	if (prov==null) prov="";%>
	<option value="" <% if(prov.equals("")||prov==null){ %> selected="selected" <%}%>>Seleziona la Provincia</option>
<%	it.cise.sql.PreviewQuery provITA=new it.cise.sql.PreviewQuery(connNew);
	provITA.setPreview("SELECT sigla, nome FROM geografia.provincie ORDER BY nome");
	for (int i=0;i<provITA.getNumberRecords();i++){%>
		<option value="<%=provITA.getField("SIGLA") %>" <% if(prov.equals(provITA.getField("SIGLA"))){ %> selected="selected" <%}%>><%=provITA.getField("NOME") %></option>
	<%	provITA.nextRecord();
	}%>
