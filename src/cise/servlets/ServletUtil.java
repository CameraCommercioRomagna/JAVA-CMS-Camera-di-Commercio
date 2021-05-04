package cise.servlets;

import java.io.*;

public class ServletUtil{
	private final static char QS_QUESTIONMARK = 'ﬁ';	// 232
	private final static char QS_AMPERSAND = 'ß'; 	// 245
	
	
	// Codifica l'URL in input sostituendo ? e & ﬁ e ß e aggiungendone uno quando gi‡ presenti
	// Es. /servlet?pagefwd=aﬁb=1ßc=2&home=/ => /servletﬁpagefwd=aﬁﬁb=1ßßc=2ßhome=/ 
	public static String URLEncode(String url){
		String u=new String(url);
		StringBuffer newURL=new StringBuffer(u);
		
		System.out.println("prima ..."+url);
		replaceOnEncode(newURL,0,newURL.length(),'?',QS_QUESTIONMARK);
		replaceOnEncode(newURL,0,newURL.length(),'&',QS_AMPERSAND);
		
		System.out.println("dopo ..."+newURL);
		
		return newURL.toString();
	}


	// Trasforma l'URL in input in una forma accettabile dai browser
	// Es. /servletﬁpagefwd=aﬁﬁb=1ßßc=2ßhome=/  => /servlet?pagefwd=aﬁb=1ßc=2&home=/ 
	public static String URLTranslate(String url){
		String u=new String(url);
		StringBuffer newURL=new StringBuffer(u);
		
		System.out.println("prima ..."+url);
		replaceOnTranslate(newURL,0,newURL.length(),'?',QS_QUESTIONMARK);
		replaceOnTranslate(newURL,0,newURL.length(),'&',QS_AMPERSAND);
		
		System.out.println("dopo ..."+newURL);
		
		return newURL.toString();
	}
	
	private static void replaceOnTranslate(StringBuffer newURL,int begin, int end, char in, char out){
			
		for (int j=begin;j<end;j++)
			if (newURL.charAt(j)==out){
				if (newURL.charAt(j+1)==out){
					newURL.deleteCharAt(j);
					end--;
					while (newURL.charAt(j)==out)
						j++;
				}else
					newURL.setCharAt(j,in);
			}
	}
	

	private static void replaceOnEncode(StringBuffer newURL,int begin, int end, char in, char out){
		/* da fare */
	}

	
	public static void main(String[] args){
		ServletUtil.URLTranslate("http://www.xxx.it/Servlet1?Servlet2a=a&b=b&b=b");
	}
}
