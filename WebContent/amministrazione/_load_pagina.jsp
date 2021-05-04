<%	// 1. Prova a caricare la pagina a partire dall'ID
	AbstractDocumentoWeb<?> pagina=null;
	PaginaWeb<?> padre = null;
	TipoDocumento tipoPagina = null;
	TipoSistema tipoSistemaPagina = null;
	boolean paginaModificabile = false;

	try{
		Long id=null;
		try{
			id = Long.parseLong(requestMP.getParameter(rq_documento));
		}catch(Exception eID){
			if (!inserimento)
				id=HOME_ID_D;	// Home aree tematiche
			else
				throw new Exception("In corso inseriemnto di nuovo documento");
		}
		
		pagina = (AbstractDocumentoWeb<?>)DocumentFactory.load(connPostgres, id);
				
		if (!pagina.accessibile(operatore))
			response.sendRedirect(HOME_ADMIN);
		else
			paginaModificabile = pagina.modificabile(operatore);
	}catch(Exception e){}
	
	// 2. Verifica se si sta creando un nuovo documento
	if (inserimento){
		try{
			Long tipo=Long.parseLong(requestMP.getParameter(rq_operazione + "_crea_tipo_d"));
			TipoDocumento nuovoTipoDocumento=TipoDocumento.fromID(tipo);
			
			paginaModificabile = nuovoTipoDocumento.modificabile(operatore);
			
			TipoSistema nuovoTipoSistema=null;
			try{
				Long tipoSistemaId=Long.parseLong(requestMP.getParameter(rq_operazione + "_crea_tipo_s"));
				nuovoTipoSistema=TipoSistema.fromID(tipoSistemaId);
			}catch(Exception e){
				// TipoSistema di default in base al TipoDocumento
				switch (nuovoTipoDocumento){
					case EDIZIONE_EVENTO_CAMERA:
						nuovoTipoSistema=TipoSistema.EVENTO;
						break;
					case IMMAGINE: case ATTO_EVENTO: case GUIDA: case MODULISTICA: case GUIDE_E_MODULI: case VOLUME: case FILE_UTILE: case FILE_ALLEGATO:
					case DOCUMENTO_RISERVATO_GIUNTA: case DOCUMENTO_RISERVATO_CONSIGLIO: case DOCUMENTO_RISERVATO_REVISORI:
					case DOCUMENTO_AMMINISTRAZIONE_TRASPARENTE: case NOTIZIARIO:
						nuovoTipoSistema=TipoSistema.DOWNLOAD;
						break;
					case EDIZIONE_EVENTO_CISE: case VIDEO: case NORMATIVA: case NOTIZIA_DAL_TERRITORIO: case LINK_UTILE:
						nuovoTipoSistema=TipoSistema.LINK;
						break;
					default:
						nuovoTipoSistema=TipoSistema.DOCUMENTO;
				}
			}
			
			padre = (PaginaWeb<?>)pagina;
			
			pagina=(padre==null ?
				(AbstractDocumentoWeb<?>)DocumentFactory.newInstance(connPostgres, operatore, nuovoTipoSistema, nuovoTipoDocumento) :
				(AbstractDocumentoWeb<?>)padre.creaFiglio(operatore, nuovoTipoSistema, nuovoTipoDocumento, false)
			);
			
		}catch(Exception e){e.printStackTrace();}
	}
	
	if (pagina != null){
		tipoPagina=pagina.getTipo();
		tipoSistemaPagina = TipoSistema.fromID(pagina.id_tipo_sistema);
		
		if (backwrapper==null)
			backwrapper = new CdCURLWrapper(connPostgres, new URL(
				currentServer + (
					pagina!=null && pagina.isInserted()
					? pagina.getAdminLink()
					: (
						padre!=null
						? padre.getAdminLink()
						: HOME_ADMIN
					)
				)
			));
	}
%>