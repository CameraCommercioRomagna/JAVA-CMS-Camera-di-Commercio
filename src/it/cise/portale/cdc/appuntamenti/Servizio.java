package it.cise.portale.cdc.appuntamenti;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import cise.utils.DateUtils;

public enum Servizio {
	CNS(1l, null, "Carta Nazionale dei Servizi con firma digitale", 6l, true, TipoUtenzaRilascio.PRIVATO, 1l, 3l, 
				GruppoErogatori.UFF_DIGITALIZZAZIONE, FiltriAmmissibilita.GRUPPO_EROGATORI, "LightSkyBlue"), 
	CARTA_TACHIGRAFICA(11l, null, "Carta tachigrafica", 6l, true, TipoUtenzaRilascio.IMPRESA, 1l, 3l, 
				GruppoErogatori.UFF_DIGITALIZZAZIONE, FiltriAmmissibilita.GRUPPO_EROGATORI,"SpringGreen"),
	CARTA_TACHIGRAFICA_CONDUCENTE(2l, CARTA_TACHIGRAFICA, "Carta tachigrafica conducente", 6l, true, TipoUtenzaRilascio.PRIVATO, 1l, null, 
				GruppoErogatori.UFF_DIGITALIZZAZIONE, FiltriAmmissibilita.GRUPPO_EROGATORI,null), 
	CARTA_TACHIGRAFICA_AZIENDA(3l, CARTA_TACHIGRAFICA, "Carta tachigrafica azienda", 6l, true, TipoUtenzaRilascio.IMPRESA, 1l, null, 
				GruppoErogatori.UFF_DIGITALIZZAZIONE, FiltriAmmissibilita.GRUPPO_EROGATORI,null), 
	CARTA_TACHIGRAFICA_OFFICINA(4l, CARTA_TACHIGRAFICA, "Carta tachigrafica officina", 6l, true, TipoUtenzaRilascio.IMPRESA, 1l, null, 
				GruppoErogatori.UFF_DIGITALIZZAZIONE, FiltriAmmissibilita.GRUPPO_EROGATORI,null), 
	CARTA_TACHIGRAFICA_CONTROLLO(5l, CARTA_TACHIGRAFICA, "Carta tachigrafica controllo", 6l, true, TipoUtenzaRilascio.IMPRESA, 1l, null, 
				GruppoErogatori.UFF_DIGITALIZZAZIONE, FiltriAmmissibilita.GRUPPO_EROGATORI,null),
	FIRMA_DIGITALE_REMOTA(8l, null, "Firma Digitale Remota", 6l, false, TipoUtenzaRilascio.PRIVATO, 1l, 3l, 
				GruppoErogatori.UFF_DIGITALIZZAZIONE, FiltriAmmissibilita.GRUPPO_EROGATORI,"LightSkyBlue"),
	UFFICIO_IMPEGNATO(7l, null, "Singolo sportello impegnato", 6l, false, TipoUtenzaRilascio.NESSUNO, 0l, 0l, 
				null, null, "Crimson"),
	BOLLATURA_VIDIMAZIONE_LIBRI_REGISTRI(12l, null, "Bollatura / Vidimazione libri e registri", 6l, true, TipoUtenzaRilascio.PRIVATO, 1l, 0l, 
				GruppoErogatori.UFF_REGISTROIMPRESE, FiltriAmmissibilita.SERVIZIO, "LightSkyBlue"),
	CERTIFICATI_RI_AA(15l, null, "Certificati del Registro Imprese / Albo Artigiani", 3l, true, TipoUtenzaRilascio.PRIVATO, 1l, 0l, 
				GruppoErogatori.UFF_REGISTROIMPRESE, FiltriAmmissibilita.SERVIZIO, "SpringGreen"),
	ELENCHI_MERCEOLOGICI(13l, null, "Elenchi merceologici", 3l, false, TipoUtenzaRilascio.PRIVATO, 0l, 0l, 
				GruppoErogatori.UFF_REGISTROIMPRESE, FiltriAmmissibilita.SERVIZIO, "Crimson"),
	ISTANZE_ANNULLAMENTO_PRATICHE_TELEMATICHE(14l, null, "Consegna istanze di annullamento di pratiche telematiche", 3l, true, TipoUtenzaRilascio.PRIVATO, 1l, 0l, 
				GruppoErogatori.UFF_REGISTROIMPRESE, FiltriAmmissibilita.SERVIZIO, "SpringGreen"),
	COPIE_ATTI_BILANCI(16l, null, "Copie atti bilanci", 3l, true, TipoUtenzaRilascio.PRIVATO, 1l, 0l, 
				GruppoErogatori.UFF_REGISTROIMPRESE, FiltriAmmissibilita.SERVIZIO, "SpringGreen"),
	VISURE_RI_AA(17l, null, "Visure del Registro Imprese / Albo Artigiani / ex REC", 3l, true, TipoUtenzaRilascio.PRIVATO, 1l, 0l, 
				GruppoErogatori.UFF_REGISTROIMPRESE, FiltriAmmissibilita.SERVIZIO, "SpringGreen");
	/*SPID(-, null, "SPID", 6l, false, TipoUtenzaRilascio.PRIVATO, 1l, 3l, "DeepSkyBlue")*/
	
	public final static int SLOT_MINUTES = 5;
	
	private Long id;
	private String nome;
	private Long numeroSlot;
	private Boolean pubblico;
	private TipoUtenzaRilascio tipoUtenza;
	private Long giorniAnticipoPrenotazione;
	private Long numeroPraticheIntermediario;
	private GruppoErogatori gruppo;
	private FiltriAmmissibilita filtro_ammissibilita;
	private String colore;
	
	private Servizio padre;
	private List<Servizio> figli;
	
	public enum FiltriAmmissibilita{
		GRUPPO_EROGATORI("GRUPPO"),
		SERVIZIO("SERVIZIO");
		
		private String id;
		
		private FiltriAmmissibilita(String id) {
			this.id = id;
		}
	}
	
	private Servizio(Long id, Servizio padre, String nome, Long numeroSlot, Boolean pubblico, TipoUtenzaRilascio tipoUtenza, Long giorniAnticipoPrenotazione, Long numeroPraticheIntermediario, GruppoErogatori gruppo, FiltriAmmissibilita filtro_ammissibilita, String colore){
		this.id=id;
		this.nome=nome;
		this.numeroSlot=numeroSlot;
		this.pubblico=pubblico;
		this.tipoUtenza=tipoUtenza;
		this.giorniAnticipoPrenotazione=giorniAnticipoPrenotazione;
		this.numeroPraticheIntermediario=numeroPraticheIntermediario;
		this.gruppo=gruppo;
		this.filtro_ammissibilita=filtro_ammissibilita;
		this.colore=colore;
		
		if(this.gruppo!=null)
			this.gruppo.addServizi(this);
		
		figli=new ArrayList<Servizio>();
		if (padre!=null) {
			this.padre=padre;
			padre.addFiglio(this);
		}
	}
	
	public Long getId(){
		return id;
	}
	
	public String getNome() {
		return nome;
	}
	
	public Long getNumeroSlot() {
		return numeroSlot;
	}
	
	public GruppoErogatori getGruppo() {
		return gruppo;
	}
	
	public FiltriAmmissibilita getFiltroAmmissibilita() {
		return filtro_ammissibilita;
	}
	
	public String getColore() {
		return (colore!=null ? colore : getPadre().getColore());
	}
	
	public Servizio getPadre() {
		return padre;
	}
	public List<Servizio> getFigli() {
		return figli;
	}
	private void addFiglio(Servizio servizio) {
		figli.add(servizio);
	}


	/**	Durata in minuti */
	public int durata() {
		return getNumeroSlot().intValue()*Servizio.SLOT_MINUTES;
	}
	
	public Date termina(Date inizio) {
		return DateUtils.addMinutes(inizio, durata());
	}

	public TipoUtenzaRilascio getTipoUtenza() {
		return tipoUtenza;
	}

	public Long getNumeroPraticheIntermediario() {
		return (numeroPraticheIntermediario!=null ? numeroPraticheIntermediario : getPadre().getNumeroPraticheIntermediario());
	}

	public Boolean isPubblico() {
		return pubblico;
	}
	
	public Long getGiorniAnticipoPrenotazione() {
		return giorniAnticipoPrenotazione;
	}
	
	public List<Sede> getSedi(){
		List<Sede> sedi=new ArrayList<Sede>();
		for(Sede s: Sede.values()){
			if(s.getServizi().contains(this)){
				sedi.add(s);
			}	
		}
		return sedi;
	}
	
	public List<Date> accessibile(Date data){
		return accessibile(data, data);
	}
	public List<Date> accessibile(Date dal, Date al){
		List<Date> disponibilita=new ArrayList<Date>();
		Map<Sportello, List<Date>> disponibilitaSportelli=accessibile(Sportello.class, dal, al);
		for (Sportello sportello: disponibilitaSportelli.keySet())
			disponibilita.addAll(disponibilitaSportelli.get(sportello));

		return disponibilita;
	}
	public <E extends ErogatoreServizi> Map<E, List<Date>> accessibile(Class<E> erogatore, Date data){
		return accessibile(erogatore, data, data);
	}
	public <E extends ErogatoreServizi> Map<E, List<Date>> accessibile(Class<E> erogatore, Date dal, Date al){
		Map<E, List<Date>> sportelliDisponibili=new HashMap<E, List<Date>>();
		for (E e: erogatore.getEnumConstants()) {
			List<Date> fasceDisponibilita=e.fasceDisponibilita(this, dal, al);
			if (fasceDisponibilita.size()>0)
				sportelliDisponibili.put(e, fasceDisponibilita);
		}
		return sportelliDisponibili;
	}
	
	public static Servizio getServizio(Long id){
		Servizio pFound=null;
		for (Servizio p: values())
			if (p.getId().equals(id))
				pFound=p;
				
		if (pFound==null)
			throw new IllegalArgumentException("Servizio non corrispondente al valore passatpo in input: " + id);
		
		return pFound;
	}
	
	public static List<Servizio> getServizi(){
		return getServizi(null);
	}
	public static List<Servizio> getServizi(Boolean pubblici){
		List<Servizio> serviziBase=new ArrayList<Servizio>();
		for (Servizio s: values())
			if (s.getPadre() == null)
				if (pubblici==null || (s.isPubblico().equals(pubblici)))
					serviziBase.add(s);
	
		return serviziBase;
	}
	
	@Override
	public String toString() {
		/*String label = name().toLowerCase().replaceAll("_", " ");
		label = Character.toUpperCase(label.charAt(0)) + label.substring(1);
		return label;*/
		return getNome();
	}
}
