package org.jboss.highlight;

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

import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import com.uwyn.jhighlight.renderer.Renderer;

/**
 * HACK for MPJDOCBOOK-73: This file is duplicated from
 * (org.richfaces.docs:highlight:jar:3.3.1.SP3)!org/richfaces/highlight/XhtmlRendererFactory.java
 * to avoid the org.richfaces.docs:highlight dependency.
 * That dependency has invalid dependencies on eclipse css and sse (and excluding them doesn't help)
 * which slow down the build considerably.
 * Furthermore, because XhtmlRendererFactory seems to have disappeared from richfaces 4, for now,
 * the lesser evil of duplicating that file has been chosen.
 * @author Maksim Kaszynski
 * @author Geoffrey De Smet
 */
public class RichfacesXhtmlRendererFactory {

	private static RichfacesXhtmlRendererFactory instance;
	public static final String fileName = "renderers.properties";
	private Map<Object, Object> classNames = new HashMap<Object, Object>();

	public static final RichfacesXhtmlRendererFactory instance() {
		synchronized(RichfacesXhtmlRendererFactory.class) {
			if (instance == null) {
				instance = new RichfacesXhtmlRendererFactory();
			}
		}

		return instance;
	}

	public RichfacesXhtmlRendererFactory() {
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

		Renderer renderer =
			com.uwyn.jhighlight.renderer.XhtmlRendererFactory.getRenderer(type);
		if (renderer == null) {
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
			}
		}

		return renderer;
	}

}

