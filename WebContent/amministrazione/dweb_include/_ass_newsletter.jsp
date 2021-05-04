
<%	boolean raggiunto_numero_max=false;
	int numero_pubblicazioni=0;
	
	for (NewsLetter tipo_nl: NewsLetter.loadEntitiesFromQuery("select * from " + NewsLetter.NAME_TABLE, connPostgres, NewsLetter.class)){
		List<PromozioneDocumentoWeb> promozioni = pagina.getPromozioniSuNewsletter(tipo_nl);
		numero_pubblicazioni = promozioni.size();
		raggiunto_numero_max = !(numero_pubblicazioni<tipo_nl.num_max_numeri.intValue());
		//nuova associazione
		PromozioneDocumentoWeb promo = new PromozioneDocumentoWeb(pagina);
		Long id_nl_pubblicazione = null;
		NumeroNewsLetter numeroNewsletter = null;
		List<NumeroNewsLetter> nnl_list = NumeroNewsLetter.loadEntitiesFromQuery("select * from " + NumeroNewsLetter.NAME_TABLE + " where id_nl_tipo=" + tipo_nl.id_nl_tipo + " and data_pubblicazione is null and id_nl_numero not in (select id_nl_numero from " + PromozioneDocumentoWeb.NAME_TABLE + " where id_documento_web=" + pagina.getId() + ") order by data",connPostgres,NumeroNewsLetter.class);
	%>

<h3 class="blu-colored" style="margin-top:1rem;"><b><%=tipo_nl.nome %></b></h3>
	<%	if(tipo_nl.descrizione!=null){%>
	<p><%=tipo_nl.descrizione %></p>
	<%	}%> 
	<%	if(promozioni.size()==0){%>
	<div class="alert alert-info" role="alert"><span class="glyphicon glyphicon-info-sign" style="font-size:1.5rem;margin-right:1.2rem;"></span> Il documento non è mai stato associato ad un numero di <%=tipo_nl.nome %></div>
	<%	}%>
		
<div class="list-group">
	<div id="nuova_associazioneNL<%=tipo_nl.id_nl_tipo%>" role="tablist" aria-multiselectable="false">
		<div class="card">
			<div class="list-group-item list-group-item-primary" role="tab" id="associazioneNLT<%=tipo_nl.id_nl_tipo%>-00">
				<div class="d-flex w-75 justify-content-between">
					<h5 class="mb-1"><a data-toggle="collapse" data-parent="#nuova_associazioneNL<%=tipo_nl.id_nl_tipo%>" href="#associazioneNL<%=tipo_nl.id_nl_tipo%>-00" aria-expanded="false" aria-controls="associazioneNL<%=tipo_nl.id_nl_tipo%>-00"><span class="glyphicon glyphicon-plus"></span> Inserisci nuova associazione</a></h5>
				</div>
			</div>
			<div id="associazioneNL<%=tipo_nl.id_nl_tipo%>-00" class="collapse" role="tabcard" aria-labelledby="associazioneNLT<%=tipo_nl.id_nl_tipo%>-00">
				<div class="card-body" style="padding-left:5rem;">
					<%@include file="/amministrazione/dweb_include/_ass_newsletter_contenuto.jsp" %>
				</div>
			</div>
		</div>
	</div>
	
	<%	if(promozioni.size()>0){%>
		<div class="list-group-item list-group-item-<%=(raggiunto_numero_max ? "warning" : "success")%>" style="margin-top:2rem;">
			<div class="d-flex w-75 justify-content-between">
				<h5 class="text-<%=(raggiunto_numero_max ? "warning" : "success")%>">La notizia è attualmente pubblicata in <%=numero_pubblicazioni %> newsletter</h5>
			</div>
		</div>
		<div id="associazioniNL<%=tipo_nl.id_nl_tipo%>" role="tablist" aria-multiselectable="false">
		<%	for(PromozioneDocumentoWeb p : promozioni){
				promo  = p;
				id_nl_pubblicazione = promo.id_nl_pubblicazione;
				numeroNewsletter = promo.getNumeroNewsletter();
				Boolean numeroNewsletter_modificabile = numeroNewsletter.isModificabile();%>
			<div class="card border-light">
			<%	if(numeroNewsletter_modificabile){%>
				<div class="card-header" role="tab" id="associazioneNLT<%=id_nl_pubblicazione%>">
					<h5 class="card-title">
						<a data-toggle="collapse" data-parent="#associazioniNL<%=tipo_nl.id_nl_tipo%>" href="#associazioneNL<%=tipo_nl.id_nl_tipo%>-<%=id_nl_pubblicazione%>" aria-expanded="false" aria-controls="associazioneNL<%=tipo_nl.id_nl_tipo%>-<%=id_nl_pubblicazione%>">
							<%=" - Numero del " + cise.utils.DateUtils.formatDate(numeroNewsletter.data) + " nella sezione \"" + promo.sezione + "\""  %>
						</a>
					</h5>
				</div>
				<div id="associazioneNL<%=tipo_nl.id_nl_tipo%>-<%=id_nl_pubblicazione%>" class="collapse" role="tabcard" aria-labelledby="associazioneNLT<%=tipo_nl.id_nl_tipo%>-<%=id_nl_pubblicazione%>">
					<div class="card-body" style="padding-left:5rem;">
						<%@include file="/amministrazione/dweb_include/_ass_newsletter_contenuto.jsp" %>
					</div>
				</div>
			<%	}else{%>
				<div class="card-header">
					<h5 class="card-title"><%="Associazione al numero del " + cise.utils.DateUtils.formatDate(numeroNewsletter.data) + " nella sezione \"" + promo.sezione + "\""  %></h5>
				</div>
			<%	}%>	
			</div>
		
		<%	}%>
		</div>

	<%	}%>
	</div>

<%	}%>
