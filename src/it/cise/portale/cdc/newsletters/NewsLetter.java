package it.cise.portale.cdc.newsletters;

import java.util.List;

import it.cise.db.CounterRecord;
import it.cise.db.jdbc.DBConnectPool;
import it.cise.portale.cdc.documenti.AbstractDocumentoWeb;
import it.cise.portale.cdc.documenti.TipoDocumento;

public class NewsLetter extends CounterRecord {
	
	static final long serialVersionUID = 3771950404433468441L;
	
	public static final String NAME_TABLE = AbstractDocumentoWeb.NAME_SCHEMA+".nl_tipi";
	public final static String PARAMETER_ID="ID_NLTIPO";

	public Long id_nl_tipo;
	public String nome;
	public Long num_max_numeri;
	public String descrizione;
	public Long gg_associa_entro;
	public Long id_tipo_documento_web;
	public String url_pubblico;
	
	private TipoDocumento tipo;
	private List<Sezione> sezioni;
	
	public NewsLetter(){
		super(NAME_TABLE);
	}
	
	public NewsLetter(Long id, DBConnectPool pool){
		super(NAME_TABLE, pool);
		this.id_nl_tipo = id;
		load();
	}
	
	public String getNome(){
		return nome;
	}
	
	
	public List<Sezione> getSezioni(){
		if (sezioni==null)
			sezioni=loadEntitiesFromQuery("select * from " + Sezione.NAME_TABLE + " where id_nl_tipo=" + id_nl_tipo + " order by ordine", getPool(), Sezione.class, this);
		
		return sezioni;
	}
	
	public TipoDocumento getTipo(){
		if (tipo==null && id_tipo_documento_web!=null)
			tipo = TipoDocumento.fromID(id_tipo_documento_web);
		return tipo;
	}
	
}
