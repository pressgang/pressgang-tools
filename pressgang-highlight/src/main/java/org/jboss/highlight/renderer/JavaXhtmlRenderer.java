/*
 * Copyright 2004-2006 Geert Bevin <gbevin[remove] at uwyn dot com>
 * Distributed under the terms of either:
 * - the common development and distribution license (CDDL), v1.0; or
 * - the GNU Lesser General Public License, v2.1 or later
 * $Id$
 */
package org.jboss.highlight.renderer;

import java.io.*;

import com.uwyn.jhighlight.highlighter.ExplicitStateHighlighter;
import com.uwyn.jhighlight.highlighter.JavaHighlighter;
import com.uwyn.jhighlight.renderer.XhtmlRenderer;
import java.util.HashMap;
import java.util.Map;
import com.uwyn.jhighlight.tools.StringUtils;

/**
 * Generates highlighted syntax in XHTML from Java source.
 *
 * @author Geert Bevin (gbevin[remove] at uwyn dot com)
 * @author Mark Newton (mark.newton@jboss.org)
 * @version $Revision$
 * @since 1.0
 */
public class JavaXhtmlRenderer extends XhtmlRenderer
{
	private int lineNo = 0;
	
	/**
	 * Transforms source code that's provided through an
	 * <code>InputStream</code> to highlighted syntax in XHTML and writes it
	 * back to an <code>OutputStream</code>.
	 * <p>If the highlighting has to become a fragment, no CSS styles will be
	 * generated.
	 * <p>For complete documents, there's a collection of default styles that
	 * will be included. It's possible to override these by changing the
	 * provided <code>jhighlight.properties</code> file. It's best to look at
	 * this file in the JHighlight archive and modify the styles that are
	 * there already.
	 *
	 * @param name The name of the source file.
	 * @param in The input stream that provides the source code that needs to
	 * be transformed.
	 * @param out The output stream to which to resulting XHTML should be
	 * written.
	 * @param encoding The encoding that will be used to read and write the
	 * text.
	 * @param fragment <code>true</code> if the generated XHTML should be a
	 * fragment; or <code>false</code> if it should be a complete page
	 * @see #highlight(String, String, String, boolean)
	 * @since 1.0
	 */
	public void highlight(String name, InputStream in, OutputStream out, String encoding, boolean fragment)
	throws IOException
	{
		ExplicitStateHighlighter highlighter = getHighlighter();
		
		Reader isr;
		Writer osw;
		if (null == encoding)
		{
			isr = new InputStreamReader(in);
			osw = new OutputStreamWriter(out);
		}
		else
		{
			isr = new InputStreamReader(in, encoding);
			osw = new OutputStreamWriter(out, encoding);
		}
		
		BufferedReader r = new BufferedReader(isr);
		BufferedWriter w = new BufferedWriter(osw);
		
		if (fragment)
		{
//			w.write(getXhtmlHeaderFragment(name));
		}
		else
		{
			w.write(getXhtmlHeader(name));
		}
		
		String line;
		String token;
		int length;
		int style;
		String css_class;
		int previous_style = 0;
		boolean newline = false;
		
		StringBuilder buf = new StringBuilder();
		int c = 0;	 
		while ((c = r.read()) != -1) {
		  buf.append((char) c);
		}
		 
		String allLines = buf.toString();
		String[] lines = allLines.split("\n");
//		for (int jj=0; jj < lines.length; jj++) {
//			System.out.println("Line: " + lines[jj]);
//		}
		
		// We get a new instance of this class each time we parse a programlisting so we can
		// can use an instance variable to detect if it's the first time we've been called.
		// This will allow us to put <br/> before each line so that the callout extension will work correctly.
		
		for (int i=0; i < lines.length; i ++) {
			line = lines[i];
			lineNo++;

			line = StringUtils.convertTabsToSpaces(line, 4);
			
			// should be optimized by reusing a custom LineReader class
			Reader lineReader = new StringReader(line);
			highlighter.setReader(lineReader);
			int index = 0;
			while (index < line.length())
			{
				style = highlighter.getNextToken();
				length = highlighter.getTokenLength();
				token = line.substring(index, index + length);
				
				if (style != previous_style || newline)		  // assume we have a new style if there is a newline
				{
					css_class = getCssClass(style);
					
					if (css_class != null)
					{
						if (previous_style != 0 && !newline)	// each token will potentially have a different style
						{
							w.write("</span>");
						}
						
						// Write the start tag for the <span> element representing the style
						if (lineNo == 1) {
							w.write("<!-- <br/> --><span class=\"" + css_class + "\">");	// the 1st line doesn't have a linebreak				
						} else if (!newline) {
							w.write("<span class=\"" + css_class + "\">");				    // we're in the middle of a line												
						}
						else if (newline && lineNo != 1) {
							w.write("<!--  --><br/><span class=\"" + css_class + "\">");	// we're at the start of a new line						
						}
						
						previous_style = style;
					}
				}
				newline = false;	// if we've just started processing a new line we need to know				
				w.write(StringUtils.replace(StringUtils.encodeHtml(StringUtils.replace(token, "\n", "")), " ", "&nbsp;"));
				
				index += length;
			}
			
			// Write a newline character if we're not on the last line or we are and there was a newline at the end anyway
			if ((i != lines.length -1) || (i == lines.length - 1 && allLines.endsWith("\n"))) {
				w.write("</span>\n");
			} else {
				w.write("</span>");		
			}
			newline = true;
		}
		
		if (!fragment) w.write(getXhtmlFooter());
		
		w.flush();
		w.close();
	}	
	
	public final static HashMap DEFAULT_CSS = new HashMap() {{
			put("h1",
				"font-family: sans-serif; " +
				"font-size: 16pt; " +
				"font-weight: bold; " +
				"color: rgb(0,0,0); " +
				"background: rgb(210,210,210); " +
				"border: solid 1px black; " +
				"padding: 5px; " +
				"text-align: center;");
			
			put("code",
				"color: rgb(0,0,0); " +
				"font-family: monospace; " +
				"font-size: 12px; " +
				"white-space: nowrap;");
			
			put(".java_plain",
				"color: rgb(0,0,0);");
			
			put(".java_keyword",
				"color: rgb(0,0,0); " +
				"font-weight: bold;");
			
			put(".java_type",
				"color: rgb(0,44,221);");
			
			put(".java_operator",
				"color: rgb(0,124,31);");
			
			put(".java_separator",
				"color: rgb(0,33,255);");
			
			put(".java_literal",
				"color: rgb(188,0,0);");
			
			put(".java_comment",
				"color: rgb(147,147,147); " +
				"background-color: rgb(247,247,247);");
			
			put(".java_javadoc_comment",
				"color: rgb(147,147,147); " +
				"background-color: rgb(247,247,247); " +
				"font-style: italic;");
			
			put(".java_javadoc_tag",
				"color: rgb(147,147,147); " +
				"background-color: rgb(247,247,247); " +
				"font-style: italic; " +
				"font-weight: bold;");
		}};
	
	protected Map getDefaultCssStyles()
	{
		return DEFAULT_CSS;
	}
		
	protected String getCssClass(int style)
	{
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
		
		return null;
	}
	
	protected ExplicitStateHighlighter getHighlighter()
	{
		JavaHighlighter highlighter = new JavaHighlighter();
		highlighter.ASSERT_IS_KEYWORD = true;
		
		return highlighter;
	}
}
