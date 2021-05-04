<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@page buffer="512kb" autoFlush="false" %>

<%	String original_password = operatore.password;%>


<!doctype html>

<%@include file="/amministrazione/_load_pagina.jsp" %>
<%@include file="/amministrazione/componenti/_filtri_documenti_init.jsp" %>

<html lang="it">
<head>
	<%@include file="/amministrazione/common/struct_template/head.htm" %>
<script language="Javascript">

	function check_old_pwd()
{
	var ritorno=true;
	var old_password = document.reg_psw.old_password.value;
	var original_password = '<%=original_password%>';

	if(original_password != old_password){
	alert("La vecchia password non è stata digitata correttamente");
	ritorno = false;
}else{ 
	ritorno = true;
}
	return ritorno && check_pwd(); 
}

	function check_pwd()
{
	var ritorno=false;
	var password=document.reg_psw.f_s_password.value;
	var chk_password=document.reg_psw.chk_password.value;

	if (password.length > 4)
	if (password == chk_password) 
 ritorno=true;
	else 
 alert("Le due password immesse non sono uguali!!! :" + password + " " + chk_password);
	else 
	alert("Per registrarsi è necessario inserire una password con più di 4 caratteri");

	ritorno = ritorno && check_spazi();
	return ritorno;
}

	function check_spazi()
{
	var ritorno=true;
	var old_password=document.reg_psw.old_password.value;
	var password=document.reg_psw.f_s_password.value;

	if(old_password.indexOf(" ")!=-1){
	alert("Non è possibile inserire spazi nel campo vecchia password!");
	ritorno=false;
}else if(password.indexOf(" ")!=-1){
	alert("Non è possibile inserire spazi nel campo nuova password!");
	ritorno=false;
}

	return ritorno;
}


</script>
</head>


<body>
	<%@include file="/amministrazione/common/struct_template/header.htm" %>
	<main class="main-content-admin">
		<div class="row">
			
			<div class="col-md-3 col-sm-4 col-xl-2 order-sm-2" style="padding-left:0px !IMPORTANT;">
				<div class="position-fixed" style="top: 100;">
		
				<%@include file="/amministrazione/common/struct_template/menu_sx.htm" %>
				</div>
			</div>
			
			<div class="col-md-9 col-sm-8 col-xl-10 order-first order-sm-2 border-gray">

	<h1><span class="glyphicon glyphicon-user" aria-hidden="true" style="margin-right:10px;"></span> Cambia password</h1>
	
	<form id="reg_psw" method="post" onSubmit="return check_old_pwd()" action="/servlet/ExecuteUpdateServletPostgresCdC">
		<fieldset id="registrazione">
			<legend>Modifica password utente: <%=operatore.username %></legend>
			<div class="form-group row">
				<label for="titolo" class="col-sm-4 col-form-label"><b>Inserire la vecchia Password</b></label>
					<div class="col-sm-8">
						<input type="password" class="form-control" id="old_pwd" name="old_password" size="40" /> 
					</div>
			</div>
			<div class="form-group row">
				<label for="titolo" class="col-sm-4 col-form-label"><b>Nuova Password</b></label>
					<div class="col-sm-8">
						<input type="password" class="form-control" name="f_s_password" id="new_pwd" size="40" />
					</div>
			</div>
			<div class="form-group row">
				<label for="titolo" class="col-sm-4 col-form-label"><b>Conferma Password</b></label>
					<div class="col-sm-8">
						<input type="password" class="form-control" name="chk_password" id="chk_pwd" size="40" />
					</div>
			</div>

				<input type="hidden" name="f_d_data_change_pwd" value="<%=cise.utils.DateUtils.today() %>" >
				<input type="hidden" name="op" value="U" >
				<input type="hidden" name="table" value="portalowner2.utenti">
				<input type="hidden" name="pagefwd" value="/auth/conferma_modifica_password.jsp" />
				<input type="hidden" name="pagefwd_modificato" value="yes" />
				<input type="hidden" name="condition" value="id_utente=<%=operatore.id_utente%>">
				<input type="hidden" name="connection" value="DBPortalCdCRomagnaPostgres-Postgres" />
			
			<div class="form-group row">
				<div class="col-sm-3 col-form-label"></div>
				<div class="col-sm-9">
					<input type="submit" class="btn btn-success" name="Submit" value="Salva"/>
					<!--input type="button" class="btn btn-danger" name="annulla" value="Annulla" onclick="location.href='/amministrazione/'"/-->
				</div>
			</div>
			
		
		</fieldset>
	</form>
	</div>
</div>
</main>

</body>
</html>
