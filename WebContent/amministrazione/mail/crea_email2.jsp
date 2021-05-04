<%@include file="/amministrazione/common/include/begin.jsp" %>

<!doctype html>

<%@include file="/amministrazione/_load_pagina.jsp" %>
<%@include file="/common/componenti/collettori/_tab_anni-import.jsp"%>

<%	QueryPager pager = new QueryPager(connPostgres);
	pager.set("select * from " + TematicaNl.NAME_TABLE + " order by nome");
	String key = UUID.randomUUID().toString();
	
	String areaNewsletter = request.getParameter("areaNewsletter")==null ? "" : request.getParameter("areaNewsletter");

	EmailWeb email = null;
	Long id_email = null;
	try{
		id_email = Long.parseLong(requestMP.getParameter(rq_email));
		email = new EmailWeb(id_email, connPostgres);
	}catch(Exception eID){
	}
	
	Emailable obj_emailable = null;
	if(email!=null)
		obj_emailable = email;
	else
		obj_emailable = (PaginaWeb)pagina;
	
	List<ItemEmailable> punti = obj_emailable.getItem();
	
	Boolean isEvento=false;
	String luogo=obj_emailable.luogoENote();
	String periodo=obj_emailable.periodoENote();
	String indicazioneOrario=obj_emailable.getOrario();
	String iscrizione="";
	EdizioneInterna edizione=null;
	if (pagina instanceof Edizione){
		edizione=(EdizioneInterna)pagina;
		isEvento=true;

		try{
			Date oggi = cise.utils.DateUtils.stringToDate(cise.utils.DateUtils.formatDate(new Date(),"dd/MM/yyyy"));
			if (!edizione.getDataScadenzaIscrizione().before(oggi)){
				iscrizione="<a href=" + edizione.getLinkIscrizione() + "><p style='font-size:1rem;'><i class='fas fa-edit'></i> Iscriviti</p></a>";
			}
		}catch(Exception e){}
	}
%>

	

<html>
<head>
<title><%=obj_emailable.getTitolo() %></title>
	<script src="/common/js/jquery-3.3.1.min.js" type="text/javascript"></script>
	<script src="/common/js/clipboard.min.js"></script>
	<script>
	function viewSource(){;
	$("#buttonSource").empty();
	$("#buttonSource").remove();
    var source = "<div class='email'>";
    source += document.getElementsByTagName('body')[0].innerHTML;
    source += "</div>";
    source = source.replace(/</g, "&lt;").replace(/>/g, "&gt;");
    source =  " <textarea  readonly rows=35 cols=100 id=\"bar\"> "+source+"</textarea> <script src=\"/common/js/clipboard.min.js\"><\/script><br/> <button style=\"font-size:15px;\" class=\"btn\" data-clipboard-action=\"copy\" data-clipboard-target=\"#bar\" onClick=\" new ClipboardJS('.btn')\">Copia codice</button>" ;
	sourceWindow = window.open('','Source of page','height=800,width=900,scrollbars=1,resizable=1');
    sourceWindow.document.write(source);
    sourceWindow.document.close(); 
    if(window.focus) sourceWindow.focus();
} 
</script>


</head>

<body>

<div style="clear:both;overflow:hidden;max-width:600px;display:block;font-family :sans-serif, Helvetica, Arial; margin-left:10px; font-size: 16px;">
	<div>
		<a href="http://www.xxx.it" title="XXX">
			<img src="http://www.xxx.it/imgs/xxx.jpg" alt="XXX" border="0"/>
		</a>
	</div>
	<%		if ((obj_emailable.getIcona()!=null)&&(!obj_emailable.getIcona().equals(""))){%><p style="text-align:center; margin:0.3rem 0 0 0;"><img src="http://www.xxx.it/<%=obj_emailable.getIcona()%>" alt="" style="max-width:600px; max-height:180px;" /></p><%}%>
		<%if (isEvento){%>
		<div style="overflow-x:auto; margin-top:0.3rem;">
			<table style="background-color:#071d49; border-radius:15px; text-align:center; font-size: 13px; width:100%;">
				<tr>
					<td style="width:200px; color:white;">
						<%=periodo%>
					</td>
					<%if(obj_emailable.getOrario()!=null){%>
						<td style="width:200px; border-left:2px solid white; color:white;"><%=obj_emailable.getOrario()%></td>
					<%}%>
					<%if(!luogo.equals("")){%>
						<td style="width:200px; border-left:2px solid white; color:white;"><%=luogo%></td>
					<%}%>
				</tr>
			</table>
		</div>
			
	<%}%>
	<div style="font-family: Arial; color: #000000;">
		<h1 style="font-family : Arial, Helvetica, sans-serif;font-size:24px; color:#071d49 !IMPORTANT;"><%=obj_emailable.getTitolo() %></h1>
		
		<%	if ((obj_emailable.getAbstract()!=null) && (obj_emailable.getTipo().estende() != TipoDocumento.COMUNICAZIONE)){%>
		<p style="font-size:16px; max-width:580px; overflow:hidden;">
			<%=obj_emailable.getAbstract()%>
		</p>
		<%}%>
		<%	if (isEvento){%>
		<%		if (edizione instanceof EdizioneInterna){
					EdizioneInterna edizioneInterna=(EdizioneInterna)pagina;
					if(punti.size()>0){%>	
						<h2 style="font-family : Arial, Helvetica, sans-serif;font-size:16px; color:#071d49 !IMPORTANT;">Programma</h2>
						<div style="overflow-x:auto;">
						<table cellspacing=0>
								<%	for (ItemEmailable pr: punti){%>
									<tr style="height:2rem;">
									<%--	if (!pr.getData().equals("")){%><h3 style="font-family : Arial, Helvetica, sans-serif;font-size:1.1rem; color:#071d49; margin:0; padding:0;"><%=pr.getData()%></h3><%}--%>
										<td style="width:100px; vertical-align:top; border-bottom: 2px solid #ddd; cell-padding:0;">
											<%	if(!pr.getOrario().equals("")){%>
												<time style=" font-weight:bold;"><%=pr.getOrario()%></time>
											<%	}%>
										</td>
										<td style="width:500px; vertical-align:top; border-bottom: 2px solid #ddd;">
											<%	if (pr.getTitolo()!=null && !pr.getTitolo().equals("")){%><p style="font-weight:bold; color:#071d49; margin-bottom:-10px; margin-top:0"><%=pr.getTitolo()%></p><%}%>
											<%	if (pr.getTesto()!=null){
													String testo = pr.getTesto();
													if(testo.indexOf("<ul")>=0){
														testo = testo.replaceAll("<li","<li style=\"margin-left:-1rem!important;\" ");
													}	%>
												<span style="font-size:0.85rem;"><%=testo %></span>
											<%	}%>
										</td>
									</tr>
							<%		}%>
							
						</table>
				<%	}%>
				<br/>
				
				
			<%		if(edizioneInterna.iscrizione_online){%> 
					
						<div style="margin-top:15px; margin-left:187px; background-color:#071d49!IMPORTANT; border-color:#071d49; border-radius:15px; text-align:center; font-size: 13px; width:220px;">
						<% String link="";
						if(edizioneInterna.getLinkIscrizione().contains("http")){
							link=edizioneInterna.getLinkIscrizione();
						}else{
							link="http://www.xxx.it" +edizioneInterna.getLinkIscrizione()+ "&pk_campaign=" +DateUtils.formatDate(new Date(),"yyyyMMdd") + "-" +  it.cise.util.http.HttpUtils.getTextForWebLink(edizioneInterna.getTitolo()) + "&pk_kwd=iscrizione";
						}
						%>
							
							<a style="font-family: Arial, Helvetica, sans-serif;font-size:1.8rem; color:#ffffff; text-decoration:none;" href="<%=link%>">
								Iscriviti online
							</a>
						
						</div>
					
					
			<%	}%>
			<p style="text-align:center;"><%if (edizioneInterna.a_pagamento!=null && edizioneInterna.a_pagamento){%><b>Evento a pagamento</b><%}else{%><b>La partecipazione è gratuita</b><%}%></p>
		
		<%	}%>
	<%	}else if(pagina instanceof Documento){%>
			
			<%	if(punti.size()>0){%>
				<%	if(email!=null){%>
						<div style="overflow-x:auto;">
							<table cellspacing=0>
					<%	for (ItemEmailable p: punti){%>
						<tr><td style="vertical-align:top; border-bottom: 2px solid #ddd; padding-top:10px; padding-bottom:10px;">
						<%	if(p.getTitolo()!=null && !p.getTitolo().equals("")){%>
								<h4><%=p.getTitolo() %></h4>
						<%	}%>
						<%	if (p.getImmagine() !=null){%>
							
						
								<img src="http://www.xxx.it<%=p.getImmagine() %>" style="float:right; max-width:40%; margin:1rem 0.5rem 0.5rem 0.3rem">
							
					<%	}%>
						<%	if(p.getTesto()!=null && !p.getTesto().equals("")){%>
									<%=p.getTesto()%>
						<%	}%>
						
						</td></tr>
					<%	}%>
							</table>
						</div>
				<%	}else{%>
						<ul style="list-style-type:none;">
					<%	for (ItemEmailable p: punti){%>
						<%	if(p.getTitolo()!=null && !p.getTitolo().equals("")){%>
							<li style="padding-bottom:10px;"><a style="text-decoration:none; color: #007bff;" href="http://www.xxx.it<%=pagina.getLink()%>#<%=p.getId() %>"><img src="http://www.xxx.it/imgs/icone/list-item.png"/> <%=p.getTitolo() %></a></li>
					<%		}%>
				<%		}%>
					</ul>
				<%}%>
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
											<%	if(e.getOrario()!=null){%>
													<span class="small"><%=e.getOrario()%></span><br/>
											<%	}%>
											
												<span class="small" ><a href="http://www.xxx.it<%=e.getLink()%>" style="color:#071d49 !IMPORTANT;"> <img src="http://www.xxx.it/imgs/icone/orologio_icona.png" style="width:20px;"><b>Programma</b></a></span>
											<%	if(e instanceof EdizioneInterna){
													EdizioneInterna eInterna = (EdizioneInterna)e;%>
												<%	try{
														if (eInterna.getDataScadenzaIscrizione().after(new Date())){%>
															<% String elink="";
																if(eInterna.getLinkIscrizione() .contains("http")){
																	elink=eInterna.getLinkIscrizione() ;
																}else{
																	elink="http://www.xxx.it" +eInterna.getLinkIscrizione() + "&pk_campaign=" +DateUtils.formatDate(new Date(),"yyyyMMdd") + "-" +  it.cise.util.http.HttpUtils.getTextForWebLink(eInterna.getTitolo()) + "&pk_kwd=iscrizione";
																}
															%>
														<span>
														 <a href="<%=elink%>" style="color:#071d49 !IMPORTANT;"><img src="http://www.xxx.it/imgs/icone/iscrizione_icona.png" style="width:20px;"><b> Iscriviti</b></a>
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
	
	<div style="margin-top:15px; background-color:#071d49!IMPORTANT; border-color:#071d49; border-radius:15px; text-align:center; font-size: 13px; width:100%;"><a style="font-size: 13px; width:100%; color:#ffffff; text-decoration:none; " href="http://www.xxx.it<%=pagina.getLink()%>&pk_campaign=<%=DateUtils.formatDate(new Date(),"yyyyMMdd") + "-" +  it.cise.util.http.HttpUtils.getTextForWebLink(pagina.getTitolo())%>&pk_kwd=sito">
	<%if(pagina instanceof Pubblicazione){%>
		Visualizza l'ultimo volume
	<%}else{%>
		Per saperne di più
	<%}%>
	</a></button>

	
<%	if(areaNewsletter!=null && !areaNewsletter.equals("")){%>	
		</div>
		<hr style="color: #33519c; size:2px;" />
		<p style="font-size :12px;margin:1em 1.5em 1em 0;max-width:600px;margin-top:0; text-align:center;">
			<b>XXX - </b> <br />
			<a href="https://www.xxx.it" style="color : Navy;">https://www.xxx.it</a>
			<br /><br />
			ATTENZIONE - Non scrivere a abc@xxx.it, indirizzo non presidiato<br />SE NON DESIDERI PIU' RICEVERE QUESTA NEWSLETTER,&nbsp; <a href="http://www.xxx.it/newsletter/cancellazione.jsp?areaNewsletter=<%=areaNewsletter%>&amp;email=$contact_email1">CLICCA QUI</a>
		</p>
	</div>
<%	}else{%>
		</div>
	</div>
	<div style="width:100%;background-color:#dddddd;">	
		<h2 style="background:orange; font-size:18px;"><strong>Per completare la creazione della mail</strong></h2>
		<h3>Scegli l'area tematica dell'evento</h3>

		<form name="scelta_nl" method="get" action="crea_email2.jsp" onsubmit="return checkInserimento()">
			<select id="areaNewsletter" name="areaNewsletter" style="font-size:1.2rem;">
					<option value="" >--- Scegli l'area tematica ---</option>
				<%	for (Row<String> rs : pager){%>
						<option value="<%=rs.getField("id_tematica") %>"><%=rs.getField("nome") %></option>
				<%	}%>
			</select>
			<input type="hidden" name="<%=rq_documento%>" value="<%=pagina.getId()%>" />
			<%	if(email!=null){%>
				<input type="hidden" name="<%=rq_email%>" value="<%=email.getId()%>" />
			<%	}%>
			<button type="submit" style="width:250px;font-size:1.2rem;margin-top:10px;">Procedi</button>
		</form>
	</div>	
<%	}%>

</body>
<%	if(areaNewsletter!=null && !areaNewsletter.equals("")){%>
<button style="margin:10px 0 20px 120px; font-size:15px;" id="buttonSource" type="button"  onclick="viewSource()">Visualizza il codice da copiare per creare la mail</button>
<%	}%>
</html>