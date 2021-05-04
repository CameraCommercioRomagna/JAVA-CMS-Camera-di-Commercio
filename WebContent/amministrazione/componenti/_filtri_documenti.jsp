<%	if (visualMenuAdminSx){%>
		<%	if (!inserimento){%>
				<form id="filtri" action="<%=urlwrapper.getResourceName() %>" class="form-control-cciaa-sm">
				<div>
					<h3>Filtra la ricerca</h3>
					<div style="margin-top:0.3rem;">
						Titolo/Nr:
						<div class="btn-group btn-group-toggle" data-toggle="buttons">
							<input type="test" name="titolo_dweb" style="width:85%;font-size:0.7rem;" id="titolo_dweb" <%//=(urlwrapper.getResourceName().indexOf("ricerca.htm")>-1? "required" : "") %> value="<%=(titolo_dweb!=null ? titolo_dweb : "")%>" />
						</div>
					</div>
					<div style="margin-top:0.3rem;">
						Proprietario:
						<div class="btn-group btn-group-toggle" data-toggle="buttons">
							<input type="test" name="user_dweb" style="width:72%;font-size:0.7rem;" placeHolder="Indicare cfo/crn" id="user_dweb" <%//=(urlwrapper.getResourceName().indexOf("ricerca.htm")>-1? "required" : "") %> value="<%=(user_dweb!=null ? user_dweb : "")%>" />
						</div>
					</div>
					<div style="margin-top:0.3rem;">
						Tipo Documenti:
						<div class="btn-group btn-group-toggle" data-toggle="buttons">
							<select style="width:80%;font-size:0.7rem;" id="tipo_d" name="tipo_d">
								<option value="">Seleziona la tipologia</option>
							<%	TipoDocumento[] tipi_doc_array = TipoDocumento.values();
								for(int tdi=0; tdi<tipi_doc_array.length; tdi++){
									if(tipi_doc_array[tdi].accessibile(operatore) && tipi_doc_array[tdi].estende()==null){%>	
								<option value="<%=tipi_doc_array[tdi].getId()%>" <%=(tipo_d!=null && tipo_d.getId().compareTo(tipi_doc_array[tdi].getId())==0 ? "selected=\"selected\"" : "")%> ><%=tipi_doc_array[tdi]%></option>
								<%	}	
								}%>	
							</select>
						</div>
					</div>
					<div style="margin-top:0.3rem;">
						<label style="width:60px;">Validati:</label>
						<div class="btn-group btn-group-toggle btn-sm" data-toggle="buttons">
							<label class="btn btn-info btn-cciaa btn-sm <%=(validati==null ? "active" : "") %>">
								<input type="radio" name="validati" id="v_tutti" value="" autocomplete="off" <%=(validati==null ? "checked" : "") %>> Tutti
							</label>
							<label class="btn btn-success btn-cciaa btn-sm <%=(validati!=null && validati ? "active" : "") %>">
								<input type="radio" name="validati" id="v_si" value="true" autocomplete="off" <%=(validati!=null && validati? "checked" : "") %>> Sì
							</label>
							<label class="btn btn-secondary btn-cciaa btn-sm <%=(validati!=null && !validati ? "active" : "") %>">
								<input type="radio" name="validati" id="v_no" value="false" autocomplete="off" <%=(validati!=null && !validati? "checked" : "") %>> No
							</label>
						</div>
					</div>
					<div style="margin-top:0.1rem;">
						<label style="width:60px;">Pubblicati:</label>
						<div class="btn-group btn-group-toggle btn-sm" data-toggle="buttons">
							<label class="btn btn-info btn-cciaa btn-sm <%=(pubblicati==null ? "active" : "") %>">
								<input type="radio" name="pubblicati" id="p_tutti" value="" autocomplete="off" <%=(pubblicati==null ? "checked" : "") %>> Tutti
							</label>
							<label class="btn btn-success btn-cciaa btn-sm <%=(pubblicati!=null && pubblicati ? "active" : "") %>">
								<input type="radio" name="pubblicati" id="p_si" value="true" autocomplete="off" <%=(pubblicati!=null && pubblicati? "checked" : "") %>> Sì
							</label>
							<label class="btn btn-warning btn-cciaa btn-sm <%=(pubblicati!=null && !pubblicati ? "active" : "") %>">
								<input type="radio" name="pubblicati" id="p_no" value="false" autocomplete="off" <%=(pubblicati!=null && !pubblicati? "checked" : "") %>> No
							</label>
						</div>
					</div>
					<div style="margin-top:0.1rem;">
						<label style="width:60px;">Scaduti:</label>
						<div class="btn-group btn-group-toggle btn-sm" data-toggle="buttons">
							<label class="btn btn-info btn-cciaa btn-sm <%=(scaduti==null ? "active" : "") %>">
								<input type="radio" name="scaduti" id="s_tutti" value="" autocomplete="off" <%=(scaduti==null ? "checked" : "") %>> Tutti
							</label>
							<label class="btn btn-danger btn-cciaa btn-sm <%=(scaduti!=null && scaduti ? "active" : "") %>">
								<input type="radio" name="scaduti" id="s_si" value="true" autocomplete="off" <%=(scaduti!=null && scaduti? "checked" : "") %>> Sì
							</label>
							<label class="btn btn-success btn-cciaa btn-sm <%=(scaduti!=null && !scaduti ? "active" : "") %>">
								<input type="radio" name="scaduti" id="s_no" value="false" autocomplete="off" <%=(scaduti!=null && !scaduti? "checked" : "") %>> No
							</label>
						</div>
					</div>
					
					<%if(operatoreComitatoDiRedazione){%>
						<div style="margin-top:0.1rem;">
							<label style="width:60px;">In home:</label>
							<div class="btn-group btn-group-toggle btn-sm" data-toggle="buttons">
								<label class="btn btn-info btn-cciaa btn-sm <%=(visibilita==null ? "active" : "") %>">
									<input type="radio" name="visibilita" id="h_tutti" value="" autocomplete="off"> Tutti
								</label>
								<label class="btn btn-danger btn-cciaa btn-sm <%=(visibilita!=null && visibilita.getValore()==1l ? "active" : "") %>">
									<input type="radio" name="visibilita" id="h_si" value="1" autocomplete="off"> &nbsp;&nbsp;Sì&nbsp;&nbsp;
								</label>
							</div>
						</div>
						
						<!--div style="margin-top:0.1rem;">
						<label style="width:60px;">Edizione evento:</label>
						<div class="btn-group btn-group-toggle btn-sm" data-toggle="buttons">
							<label class="btn btn-info btn-cciaa btn-sm <%=(tipo_d==null ? "active" : "") %>">
								<input type="radio" name="tipo_d" id="t_tutti" value="" autocomplete="off" <%=(tipo_d==null ? "checked" : "") %>> Tutti
							</label>
							<label class="btn btn-danger btn-cciaa btn-sm ">
								<input type="radio" name="tipo_d" id="t_si" value="27" autocomplete="off"> Sì
							</label>
							<label class="btn btn-danger btn-cciaa btn-sm ">
								<input type="radio" name="tipo_d" id="no" value="27" autocomplete="off"> No
							</label>
						</div>
					</div-->
						
						<div style="margin-top:0.1rem;">
							<label style="width:60px;">Priorità:</label>
							<div class="btn-group btn-group-toggle" data-toggle="buttons">
								<label class="btn btn-info btn-cciaa btn-sm <%=(priorita==null ? "active" : "") %>" style="height:50px !important; padding:0; width:25px;">
									<input type="radio" name="priorita" id="pr_tutti" value="" autocomplete="off"><span class="rotate" style="margin-left:-5px;margin-top:12px">Tutte</span>
								</label>
								<label class="btn btn-danger btn-cciaa btn-sm <%=(priorita!=null && priorita.getValore()==0l ? "active" : "") %>" style="height:50px !important; padding:0; width:25px;">
									<input type="radio" name="priorita" id="pr_nul" value="0" autocomplete="off"><span class="rotate" style="margin-left:-5px;margin-top:12px">Nulla</span>
								</label>
								<label class="btn btn-warning btn-cciaa btn-sm <%=(priorita!=null && priorita.getValore()==1l ? "active" : "") %>" style="height:50px !important; padding:0; width:25px;">
									<input type="radio" name="priorita" id="pr_bas" value="1" autocomplete="off"><span class="rotate" style="margin-left:-7px;margin-top:12px">Bassa</span>
								</label>
								<label class="btn btn-secondary btn-cciaa btn-sm <%=(priorita!=null && priorita.getValore()==2l ? "active" : "") %>" style="height:50px !important; padding:0; width:25px;">
									<input type="radio" name="priorita" id="pr_med" value="2" autocomplete="off"><span class="rotate" style="margin-left:-7px;margin-top:12px">Media</span>
								</label>
								<label class="btn btn-success btn-cciaa btn-sm <%=(priorita!=null && priorita.getValore()==3l ? "active" : "") %>" style="height:50px !important; padding:0; width:25px;">
									<input type="radio" name="priorita" id="pr_alt" value="3" autocomplete="off"><span class="rotate" style="margin-left:-3px;margin-top:12px">Alta</span>
								</label>
								<label class="btn btn-primary btn-cciaa btn-sm <%=(priorita!=null && priorita.getValore()==4l ? "active" : "") %>" style="height:50px !important; padding:0; width:25px;">
									<input type="radio" name="priorita" id="pr_max" value="4" autocomplete="off"><span class="rotate" style="margin-left:-3px;margin-top:12px">Max</span>
								</label>
							</div>
						</div>
						
					<%}%>
					
					
				</div>
				<input type="hidden" name="ricerca" value="yes" />
			<%	Set<String> parameters_filtri_dweb = new HashSet<String>();
				parameters_filtri_dweb.addAll(parameters_filtri_dweb_tot);
				parameters_filtri_dweb.remove("titolo_dweb");
				parameters_filtri_dweb.remove("tipo_d");
				parameters_filtri_dweb.remove("validati");
				parameters_filtri_dweb.remove("pubblicati");
				parameters_filtri_dweb.remove("scaduti");
				parameters_filtri_dweb.remove("ricerca");
				parameters_filtri_dweb.remove("visibilita");
				parameters_filtri_dweb.remove("priorita");
				for (String name: parameters_filtri_dweb){
					for (String value: urlwrapper.getParameter(name)){%>
				<input type="hidden" name="<%=name %>" value="<%=value %>" />
			<%		}
				}%>
				<button style="margin-top:0.3rem;" type="submit" class="btn btn-primary btn-sm">Applica filtri</button>
				</form>
				<br/>
		<%	}%>
	<%	//per rendere obbligatori almeno uno dei campi: titolo o proprietario
		if(urlwrapper.getResourceName().indexOf("ricerca.htm")>-1){%>		
		<!--script>	
			jQuery(function ($) {
				var $inputs = $('input[name=user_dweb],input[name=titolo_dweb]');
				$inputs.on('input', function () {
					// Set the required property of the other input to false if this input is not empty.
					$inputs.not(this).prop('required', !$(this).val().length);
				});
			});
		</script-->
	<%	}%>
<%	}%>