<%--	Visualizza un elenco di documenti come sequenza di card

		Parametri richiesti:
		 - List<DocumentoWeb<?>> documenti = risultatoRicerca;	// Lista dei documenti da rappresentare
		 - TipoDocumento tipo;			// Tipologia dei documenti rappresentati (null se non è unica)
		 - boolean visualNumerosita;	// Definisce se deve essere vista la numerosità dei documenti (stile motore di ricerca) 
		 --%>
<%
	PaginaWeb<?> pag_padre = null;
	Documento doc=null;%>
<%	if (visualNumerosita){%>
		<h2 style="margin:2rem;" role="status"> <%=(tipo!=null ? tipo.getNomePlurale() : "Documenti") %> trovati</h2>
<%	}%>
	<div class="row">
	
<%	for (DocumentoWeb<?> documento: documenti){%>
	<%	if(tipo==TipoDocumento.STRUTTURA_CAMERALE){
			doc=(Documento)documento;
			pag_padre=doc.getPadre();
		}%>
		<%if((tipo!=TipoDocumento.STRUTTURA_CAMERALE)||((pag_padre!=null)&&((pag_padre.getTipo()==TipoDocumento.AREA_TEMATICA)||(pag_padre.getTipo()==TipoDocumento.COMPETENZA)))) {%>
			
		<div class="col-xl-4 col-lg-6 col-md-12" style="margin-top:2rem; margin-bottom:2rem;">
			<div class="card h-100 " style="margin-left:0.5rem;padding:0;flex-grow:0!important;">
				<div class="card-header header_bg">
				<% if(tipo.compareTo(TipoDocumento.STRUTTURA_CAMERALE)==0){%>
					<h5 style="color:#ffffff;">
					<% if(pag_padre!=null){%>
						<a href="<%=pag_padre.getLink()%>"><%=pag_padre.getTitolo()%></a>
					<% }%>
					</h5>
				<% }else{%>
					<a href="<%=documento.getLink()%>"><%=documento.getTitolo()%></a>
				<% }%>
				</div>
				<div class="card-body">
						
					<%	try{
							if ((!documento.getIcona().equals(""))&&(!documento.getIcona().equals(documento.getTipo().getIcona()))){%>
								<img class="float-left img-fluid img-thumbnail" style="max-width:40%; margin:0.3rem 0.3rem 0.3rem 0" src="<%=documento.getIcona() %>" alt="Immagine di <%=documento.getTitolo() %>"  />
						<%	}
						}catch(Exception e){}%>
						
						<%if(tipo.compareTo(TipoDocumento.STRUTTURA_CAMERALE)==0){%>
							
							<p style="margin:0 0 0.2rem;"><strong><%=doc.getTitolo()%></strong></p>
							
							<%List<Paragrafo> par=doc.getParagrafi();
							for (Paragrafo p: par){%>
								<%	if ((p.titolo!=null)&&(!p.titolo.equals(""))){%>
									<p style="margin:0;"><strong><%=p.titolo %></strong></p> 
								<%	}%>
								<%	if (p.testo!=null){%>
										<div style="font-size:0.9rem; line-height: 1.2;"><%=p.testo %></div>
							<%	}%>
							</p>
						<%	}%>
										
						<%}else{%>
							<p class="card-text">
								<%=documento.getAbstract() %>
							</p>
						<%}%>
				</div>	
				<%if(tipo!=TipoDocumento.STRUTTURA_CAMERALE){%>
					<div class="card-footer ">
						<a href="<%=documento.getLink()%>" title="Visualizza" class="btn btn-info">Visualizza dettagli</a>
					</div>
				<%}%>
			</div>
		</div>
		<%}%>
<%	}
	if(!visualNumerosita && documenti.size()==0){%>
		<p style="margin:2rem;">Non sono presenti <%=(tipo!=null ? tipo.getNomePlurale() : "Dcoumenti") %></p>
<%	}%>
	</div>
