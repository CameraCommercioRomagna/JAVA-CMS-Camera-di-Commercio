<%	/* input richiesti:
	 *	String id_modal;
		EmailWeb email_modal
		String form_action
		String form_add_input_hidden
		String name_field_img*/%>

<!-- init Modal -->
	<div class="modal fade" id="<%=id_modal%>" tabindex="-1" role="dialog" aria-labelledby="modalTitle<%=id_modal%>" aria-hidden="true">
		<div class="modal-dialog modal-dialog-centered" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h3 class="modal-title" id="exampleModalLabel">Elimina immagine</h3>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<form name="formAss" method="post" action="<%=form_action%>" class="form-control-cciaa-sm">
				<div class="modal-body">
					Sei sicuro di voler eliminare questa immagine?
				</div>
				<div class="modal-footer">
					<input type="Hidden" name="<%=name_field_img %>" value="" />
					<%=form_add_input_hidden %>
					<input type="Hidden" name="<%=rq_operazione %>" value="salva" />
					<input type="Hidden" name="<%=rq_email %>" value="<%=email_modal.getId() %>" />
					<button type="submit" class="btn btn-danger">Elimina</button>
					<button type="button" class="btn btn-secondary" data-dismiss="modal">Annulla</button>
				</div>
				</form>
			</div>
		</div>
	</div>
<!-- fine Modal -->