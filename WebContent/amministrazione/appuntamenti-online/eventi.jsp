<%@page contentType="application/json"%>
<%@include file="/amministrazione/common/include/begin.jsp" %>
<%	ErogatoreServizi erogatore = null;
	%><%@include file="./_parameter_erogatore.jsp" %><%
	
	List<Appuntamento> appuntamenti=new ArrayList<Appuntamento>();
	List<Annotazione> annotazioni=new ArrayList<Annotazione>();
	if (erogatore != null){
		try{
			Date dal=DateUtils.stringToDate(request.getParameter("start").substring(0, 10), "yyyy-MM-dd");
			Date al=DateUtils.stringToDate(request.getParameter("end").substring(0, 10), "yyyy-MM-dd");
			
			appuntamenti=erogatore.getAppuntamenti(dal, al);
			annotazioni=erogatore.getAnnotazioni(dal, al);
		}catch(Exception e){}
	}%>
[
<%	boolean primo=true;
	
	for (Appuntamento appuntamento: appuntamenti){
		
		String pratiche="";
		String bkcolor="";
		TipoPratica tipo=null;
		
			if(appuntamento.prenotato() && !appuntamento.passato())
				bkcolor=appuntamento.getServizio().getColore();
			if(appuntamento.passato())
				bkcolor="lightyellow";
			if(appuntamento.opzionato())
				bkcolor="lightgray";
		
		
		for (Pratica p: appuntamento.getPratiche()){
			pratiche += p+"<br/>";
			tipo = TipoPratica.getTipoPratica(p.tipo_pratica);
		}
		if (!primo) out.print(","); else primo=false;
	%>{
		"id": "<%=appuntamento.id_appuntamento %>",
		"title": "<%=appuntamento.getServizio()%> n.<%=appuntamento.id_appuntamento%>: <%=(appuntamento.prenotato() ?  appuntamento.getRichiedente().getNomeCognome() : "Richiesta appuntamento in corso")%>",
		"start": "<%=DateUtils.formatDate(appuntamento.getInizio(), "yyyy-MM-dd HH:mm") %>",
		"end": "<%=DateUtils.formatDate(appuntamento.getFine(), "yyyy-MM-dd HH:mm") %>",
		
		"backgroundColor": "<%=bkcolor %>",
		"borderColor": "Black",
		"textColor": "Black",
		"extendedProps": {
			"url": "./appuntamento.htm?id=<%=appuntamento.id_appuntamento %>",
<%			if (appuntamento.prenotato()){
				String note = appuntamento.getNote();
				if(note!=null)
					note = note.replace("\"","&quot;");
%>			"description": "<b><%=appuntamento.getServizio()%> n.<%=appuntamento.id_appuntamento%></b><br/><i>Richiedente</i>:<br/><%=appuntamento.getRichiedente() %><br/><i>Pratiche</i>:<br/><%=pratiche %><% if (note!=null){%><i>Note dell'operatore</i>:<br/><%=note %><br/><%}%>"<%
			}else{
%>			"description": "<%=appuntamento.getServizio() %>",
			"opzionato": "yes"<%
			}
%>		}
	}<%
	}
	
	for (Annotazione annotazione: annotazioni){
		if (!primo) out.print(","); else primo=false;
		String ann_descr = annotazione.getDescrizione();
		if(ann_descr!=null)
			ann_descr = ann_descr.replace("\"","&quot;");
%>{
		"id": "nota-<%=annotazione.id_annotazione %>",
		"title": "<%=ann_descr %>",
		"allDay": <%=(annotazione.isChiuso() ? "false" : "true") %>,
		"start": "<%=DateUtils.formatDate(annotazione.getData(), "yyyy-MM-dd") %> 08:00",
		"end": "<%=DateUtils.formatDate(annotazione.getData(), "yyyy-MM-dd") %> 18:00",
		"editable": false,
		"backgroundColor": "<%=(annotazione.isChiuso() ? "Crimson" : "Yellow") %>",
		"borderColor": "Black",
		"textColor": "Black",
		"extendedProps": {
			"description": "<%=ann_descr %>"
		}
	}<%
	}%>
]