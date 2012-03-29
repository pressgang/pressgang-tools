<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:d="http://docbook.org/ns/docbook" version="1.0">

    <!-- IMPORTS && INCLUDES -->
    <xsl:import href="http://docbook.sourceforge.net/release/xsl/1.76.1/xhtml/docbook.xsl"/>
    <xsl:include href="common-xhtml.xsl"/>

    <!--
        Customize titlepage rendering to add JBoss.org and Community Documentation graphics to header

        FROM : html/titlepage.templates.xsl
    -->
    <xsl:template name="book.titlepage.before.recto">
        <p xmlns="http://www.w3.org/1999/xhtml">
            <xsl:attribute name="id">
                <xsl:text>title</xsl:text>
            </xsl:attribute>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="$siteHref"/>
                </xsl:attribute>
                <xsl:attribute name="class">
                    <xsl:text>site_href</xsl:text>
                </xsl:attribute>
                <strong>
                    <xsl:value-of select="$siteLinkText"/>
                </strong>
            </a>
            <a>
                <xsl:attribute name="href">
                    <xsl:value-of select="$docHref"/>
                </xsl:attribute>
                <xsl:attribute name="class">
                    <xsl:text>doc_href</xsl:text>
                </xsl:attribute>
                <strong>
                    <xsl:value-of select="$docLinkText"/>
                </strong>
            </a>
        </p>
    </xsl:template>

</xsl:stylesheet>
