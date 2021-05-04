		<%	if (!inserimento_ente){%>
				<form id="filtri" action="<%=urlwrapper.getResourceName() %>" class="form-control-cciaa-sm">
				<div>
					<h3>Filtra gli enti:</h3>
					<div style="margin-top: 10px">
						Nome:
						<div class="btn-group btn-group-toggle" data-toggle="buttons">
							<input type="test" name="nome_ente" id="nome_ente" value="<%=(nome_ente!=null ? nome_ente : "")%>" />
						</div>
					</div>
				</div>
				<br/>
			<%	Set<String> parameters_filtri_enti = new HashSet<String>();
				parameters_filtri_enti.addAll(parameters_filtri_dweb_tot);
				parameters_filtri_enti.remove("nome_ente");
				for (String name: parameters_filtri_enti){
					for (String value: urlwrapper.getParameter(name)){%>
				<input type="hidden" name="<%=name %>" value="<%=value %>" />
			<%		}
				}%>
				<button type="submit" class="btn btn-primary">Applica filtro</button>
				</form>
				<br/>
		<%	}%>