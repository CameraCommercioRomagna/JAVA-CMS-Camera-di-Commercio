<div class="list-group">
	
	<div class="list-group-item list-group-item-success" style="margin-top:2rem;">
		<div class="d-flex w-75 justify-content-between">
			<h5 class="mb-1">Crea</h5>
		</div>
	</div>
	<div id="paragrafi" role="tablist" aria-multiselectable="false">
		<div class="card border-light">
			<div class="card-header" role="tab">
				<h5 class="card-title"><span class="glyphicon glyphicon-envelope" style="margin-right:1rem;" aria-hidden="true"></span> <a href="mail/crea_email2.jsp?ID_D=<%=pagina.getId()%>" target="_blank">Email proposta dal sistema</a></h5>
				<p>Email composta in automatico dal sistema secondo criteri standard in dipendenza dalla tipologia di documento. (Scelta consigliata)</p>
			</div>
		</div>
	<%	EmailWeb email = null;
		//List<EmailWeb> email_list = pagina.getEmailweb();
		List<EmailWeb> email_list = pagina.getRelation(EmailWeb.REF_EMAIL_DOC, EmailWeb.class, this).getRecords();
	%>
		<div class="card border-light">
			<div class="card-header" role="tab">
				<h5 class="card-title"><span class="glyphicon glyphicon-envelope" style="margin-right:1rem;" aria-hidden="true"></span> <a href="mail/email_customized.htm?ID_D=<%=pagina.getId()%>" target="_blank">Email personalizzata</a></h5>
				<p>Email che viene creata inizialmente con il contenuto del documento e che può essere rielaborata a piacere dall'utente.</p>
			</div>
		</div>
	</div>
</div>
