<%--	Visualizza un elenco di documenti a lista

		Parametri richiesti:
		 - PaginaWeb<?> pagina // pagina padre se esiste (null se non esiste)
		 - List<DocumentoWeb<?>> documenti;	// Lista dei documenti da rappresentare
		 - TipoDocumento tipo;			// Tipologia dei documenti rappresentati (null se non è unica)
		 - boolean visualNumerosita;	// Definisce se deve essere vista la numerosità dei documenti (stile motore di ricerca) 
		 - boolean visualInfo;			// Definisce se deve essere vista la numerosità dei documenti (stile motore di ricerca) 
		 --%>
	<ul class="list-group">
<%	if (visualNumerosita){%>
		<h2 style="margin:2rem;" role="status"><%=(tipo!=null ? tipo.getNomePlurale() : "Documenti") %> trovati: <%=documenti.size() %></h2>
<%	}%>
<%	if(tipo!=null && tipo.compareTo(TipoDocumento.COMUNICATO_STAMPA)==0){
		documenti.sort(new Comparator<DocumentoWeb>() {
			@Override
			public int compare(DocumentoWeb d1, DocumentoWeb d2) {
				return d2.getPubblicazione().compareTo(d1.getPubblicazione());
			}
		});
	}%>
	<%for (DocumentoWeb<?> documento: documenti){%>
		<li class="list-group-item">
			<a href="<%=documento.getLink()%>"><%=documento.getTitolo()%></a>
			<p class="card-text" style="margin-bottom:0.5rem">
			<%	try{
					if ((!documento.getIcona().equals(""))&&(!documento.getIcona().equals(documento.getTipo().getIcona()))){%>
						<img class="float-left img-fluid img-thumbnail" style="max-width:150px; margin:0.3rem 0.6rem 0.3rem 0" src="<%=documento.getIcona() %>" alt="Immagine di <%=documento.getTitolo() %>"  />
				<%	}%>
			<%	}catch(Exception e){}%>
				<%=documento.getAbstract() %><br/>
			<%	if (visualInfo){
					try{
						String info=documento.getInfo();%>
						<span class="text-success"><%=info %></span><br/>
			<%		}catch(Exception e1){}
				}%>
			</p>
		</li>
<%	}
	if(!visualNumerosita && documenti.size()==0){%>
	<%	if (pagina!=null && (pagina.getTipo() == TipoDocumento.AMMINISTRAZIONE_TRASPARENTE || pagina.getTipo() == TipoDocumento.SEZIONE_AMMINISTRAZIONE_TRASPARENTE)){%>
		<p style="margin:2rem;">Non sono ci sono documenti in questa sezione.<br />Puoi cercare in Archivio o nelle altre cartelle del box "In questa sezione".</p>
	<%	}else{%>
		<p style="margin:2rem;">Non sono presenti <%=(tipo!=null ? tipo.getNomePlurale() : "Documenti") %></p>
<%		}
	}%>
	</ul>
