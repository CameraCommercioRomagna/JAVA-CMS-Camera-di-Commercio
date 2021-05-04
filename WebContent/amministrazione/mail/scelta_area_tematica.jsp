<%@include file="/amministrazione/common/include/begin.jsp" %>

<!doctype html>

<%@include file="/amministrazione/_load_pagina.jsp" %>
<%
	
%>

<%	QueryPager pager = new QueryPager(connPostgres);
	pager.set("select * from " + TematicaNl.NAME_TABLE + " order by nome");
	String key = UUID.randomUUID().toString();%>
	
<html>
<head>
<%@include file="/amministrazione/common/struct_template/head.htm" %>
<title>Area tematica</title>
	<script type="text/javascript">
		function checkInserimento(){
			var ritorno = true;
			var scelta = window.document.scelta_nl;
			var messaggio = "";
			
			if (scelta.areaNewsletter.value == ""){
				ritorno = false;
				messaggio += "\nSelezionare un'area tematica";
			}
			
			if (messaggio != "")
				alert(messaggio);
				
			return ritorno;
		}
	</script>
</head>

<body> 
<%@include file="/amministrazione/common/struct_template/header.htm" %>
	<main class="main-content-admin">
		<h2>Scegli l'area tematica dell'evento</h2>

		<form name="scelta_nl" method="post" action="crea_email.jsp" onsubmit="return checkInserimento()" class="form-control-cciaa-sm">
			<div class="form-group row">
				<label for="areaNewsletter" class="col-sm-2 col-form-label"><b>Autorizzazione di visualizzazione</b></label>
				<div class="col-sm-10">
					<select class="form-control" id="areaNewsletter" name="areaNewsletter">
							<option value="" >--- Scegli l'area tematica ---</option>
						<%	for (Row<String> rs : pager){%>
								<option value="<%=rs.getField("id_tematica") %>"><%=rs.getField("nome") %></option>
						<%	}%>
					</select>
				</div>
			</div>
			<input type="hidden" name="ID_D" value="<%=pagina.getId()%>" />
			<button type="submit" style="width:250px;" class="btn btn-primary">Procedi</button>
		</form>

	</main>
  
</body>
</html>