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
				<div class="form-group row row-form-admin">
					<label for="f_s_h1" class="col-2 col-form-label"><b>Titolo(H1)</b></label> 
					<div class="col-10">
						<input type="text" class="form-control" id="f_s_h1" name="f_s_h1" value=""  maxlength="400"/>
					</div>
				</div>
		
				<div class="form-group">
					<label for="f_s_body1"><b>Descrizione</b></label>
						<textarea maxlength="4000" class="body" id="f_s_body1" name="f_s_body" onkeyup="return textLimitExceed(insert.f_s_body,4000)"></textarea>
						<p id="f_s_body1HelpBlock" class="form-text text-muted">
							Premendo il tasto Invio l'andata a capo genera una riga di spaziatura. Per andare a capo senza lasciare spazio premere i tasi Maiuscolo (Shift) e Invio contemporaneamente. <br/>
							Il testo qui incollato sarà pulito automaticamente dall'editor da ogni fomattazione esistente. Ricordarsi di inserire quindi la formattazione utilizzando gli appositi comandi.
						</p>
				</div>
				
				<div class="form-group row row-form-admin">
					<label for="f_f_icona" class="col-2 col-form-label"><b>Icona</b></label> 
					<div class="col-10">
						<input type="file" id="file" name="f_f_image">
						<input type="hidden" name="upd" value=" " /> 
						&nbsp;<a href="http://www.ciseweb.it" onclick="return previewDocument('')">Anteprima immagine</a>
	
					</div>
				</div>
				<div class="form-group row row-form-admin">
					<label for="f_n_posizione" class="col-2 col-form-label"><b>Ordinamento</b></label> 
					<div class="col-10">
						<input type="text" class="form-control" style="width:5rem !important;" id="f_n_posizione" name="f_n_posizione" value="<%=(paragrafo_curr!=null && paragrafo_curr.posizione!=null ? paragrafo_curr.posizione.intValue() : newPos) %>"/>
					</div>
				</div>
				
				
				<p>
					<input  type="reset" class="btn btn-primary" name="Reset" value="Ripristina" />
					<input  type="submit" class="btn btn-success" name="Inserisci" value="Salva" />
				</p>

		
			</form>


	
</div>	


</body>
</html>