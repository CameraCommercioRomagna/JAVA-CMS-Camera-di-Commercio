<%@include file="/amministrazione/common/include/begin.jsp" %>
<%@page buffer="512kb" autoFlush="false" %>

<%	String original_password = operatore.password;%>


<!doctype html>

<%@include file="/amministrazione/_load_pagina.jsp" %>
<%@include file="/amministrazione/componenti/_filtri_documenti_init.jsp" %>

<html lang="it">
<head>
	<%@include file="/amministrazione/common/struct_template/head.htm" %>

	
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
			Password modificata con successo

	</div>
</div>
</main>

</body>
</html>