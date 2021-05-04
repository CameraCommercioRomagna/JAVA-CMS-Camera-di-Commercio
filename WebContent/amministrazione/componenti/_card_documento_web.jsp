<%	/* input richiesti:
	 *	DocumentoWeb<?> f;*/
	String stile=(f.scaduto() ? "danger" : (f.pubblico() ? "success" : (f.valido() ? "warning" : "secondary")));
	boolean case_non_modificabile_in_padre_secondario = pagina!=null && pagina.getId()!=0 && ((AbstractDocumentoWeb<?>)f).getPadre()!=null && ((AbstractDocumentoWeb<?>)f).getPadre().getId().compareTo(pagina.getId())!=0;%>
<div class="col-xl-4 col-lg-6 col-md-12 ui-state-default" style="margin-top:2rem;" data-id_documento_web="<%=f.getId()%>" data-id_padre="<%=(pagina==null? null : pagina.getId())%>" data-ordine="<%=((AbstractDocumentoWeb<?>)f).getOrdineInPadre((PaginaWeb<?>)pagina)%>">
	<div class="card h-100 border-<%=stile %>" style="margin-left:0.5rem;padding:0;flex-grow:0!important;">
		<div class="card-header bg-<%=stile %>">
			<%	if(!case_non_modificabile_in_padre_secondario){%> <a class="text-white" href="<%=f.getAdminLink()%>"><%	}else{%><span class="text-white"><%	}%>
				<%=f.getTitolo() %>
				<% if ( ( (f instanceof PaginaWeb) && (((PaginaWeb<?>)f).isForward()) ) || (f.getVisibilita() == Visibilita.NON_VISIBILE)){%> <span class="glyphicon glyphicon-eye-close" aria-hidden="true"></span><% } %>
				<% if (case_non_modificabile_in_padre_secondario){%> <i class="fas fa-lock" aria-hidden="true" title="Documento non modificabile se non aperto nel padre principale. (Vedi 'Dove mi trovi')" ></i><% } %>
			<%	if(!case_non_modificabile_in_padre_secondario){%> </a><%	}else{%></span><%	}%>
		</div>
		<div class="card-body">
			<small class="text-info"><%=f.getTipo().toString().toUpperCase() %> <%=f.getId()%></small>
			<p class="card-text"><%=f.getAbstract() %></p>
		<%	if (f.getPubblicazione()!=null){%>
			<p class="card-text"><i><%=(f.valido() ? "Pubblico" : "Pubblicabile") %> dal <%=DateUtils.formatDate(f.getPubblicazione()) %> al <%=DateUtils.formatDate(f.getScadenza()) %></i></p>
		<%	}%>
			<%	if (f.pubblico()){%>
				<%	int indiceRitardo=(int)(f.indiceRitardoAggiornamentoSezione()*100);%>
				<a href="<%=f.getAdminLink()%>&<%=rq_documento %>_tab=Aggiornamento+contenuti" class="card-link<%=(!f.modificabile(operatore) ? " disabled" : "") %>"><%@include file="_bar_ritardo.jsp" %></a>
			<%	}%>
		</div>	
		<!-- Spazio per i link di azione -->
		<div class="card-footer ">
			<%	if(!case_non_modificabile_in_padre_secondario){%>
				<a href="<%=f.getAdminLink()%>" title="Modifica" class="btn btn-<%=stile%>" aria-label="Modifica"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></a>
			<%	}%>
			<%	if(f.getTipo().inseribile(operatore) && !case_non_modificabile_in_padre_secondario){
					id_modal = "modalBoxDuplica"+f.getId();
					href_redirect = "esegui.jsp?" + rq_documento + "=" + f.getId() + "&op=copia";%>
					<a title="Duplica" class="btn btn-<%=stile%>" aria-label="Duplica" data-toggle="modal" data-target="#<%=id_modal%>" href=""><span class="glyphicon glyphicon-duplicate" aria-hidden="true"></span></a>
					<%@include file="/amministrazione/componenti/_modal_confirmation.jsp" %>
			<%	}%>
			
			<a href="<%=f.getPreviewLink()%>" target="_blank" title="Anteprima" class="btn btn-info" aria-label="Anteprima"><span class="glyphicon glyphicon-picture" aria-hidden="true"></span></a>
			<%	if(f.pubblico()){
					if (f instanceof PaginaWeb<?>){%>
						<a href="/amministrazione/index.htm?<%=rq_documento%>=<%=f.getId()%>&<%=rq_documento%>_tab=Crea+Email" target="_blank" title="Crea mail" class="btn btn-primary" aria-label="Crea mail"><span class="glyphicon glyphicon-envelope" aria-hidden="true"></span></a>
				<%	}
					if (!(f instanceof Download)){%>
						<a href="<%=f.getAdminLink()%>&<%=rq_documento %>_tab=Associa+a+newsletter" title="Associa alla newsletter" class="btn btn-primary" aria-label="Associa alla newsletter"><span class="glyphicon glyphicon-share" aria-hidden="true"></span></a>
			<%		}
				}
				if (f instanceof EdizioneInterna){%>
				<a href="/amministrazione/elenco_iscritti.jsp?<%=rq_documento%>=<%=f.getId()%>" target="_blank" title="Iscritti" class="btn btn-info" aria-label="Iscritti"><span class="glyphicon glyphicon-list" aria-hidden="true"></span></a>
			<%	}%>
			
			<%	String lista_padri = "";
				String item_padre = "";
				PaginaWeb<?> padre_curr = ((AbstractDocumentoWeb<?>)f).getPadre();
				if(padre_curr!=null){
					while(padre_curr!=null){
						item_padre = (padre_curr.getTipo().getFigli().size()>0 ? padre_curr.getTipo().toString().toUpperCase() + ": " : "");
						item_padre += padre_curr.getTitolo();
						item_padre += "/ ";
						padre_curr = padre_curr.getPadre();
						lista_padri = item_padre + lista_padri;
					}%>
					<button type="button" class="btn btn-info" data-toggle="popover" data-placement="bottom" aria-label="Dove mi trovi" title="Dove mi trovi" data-content="<%=lista_padri%>"><span class="glyphicon glyphicon-map-marker" aria-hidden="true"></span></button>
			<%	}else{
					if (f.getTipo().getPadri().size()>0){
						id_modal = "assPadre"+f.getId();
						id_requested=f.getId();
						doc_modal = f;%>
						<a data-toggle="modal" data-target="#<%=id_modal%>" href="" title="Nessun padre associato. Associa padre" class="btn btn-warning" aria-label="Nessun padre associato. Associa padre"><span class="glyphicon glyphicon-map-marker" aria-hidden="true"></span><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></a>
						<%@include file="/amministrazione/componenti/_modal_ass_padre.jsp" %>
				<%	}else{
						String chiSono="Sono un documento di tipo " + f.getTipo().toString().toUpperCase();%>
						<button type="button" class="btn btn-info" data-toggle="popover" data-placement="bottom" aria-label="Dove mi trovi" title="Dove mi trovi" data-content="<%=chiSono%>"><span class="glyphicon glyphicon-map-marker" aria-hidden="true"></span></button>
				<%	}
				}%>
				<%	if(f.valido() && (!((f instanceof PaginaWeb) && (((PaginaWeb<?>)f).isForward()) ) || (f.getVisibilita() == Visibilita.NON_VISIBILE))){%>
						
							<button type="button" class="btn btn-info" data-toggle="popover" data-placement="bottom" aria-label="Il mio Link" title="Il mio Link"   data-content="<%=((f.getLink().indexOf("www"))>0? "" : "www.xxx.it")%><%=f.getLink()%>"><span class="glyphicon glyphicon-globe" aria-hidden="true"></span></button>
						
				<%	}%>
			<%	if(f.getTipo() == TipoDocumento.SERVIZIO_ONLINE){
					String urlAmministrazione = null;
					try{
						urlAmministrazione = (String)((Documento)f).getField("url_amministrazione").getValue();
					}catch(Exception e){
						urlAmministrazione = (String)((Referenza)f).getField("url_amministrazione").getValue();
					}%>
					<a href="<%=urlAmministrazione %>" target="_blank" title="Amministra il servizio" class="btn btn-primary" aria-label="Amministra il servizio"><span class="glyphicon glyphicon-cog" aria-hidden="true"></span></a>
			<%	}%>
		</div>
	</div>
</div>