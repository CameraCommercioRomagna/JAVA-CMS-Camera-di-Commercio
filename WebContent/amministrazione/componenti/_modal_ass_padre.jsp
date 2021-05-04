<%	/* input richiesti:
	 *	String id_modal;
		Long id_requested;
		DocumentoWeb doc_modal
		CdCURLWrapper urlwrapper*/%>

<!-- init Modal -->
	<div class="modal fade" id="<%=id_modal%>" tabindex="-1" role="dialog" aria-labelledby="modalTitle<%=id_modal%>" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h3 class="modal-title" id="exampleModalLabel">Associa padre</h3>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<form name="formAss" method="post" action="/amministrazione/esegui.jsp" class="form-control-cciaa-sm">
				<div class="modal-body">
					<div class="alert alert-info">
						Ricordati che per il documento "<%=doc_modal.getTipo().toString().toUpperCase()%>" puoi inserire solo padri di tipo:
						<ul>	
					<%	for(TipoDocumento td : doc_modal.getTipo().getPadri()){%>
							<li><%=td.toString().toUpperCase()%></li>
					<%	}%>
						</ul>
						In caso di associazione con un padre di tipo diverso l'operazione non avrà alcun esito.
					</div>
					Puoi associare un padre inserendo nel campo sottostante il suo URL oppure direttamente il suo ID
					<div class="form-group row">
						<label for="<%=rq_operazione+"_associa_padre_url"%>" class="col-sm-2 col-form-label"><b>Padre</b>*</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="<%=rq_operazione+"_associa_padre_url"%>" name="<%=rq_operazione+"_associa_padre_url"%>" required value="" /> 
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<input type="Hidden" name="<%=rq_operazione %>" value="associa_padre" />
					<input type="Hidden" name="<%=rq_documento %>" value="<%=id_requested%>" />
					<input type="hidden" name="back" value="<%=urlwrapper.getResourceName() %>" />
				<%	for (String name: parameters_filtri_dweb_tot){
						for (String value: urlwrapper.getParameter(name)){%>
					<input type="hidden" name="back_<%=name %>" value="<%=value %>" />
				<%		}
					}%>
					<button type="submit" class="btn btn-primary">Associa</button>
					<button type="button" class="btn btn-secondary" data-dismiss="modal">Annulla</button>
				</div>
				</form>
			</div>
		</div>
	</div>
<!-- fine Modal -->