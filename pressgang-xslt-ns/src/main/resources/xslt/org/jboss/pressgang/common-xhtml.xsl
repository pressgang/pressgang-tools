<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns:rf="java:org.jboss.highlight.XhtmlRendererFactory"
                exclude-result-prefixes="#default">

    <!-- IMPORTS && INCLUDES -->
    <xsl:import href="common-base.xsl"/>


    <!-- PARAMETERS -->
    <xsl:param name="siteHref" select="'http://www.jboss.org'"/>
    <xsl:param name="docHref" select="'http://docs.jboss.org/'"/>
    <xsl:param name="siteLinkText" select="'JBoss.org'"/>
    <xsl:param name="docLinkText" select="'Community Documentation'"/>

    <xsl:param name="html.stylesheet" select="'css/jbossorg.css'"/>
    <xsl:param name="html.stylesheet.type" select="'text/css'"/>
    <xsl:param name="html.cleanup" select="1"/>
    <xsl:param name="html.ext" select="'.html'"/>

    <xsl:param name="chunk.section.depth" select="0"/>
    <xsl:param name="chunk.first.sections" select="1"/>
    <xsl:param name="chunk.toc" select="''"/>
    <xsl:param name="chunker.output.doctype-public" select="'-//W3C//DTD XHTML 1.0 Strict//EN'"/>
    <xsl:param name="chunker.output.doctype-system" select="'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'"/>
    <xsl:param name="chunker.output.encoding" select="'UTF-8'"/>

    <xsl:param name="graphicsize.extension">0</xsl:param>
    <xsl:param name="ignore.image.scaling" select="1"/>

    <xsl:param name="generate.legalnotice.link" select="1"/>
    <xsl:param name="generate.revhistory.link" select="0"/>

    <xsl:param name="suppress.navigation" select="0"/>
    <xsl:param name="suppress.header.navigation" select="0"/>
    <xsl:param name="suppress.footer.navigation" select="0"/>

    <xsl:param name="header.rule" select="0"/>
    <xsl:param name="footer.rule" select="0"/>
    <xsl:param name="css.decoration" select="0"/>
    <xsl:param name="ulink.target"/>
    <xsl:param name="table.cell.border.style"/>

    <!-- TOC: remove list of figures, list of tables, ... Only keep Table of Contents -->
    <xsl:param name="generate.toc">
        <xsl:choose>
            <xsl:when test="$asciidoc.mode = 0">
set toc
book toc
article toc
chapter toc
qandadiv toc
qandaset toc
sect1 nop
sect2 nop
sect3 nop
sect4 nop
sect5 nop
section toc
part toc
            </xsl:when>
            <xsl:when test="/processing-instruction('asciidoc-toc')">
article toc,title
book    toc,title,figure,table,example,equation
                <xsl:if test="$generate.section.toc.level != 0">
chapter   toc,title
part      toc,title
preface   toc,title
qandadiv  toc
qandaset  toc
reference toc,title
sect1     toc
sect2     toc
sect3     toc
sect4     toc
sect5     toc
section   toc
set       toc,title
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
article nop
book    nop
            </xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <!-- TEMPLATES -->
    <xsl:output method="xml"
                encoding="UTF-8"
                standalone="no"
                doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <!--
        Comes from xhtml/docbook.xsl
        Used to apply a charset <meta/> tag to the xhtml <head/>.
    -->
    <xsl:template name="user.head.content">
        <xsl:param name="node" select="."/>
        <meta xmlns="http://www.w3.org/1999/xhtml" http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    </xsl:template>


    <!--
        From: xhtml/admon.xsl
        Reason: remove tables
    -->
    <xsl:template name="graphical.admonition">
        <xsl:variable name="admon.type">
            <xsl:choose>
                <xsl:when test="local-name(.)='note'">Note</xsl:when>
                <xsl:when test="local-name(.)='warning'">Warning</xsl:when>
                <xsl:when test="local-name(.)='caution'">Caution</xsl:when>
                <xsl:when test="local-name(.)='tip'">Tip</xsl:when>
                <xsl:when test="local-name(.)='important'">Important</xsl:when>
                <xsl:otherwise>Note</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="alt">
            <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="$admon.type"/>
            </xsl:call-template>
        </xsl:variable>

        <div xmlns="http://www.w3.org/1999/xhtml">
            <xsl:apply-templates select="." mode="class.attribute"/>
            <xsl:if test="$admon.style != ''">
                <xsl:attribute name="style">
                    <xsl:value-of select="$admon.style"/>
                </xsl:attribute>
            </xsl:if>

            <xsl:call-template name="anchor"/>
            <xsl:if test="$admon.textlabel != 0 or d:title">
                <h2>
                    <xsl:apply-templates select="." mode="object.title.markup"/>
                </h2>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>

    <!--
        <programlisting/> highlighting using jHighLight

        NOTE : This stuff needs to go away ASAP!
    -->
    <xsl:template match="programlisting">

        <xsl:variable name="language">
            <xsl:value-of select="s:toUpperCase(string(@language))" xmlns:s="java:java.lang.String"/>
        </xsl:variable>

        <xsl:variable name="factory" select="rf:instance()"/>
        <xsl:variable name="hiliter" select="rf:getRenderer($factory, string($language))"/>

        <pre class="{$language}">
            <xsl:choose>
                <xsl:when test="$hiliter">
                    <xsl:for-each select="node()">
                        <xsl:choose>
                            <xsl:when test="self::text()">
                                <xsl:variable name="child.content" select="."/>
                                <xsl:value-of
                                        select="jhr:highlight($hiliter, $language, string($child.content), 'UTF-8', true())"
                                        xmlns:jhr="com.uwyn.jhighlight.renderer.Renderer"
                                        disable-output-escaping="yes"/>
                            </xsl:when>

                            <xsl:otherwise>
                                <xsl:variable name="targets" select="key('id', @linkends)"/>
                                <xsl:variable name="target" select="$targets[1]"/>
                                <xsl:choose>
                                    <xsl:when test="$target">
                                        <a>
                                            <xsl:if test="@id or @xml:id">
                                                <xsl:attribute name="id">
                                                    <xsl:value-of select="(@id|@xml:id)[1]"/>
                                                </xsl:attribute>
                                            </xsl:if>
                                            <xsl:attribute name="href">
                                                <xsl:call-template name="href.target">
                                                    <xsl:with-param name="object" select="$target"/>
                                                </xsl:call-template>
                                            </xsl:attribute>
                                            <xsl:apply-templates select="." mode="callout-bug"/>
                                        </a>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="anchor"/>
                                        <xsl:apply-templates select="." mode="callout-bug"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </pre>

    </xsl:template>

    <!-- Forced line break -->
    <xsl:template match="processing-instruction('asciidoc-br')">
        <br/>
    </xsl:template>

    <!-- Forced page break -->
    <xsl:template match="processing-instruction('asciidoc-pagebreak')">
       <div class="page-break"/>
    </xsl:template>

    <!-- Horizontal ruler -->
    <xsl:template match="processing-instruction('asciidoc-hr')">
        <hr/>
    </xsl:template>

</xsl:stylesheet>
