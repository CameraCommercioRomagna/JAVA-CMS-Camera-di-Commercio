<!--
	input richiesti:
	Organizzatore o;
 -->

<div class="col-md-<%=12/collaboratori.size()%>" style="margin-top:1rem;">
	<div class="card h-100" style="margin-left:0.5rem; padding:0; flex-grow:0!important;">
		<div class="card-block" style="height:70%;">
		<%	if ((o.getEnte().img_path !=null) && (!o.getEnte().img_path.equals(""))){%>
				<a href="<%=o.getEnte().url%>" title="Sito web <%=o.getEnte().nome%>">
					<img src="<%=o.getEnte().img_path %>" style=" border:0; max-height:8rem;" class="img-fluid img-thumbnail" alt="Logo <%=o.getEnte().nome%>" />
				</a>
		<%	}%>
		</div>
		<div class="card-footer footer-card-ente" >
			<a href="<%=o.getEnte().url%>" title="Sito web <%=o.getEnte().nome%>" class="small">
				<%=o.getEnte().nome%>
			</a>
		</div>
	</div>
</div>