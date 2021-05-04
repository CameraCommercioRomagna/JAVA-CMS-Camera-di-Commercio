<%	/* input richiesti:
	 *	int indiceRitardo;*/
	
	int fasciaSuccess=(indiceRitardo > 33 ? 33 : indiceRitardo);
	int fasciaWarning=(indiceRitardo > 67 ? 34 : indiceRitardo-33);
	int fasciaDanger=(indiceRitardo >= 100 ? 33 : indiceRitardo-67);%>
	<div class="progress" title="Aggiornamento" aria-label="Aggiornamento">
		<div class="progress-bar bg-success" role="progressbar" style="width: <%=fasciaSuccess%>%" aria-valuenow="<%=fasciaSuccess%>" aria-valuemin="0" aria-valuemax="100"></div>
		<div class="progress-bar bg-warning" role="progressbar" style="width: <%=fasciaWarning%>%" aria-valuenow="<%=fasciaWarning%>" aria-valuemin="0" aria-valuemax="100"></div>
		<div class="progress-bar bg-danger" role="progressbar" style="width: <%=fasciaDanger%>%" aria-valuenow="<%=fasciaDanger%>" aria-valuemin="0" aria-valuemax="100"></div>
	</div>
	<div style="width:100%;text-align:right;position:relative;top:-1rem;font-size:0.75rem;"><span>Aggiornamento dei contenuti</span></div>