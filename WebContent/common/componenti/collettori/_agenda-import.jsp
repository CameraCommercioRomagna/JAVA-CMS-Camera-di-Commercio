<%!	enum ModalitaVisualizzazioneData {
		LARGE (1), MEDIUM (2), SMALL (3);
		private int colonne;
		ModalitaVisualizzazioneData(int colonne){
			this.colonne=colonne;
		}
		public int getColonne(){
			return colonne;
		}
	}
	%>