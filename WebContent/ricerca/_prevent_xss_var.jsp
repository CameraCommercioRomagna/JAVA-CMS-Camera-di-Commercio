<%	//based on https://www.owasp.org/index.php/XSS_Filter_Evasion_Cheat_Sheet
	List<String> xss_words_list = new ArrayList<String>();
	xss_words_list.add("prompt");
	xss_words_list.add("onerror");
	xss_words_list.add("onsubmit");
	xss_words_list.add("onchange");
	xss_words_list.add("javascript");
	
	Map<String, String> xss_escape_char_list = new HashMap<String, String>();
	xss_escape_char_list.put("&","&amp;");
	xss_escape_char_list.put("<","&lt;");
	xss_escape_char_list.put(">","&gt;");
	xss_escape_char_list.put("\"","&quot;");
	xss_escape_char_list.put("'","&#x27;");
	xss_escape_char_list.put("/","&#x2F;");
%>