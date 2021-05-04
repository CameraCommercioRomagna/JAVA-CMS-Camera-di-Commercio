package it.cise.portale.cdc.documenti;

import it.cise.portale.cdc.documenti.download.Download;
import it.cise.portale.cdc.documenti.eventi.EdizioneInterna;
import it.cise.portale.cdc.documenti.referenza.Referenza;
import it.cise.portale.cdc.documenti.standard.Documento;

public enum TipoSistema {

	DOCUMENTO(1l, Documento.class), 
	EVENTO(2l, EdizioneInterna.class), 
	DOWNLOAD(3l, Download.class),
	LINK(4l, Referenza.class);
	
	private Long id_tipo_sistema;
	private Class<? extends DocumentoWeb<?>> defaultGeneratedClass;
	
	private TipoSistema(Long id,  Class<? extends DocumentoWeb<?>> defaultGeneratedClass) {
		this.id_tipo_sistema = id;
		this.defaultGeneratedClass = defaultGeneratedClass;
	}
	
	public Long getId() {
		return id_tipo_sistema;
	}
	
	public static TipoSistema fromID(Long id) {
		TipoSistema eFound=null;
		for (TipoSistema e: values())
			if (e.id_tipo_sistema.equals(id))
				eFound=e;			
		
		return eFound;
	}
	
	public Class<? extends DocumentoWeb<?>> getDefaultGeneratedClass() {
		return defaultGeneratedClass;
	}
}
