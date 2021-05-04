package it.cise.portale.auth;

public enum AuthenticationStatus {
	LOGIN_FAILED(-1l),
	AUTHENTICATED(0l),
	ERROR_WRONG_PWD(1l),
	ERROR_WRONG_USERNAME(2l),
	EXPIRED_USER(3l);
	
	private Long id_status;
	
	private AuthenticationStatus(Long id_status){
		this.id_status = id_status;
	}
	
	public Long getIdStatus(){
		return id_status;
	}
}
