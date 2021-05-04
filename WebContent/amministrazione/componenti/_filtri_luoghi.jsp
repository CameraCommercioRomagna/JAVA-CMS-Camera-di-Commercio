		<%	if (!inserimento_luogo){%>
				<form id="filtri" action="<%=urlwrapper.getResourceName() %>" class="form-control-cciaa-sm">
				<div>
					<h3>Filtra i luoghi:</h3>
					<div style="margin-top: 10px">
						Nome:
						<div class="btn-group btn-group-toggle" data-toggle="buttons">
							<input type="test" name="nome_luogo" id="nome_luogo" value="<%=(nome_luogo!=null ? nome_luogo : "")%>" />
						</div>
					</div>
				</div>
				<br/>
			<%	Set<String> parameters_filtri_luoghi = new HashSet<String>();
				parameters_filtri_luoghi.addAll(parameters_filtri_dweb_tot);
				parameters_filtri_luoghi.remove("nome_luogo");
				for (String name: parameters_filtri_luoghi){
					for (String value: urlwrapper.getParameter(name)){%>
				<input type="hidden" name="<%=name %>" value="<%=value %>" />
			<%		}
				}%>
				<button type="submit" class="btn btn-primary">Applica filtro</button>
				</form>
				<br/>
		<%	}%>