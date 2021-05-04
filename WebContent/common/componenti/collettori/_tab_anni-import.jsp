<%!	enum ModalitaVisualizzazioneTabAnni {
		INCORSO, ARCHIVIO, ANNI;
	}
	enum ModalitaVisualizzazioneDocumenti {
		CARD, LISTA, AGENDA;
	}%>
	
<%!	class ConfigurazionePagina implements Comparable<ConfigurazionePagina>{
		private ModalitaVisualizzazioneTabAnni modOrganizza;
		private Boolean archivioAnnoInCorso;
		private String anno;
		
		public ConfigurazionePagina(ModalitaVisualizzazioneTabAnni modOrganizza, boolean archivioAnnoInCorso, String anno){
			this.modOrganizza = modOrganizza;
			this.archivioAnnoInCorso = archivioAnnoInCorso;
			this.anno = anno;
		}
		public ConfigurazionePagina(ModalitaVisualizzazioneTabAnni modOrganizza, DocumentoWeb documento){
			this.modOrganizza = modOrganizza;
			switch (modOrganizza){
				case ARCHIVIO:
					this.archivioAnnoInCorso = !documento.pubblico();
					this.anno = (documento.scaduto() ? String.valueOf(documento.getAnnoPertinenza()) : DateUtils.formatDate(new Date(), "yyyy"));	// Un documento InCorso viene considerato comunque dell'anno corrente
					break;
				case INCORSO:
					this.archivioAnnoInCorso = !documento.pubblico();
					this.anno = "";
					break;
				case ANNI:
					this.archivioAnnoInCorso = false;
					this.anno = String.valueOf(documento.getAnnoPertinenza());
					break;
			}
		}
		
		public String getAnno(){
			return anno;
		}
		
		@Override
		public boolean equals(Object conf){
			try{
				ConfigurazionePagina confCast = (ConfigurazionePagina)conf;
				switch (modOrganizza){
					case INCORSO:
						return archivioAnnoInCorso.equals(confCast.archivioAnnoInCorso);
					case ARCHIVIO:
						if (archivioAnnoInCorso.compareTo(confCast.archivioAnnoInCorso) == 0)
							return anno.equals(confCast.anno);
						else
							return archivioAnnoInCorso.equals(confCast.archivioAnnoInCorso);
					case ANNI:
						return anno.equals(confCast.anno);
				}
			}catch(Exception e){}
			throw new IllegalArgumentException("Errata configurazione per ModalitaVisualizzazioneTabAnni=" + modOrganizza);
		}
		@Override
		public int hashCode(){
			return toString().hashCode();
		}
		
		@Override
		public int compareTo(ConfigurazionePagina conf){
			switch (modOrganizza){
				case INCORSO:
					return archivioAnnoInCorso.compareTo(conf.archivioAnnoInCorso);
				case ARCHIVIO:
					if (archivioAnnoInCorso.compareTo(conf.archivioAnnoInCorso) == 0)
						return anno.compareTo(conf.anno);
					else
						return archivioAnnoInCorso.compareTo(conf.archivioAnnoInCorso);
				case ANNI:
					return anno.compareTo(conf.anno);
			}
			throw new IllegalArgumentException("Errata configurazione per ModalitaVisualizzazioneTabAnni=" + modOrganizza);
		}
		
		@Override
		public String toString(){
			return (archivioAnnoInCorso ? "Archivio" + anno : "InCorso");
		}
	}%>