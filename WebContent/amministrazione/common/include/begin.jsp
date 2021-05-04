<%--@page buffer="1024kb" autoFlush="false" --%>
<%@page 
	language="java"
	import="java.io.*"
	import="java.util.*"
	import="java.net.URL"
	import="javax.servlet.http.*"
	import="it.cise.sql.*" 
	import="it.cise.util.http.*" 
	import="it.cise.structures.field.*"
	import="it.cise.structures.preview.*"
	import="it.cise.db.SQLTransactionManager" 
	import="it.cise.portale.cdc.*"
	import="it.cise.portale.cdc.appuntamenti.*"
	import="it.cise.portale.cdc.auth.*"
	import="it.cise.portale.cdc.documenti.*" 
	import="it.cise.portale.cdc.documenti.eventi.*" 
	import="it.cise.portale.cdc.documenti.standard.*"
	import="it.cise.portale.cdc.documenti.download.*" 
	import="it.cise.portale.cdc.documenti.referenza.*" 
	import="it.cise.portale.cdc.documenti.pubblicazioni.*" 
	import="it.cise.portale.cdc.email.*" 
	import="it.cise.portale.cdc.newsletters.*" 
	import="it.cise.portale.cdc.prezzi.*" 
	import="it.cise.portale.statistica.congiuntura.*"
	import="it.cise.mailing.*"
	import="cise.utils.*"
	
		
	import= "com.itextpdf.text.Document"
	import= "com.itextpdf.text.DocumentException"
	import= "com.itextpdf.text.PageSize"
	import= "com.itextpdf.text.pdf.PdfWriter"
	import= "com.itextpdf.tool.xml.XMLWorkerHelper"
	import= "com.itextpdf.text.Paragraph"
	import= "com.itextpdf.text.Image"
	import= "org.jsoup.*"%>

<%@include file="/common/jsp/connect_postgres.jsp"%>
<%@include file="/common/jsp/connect_crm.jsp"%>
<%@include file="/common/jsp/extractinitchars.jsp"%>
<%@include file="/common/jsp/nulltoemptystring.jsp"%>
<%@include file="/common/jsp/replacehtml.jsp" %>
<%	Logger.write(this);%>
<%@include file="_project_var.jsp" %>
<%@include file="_login.jsp" %> 
