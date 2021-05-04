
<form name="forminsert" method="post" action="/amministrazione/newsletter/esegui_newsletter.jsp" class="form-control-cciaa-sm">
<%	for (Sezione sez: tipo_newsLetter.getSezioni()){
		if(sez.isValida()){%>
			<h3 style="margin-top:1rem;"><%=sez.nome %></h3>
		<%	List<PromozioneDocumentoWeb> list = numero_nl.getDocumentiPubblicabili(sez);
			if(list.size()>0){
				for (PromozioneDocumentoWeb pdweb: list){
					DocumentoWeb dweb = pdweb.getDocumento(); %>

					<div role="tablist" aria-multiselectable="false">
						<div class="card border-light">
							<div class="card-header" role="tab">
								<div class="row">
									<div class="col-1">
										<input type="checkbox" id="check<%=dweb.getId()%>" name="check<%=dweb.getId()%>" value="true" <%=(pdweb.isApprovato() ? "checked" : "")%>/>
										<input type="number" id="ordine<%=dweb.getId()%>" name="ordine<%=dweb.getId()%>" value="<%=(pdweb.ordine!=null ? pdweb.ordine : "") %>" style="width:3rem;" />
									</div>
									<div class="col-9">
										<h5 class="card-title"><b><%=dweb.getTitolo() %></b></h5>
										<p class="small"><%=dweb.getAbstract() %></p>
											<%if(!dweb.valido()){%>
												<p style="color:red;">Documento svalidato</p>
											<%}%>

									</div>
									<div class="col-2">
										<a href="/amministrazione/?<%=rq_documento%>=<%=dweb.getId()%>" target="_blank" title="Modifica" class="btn btn-primary" aria-label="Modifica"><span class="glyphicon glyphicon-pencil" aria-hidden="true"></span></a>
										<a href="<%=dweb.getPreviewLink()%>" target="_blank" title="Anteprima" class="btn btn-info" aria-label="Anteprima"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></a>
									</div>
								</div>
							</div>
						</div>
					</div>

	<%			}
			}else{%>
				<div role="tablist" aria-multiselectable="false">
					<div class="card border-light">
						<div class="card-header" role="tab">
							<p class="small">Nessun documento associato</p>
						</div>
					</div>
				</div>
<%			}
		}	
	}%>
	<div style="margin-top:2rem;"  class="form-group row">
		<div class="col-sm-2 col-form-label"></div>
		<div class="col-sm-10"><button type="submit" style="width:250px;" class="btn btn-success">Approva</button></div>
	</div>

	<input type="Hidden" name="back" value="/amministrazione/newsletter/index.htm" />
	<input type="Hidden" name="back_<%=rq_tipo_newsLetter%>" value="<%=tipo_newsLetter.id_nl_tipo %>" />
	<input type="Hidden" name="back_<%=rq_numero_newsLetter%>" value="<%=numero_nl.id_nl_numero %>" />

	<input type="Hidden" name="<%=rq_tipo_newsLetter%>" value="<%=tipo_newsLetter.id_nl_tipo %>" />
	<input type="Hidden" name="<%=rq_numero_newsLetter%>" value="<%=numero_nl.id_nl_numero %>" />
	<input type="Hidden" name="<%=rq_operazione %>" value="approva" />
</form>
