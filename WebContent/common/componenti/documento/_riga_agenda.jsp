<!--
	input richiesti:
		Edizione e;		// Edizione evento da visualizzare
		Boolean visualAbstract;	// Definisce se visualizzare anche l'abstract; default false
		boolean visualAgendaDatiCompatti; // visualizza titolo/abstract dell'edizione
		ModalitaVisualizzazioneData modVisualAgenda; // per impostare i parametri della visualizzazione larga o stretta
 -->
 <%String visualText="";%>

 <%	if (e.accessibile(operatore)){%>
	 <%if(!e.archiviato()){%>
			<div class="row row-striped" style="margin-right:0px; margin-left:0px;" >
				<div class="col-md-<%=modVisualAgenda.getColonne() %> text-right d-inline">
					<h2 style="font-size:2rem;"><span class="badge badge-secondary badge-camera"><%=DateUtils.formatDate(e.getDal(), "dd") %></span></h2>
					<h3><%=DateUtils.formatDate(e.getDal(), "MMM").toUpperCase() %></h3>
					<h3 style="font-weight:normal; font-size:1.3rem; color:#535353"><%=DateUtils.formatDate(e.getDal(), "YYYY") %></h3>
				</div>
				<div class="col-md-<%=(12 - modVisualAgenda.getColonne()) %>" <%=(modVisualAgenda!=ModalitaVisualizzazioneData.SMALL && !visualAgendaDatiCompatti? "style='padding-left:2rem;'":"")%>>
				<%	if(!visualAgendaDatiCompatti){%>
					<h4>
						<%	if (e.getTipo() == TipoDocumento.EDIZIONE_EVENTO_CISE){%>
						<span style="font-size:0.9rem; font-weight:normal;">L'azienda speciale CISE propone:<br/></span>
					<%	}%>
						<a href="<%=e.getLink()%>" class="color_blu"><%=e.getTitolo()%></a>
					</h4>
				<%}%>
					<ul class="list-inline">
					<%	if(e.getLuogo()!=null){%><li class="small"><span class="glyphicon glyphicon-map-marker" ></span> <%=e.getLuogo()%></li><%}%>
					<%	if(modVisualAgenda!=ModalitaVisualizzazioneData.SMALL && !visualAgendaDatiCompatti){%>
							<li class="small"  style="margin-top:0.5rem;"><%=e.getAbstract()%></li>
					<%	}%>
					<%	if(modVisualAgenda==ModalitaVisualizzazioneData.SMALL){%>
							<%visualText="noVisulal";%>
					<%	}%>
						<li class="small" style="margin-top:0.5rem;">
							<div class="row no-gutters classeAgenda">
							<%	if (e instanceof EdizioneInterna){
									EdizioneInterna eInterna=(EdizioneInterna)e;
									%>
									<a href="<%=eInterna.getPadre().getLink()%>" class="color_blu" style="margin-right:0.5rem;" title="Contenuti" aria-label="Contenuti <%=e.getTitolo()%>"><span class="glyphicon glyphicon-hand-right" aria-hidden="true"></span> <span class="<%=visualText%>"><strong>Contenuti</strong></span></a>
								<%	if(modVisualAgenda==ModalitaVisualizzazioneData.SMALL){%>
										<br/>
								<%	}%>
									<a href="<%=e.getLink()%>" class="color_blu" style="margin-right:0.5rem;" title="Programma" aria-label="Programma <%=e.getTitolo()%>"><span class="glyphicon glyphicon-time" aria-hidden="true"></span> <span class="<%=visualText%>"><strong>Programma</strong></span></a>
								<%	try{
										Date oggi = cise.utils.DateUtils.stringToDate(cise.utils.DateUtils.formatDate(new Date(),"dd/MM/yyyy"));
										if (!eInterna.getDataScadenzaIscrizione().before(oggi)){%>
											<a href="<%=eInterna.getLinkIscrizione() %>" class="color_blu" title="Iscriviti" aria-label="Iscriviti a <%=e.getTitolo()%>"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span> <span class="<%=visualText%>"><strong>Iscriviti</strong></span></a>
									<%	}
									}catch(Exception e1){}%>
									<br/><br/>
									<p style="margin-bottom:0;">
									<span class="glyphicon glyphicon-<%=(eInterna.a_pagamento!=null && eInterna.a_pagamento ? "euro" : "user") %>" aria-hidden="true"></span> 
										<%=(eInterna.a_pagamento!=null && eInterna.a_pagamento ? "Evento a pagamento" : "Evento gratuito") %>
									</p>
							<%	}else{%>
									<a href="<%=e.getLink()%>" class="color_blu" style="margin-right:0.5rem;" title="Programma"><span class="glyphicon glyphicon-time" aria-hidden="true"></span> <span class="<%=visualText%>"><strong>Programma</strong></span></a>
							<%	}%>
							</div>
						</li>
					</ul>
				</div>
			</div>
	 <%}else{%>
			 <div class="card" style="border:0px!important;padding-top:0.5rem;padding-left:0.5rem;padding-right:0.5rem;">
				<div class="row no-gutters" style="border-bottom:2px solid #cccccc !important;border-top:0px!important;">
					<div class="col-auto" style="padding-bottom:0.5rem;">
						<%if((e.getIcona()!=null)&&(!e.getIcona().equals("")) && (!e.getIcona().equals("/imgs/tipi_documento_web/"))){%>
							<img src="<%=e.getIcona()%>" class="img-fluid" alt="" style="width:5rem;">
						<%}%>
					</div>
					<div class="col">
						<div class="card-block px-2">
							<h4 class="card-title" style="font-size:0.9rem; margin-bottom:0.3rem;"><a href="<%=e.getLink()%>" class="color_blu"><%=e.getTitolo()%></a></h4>
							<p class="card-text" style="font-size:0.8rem;"><%=DateUtils.formatDate(e.getDal(), "dd/MM/yyyy") %><%if(e.getLuogo()!=null){%> - <%=e.getLuogo()%><%}%>
							<%	if (e instanceof EdizioneInterna){
									List<AttoEvento> e_atti = ((EdizioneInterna)e).getAtti();
									if(e_atti!=null && e_atti.size()>0){
										String link_atto = e_atti.size()==1 ? e_atti.get(0).getLink() : e.getLink();%>
										<br/><a href="<%=e.getLink()%>#Atti" class="color_blu" style="margin-right:0.5rem;" title="Atti"><span class="glyphicon glyphicon-file" aria-hidden="true"></span> <span class="<%=visualText%>"><strong>Atti evento</strong></span></a>
								<%	}%>
							<%	}%>
							</p>
						</div>
					</div>
				</div>
			</div>
		 
	<% }%>
<%	}%>