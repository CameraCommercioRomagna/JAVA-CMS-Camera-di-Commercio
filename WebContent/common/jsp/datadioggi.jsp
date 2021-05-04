<%@page import="java.util.Date" %> 
<%@page import="java.util.Calendar" %> 
<%@page import="java.text.SimpleDateFormat" %> 

<%@page import="cise.db.constants.FieldConstants" %> 

<%!
public String DataDiOggi()
{
	SimpleDateFormat formatter=new SimpleDateFormat(FieldConstants.FORMAT_DATE_JAVA);
	String data=formatter.format(new Date());
	return (data);
}
%>