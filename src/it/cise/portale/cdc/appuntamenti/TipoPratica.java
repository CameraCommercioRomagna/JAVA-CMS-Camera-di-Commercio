package it.cise.portale.cdc.appuntamenti;

public enum TipoPratica {

	RILASCIO_CNS(1l, "RILASCIO_CNS", "Rilascio Carta Nazionale dei Servizi con firma digitale", Servizio.CNS),
	RINNOVO_CNS(2l, "RINNOVO_CNS", "Rinnovo Carta Nazionale dei Servizi con firma digitale", Servizio.CNS),
	RILASCIO_CT_AZ(3l, "RILASCIO_CT_AZ", "Rilascio/rinnovo Carta Tachigrafica Azienda",Servizio.CARTA_TACHIGRAFICA_AZIENDA),
	SOSTITUZIONE_CT_AZ_MALFUNZIONAMENTO(4l, "SOSTITUZIONE_CT_AZ_MALFUNZIONAMENTO", "Sostituzione Carta Tachigrafica Azienda per modifica dati, malfunzionamento o danneggiamento", Servizio.CARTA_TACHIGRAFICA_AZIENDA),
	SOSTITUZIONE_CT_AZ_FURTO(5l, "SOSTITUZIONE_CT_AZ_FURTO", "Sostituzione Carta Tachigrafica Azienda per smarrimento o furto", Servizio.CARTA_TACHIGRAFICA_AZIENDA),
	RILASCIO_CT_COND(6l, "RILASCIO_CT_COND", "Rilascio/rinnovo Carta Tachigrafica Conducente", Servizio.CARTA_TACHIGRAFICA_CONDUCENTE),
	SOSTITUZIONE_CT_COND_MALFUNZIONAMENTO(7l, "SOSTITUZIONE_CT_COND_MALFUNZIONAMENTO", "Sostituzione Carta Tachigrafica Conducente per modifica dati, malfunzionamento o danneggiamento", Servizio.CARTA_TACHIGRAFICA_CONDUCENTE),
	SOSTITUZIONE_CT_COND_FURTO(8l, "SOSTITUZIONE_CT_COND_FURTO", "Sostituzione Carta Tachigrafica Conducente per smarrimento o furto", Servizio.CARTA_TACHIGRAFICA_CONDUCENTE),
	RILASCIO_CT_OFF(9l, "RILASCIO_CT_OFF", "Rilascio/rinnovo Carta Tachigrafica Officina", Servizio.CARTA_TACHIGRAFICA_OFFICINA),
	SOSTITUZIONE_CT_OFF_MALFUNZIONAMENTO(10l, "SOSTITUZIONE_CT_OFF_MALFUNZIONAMENTO", "Sostituzione Carta Tachigrafica Officina per modifica dati, malfunzionamento o danneggiamento", Servizio.CARTA_TACHIGRAFICA_OFFICINA),
	SOSTITUZIONE_CT_OFF_FURTO(11l, "SOSTITUZIONE_CT_OFF_FURTO", "Sostituzione Carta Tachigrafica Officina per smarrimento o furto", Servizio.CARTA_TACHIGRAFICA_OFFICINA),
	RILASCIO_CT_CONTR(12l, "RILASCIO_CT_CONTR", "Rilascio/rinnovo Carta Tachigrafica Controllo", Servizio.CARTA_TACHIGRAFICA_CONTROLLO),
	SOSTITUZIONE_CT_CONTR_MALFUNZIONAMENTO(13l, "SOSTITUZIONE_CT_CONTR_MALFUNZIONAMENTO", "Sostituzione Carta Tachigrafica Controllo per modifica dati, malfunzionamento o danneggiamento", Servizio.CARTA_TACHIGRAFICA_CONTROLLO),
	SOSTITUZIONE_CT_CONTR_FURTO(14l, "SOSTITUZIONE_CT_CONTR_FURTO", "Sostituzione Carta Tachigrafica Controllo per smarrimento o furto", Servizio.CARTA_TACHIGRAFICA_CONTROLLO),
	RILASCIO_FIRMA_DIGITALE_REMOTA(15l, "RILASCIO_FIRMA_DIGITALE_REMOTA", "Rilascio firma digitale remota", Servizio.FIRMA_DIGITALE_REMOTA),
	RILASCIO_BOLLATURA_VIDIMAZIONE_LIBRI_REGISTRI(16l, "RILASCIO_BOLLATURA_VIDIMAZIONE_LIBRI_REGISTRI", "Bollatura / Vidimazione libri e registri", Servizio.BOLLATURA_VIDIMAZIONE_LIBRI_REGISTRI),
	RILASCIO_CERTIFICATI_RI_AA(17l, "RILASCIO_CERTIFICATI_RI_AA", "Rilascio certificati del Registro Imprese / Albo Artigiani", Servizio.CERTIFICATI_RI_AA),
	RILASCIO_ELENCHI_MERCEOLOGICI(18l, "RILASCIO_ELENCHI_MERCEOLOGICI", "Rilascio elenchi merceologici", Servizio.ELENCHI_MERCEOLOGICI),
	RILASCIO_ISTANZE_ANNULLAMENTO_PRATICHE_TELEMATICHE(19l, "RILASCIO_ISTANZE_ANNULLAMENTO_PRATICHE_TELEMATICHE", "Consegna istanze di annullamento di pratiche telematiche", Servizio.ISTANZE_ANNULLAMENTO_PRATICHE_TELEMATICHE),
	RILASCIO_COPIE_ATTI_BILANCI(20l, "RILASCIO_COPIE_ATTI_BILANCI", "Rilascio copie atti bilanci", Servizio.COPIE_ATTI_BILANCI),
	RILASCIO_VISURE_RI_AA(21l, "RILASCIO_VISURE_RI_AA", "Rilascio visure del Registro Imprese / Albo Artigiani / ex REC", Servizio.VISURE_RI_AA);
	
	private Long id;
	private String nome;
	private String descrizione;
	private Servizio servizio;
	
	private TipoPratica(Long id, String nome, String descrizione, Servizio servizio){
		this.id=id;
		this.nome=nome;
		this.descrizione=descrizione;
		this.servizio=servizio;
	}
	
	public Long getId(){
		return id;
	}
	public String getNome() {
		return nome;
	}
	public Servizio getServizio() {
		return servizio;
	}
	
	public String getDescrizione() {
		return descrizione;
	}
	
	public static TipoPratica getTipoPratica(String nome){
		TipoPratica pFound=null;
		for (TipoPratica tp: values())
			if (tp.getNome().equals(nome))
				pFound=tp;
		if (pFound==null)
			throw new IllegalArgumentException("Tipo servizio non corrispondente al valore passato in input: " + nome);
		return pFound;
	}
	
}
