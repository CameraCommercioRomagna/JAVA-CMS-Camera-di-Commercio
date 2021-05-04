package it.cise.servlet;

import it.cise.structures.preview.Preview;

import javax.servlet.*;
import javax.servlet.http.*;

import java.io.*;

import cise.utils.*;

import org.apache.poi.hssf.usermodel.*;	
	
/******************************************************************************
 *	Servlet per la creazione di un documento in formato Microsoft Excel (XLS).
 *	a partire da un oggetto PreviewQuery salvato in sessione: genera n colonne
 *	in base agli n campi estratti dalla preview per ogni record, ed m colonne
 *	in base al numero di record presenti nella preview (o a quelli della pagina
 *	corrente).
 *
 *	Accetta i seguenti parametri (tra parentesi quadre gli opzionali):
 *	 - preview_xls:		il nome dell'attributo di sessione contente la preview
 *	 - [pagina_corrente]: indica se deve essere riportata nel file di output
 *				solo la pagina corrente della preview o tutti i record estratti
 *	 - [cols]:	le colonne della preview da stampare: sono gli indici 
 *				di colonna separati da virgole; se omesso vengono stampate 
 *				tutte le colonne
 *
 *	@author Elio Amadori/Cate Mambels
 *	@version 1.0
 ******************************************************************************/
public class XLSServlet extends HttpServlet{	

	public void doPost(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
		
		response.setContentType("application/vnd.ms-excel");
		ServletOutputStream out = response.getOutputStream();
		
		HttpSession session = request.getSession();
		String nome_prev = request.getParameter("preview_xls");
		HSSFWorkbook wb = new HSSFWorkbook();
		
		if(nome_prev!=null){
		
			boolean pagina_corrente = request.getParameter("pagina_corrente")!=null && request.getParameter("pagina_corrente").equals("1");
			Preview prev = (Preview)session.getAttribute(nome_prev);
			
			if ((prev!=null) && (prev.getNumberRecords()>0)){
				
				// Determina quali colonne della preview da stampare nel file XLS
				/* Aggiunto */
				int[] colonne=null;
				boolean allColumns=true;
				try{
					String[] colonneStr=StringUtils.arrayFromString(request.getParameter("cols"), ",");
					colonne=new int[colonneStr.length];
					for (int i=0; i<colonneStr.length; i++)
						colonne[i]=Integer.parseInt(colonneStr[i]);
					allColumns=false;
				}catch(Exception e){}
				/* FINE - Aggiunte */
				
				int prevRecForPage = prev.getRecordForPage();
				int prevCurrPage = prev.getCurrentPage();
				if(!pagina_corrente)
					prev.setRecordForPage(prev.getNumberRecords());
				else
					prev.resetPrintingPage();
				
				HSSFCellStyle styleTitle=wb.createCellStyle();
				HSSFFont fontTitle=wb.createFont();
				fontTitle.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
				styleTitle.setFont(fontTitle);
				
				HSSFSheet s = wb.createSheet(nome_prev);
				HSSFRow r = s.createRow((short) 0);
				//for(int i=0; i<prev.getNumberFields(); i++){ sostituito con:
				for(int i=0; i<(allColumns ? prev.getNumberFields() : colonne.length); i++){
					HSSFCell currCell=r.createCell((short) i);
					currCell.setCellStyle(styleTitle);
					//currCell.setCellValue(prev.getTitleColumn(i)); sostituito con:
					currCell.setCellValue(prev.getTitleColumn(allColumns ? i : colonne[i]));
				}
				
				for(int i=prev.getCurrentPageFirstRecord(); i<=prev.getCurrentPageLastRecord(); i++){
					r = s.createRow((short) i-prev.getCurrentPageFirstRecord()+1);
					//for(int j=0; j<prev.getNumberFields(); j++){ sostituito con:
					for(int j=0; j<(allColumns ? prev.getNumberFields() : colonne.length); j++){
						HSSFCell currCell=r.createCell((short) j);
						currCell.setCellType(HSSFCell.CELL_TYPE_STRING);
						//currCell.setCellValue(prev.getField(j)); sostituito con:
						currCell.setCellValue(prev.getField(allColumns ? j : colonne[j]));
					}
					prev.nextRecord();
				}
				
				if(!pagina_corrente){
					prev.setRecordForPage(prevRecForPage);
					prev.gotoPage(prevCurrPage);
				}else
					prev.resetPrintingPage();
				
			}
		}
		
		wb.write(out);
		out.flush();
		
	}
	
	public void doGet(HttpServletRequest request, HttpServletResponse response)
		throws ServletException, IOException {
	
		doPost(request,response);
	}
}
