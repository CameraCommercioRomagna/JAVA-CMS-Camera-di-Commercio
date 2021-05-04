package it.cise.util.http;

import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import cise.utils.Logger;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.portale.cdc.documenti.ForwardBehaviour;
import it.cise.portale.cdc.documenti.DocumentFactory;
import it.cise.portale.cdc.documenti.DocumentoWeb;
import it.cise.portale.cdc.documenti.PaginaWeb;
import it.cise.portale.cdc.documenti.TipoDocumento;
import it.cise.portale.cdc.documenti.TipoSistema;


public class CdCURLWrapper extends URLWrapper {
	
	private DBConnectPool dbPool;
	private DocumentoWeb<?> documento;
	private List<DocumentoWeb<?>> gerarchiaDocumento;
	//private static final List<String> REWRITE_RESOURCE_ALLOWED = Arrays.asList("collettore.htm", "paginaWeb.htm");
	
	public CdCURLWrapper(DBConnectPool pool, URL url){
		super(url);
		dbPool = pool;
		
		rewriteResource();
	}
	public CdCURLWrapper(CdCURLWrapper wrapper){
		super(wrapper);
		this.dbPool = wrapper.getPool();
		
		rewriteResource();
	}
	private CdCURLWrapper(DBConnectPool pool, URLWrapper wrapper){
		super(wrapper);
		dbPool = pool;
		
		rewriteResource();
	}
	public CdCURLWrapper(DBConnectPool pool, HttpServletRequest request){
		super(request);
		dbPool = pool;
		
		rewriteResource();
	}
	

	private DBConnectPool getPool() {
		return dbPool;
	}

/**
 * 	Gestisce la riscrittura del path / semplificazione dei parametri per riscrittura di nomi dei collettori
 * 	(definizione da file di apache) 
 */
	private void rewriteResource() {
		try {
			switch (RewriteResourceAllowed.fromPage(rFile)){
				case COLLETTORE:
					String nomeParametro = TipoDocumento.PARAMETER_ID;
					TipoDocumento tipo = null;
					try{
						tipo = TipoDocumento.fromID(new Long(getParameter(nomeParametro).get(0)));
					}catch(Exception e1){
						try{
							nomeParametro = TipoDocumento.PARAMETER_WEB_NAME;
							tipo = TipoDocumento.fromWebName(getParameter(nomeParametro).get(0));
						}catch(Exception e2){}
					}
					
					if (tipo!=null){
						String nomeRisorsa=tipo.getWebName();
						rFile=nomeRisorsa+rFile.substring(rFile.indexOf("."));
						removeParameter(nomeParametro);
					}
					break;
				case PAGINA_WEB:
					try{
						String documentoKey=(
								getParameter(AbstractDocumentoWeb.PARAMETER_ID)!=null ? 
								getParameter(AbstractDocumentoWeb.PARAMETER_ID) : 
								getParameter(AbstractDocumentoWeb.PARAMETER_PAGE)
						).get(0);
						documento = DocumentFactory.fromString(getPool(), documentoKey);
						
						rPath=documento.getPathLink();
						rFile=documento.getResourceName();
					}catch(Exception e){}
					break;
				case PAGINA_OLD_WEB:
					try{
						String documentoKey=(
								getParameter(AbstractDocumentoWeb.PARAMETER_ID)!=null ? 
								getParameter(AbstractDocumentoWeb.PARAMETER_ID) : 
								getParameter(AbstractDocumentoWeb.PARAMETER_PAGE)
						).get(0);
						documento = DocumentFactory.fromString(getPool(), documentoKey, true); //case_old_db=true;
						Logger.write("***** CdCURLWrapper PAGINA_OLD_WEB documento.isCaseOldDB() " + documento.isCaseOldDB());
						rPath=documento.getPathLink();
						rFile=documento.getResourceName();
					}catch(Exception e){}
					break;
				case INDEX_AMMINISTRAZIONE:
					try{
						String documentoKey=(
								getParameter(AbstractDocumentoWeb.PARAMETER_ID)!=null ? 
								getParameter(AbstractDocumentoWeb.PARAMETER_ID) : 
								getParameter(AbstractDocumentoWeb.PARAMETER_PAGE)
						).get(0);
						documento = DocumentFactory.fromString(getPool(), documentoKey);
					}catch(Exception e){}
					break;
				default:
			}
		}catch (IllegalArgumentException e) {}
	}
	
	@Override
	public CdCURLWrapper extractURL(String parameter)
		throws MalformedURLException, UnsupportedEncodingException {
		
		URLWrapper tempWrapper=super.extractURL(parameter);
		return (tempWrapper!= null ? new CdCURLWrapper(getPool(), tempWrapper) : null);
	}
	
	public boolean removeParameterTree(String name){
		boolean rimosso=false;
		Set<String> parameterNames = getParameters().keySet();
		for (String n: parameterNames)
			if (n.startsWith(name))
				removeParameter(n);
		return rimosso;
	}
	
	public DocumentoWeb<?> getDocumento(){
		return documento;
	}
	
	public List<DocumentoWeb<?>> getDocumentoGerarchia(){
		return getDocumentoGerarchia(ForwardBehaviour.FORWARD, false);
	}
	public List<DocumentoWeb<?>> getDocumentoGerarchia(ForwardBehaviour forwardType, boolean keepCurrentDocument){
		if (gerarchiaDocumento == null) {
			gerarchiaDocumento = new ArrayList<DocumentoWeb<?>>();
			
			try {
				AbstractDocumentoWeb<?> risorsa = (AbstractDocumentoWeb<?>)documento;
				
				try {
					do {
						if (keepCurrentDocument) {
							if ((forwardType == ForwardBehaviour.NO_FORWARD) || (risorsa instanceof PaginaWeb && !((PaginaWeb<?>)risorsa).isForward()))
								gerarchiaDocumento.add(0, DocumentFactory.cast(risorsa, risorsa.isCaseOldDB()));
						}else
							keepCurrentDocument = true;
						risorsa = risorsa.getPadre();
					}while(risorsa != null);
				}catch(Exception e) {}
				
			}catch(Exception e) {}
		}
		return gerarchiaDocumento;
	}
	
	public static void main(String[] args) throws Exception{
		
	}
	
}

enum RewriteResourceAllowed{
	PAGINA_WEB("paginaWeb.htm"), PAGINA_OLD_WEB("paginaOldWeb.htm"), COLLETTORE("collettore.htm"), INDEX_AMMINISTRAZIONE("index.htm");
	
	private String nomaPagina;
	
	RewriteResourceAllowed(String nomaPagina){
		this.nomaPagina=nomaPagina;
	}
	
	static RewriteResourceAllowed fromPage(String pagina) {
		RewriteResourceAllowed rFound=null;
		for (RewriteResourceAllowed r: values())
			if (r.nomaPagina.equals(pagina))
				rFound=r;			
		
		if (rFound==null)
			throw new IllegalArgumentException(pagina + " non è una risorsa trasfromabile. Disponibili " + values());
		
		return rFound;
	}
}