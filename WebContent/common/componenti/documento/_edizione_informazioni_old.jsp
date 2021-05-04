<%--	Visualizza le informazioni generali di un'edizione evento
		Parametri richiesti:
		 - EdizioneInterna edizione;
		 - boolean visualCompatta;
--%>

<%	String luogo=edizione.luogoENote();
	String periodo=edizione.periodoENote();
	List<Organizzatore> organizzatori=edizione.getOrganizzatori(TipoCollaborazione.ORGANIZZATORE);
	List<PuntoProgramma> programma=edizione.getProgramma();
	List<AttoEvento> atti=edizione.getAtti();%>
	
<%	if(!visualCompatta){%>
	<h2 style="margin-top:2rem;border-bottom:2px solid #ddd;"><span class="glyphicon glyphicon-hand-right"></span> Contenuti</h2>
<%	}%>
	<p style="margin-top:0.5rem;">
		<%=edizione.getAbstract() %><br/>
	<%	if(!visualCompatta){%>
		<a href="<%=pagina.getPadre().getLink() %>"><span class="glyphicon glyphicon-hand-right"></span> Approfondisci i contenuti</a>
	<%	}%>
	</p>
<%	if(!luogo.equals("")||(!periodo.equals(""))){%>
	<%	if(!visualCompatta){%>
		<h2 style="margin-top:2rem;border-bottom:2px solid #ddd;"><span class="glyphicon glyphicon-pushpin"></span> Come, dove e quando</h2>
	<%	}%>
	<%	if(!luogo.equals("")){%>
			<a href="https://maps.google.it/maps?f=q&hl=it&q='<%=eliminaAccenti(luogo.replace(" ", "-"))%>'.&z=10&source=embed" style="color:#0000FF;text-align:left" title="Collegamento a Google Maps" target="_blank">
				<iframe width="250" height="180" src="https://maps.google.it/maps?f=q&hl=it&q='<%=eliminaAccenti(luogo.replace(" ", "-"))%>>'&output=embed" style="border: 1px solid rgba(0,0,0,.125); float:right; margin:0 0 0.5rem 1rem;"></iframe>
			</a>
	<%	}%>
		<%if(!luogo.equals("")){%><p style="margin-top:1.5rem;"><span class="glyphicon glyphicon-map-marker"></span> <span class="text-color" >Luogo:</span> <%=luogo%> </p><%}%>
		<%if(!periodo.equals("")){%><p><span class="glyphicon glyphicon-calendar"></span> <span class="text-color">Data:</span> <%=periodo%></p><%}%>
		<p><span class="glyphicon glyphicon-<%=(edizione.a_pagamento!=null && edizione.a_pagamento ? "euro" : "user") %>"></span> <%=(edizione.a_pagamento!=null && edizione.a_pagamento ? "Evento a pagamento" : "Evento a partecipazione gratuita") %></p>
<%	}%>




