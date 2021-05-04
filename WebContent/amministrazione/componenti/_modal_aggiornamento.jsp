<%	/* input richiesti:
	 *	String id_modal;
		String href_redirect;*/%>

<!-- init Modal -->
<div class="modal fade" id="<%=id_modal%>" tabindex="-1" role="dialog" aria-labelledby="modalTitle<%=id_modal%>" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
	<div class="modal-content">
	  <div class="modal-header">
		<h3 class="modal-title" id="exampleModalLabel">Attenzione</h3>
		<button type="button" class="close" data-dismiss="modal" aria-label="Close">
		  <span aria-hidden="true">&times;</span>
		</button>
	  </div>
	  <div class="modal-body">
		<div class="alert alert-info" role="alert"><span class="glyphicon glyphicon-info-sign" style="font-size:1.5rem;margin-right:1.2rem;"></span> Hai completato la verifica dei contenuti come suggerito?</div>
		Confermi l'aggiornamento?
	  </div>
	  <div class="modal-footer">
		<a class="btn btn-info" href="<%=href_redirect%>" onclick="$('#<%=id_modal%>').modal('hide')">Sì</a>
		<button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
	  </div>
	</div>
  </div>
</div>
<!-- fine Modal -->