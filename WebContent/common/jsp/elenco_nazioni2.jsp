<%	PreviewQuery statiMondo=new PreviewQuery(connNew);
	statiMondo.setPreview("SELECT codice, nome FROM geografia.nazioni WHERE codice is not null ORDER BY nome");
	for (int i=0;i<statiMondo.getNumberRecords();i++){%>
		<option value="<%=statiMondo.getField("CODICE") %>" <% if(statiMondo.getField("NOME").compareTo("Italia")==0){ %> selected="selected" <%}%>><%=statiMondo.getField("NOME") %></option>
	<%	statiMondo.nextRecord();
	}%>
