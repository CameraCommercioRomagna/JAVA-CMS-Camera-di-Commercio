		<%	if(numero_nl==null){%>
				<form id="filtri" action="<%=urlwrapper.getResourceName() %>" class="form-control-cciaa-sm">
				<div>
					<h3>Filtra nella pagina</h3>
					<div style="margin-top:0.1rem;">
						<label style="width:60px;">Visualizza:</label><br/>
						<div class="btn-group btn-group-toggle btn-sm" data-toggle="buttons">
							<label class="btn btn-success btn-cciaa btn-sm <%=(archivio ? "active" : "") %>">
								<input type="radio" name="archivio" id="archivio1" value="true" autocomplete="off" <%=(archivio? "checked" : "") %>> Archivio
							</label>
							<label class="btn btn-secondary btn-cciaa btn-sm <%=(!archivio ? "active" : "") %>">
								<input type="radio" name="archivio" id="archivio0" value="false" autocomplete="off" <%=(!archivio? "checked" : "") %>> Prossimi numeri
							</label>
						</div>
					</div>
				</div>
			<%	Set<String> parameters_filtri_nl = new HashSet<String>();
				parameters_filtri_nl.addAll(parameters_filtri_dweb_tot);
				parameters_filtri_nl.remove("archivio");
				for (String name: parameters_filtri_nl){
					for (String value: urlwrapper.getParameter(name)){%>
				<input type="hidden" name="<%=name %>" value="<%=value %>" />
			<%		}
				}%>
				<button style="margin-top:0.3rem;" type="submit" class="btn btn-primary btn-sm">Applica filtri</button>
				</form>
				<br/>
		<%	}%>