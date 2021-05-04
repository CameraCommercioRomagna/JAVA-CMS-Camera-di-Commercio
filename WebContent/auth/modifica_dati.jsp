
<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@page buffer="512kb" autoFlush="false" %>
<!doctype html>

<html lang="it">
<head>
	<%@include file="/amministrazione/common/struct_template/head.htm" %>
</head>

<body>
	<%@include file="/amministrazione/common/struct_template/header.htm" %>

	<h1><span class="glyphicon glyphicon-user" aria-hidden="true" style="margin-right:10px;"></span>Modifica dati utente</h1>
	<p><b>N.B.</b>: I dati contrassegnati da un asterisco * sono obbligatori </p>
	
	<form id="reg_usr" action="/servlet/ExecuteUpdateServletPostgres" method="post">

	<fieldset id="registrazione">
		<legend><b>Dati utente</b></legend>
		<p><label for="f_s_nome">Nome</label><input type="text" class="form-control" name="f_s_nome" id="f_s_nome" size="20" maxlength="50" value="<%=nullToEmptyString(u.nome)%>" /></p>
		<p><label for="f_s_cognome">Cognome</label><input type="text" class="form-control" name="f_s_cognome" id="f_s_cognome" size="20" maxlength="50" value="<%=nullToEmptyString(u.cognome)%>" /></p>
		<p><label for="f_s_indirizzo">Indirizzo</label><input type="text" class="form-control" name="f_s_indirizzo" id="f_s_indirizzo" size="40" maxlength="100" value="<%=nullToEmptyString(u.indirizzo) %>" /></p>
		<p><label for="f_s_num_civ">Numero</label><input type="text" class="form-control" name="f_s_num_civ" id="f_s_num_civ" size="2" maxlength="10" value="<%=nullToEmptyString(u.num_civ)%>" /></p>
		<p><label for="f_s_comune">Città *</label><input type="text" class="form-control" name="f_s_comune" id="f_s_comune" size="40" maxlength="50" value="<%=nullToEmptyString(u.comune)%>" /></p>
		<p>
		<label for="f_s_provincia">Provincia</label>
		<select name="f_s_provincia" id="f_s_provincia" class="form-control">
		<%	String prov=u.provincia;
			if (prov==null) prov="";%>
		<%@include file="/common/jsp/elenco_provincie.jsp"%>
		</select>
		</p>
		<p><label for="f_s_cap">C.A.P. *</label><input type="text" class="form-control" name="f_s_cap" id="f_s_cap" size="5" maxlength="50" value="<%=nullToEmptyString(u.cap)%>" /></p>
		<p>
			<label for="f_s_stato">Stato *</label>
			<select name="f_s_stato" id="f_s_stato" class="form-control">
			<%	String stato=u.stato;
				if (stato==null) stato="";%>
			<%@include file="/common/jsp/elenco_nazioni.jsp"%>
			</select>
		</p>
		<p><label for="f_s_telefono">Telefono</label><input type="text" class="form-control" name="f_s_telefono" id="f_s_telefono" size="10" maxlength="50" value="<%=nullToEmptyString(u.telefono) %>" /></p>
		<p><label for="f_s_fax">Fax</label><input type="text" class="form-control" name="f_s_fax" id="f_s_fax" size="10" maxlength="50" value="<%=nullToEmptyString(u.fax) %>" /></p>
		<p><label for="f_s_cellulare">Cellulare</label><input type="text" class="form-control" name="f_s_cellulare" id="f_s_cellulare" size="10" maxlength="50" value="<%=nullToEmptyString(u.cellulare) %>" /></p>
		<p><label for="f_s_email">E-mail *</label><input type="text" class="form-control" name="f_s_email" id="f_s_email" size="40" maxlength="50" value="<%=nullToEmptyString(u.email) %>" /></p>
		<p><label for="f_d_data_nascita">Data di nascita</label><input type="text" class="form-control" name="f_d_data_nascita" id="f_d_data_nascita" size="10" maxlength="10" value="<%=(u.data_nascita!=null ? cise.utils.DateUtils.formatDate(u.data_nascita) : "") %>" /> (Es. gg/mm/aaaa)</p>
		<%	String sessoUser=u.sesso;
			if (sessoUser==null) sessoUser="";%>
		<p><label>Sesso</label><span>M</span><input type="radio" class="form-control" name="f_s_sesso" id="sesso0" value="M" <% if ((sessoUser.equals(""))||(sessoUser.equals("M"))){ %> checked="checked" <%}%> />
		<span>F</span><input type="radio" class="form-control" name="f_s_sesso" id="sesso1" value="F" <% if (sessoUser.equals("F")){ %> checked="checked" <%}%> /> 
		</p>
		<p><label for="f_s_cod_fiscale">Codice Fiscale</label><input type="text" class="form-control" name="f_s_cod_fiscale" id="f_s_cod_fiscale" size="15" maxlength="50" value="<%=nullToEmptyString(u.cod_fiscale) %>" /></p>
	</fieldset>
	<fieldset>
		<p>
			<input type="hidden" name="pagefwd" value="/auth/dati_utente.jsp" />
			<input type="hidden" name="pagefwd_modificato" value="yes" />
			<input type="hidden" name="op" value="U" >
			<input type="hidden" name="table" value="portalowner.utenti">
			<input type="hidden" name="condition" value="id_utente=<%=u.id_utente%>">
			<input type="hidden" name="connection"  value="DBPortalCISE-Postgres" />
			<input type="submit" class="btn btn-danger" name="Submit" value="Salva" />
			<input type="button" class="btn btn-danger" name="annulla" value="Annulla" onclick="location.href='/auth/dati_utente.jsp'"/>
		</p>
	</fieldset>
</form>


</body>
</html>