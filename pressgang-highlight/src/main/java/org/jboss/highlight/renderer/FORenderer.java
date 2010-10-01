/*
 * Copyright 2004-2006 Geert Bevin <gbevin[remove] at uwyn dot com>
 * Distributed under the terms of either:
 * - the common development and distribution license (CDDL), v1.0; or
 * - the GNU Lesser General Public License, v2.1 or later
 * $Id$
 */
package org.jboss.highlight.renderer;

import java.io.*;

import com.uwyn.jhighlight.JHighlightVersion;
import com.uwyn.jhighlight.highlighter.ExplicitStateHighlighter;
import com.uwyn.jhighlight.tools.ExceptionUtils;
import com.uwyn.jhighlight.tools.StringUtils;
import com.uwyn.jhighlight.highlighter.JavaHighlighter;
import com.uwyn.jhighlight.highlighter.XmlHighlighter;
import java.net.URL;
import java.net.URLConnection;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.logging.Logger;
import java.util.ArrayList;
import java.util.List;
import java.util.HashMap;

/**
 * Parses the contents of programlisting elements to allow FO syntax
 * highlighting.
 *
 * @author Geert Bevin (gbevin[remove] at uwyn dot com)
 * @author Mark Newton (mark.newton@jboss.org)
 * @version $Revision$
 * @since 1.0
 */
public class FORenderer
{	
	private List<String> styles = new ArrayList<String>();
	private List<String> tokens = new ArrayList<String>();
	
	/** We assume that this class will get called multiple times by Saxon */
	private static int caller = 0;
	
	/** Store the lists for each caller so that we can access them from the iterator template */
	private static Map<Integer, List<String>> allStyles = new HashMap<Integer, List<String>>();
	private static Map<Integer, List<String>> allTokens = new HashMap<Integer, List<String>>();
	
	public static int getNoOfTokens(int caller) {
		return allTokens.get(caller).size();
	}
	
	public static String getStyle(int caller, int index) {
		List<String> styles = allStyles.get(caller);
		
		if (styles.size() > 0) {
			return styles.get(index);
		}
		return ""; 
	}
	
	public static String getToken(int caller, int index) {
		List<String> tokens = allTokens.get(caller);
		
		if (tokens.size() > 0) {
			return tokens.get(index);
		}
		return "";
	}
	
	public static boolean isParsable(String role) {
		if (role.equals("JAVA") || role.equals("XML")) {
			return true;
		} else {
			return false;
		}
	}
	
	/**
	 * Parse the text into tokens and store in a list.
	 * Also store a corresponding list of styles for each token.
	 */
	public int parseText(String role, String text, String encoding) throws IOException {
		
//		System.out.println("Text: " + text);
		styles.clear();
		tokens.clear();
		
		InputStream in = new StringBufferInputStream(text);
		
		ExplicitStateHighlighter highlighter = null;
		
		if (role.equals("JAVA")) {
		    highlighter = new JavaHighlighter();
			((JavaHighlighter) highlighter).ASSERT_IS_KEYWORD = true;			
		} else if (role.equals("XML")) {
			highlighter = new XmlHighlighter();
		} else {
			return 0;
		}
		
		Reader isr;
		if (encoding == null) {
			isr = new InputStreamReader(in);
		}
		else {
			isr = new InputStreamReader(in, encoding);
		}
		
		BufferedReader r = new BufferedReader(isr);
		
		// Read all the text into a buffer so that we capture newline characters
		StringBuffer buf = new StringBuffer();
		int c = 0;	 
		while ((c = r.read()) != -1) {
		  buf.append((char) c);
		}
		 
		// Split the text into separate lines incase it includes newline characters
		String allLines = buf.toString();
		String[] lines = allLines.split("\n");
//		for (int jj=0; jj < lines.length; jj++) {
//			System.out.println("Line: " + lines[jj]);
//		}
		
		for (int i=0; i < lines.length; i ++) {
			String line = lines[i];
			if ((i != lines.length -1) || (i == lines.length - 1 && allLines.endsWith("\n"))) {
				line += "\n";			// Put back the newline if needed 
			}

			line = StringUtils.convertTabsToSpaces(line, 4);
			
			// should be optimized by reusing a custom LineReader class
			Reader lineReader = new StringReader(line);
			highlighter.setReader(lineReader);
			int index = 0;
			while (index < line.length())
			{
				int style = highlighter.getNextToken();				
				int length = highlighter.getTokenLength();
				String token = line.substring(index, index + length);
				
				styles.add(getCssClass(role, style));
				tokens.add(token);

				index += length;
			}
		}

		// Store the lists so that we can retrieve them later
		allStyles.put(caller, styles);
		allTokens.put(caller, tokens);
		
		return caller++;
	}
	
	protected String getCssClass(String role, int style)
	{
		if (role.equals("JAVA")) {
			switch (style)
			{
				case JavaHighlighter.PLAIN_STYLE:
					return "java_plain";
				case JavaHighlighter.KEYWORD_STYLE:
					return "java_keyword";
				case JavaHighlighter.TYPE_STYLE:
					return "java_type";
				case JavaHighlighter.OPERATOR_STYLE:
					return "java_operator";
				case JavaHighlighter.SEPARATOR_STYLE:
					return "java_separator";
				case JavaHighlighter.LITERAL_STYLE:
					return "java_literal";
				case JavaHighlighter.JAVA_COMMENT_STYLE:
					return "java_comment";
				case JavaHighlighter.JAVADOC_COMMENT_STYLE:
					return "java_javadoc_comment";
				case JavaHighlighter.JAVADOC_TAG_STYLE:
					return "java_javadoc_tag";
			}			
		} else if (role.equals("XML")) {
			switch (style)
			{
				case XmlHighlighter.PLAIN_STYLE:
					return "xml_plain";
				case XmlHighlighter.CHAR_DATA:
					return "xml_char_data";
				case XmlHighlighter.TAG_SYMBOLS:
					return "xml_tag_symbols";
				case XmlHighlighter.COMMENT:
					return "xml_comment";
				case XmlHighlighter.ATTRIBUTE_VALUE:
					return "xml_attribute_value";
				case XmlHighlighter.ATTRIBUTE_NAME:
					return "xml_attribute_name";
				case XmlHighlighter.PROCESSING_INSTRUCTION:
					return "xml_processing_instruction";
				case XmlHighlighter.TAG_NAME:
					return "xml_tag_name";
				case XmlHighlighter.RIFE_TAG:
					return "xml_rife_tag";
				case XmlHighlighter.RIFE_NAME:
					return "xml_rife_name";
			}
		}

		return null;
	}
}
