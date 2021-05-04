<%@include file="/common/include/begin.jsp" %>
<%@page buffer="512kb" autoFlush="false" %>
<!doctype html>


<html lang="it">
<head>
	<%@include file="/amministrazione/common/struct_template/head.htm" %>
</head>

<body>
	<%@include file="/amministrazione/common/struct_template/header.htm" %>
<main class="main-content-admin">
		<div class="row">
			<div class=" col-md-2 col-sm-2 order-sm-2 ">
				<h3>Gestione utente</h3>
				<ul class="list-unstyled" style="font-size:0.9rem">
					<li class="menu-admin"><a href="">Dati utente</a></li>
					<li class="menu-admin"><a href="">Cambia password</a></li>
					<li class="menu-admin"><a href="">Logout</a></li>
				</ul>
		
			</div>
			<div class="col-md-10 col-sm-10 order-first order-sm-2 border-gray">
			<h1>Aree Tematiche</h1>

			<form name="forminsert" enctype="multipart/form-data" method="post" action="">
				<div class="form-group row">
					<label for="f_s_titolo" class="col-md-2 col-form-label"><b>Titolo</b> *</label> 
					<div class="col-md-10">
						<input type="text" class="form-control" id="f_s_titolo" name="f_s_titolo" value="" maxlength="1000" required />
					</div>
				</div>
				<div class="form-group row">
					<label for="f_s_text_abstract" class="col-md-2 col-form-label"><b>Abstract</b> *</label>  
					<div class="col-md-10">
						<textarea id="f_s_text_abstract"  name="body" class="form-control " rows="5" required></textarea>
						<p id="abstractHelpBlock" class="form-text text-muted">
							Testo breve per la visualizzazione nelle pagine di raccolta (max 250 caratteri)
						</p>
					</div>
				</div>
		
				<div class="form-group row">
					<label for="f_f_icona" class="col-md-2 col-form-label"><b>Icona</b></label> 
					<div class="col-md-10">
						<input type="file" id="file"  name="f_f_icona">
						<input type="hidden" name="upd" value="" /> 
						<p id="fileHelpBlock" class="form-text text-muted">
							inserire un'immagine (png,jpg) di 310*210 pixel di 72dpi
						</p>
					</div>
				</div>
				<div class="form-group row">
					<label for="f_s_url" class="col-md-2 col-form-label"><b>URL</b> *</label> 
					<div class="col-md-10">
						<input type="text" class="form-control" id="f_s_url" name="f_s_url" value="" maxlength="400" required />
						<p id="f_s_urltHelpBlock" class="form-text text-muted">
							Es. http://www.abc.it
						</p>
					</div>
				</div>
				
				<h4><b>Informazioni sul periodo</b></h4>
				<div class="form-group row" style="margin-bottom: 0.5rem;">
					<label for="f_d_dal" class="col-md-2 col-form-label"><b>Dal</b> *</label> 
					<div class="col-md-10">
						<input type="date" style="width:10rem !important;"  class="form-control" id="f_d_dal" name="f_d_dal" value=""/ required>
						<p id="f_d_dalHelpBlock" class="form-text text-muted" style="margin-bottom: 0.5rem;">
							gg/mm/aaaa
						</p>
					</div>
				</div>
				<div class="form-group row" style="margin-bottom: 0.5rem;">
					<label for="f_d_al" class="col-md-2 col-form-label"><b>Al</b> *</label> 
					<div class="col-md-10">
						<input type="date" style="width:10rem !important;"  class="form-control" id="f_d_al" name="f_d_al" value=""/ required>
						<p id="f_d_alHelpBlock" class="form-text text-muted" style="margin-bottom: 0.5rem;">
							gg/mm/aaaa
						</p>
					</div>
				</div>
				<div class="form-group row">
					<label for="f_s_note_periodo" class="col-md-2 col-form-label"><b>Annotazioni</b> </label> 
					<div class="col-md-10">
						<input type="text" class="form-control" id="f_s_note_periodo" name="f_s_note_periodo" value="" maxlength="1000"/>
						<p id="f_s_note_periodoHelpBlock" class="form-text text-muted">
							Specifiche particolari, periodicità, etc...
						</p>
					</div>
				</div>
				
				<div class="form-group row">
					<label for="f_n_id_luogo" class="col-md-2 col-form-label"><b>Luogo Evento</b> *</label>  
						<div class="col-md-10">
							<select id="f_n_id_luogo" name="f_n_id_luogo" class="custom-select form-control" required>
								<option value="" selected="selected">Seleziona il luogo </option>
								<option value="">Luogo 1</option>
							</select>
						</div>
				</div>
				
				<div class="form-group row" style="margin-bottom: 0.5rem;">
					<label for="f_s_parole_chiave" class="col-md-2 col-form-label"><b>Parole chiave</b> </label> 
						<div class="col-md-10">
							<input type="text" class="form-control" id="f_s_parole_chiave" name="f_s_parole_chiave" value=""/>
							<p id="fileHelpBlock" class="form-text text-muted">
								separate da virgole
							</p>
						</div>
				</div>
				<div class="form-group row" style="margin-bottom: 0.5rem;">
					<label for="pagefwd_data_pertinenza" class="col-md-2 col-form-label"><b>Anno di pertinenza</b> *</label> 
					<div class="col-md-10">
						<input type="text" style="width:10rem !important;" class="form-control" id="pagefwd_data_pertinenza" name="pagefwd_data_pertinenza" value="" required>
						<p id="pagefwd_data_pertinenzaHelpBlock" class="form-text text-muted">
							aaaa
						</p>
					</div>
				</div>

				<div class="form-group row" style="margin-bottom: 0.5rem;">
					<label for="f_d_data_pubblicazione" class="col-md-2 col-form-label"><b>Data inizio Pubblicazione </b> *</label> 
					<div class="col-md-10">
				<input type="date" style="width:10rem !important;"  class="form-control" id="f_d_data_pubblicazione" name="f_d_data_pubblicazione" value="" required>
				<p id="f_d_data_pubblicazioneHelpBlock" class="form-text text-muted">
					gg/mm/aaaa
				</p>
			</div>
		</div>
		<div class="form-group row" style="margin-bottom: 0.5rem;">
			<label for="f_d_data_scadenza" class="col-md-2 col-form-label"><b>Data scadenza pubblicazione </b> *</label> 
			<div class="col-md-10">
				<input type="date" style="width:10rem !important;"  class="form-control" id="f_d_data_scadenza" name="f_d_data_scadenza" value="" required>
				<p id="f_d_data_scadenzaHelpBlock" class="form-text text-muted">
					gg/mm/aaaa
				</p>
			</div>
		</div>
		
		<div class="form-group row">
			<label for="f_n_priorita" class="col-md-2 col-form-label"><b>Priorità news</b> </label>  
			<div class="col-md-10">
				<select id="f_n_priorita" name="f_n_priorita" class="custom-select form-control">
					<option value="0">NULLA</option>
					<option value="1">BASSA</option>
					<option value="2">MEDIA</option>
					<option value="3">ALTA</option>
					<option value="4">MASSIMA</option>
				</select>
			</div>
		</div>
		
		<h4><b>Informazioni sul referente</b></h4>
		<div class="form-group row">
			<label for="f_s_ref_nome" class="col-md-2 col-form-label"><b>Nome referente</b> </label> 
			<div class="col-md-10">
				<input type="text" class="form-control" id="f_s_ref_nome" name="f_s_ref_nome" value="" maxlength="100"/>
			</div>
		</div>
		
		<div class="form-group row">
			<label for="f_s_ref_email" class="col-md-2 col-form-label"><b>E-mail referente</b> </label> 
			<div class="col-md-10 input-group mb-2">
				<div class="input-group-prepend">
					<div class="input-group-text">@</div>
				</div>
				<input type="email" class="form-control" id="f_s_ref_email" name="f_s_ref_email" value="" maxlength="100"/>
			</div>
		</div>
		<div class="form-group row">
			<label for="f_s_ref_tel" class="col-md-2 col-form-label"><b>Telefono referente</b> </label> 
			<div class="col-md-10">
				<input type="text" class="form-control" id="f_s_ref_tel" name="f_s_ref_tel" value="" maxlength="100"/>
			</div>
		</div>
		<div class="form-group row">
			<label for="f_s_ref_fax" class="col-md-2 col-form-label"><b>Fax referente</b> </label> 
			<div class="col-md-10">
				<input type="text" class="form-control" id="f_s_ref_fax" name="f_s_ref_fax" value="" maxlength="100"/>
			</div>
		</div>
		
		<div class="form-group row">
			<label for="f_n_pagamento" class="col-md-2 col-form-label"><b>Pagamento</b></label>  
			<div class="col-md-10">
				<div class="form-check form-check-inline" style="margin-right:1rem;">
					<input class="form-check-input" type="radio" name="f_n_pagamento" id="f_n_pagamento1" value="1"/> 
					<label class="form-check-label form-check-label-admin" for="f_n_validato1">Sì</label>
				</div>
				<div class="form-check form-check-inline" style="margin-right:1rem;">
					<input class="form-check-input" type="radio" name="f_n_pagamento" id="f_n_pagamento2" value="0"/> 
					<label class="form-check-label form-check-label-admin" for="f_n_validato2">No</label>
				</div>
			</div>
		</div>
		<div class="form-group row">
			<label for="f_n_incontro_relatore" class="col-md-2 col-form-label"><b>Incontro con Relatore</b></label>  
			<div class="col-md-10">
				<div class="form-check form-check-inline" style="margin-right:1rem;">
					<input class="form-check-input" type="radio" name="f_n_incontro_relatore" id="f_n_incontro_relatore1" value="1" /> 
					<label class="form-check-label form-check-label-admin" for="f_n_validato1">Sì</label>
				</div>
				<div class="form-check form-check-inline" style="margin-right:1rem;">
					<input class="form-check-input" type="radio" name="f_n_incontro_relatore" id="f_n_incontro_relatore2" value="0" /> 
					<label class="form-check-label form-check-label-admin" for="f_n_validato2">No</label>
				</div>
			</div>
		</div>
		
		<div class="form-group row">
			<label for="f_n_disponibilita_atti" class="col-md-2 col-form-label"><b>Disponibilità degli atti</b></label>  
			<div class="col-md-10">
				<div class="form-check form-check-inline" style="margin-right:1rem;">
					<input class="form-check-input" type="radio" name="f_n_disponibilita_atti" id="f_n_disponibilita_atti1" value="1" /> 
					<label class="form-check-label form-check-label-admin" for="f_n_validato1">Sì</label>
				</div>
				<div class="form-check form-check-inline" style="margin-right:1rem;">
					<input class="form-check-input" type="radio" name="f_n_disponibilita_atti" id="f_n_disponibilita_atti2" value="0" /> 
					<label class="form-check-label form-check-label-admin" for="f_n_validato2">No</label>
				</div>
			</div>
		</div>
		
		
		<div class="form-group row">
			<label for="modificato_il" class="col-md-2 col-form-label"><b>Ultima modifica</b></label> 
			<div class="col-md-10">
				data
				<input type="hidden" name="f_d_modificato_il" value=""/>
			</div>
		</div>
		<div class="form-group row">
			<label for="f_n_validato" class="col-md-2 col-form-label"><b>Validato</b></label>  
			<div class="col-md-10">
				<div class="form-check form-check-inline" style="margin-right:1rem;">
					<input class="form-check-input" type="radio" name="f_n_validato" id="f_n_validato1" value="1"/> 
					<label class="form-check-label form-check-label-admin" for="f_n_validato1">Sì</label>
				</div>
				<div class="form-check form-check-inline" style="margin-right:1rem;">
					<input class="form-check-input" type="radio" name="f_n_validato" id="f_n_validato2" value="0" /> 
					<label class="form-check-label form-check-label-admin" for="f_n_validato2">No</label>
				</div>
			</div>
		</div>
		
		<div class="form-group row">
			<label for="pagefwd_validato_il" class="col-md-2 col-form-label"><b>Validato il</b></label> 
			<div class="col-md-10">
			
					dataValidazione 

			</div>
		</div>
		
		<div class="form-group row">
			<label for="f_n_id_proprietario" class="col-md-2 col-form-label"><b>Immesso da</b></label> 
			<div class="col-md-10">
			
					utenteCreatore.getIdentita() 
			</div>
		</div>

	
		<br/>
		<p>
			<input  type="reset" class="btn btn-primary" name="Reset" value="Ripristina" />
			<input  type="submit" class="btn btn-success" name="Inserisci" value="Salva" />
		</p>

		
	</form>


	
</div>	


</body>
</html>