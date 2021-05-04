<!--
	input richiesti:
		DocumentoWeb<?> n;				// Documento da visualizzare
		Boolean visualAbstract;			// Definisce se visualizzare anche l'abstract; default false
 -->
 
 <%	if (n.accessibile(operatore)){%>
	<span class="glyphicon <%if (n instanceof Download){%>glyphicon-download<%}else{%>glyphicon-link<%}%>" aria-hidden="true"></span> 
	<span style="font-size:0.9rem"><a class="menu_attivita" href="<%=n.getLink()%>">
	<%	if(n instanceof Edizione){
			if(((Edizione)n).periodo()!=null){%>
				<%=((Edizione)n).periodo()%>
	<%		}
			if(((Edizione)n).getLuogo()!=null){%>
			, <%=((Edizione)n).getLuogo().getCitta()%>
			<%}
		}%>
		<%=n.getTitolo()%></a></span><br/>
	<%	if (visualAbstract){%>
		<%=n.getAbstract()%><br/>
	<%	}%>
<%	}%>