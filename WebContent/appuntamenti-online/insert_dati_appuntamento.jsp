<%@include file="/common/include/begin.jsp" %>
		
		
<%
	Appuntamento appuntamento=null;
	//Intermediario intermediario=null;
	Servizio servizio=null;
	
	try{
		Long id=Long.parseLong(request.getParameter("id_appuntamento"));
		appuntamento=new Appuntamento(connPostgres, id);
		servizio=appuntamento.getServizio();
	
		IRichiedente richiedente=null;
		Long id_intermediario=null;
		if(servizio!=Servizio.UFFICIO_IMPEGNATO){
			if(appuntamento.getStatoInserimento()==AppuntamentoStatoInserimento.OPZIONATO){
				String intestatario=request.getParameter("intestatario");
				String cfIntermediario=request.getParameter("CF_intermediatrio");
				if((intestatario!=null) && (!intestatario.equals(""))&&(intestatario.equals("true"))){
					if((cfIntermediario!=null) && (!cfIntermediario.equals(""))){
						Intermediario intermediario = Intermediario.fromCodiceFiscale(cfIntermediario);
						try{
							appuntamento.addRichiedente(intermediario);
							appuntamento.update();

							richiedente=intermediario;
							id_intermediario=intermediario.id_intermediario;
						}catch(Exception notIntermediario){
							response.sendRedirect("richiedente-pratiche.htm?id_appuntamento="+appuntamento.id_appuntamento + "&notIntermediario=true");
						}
					}
				}else{
						Richiedente richiedenteSemplice=(Richiedente)appuntamento.addRichiedente();
						richiedenteSemplice.setNome(request.getParameter("intestatario_nome"));
						richiedenteSemplice.setCognome( request.getParameter("intestatario_cognome") != null ? request.getParameter("intestatario_cognome") : request.getParameter("intestatario_ragione_sociale") );
						richiedenteSemplice.setEmail(request.getParameter("email"));
						richiedenteSemplice.setTelefono(request.getParameter("telefono"));
						richiedenteSemplice.setCodiceFiscale(request.getParameter("intestatario_cf"));
						
						richiedente=richiedenteSemplice;
						appuntamento.update();
						
						if (richiedente.ammissibile(appuntamento.inizio)){	
							if(request.getParameter("conferma_appuntamento")!=null){
								if (appuntamento.getServizio() != Servizio.UFFICIO_IMPEGNATO){
									Pratica p=appuntamento.addPratica();
									p.tipo_pratica=request.getParameter("tipo_pratica");
									p.intestatario_cf=request.getParameter("intestatario_cf");
									p.referente_nome=request.getParameter("referente_nome");
									p.referente_cognome=request.getParameter("referente_cognome");
									p.referente_cf=request.getParameter("referente_cf");
									//p.intestatario_ragione_sociale=request.getParameter("intestatario_ragione_sociale");
									try{
										p.setServizio(Servizio.getServizio(Long.parseLong(request.getParameter("id_servizio_figlio"))));
									}catch(Exception eServizio){}
									p.utenza_privato=(p.getServizio().getTipoUtenza() == TipoUtenzaRilascio.PRIVATO);
									p.insert();
								}
								appuntamento.note=request.getParameter("note");
								if(appuntamento.prenota(operatore)){
									response.sendRedirect("fine_insert.htm?appc=" + appuntamento.codice);	
								}else{
									response.sendRedirect("index.htm?appuntamentoPerso=true");
								}
							}
						}else{
							response.sendRedirect("blocco_appuntamento.htm?appc=" + appuntamento.codice + "&blocco=maxPratichaUtente");%>
							Il richiedente ha ecceduto il numero massimo di pratiche
					<%		throw new IllegalStateException("Numero massimo di pratiche superato");
						}
				}
			
				if(((richiedente!=null) && (request.getParameter("verifica_intermediario")!=null))){
					if (richiedente.ammissibile(appuntamento.inizio)){
						if(id_intermediario!=null){
							response.sendRedirect("richiedente-pratiche.htm?id_appuntamento="+appuntamento.id_appuntamento + "&id_intermediario=" + id_intermediario) ;
						}else{
							response.sendRedirect("richiedente-pratiche.htm?id_appuntamento="+appuntamento.id_appuntamento);
						}
					}else{
						response.sendRedirect("blocco_appuntamento.htm?appc=" + appuntamento.codice+ "&blocco=maxPratichaIntermediario");%>
						Il richiedente ha ecceduto il numero massimo di pratiche
						intemediario non in archivio
					<%}
				}
			}
			if((appuntamento.getStatoInserimento()==AppuntamentoStatoInserimento.OPZIONATO_RICHIDENTE)||(appuntamento.getStatoInserimento()==AppuntamentoStatoInserimento.OPZIONATO_PRATICHE)){
				if(request.getParameter("insert_pratica")!=null){
					Pratica p=appuntamento.addPratica();
					p.tipo_pratica=request.getParameter("tipo_pratica");
					p.intestatario_nome=request.getParameter("intestatario_nome");
					p.intestatario_cognome=request.getParameter("intestatario_cognome");
					p.intestatario_ragione_sociale=request.getParameter("intestatario_ragione_sociale");
					p.intestatario_cf=request.getParameter("intestatario_cf");
					p.referente_nome=request.getParameter("referente_nome");
					p.referente_cognome=request.getParameter("referente_cognome");
					p.referente_cf=request.getParameter("referente_cf");
					try{
						p.setServizio(Servizio.getServizio(Long.parseLong(request.getParameter("id_servizio_figlio"))));
					}catch(Exception eServizio){}
					p.utenza_privato=(p.getServizio().getTipoUtenza() == TipoUtenzaRilascio.PRIVATO);
					p.insert();
					response.sendRedirect("richiedente-pratiche.htm?id_appuntamento="+appuntamento.id_appuntamento + "&id_intermediario=" + appuntamento.id_intermediario) ;
					
				}
			}
		}else{
			Richiedente richiedenteSemplice=(Richiedente)appuntamento.addRichiedente();
			richiedenteSemplice.setNome(operatore.nome);
			richiedenteSemplice.setCognome(operatore.cognome);
			richiedenteSemplice.setEmail(operatore.email);
			richiedenteSemplice.setCodiceFiscale("04283130401");
		}
		if(request.getParameter("conferma_appuntamento")!=null){
				if(request.getParameter("note")!=null && !request.getParameter("note").equals(""))
					appuntamento.note=request.getParameter("note");
				if(appuntamento.prenota(operatore)){
						response.sendRedirect("fine_insert.htm?appc=" + appuntamento.codice);	
				}else{
						response.sendRedirect("index.htm?appuntamentoPerso=true");
				}	
		}
	}catch(Exception e){
		//response.sendRedirect(HOME);
		e.printStackTrace();
		out.print(appuntamento.getStatoInserimento());
		out.print(appuntamento.getServizio());
	}
	%>
