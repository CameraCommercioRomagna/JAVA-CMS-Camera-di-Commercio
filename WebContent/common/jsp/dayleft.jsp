<%@page import="java.util.Date" %> 
<%@page import="java.util.Calendar" %> 
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.text.ParseException " %>

<%@page import="cise.db.constants.FieldConstants" %> 

<%!/* Giorni rimasti da oggi alla data specificata in input */
	private long dayLeft(String d){
	SimpleDateFormat formatter=new SimpleDateFormat(FieldConstants.FORMAT_DATE_JAVA);

// Crea la data relativa al giorno di riferimento
	Date ctrldate=null;
	try{
	ctrldate=formatter.parse(d);
}catch(ParseException pe){return 0;}

// La confronta la data di oggi
	Date today=new Date();
	long msecDiff=ctrldate.getTime() - today.getTime();
	if (msecDiff>0){
	msecDiff/=86400000; // 86400000 = # millis in un giorno
	msecDiff++;
}else
	msecDiff=0;

	return (msecDiff);
}
%>