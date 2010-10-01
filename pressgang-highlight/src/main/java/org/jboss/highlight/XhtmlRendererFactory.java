/**
 * License Agreement.
 *
 *  JBoss RichFaces 3.0 - Ajax4jsf Component Library
 *
 * Copyright (C) 2007  Exadel, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License version 2.1 as published by the Free Software Foundation.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 */

package org.jboss.highlight;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import com.uwyn.jhighlight.renderer.Renderer;

/**
 * @author Maksim Kaszynski
 * @author Mark Newton (mark.newton@jboss.org)
 *
 */
public class XhtmlRendererFactory {
	
	private static XhtmlRendererFactory instance;
	public static final String fileName = "renderers.properties";
	private Map<Object, Object> classNames = new HashMap<Object, Object>();

	public static final XhtmlRendererFactory instance() {
		synchronized(XhtmlRendererFactory.class) {
			if (instance == null) {
				instance = new XhtmlRendererFactory();
			}
		}
		
		return instance;
	}
	
	public XhtmlRendererFactory() {
		InputStream resourceAsStream = 
			getClass().getResourceAsStream(fileName);
		try {
			Properties props = new Properties();
			props.load(resourceAsStream);
			classNames.putAll(props);
			resourceAsStream.close();
		} catch (IOException e) {
			e.printStackTrace();
		} 
		
	}
	
	public Renderer getRenderer(String type) {
		
		// Look first for our own renderer, followed by the richfaces renderer
		Renderer renderer = null;
		Object object = classNames.get(type.toLowerCase());
		if (object != null) {
			String className = object.toString();
			
			try {
				Class<?> class1 = Class.forName(className);
				Object newInstance = class1.newInstance();
				if (newInstance instanceof Renderer) {
					return (Renderer) newInstance;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			renderer = org.richfaces.highlight.XhtmlRendererFactory.instance().getRenderer(type);
		}
		
		return renderer;
	}
}
