<%--	NOTA che: 	
		- Necessita di una select che inglobi le options
		- Necessita di ua variabile stato che includa il valore corrente della provincia 
			o che corrisponda alla stringa vuota se non c'è selezione--%>
<%	if (stato==null) stato="";%>
	<option value="" <% if(stato.equals("")){ %> selected="selected" <%}%>>Seleziona lo Stato</option>
<%	PreviewQuery statiMondo=new PreviewQuery(connNew);
	statiMondo.setPreview("SELECT codice, nome FROM geografia.nazioni WHERE codice is not null ORDER BY nome");
	for (int i=0;i<statiMondo.getNumberRecords();i++){%>
		<option value="<%=statiMondo.getField("CODICE") %>" <% if(stato.equals(statiMondo.getField("CODICE"))){ %> selected="selected" <%}%>><%=statiMondo.getField("NOME") %></option>
	<%	statiMondo.nextRecord();
	}%>
