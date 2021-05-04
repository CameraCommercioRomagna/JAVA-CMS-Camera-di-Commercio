<%	if (pagina.pubblico()){%>
		Ultimo aggiornamento dei contenuti della pagina: <%=DateUtils.formatDate(pagina.data_ultimo_aggiornamento, "dd/MM/yyyy HH:mm:ss") %><br/>
		<br/>
	<%	int indiceRitardo=(int)(pagina.indiceRitardoAggiornamento()*100);%>
		Indice di aggiornamento della pagina: <%=100-indiceRitardo + "%" %>
		<%{%><%@include file="/amministrazione/componenti/_bar_ritardo.jsp" %><%}%>
		
	<%	indiceRitardo=(int)(pagina.indiceRitardoAggiornamentoSezione()*100);%>
		Indice di aggiornamento della sezione: <%=100-indiceRitardo + "%" %>
		<%{%><%@include file="/amministrazione/componenti/_bar_ritardo.jsp" %><%}%>
		
	<%	if(tipoSistemaPagina == TipoSistema.DOWNLOAD || tipoSistemaPagina == TipoSistema.LINK){%>
		<p>Per validare il <%if(tipoSistemaPagina == TipoSistema.DOWNLOAD){%>download<%}else{%>link<%}%> occorre:
			<ul>
				<%if(tipoSistemaPagina == TipoSistema.DOWNLOAD){%>
				<li>controllarne il contenuto nella sua interezza tramite anteprima;</li>
				<%}else{%>
				<li>controllarne che l'URL sia funzionante e i contenuti della pagina di riferimento siano ancora validi e confacenti con quelli attesi;</li>
				<%}%>
				<li>premere il pulsante "Conferma aggiornamento contenuti".</li>
			</ul>
		</p>
		<div class="row" style="margin-top:1rem">
			<div class="col-2"></div>
			<div class="col-10">
			<%	id_modal = "modalDuplica"+pagina.getId();
				href_redirect = "/amministrazione/esegui.jsp?" + rq_documento + "=" + pagina.getId() + "&" + rq_operazione + "=" + "conferma_aggiornamento";%>
				<a data-toggle="modal" data-target="#<%=id_modal%>" href="" class="btn btn-success" style="margin-right:2rem;">Confermo aggiornamento contenuti</a>
				<%@include file="/amministrazione/componenti/_modal_aggiornamento.jsp" %>
			</div>
		</div>
	<%	}else{%>	
		<div class="row" style="margin-top:1rem">
			<div class="col-2"></div>
			<div class="col-10"><a href="<%=pagina.getPreviewLink()%>&confermacontenuti=yes" class="btn btn-success">Conferma aggiornamento contenuti</a></div>
		</div>
	<%	}%>	
<%	}else{%>
		<br/><span class="glyphicon glyphicon-info-sign" style="font-size:1.5rem;margin-right:1.2rem;"></span>L'aggiornamento è possibile solo per documenti pubblicati<br/><br/>
<%	}%>