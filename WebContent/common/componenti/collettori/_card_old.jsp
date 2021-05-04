<%--	Visualizza un elenco di documenti come sequenza di card

		Parametri richiesti:
		 - List<DocumentoWeb<?>> documenti = risultatoRicerca;	// Lista dei documenti da rappresentare
		 - TipoDocumento tipo;			// Tipologia dei documenti rappresentati (null se non è unica)
		 - boolean visualNumerosita;	// Definisce se deve essere vista la numerosità dei documenti (stile motore di ricerca) 
		 --%>
<%	if (visualNumerosita){%>
		<h2 style="margin:2rem;"><%=documenti.size() %> <%=(tipo!=null ? tipo.getNomePlurale() : "Documenti") %> trovati</h2>
<%	}%>
	<div class="row">
<%	for (DocumentoWeb<?> documento: documenti){%>
		<div class="col-xl-4 col-lg-6 col-md-12" style="margin-top:2rem; margin-bottom:2rem;">
			<div class="card h-100 " style="margin-left:0.5rem;padding:0;flex-grow:0!important;">
				<div class="card-header header_bg">
					<a href="<%=documento.getLink()%>"><%=documento.getTitolo()%></a>
				</div>
				<div class="card-body">
						<p class="card-text">
					<%	try{
							if ((!documento.getIcona().equals(""))&&(!documento.getIcona().equals(documento.getTipo().getIcona()))){%>
								<img class="float-left img-fluid img-thumbnail" style="max-width:40%; margin:0.3rem 0.3rem 0.3rem 0" src="<%=documento.getIcona() %>" alt="Immagine di <%=documento.getTitolo() %>"  />
						<%	}
						}catch(Exception e){}%>
						<%=documento.getAbstract() %></p>
				</div>	
				<div class="card-footer ">
					<a href="<%=documento.getLink()%>" title="Visualizza" class="btn btn-info">Visualizza dettagli</a>
				</div>
			</div>
		</div>
<%	}
	if(!visualNumerosita && documenti.size()==0){%>
		<p style="margin:2rem;">Non sono presenti <%=(tipo!=null ? tipo.getNomePlurale() : "Dcoumenti") %></p>
<%	}%>
	</div>