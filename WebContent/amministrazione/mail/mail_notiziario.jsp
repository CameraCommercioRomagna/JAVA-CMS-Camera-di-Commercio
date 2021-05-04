<%@include file="/amministrazione/common/include/begin.jsp" %>


<!doctype html>

<%
	String ID_N=null;
	try{
		ID_N=requestMP.getParameter("ID_NLNUMERO");
	}catch(Exception e){
		response.sendRedirect(HOME);
	}
	NumeroNewsLetter notiziario= new NumeroNewsLetter(Long.parseLong(ID_N), connPostgres);

	%>


<html>

<head>
<title><%=notiziario.getTitolo()%></title>
<style type="text/css">


</style>
</head>

<body>
<div style="clear:both;overflow:hidden;max-width:600px;display:block;font-family :sans-serif, Helvetica, Arial; margin-left:10px; font-size: 16px;">
	<div>
		<a href="http://www.xxx.it" title="XXX">
			<img src="http://www.xxx.it/imgs/header_mail2.png" alt="XXX" border="0"/>
		</a>
	</div>

<h1 style="font-family : Arial;font-size:24px; color:#071d49;;margin: 0.5em 0 0.5em 0.5em;clear : both; "><%=notiziario.getTitolo()%></h1>
<%	List<Sezione> sezioni=notiziario.getNewsLetter().getSezioni();
	for(Sezione sezione:sezioni){
			List<PromozioneDocumentoWeb> doc=notiziario.getDocumentiPubblicabili(sezione);
			int doc_size=0;
			for(PromozioneDocumentoWeb docum:doc){
				if((docum.data_validazione!=null)&&(docum.getDocumento().valido())){
					doc_size=doc_size+1;
				}
			}
			if(doc_size>0){%>
				<div style="margin : 0 10px 10px 10px; padding : 1em; background-color: #F7F7F7; border-left : 2px dotted #E0E0E0; border-top : 2px dotted #E0E0E0;">
					<h2 style="font-family : Arial, Helvetica, sans-serif;font-size:22px; margin:0px 0 20px 0; border-bottom: 2px solid silver; color:#071d49;"><img src="http://www.xxx.it<%=sezione.icona%>" alt="icona sezione <%=sezione.nome%>" style="width:25px;"/> <%=sezione.nome%></h2>

<%				for(PromozioneDocumentoWeb document:doc){%>
				<%	if((document.data_validazione!=null)&&(document.getDocumento().valido())){
						String link="";
						String pk_kwd=sistemaStringa(document.getDocumento().getTitolo().replaceAll("à", "a").replaceAll("è","e").replaceAll("é","e").replaceAll("ì","i").replaceAll("ò","o").replaceAll("ù","u").replaceAll("&","e").substring(0, Math.min(document.getDocumento().getTitolo().length(), 30)));
						if(document.getDocumento().getLink().indexOf("http")>-1){
							if(document.getDocumento().getLink().indexOf("www.xxx.it")>-1){
								if(document.getDocumento().getLink().indexOf("?")>-1){
									link=document.getDocumento().getLink() + "&pk_campaign=nq__" + DateUtils.formatDate(new Date(),"yyyyMMdd") + "&pk_kwd=" + pk_kwd ;
								}else{
									link=document.getDocumento().getLink() + "?pk_campaign=nq__" + DateUtils.formatDate(new Date(),"yyyyMMdd") + "&pk_kwd=" + pk_kwd ;
								}
							}else{
									link=document.getDocumento().getLink();
							}
						}else{
							link="http://www.xxx.it" +document.getDocumento().getLink() + "&pk_campaign=nq__" + DateUtils.formatDate(new Date(),"yyyyMMdd") + "&pk_kwd=" + pk_kwd;
						}%>

						<h3 style="font-size : 18px; color:#071d49; margin:0.8em 0.5em 0 0.5em;clear : both;"><a href="<%=link%>" style="color:#071d49 !IMPORTANT;"><%=document.getDocumento().getTitolo()%></a></h3>

				<%		String citta=null;
						int giorno_dal=0;
						int giorno_al=0;
						int mese_dal=0;
						int mese_al=0;
						int anno_dal=0;
						int anno_al=0;
				%>

						<p style="font-size : 14px;margin:0.4em 1.5em 0.5em 0.5em;">
		<%				if(document.getDocumento() instanceof Edizione){
							Edizione evento=(Edizione)document.getDocumento();%>
					<%			try{
								
								if(evento.getDal()!=null){
									Calendar dal=Calendar.getInstance();
									dal.setTime(evento.getDal());
									Calendar al=Calendar.getInstance();
									
									giorno_dal=dal.get(dal.DAY_OF_MONTH);
									mese_dal=dal.get(dal.MONTH);
									anno_dal=dal.get(dal.YEAR);
									java.text.SimpleDateFormat mese_format = new java.text.SimpleDateFormat("MMMM", java.util.Locale.ITALIAN);

									if(evento.getAl()!=null){
										al.setTime(evento.getAl());%>
									<%	if(dal.compareTo(al)==0){%>
											<%=giorno_dal%> <%=mese_format.format(new java.util.Date(dal.getTimeInMillis()))%> <%=anno_dal%>,
									<%	}else{%>
										<%	giorno_al=al.get(al.DAY_OF_MONTH);
											mese_al=al.get(al.MONTH);
											anno_al=al.get(al.YEAR);
										%>
										<%	if((mese_dal==mese_al)&&(anno_dal==anno_al)){%>
												<%=giorno_dal%>-<%=giorno_al%> <%=mese_format.format(new java.util.Date(dal.getTimeInMillis()))%> <%=anno_dal%>,
										<%	}else{
												if((mese_dal!=mese_al)&&(anno_dal==anno_al)){%>
												dal <%=giorno_dal%> <%=mese_format.format(new java.util.Date(dal.getTimeInMillis()))%> al <%=giorno_al%> <%=mese_format.format(new java.util.Date(al.getTimeInMillis()))%> <%=anno_dal%>, 
											<%	}else{
													if(anno_dal!=anno_al){%>
														dal <%=giorno_dal%> <%=mese_format.format(new java.util.Date(dal.getTimeInMillis()))%> <%=anno_dal%> al <%=giorno_al%> <%=mese_format.format(new java.util.Date(al.getTimeInMillis()))%> <%=anno_al%>, 
												<%	}
												}
											}%>
									<%	}%>
								<%	}else{%>
									<%=evento.getDal()%>, 
								<%	}
								}%>
								<%if(evento.luogo()!=null){%>
									<%=evento.luogo()%> -
							<%	}%>
						<%	}catch(Exception e){
								out.println(e);
							}%>
		<%				}%>

						<%=cise.utils.StringUtils.clearHtmlTag(document.getDocumento().getAbstract())%>
						<br/><em><a href="<%=link%>" style="color: #071d49 !IMPORTANT;">leggi la notizia completa</a></em><br/>
						</p>
<%					}%>
<%				}%>
			</div>
<%			}%>
<%	}%>


	<div style="clear:both;font-size:10px;max-width:535px;margin-left:10px;">Notiziario Quindicinale per le Imprese - periodico telematico</div>
	<hr style="color: #33519c; size:2px;"/>
	<p style="text-align:center; margin-top:0;font-size:12px;">
		<b>Comunicazione XXX</b> <br />
		<br />
		<a href="https://www.xxx.it/notiziario.htm" style="color: #33519c;">www.xxx.it/notiziario.htm</a> - <a href="mailto:comunicazione@xxx.it" style="color: #33519c;">abc@xxx.it</a><br /><br />
		ATTENZIONE - Non scrivere a abc@xxx.it, indirizzo non presidiato<br />SE NON DESIDERI PIU' RICEVERE QUESTA NEWSLETTER,&nbsp;<a href="http://www.xxx.it/newsletter/cancellazione.jsp?areaNewsletter=notiziario&amp;email=$contact_email1">CLICCA QUI</a>
		
	</p>
</div>
</body>
</html>