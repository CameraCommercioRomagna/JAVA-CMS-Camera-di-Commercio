<%@include file="/amministrazione/common/include/begin.jsp" %>



<!doctype html>

<html lang="it">
<head>
	<%@include file="/amministrazione/common/struct_template/head.htm" %>
</head>

<body>
	<%@include file="/amministrazione/common/struct_template/header.htm" %>

<div class="panel-body">
	<h1 class="gray-colored"><span class="glyphicon glyphicon-user" aria-hidden="true" style="margin-right:10px;"></span>Dati utente</h1>
	<h3 class="blu1-colored">Utente: <%=operatore.id_utente %></h3>

	<h4><b>Azioni consentite</b></h4>
	<ul class="list-unstyled">
		<li class="menu_home"><a href="modifica_dati.jsp?pagefwd=dati_utente.jsp"><b>Modifica i tuoi dati</b></a></li>
		<li class="menu_home"><a href="modifica_password.jsp?pagefwd=dati_utente.jsp"><b>Modifica la tua password</b></a></li>
	</ul>
	
	<br/>

	<h4 class="green-colored"><b>Riepilogo dati forniti durante il processo di registrazione</b></h4>
	
</div>

</body>
</html>


