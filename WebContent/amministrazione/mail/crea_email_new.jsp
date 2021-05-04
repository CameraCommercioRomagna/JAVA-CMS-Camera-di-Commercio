<%@include file="/amministrazione/common/include/begin.jsp" %>

<%	QueryPager pager = new QueryPager(connPostgres);
	pager.set("select * from " + TematicaNl.NAME_TABLE + " order by nome");
	String key = UUID.randomUUID().toString();
	
	String areaNewsletter = request.getParameter("areaNewsletter")==null ? "" : request.getParameter("areaNewsletter");%>

<!doctype html>

<%@include file="/amministrazione/_load_pagina.jsp" %>
<%@include file="/common/componenti/collettori/_tab_anni-import.jsp"%>
	

<html>
<head>
<title><%=pagina.getTitolo() %></title>
</head>
<body>
<div style="clear:both;overflow:hidden;max-width:600px;display:block;font-family :sans-serif, Helvetica, Arial; margin-left:10px; font-size: 16px;">
	<div>
		<a href="http://www.xxx.it" title="XXX">
			<img src="http://www.xxx.it/imgs/header_mail2.png" alt="XXX" border="0"/>
		</a>
	</div>
	<div style="margin:1.5rem 0.5rem; font-family:Arial;">
		<h1 style="font-family : Arial;font-size:24px; color:#071d49 !IMPORTANT;  max-width:580px; text-align:left !IMPORTANT;"><%=pagina.getTitolo() %></h1>
		<%if ((pagina.icona!=null)|| ((pagina.abstract_txt!=null) && (pagina.getTipo().estende() != TipoDocumento.COMUNICAZIONE))){%>
		<p style="font-size:16px; max-width:580px; overflow:hidden;">
		<%}%>
		<%		if (pagina.icona!=null){%><img src="http://www.xxx.it/<%=pagina.icona%>" alt="" style="max-width:130px;float:right; margin:3px 5px 0 10px; border : 0px;" /><%}%>
		<%		if ((pagina.abstract_txt!=null) && (pagina.getTipo().estende() != TipoDocumento.COMUNICAZIONE)){%><%=pagina.abstract_txt%><%}%>
		<%if ((pagina.icona!=null)|| ((pagina.abstract_txt!=null) && (pagina.getTipo().estende() != TipoDocumento.COMUNICAZIONE))){%>
			</p>
		<%}%>
<%		if (pagina instanceof Edizione){
			Edizione edizione=(Edizione)pagina;
			String luogo=edizione.luogoENote();
			String periodo=edizione.periodoENote();%>
		<%	if(!periodo.equals("")){%><b><%=periodo%><%}%></b> <%if(!luogo.equals("")){%>presso <%=luogo%><%}%>
		<%	if (edizione instanceof EdizioneInterna){
				EdizioneInterna edizioneInterna=(EdizioneInterna)pagina;
				List<PuntoProgramma> programma=edizioneInterna.getProgramma();
				if(programma.size()>0){%>
					<h2 style="font-family : Arial, Helvetica, sans-serif;font-size:16px; color:#071d49 !IMPORTANT;"><img src="http://www.xxx.it/imgs/icone/eventi_icona.png"/>Programma</h2>
				<%	for (PuntoProgramma pr: programma){%>
					<%	if (pr.info_data!=null && !pr.info_data.equals("")){%><h3 style="font-family : Arial, Helvetica, sans-serif;font-size:1.1rem; color:#071d49; margin:0; padding:0;"><%=pr.info_data%></h3><%}%>
					<%	if (pr.titolo!=null && !pr.getInfoTitolo().equals("")){%><h4 style="font-family : Arial, Helvetica, sans-serif; color:#071d49; margin-top:0.5rem;"><%=pr.getInfoTitolo()%></h4><%}%>
				<%	}%>
			<%	}%>
		<%		if (edizioneInterna.a_pagamento){%><b>Evento a pagamento</b><br/><%}else{%><b>La partecipazione è gratuita</b><br/><%}%>
		<%		if(edizioneInterna.iscrizione_online){%> 
					<h2 style="font-family: Arial, Helvetica, sans-serif;font-size:1.3rem; color:#071d49;">
						<a style="font-family: Arial, Helvetica, sans-serif;font-size:1rem; color:#071d49;" href="http://www.xxx.it<%=edizioneInterna.getLinkIscrizione() %>&pk_campaign=<%=DateUtils.formatDate(new Date(),"yyyyMMdd") + "-" +  it.cise.util.http.HttpUtils.getTextForWebLink(edizioneInterna.getTitolo())%>&pk_kwd=iscrizione">
							<img src="http://www.xxx.it/imgs/icone/iscrizione_icona.png"/>Iscriviti online
						</a>
					</h2>
			<%	}%>
		<%	}%>
	<%	}else if(pagina instanceof Documento){
			Documento documento=(Documento)pagina;
			List<Paragrafo> paragrafi=documento.getParagrafi();%>
			<%if(pagina.getTipo().estende() == TipoDocumento.COMUNICAZIONE){%>
				<%	for (Paragrafo p: paragrafi){%>
					<div style="margin-top:1rem; display:block; overflow: hidden;">
					<%	if ((p.titolo!=null)&&(!p.titolo.equals(""))){%>
							<span id="<%=p.id_paragrafo %>"></span><h2><%=p.titolo %></h2>
					<%	}%>
					<%	if (p.img_path!=null){%>
							<img src="http://www.xxx.it<%=p.img_path %>" style="float:right; max-width:40%;cursor:pointer; margin:1rem 0.5rem 0.5rem 0">
					<%	}%>
					<%	if (p.testo!=null){%>
							<%=p.testo.replace("<a href=", "<a style='color: #007bff !IMPORTANT' href=") %>
					<%	}%>
					</div>
				<%	}%>
	
	<%		}else {%>
			<%	if(paragrafi.size()>0){%>
					<ul style="list-style-type:none;">
			<%		for (Paragrafo p: paragrafi){%>
					<%	if(p.titolo!=null && !p.titolo.equals("")){%>
							<li style="padding-bottom:10px;"><a style="text-decoration:none; color: #007bff;" href="http://www.xxx.it<%=pagina.getLink()%>#<%=p.id_paragrafo %>"><img src="http://www.xxx.it/imgs/icone/list-item.png"/> <%=p.titolo %></a></li>
				<%		}%>
				<%	}%>
					</ul>
			<%	}%>
		<%	}%>
		
	<%	}%>
	
	<%
		List<DocumentoWeb<?>> lista=new ArrayList<DocumentoWeb<?>>();
		List<Edizione> edizioni=new ArrayList<Edizione>();
		TipoDocumento tipo = null;
		if (pagina instanceof Attivita){
			Attivita attivita=(Attivita)pagina;
			edizioni=(pagina instanceof GruppoAttivita ? attivita.getEdizioni(true, true, null) : attivita.getEdizioni());
		}
	%>
	<%	Set<Edizione> edizioniAgenda=null;
			if(edizioni.size()>0) {
				lista=new ArrayList<DocumentoWeb<?>>();
				for (Edizione e: edizioni) lista.add(e);
				List<DocumentoWeb<?>> documenti=lista;
				int numElementiCollettore=lista.size();
				int contatore=0;
				edizioniAgenda=new TreeSet<Edizione>(new Comparator<Edizione>() {
					public int compare(Edizione e1, Edizione e2) {
						int ordine = e1.getDal().compareTo(e2.getDal());	// Prima ordine di data...
						if (ordine == 0){
							ordine = e1.getId().compareTo(e2.getId());
						}//...poi eventualmente di ID
						return ordine;
					}
				}
				);
				edizioniAgenda.addAll(DocumentFactory.getAll(documenti, Edizione.class));
				if(edizioniAgenda.size()>0){
					for(Edizione e: edizioniAgenda){
						if(e.getDal().after(new Date())){
							if(numElementiCollettore>0){
								contatore=contatore+1;%>
								<div style="font-family:Arial; <%=((contatore%2)==0? " background-color: #ffffff; border-left: 4px #efefef solid;" : "background-color: #c0c9dc; border-left: 4px #071d49 solid;")%>  ; margin-right:0px; margin-left:0px; padding-top:5px; display: flex;">
									<div style="width:15%; text-align:center; float:left;">
										<h1 style="margin:0; padding:0;"><span style="color: #fff;background-color: #071d49; display: inline-block;padding: .25em .4em;font-size: 75%;font-weight: 700;line-height: 1;text-align: center;white-space: nowrap;vertical-align: baseline; border-radius: .25rem;"><%=DateUtils.formatDate(e.getDal(), "dd") %></span></h1>
										<h3 style="margin:0; padding:0; color:#071d49;"><%=DateUtils.formatDate(e.getDal(), "MMM").toUpperCase() %></h3>
									</div>
									<div style="padding-left:5px; width:85%; float:left;">
										<h3 style="margin:5px 0; font-size:16px;"><a href="http://www.xxx.it<%=e.getLink()%>" style="color:#071d49 !IMPORTANT; text-decoration:none; margin:0; padding:0;"><%=e.getTitolo()%></a></h3>
										<p style="margin-top:8px; font-size:14px;">
											<%	if(e.getLuogo()!=null){%>
													<span class="small"><img style="width:20px; color:#071d49;" src="http://www.xxx.it/imgs/icone/localizza_icona.png"> <%=e.getLuogo()%></span><br/>
											<%	}%>
												<span class="small" style="margin-top:0.5rem;"><a href="http://www.xxx.it<%=e.getLink()%>" style="color:#071d49 !IMPORTANT;"> <img src="http://www.xxx.it/imgs/icone/orologio_icona.png" style="width:20px;"><b>Programma</b></a></span>
											<%	if(e instanceof EdizioneInterna){
													EdizioneInterna eInterna = (EdizioneInterna)e;%>
												<%	try{
														if (eInterna.getDataScadenzaIscrizione().after(new Date())){%>
														<span>
														 <a href="http://www.xxx.it<%=eInterna.getLinkIscrizione() %>" style="color:#071d49 !IMPORTANT;"><img src="http://www.xxx.it/imgs/icone/iscrizione_icona.png" style="width:20px;"><b> Iscriviti</b></a>
														</span>
												<%		}
													}catch(Exception e1){}%>
											<%	}%>
										</p>
									</div>
								</div>
							<%	numElementiCollettore--;
							}
						}%>
			
			<%		}%>
			<%	}%>
		<%	}%>
	
	<p><a style="color: #007bff !IMPORTANT" href="http://www.xxx.it<%=pagina.getLink()%>&pk_campaign=<%=DateUtils.formatDate(new Date(),"yyyyMMdd") + "-" +  it.cise.util.http.HttpUtils.getTextForWebLink(pagina.getTitolo())%>&pk_kwd=sito"><img src="http://www.xxx.it/imgs/mail_icon/link_icona.png" style="border:0 !IMPORTANT;"/>
	<%if(pagina instanceof Pubblicazione){%>
		Visualizza l'ultimo volume
	<%}else{%>
		Per saperne di più
	<%}%>
	</a></p>

	
	<%	if(areaNewsletter!=null && !areaNewsletter.equals("")){%>
		</div>
		<hr style="color: #33519c; size:2px;" />
		<p style="font-size : 12px;margin:1em 1.5em 1em 0;max-width:600px;text-align:center; margin-top:0;">
			<b>XXX - </b> <br />
			<a href="http://www.xxx.it" style="color : Navy;">http://www.xxx.it</a>
			<br /><br />
			ATTENZIONE - Non scrivere a abc@xxx.it, indirizzo non presidiato<br />SE NON DESIDERI PIU' RICEVERE QUESTA NEWSLETTER,&nbsp; <a href="http://www.xxx.it/newsletter/cancellazione.jsp?areaNewsletter=<%=areaNewsletter%>&amp;email=$contact_email1">CLICCA QUI</a>
		</p>
	</div>	
	<%	}else{%>
		</div>
	</div>
	<div style="width:80%;background-color:#dddddd;">	
		<h2 style="background:orange;"><strong>Per completare la creazione della mail</strong></h2>
		<h3>Scegli l'area tematica dell'evento</h3>

		<form name="scelta_nl" method="post" action="crea_email_new.jsp" onsubmit="return checkInserimento()">
			<select id="areaNewsletter" name="areaNewsletter" style="font-size:1.2rem;">
					<option value="" >--- Scegli l'area tematica ---</option>
				<%	for (Row<String> rs : pager){%>
						<option value="<%=rs.getField("id_tematica") %>"><%=rs.getField("nome") %></option>
				<%	}%>
			</select>
			<input type="hidden" name="ID_D" value="<%=pagina.getId()%>" />
			<button type="submit" style="width:250px;font-size:1.2rem;margin-top:10px;">Procedi</button>
		</form>
	</div>	
	<%	}%>
</body>
</html>