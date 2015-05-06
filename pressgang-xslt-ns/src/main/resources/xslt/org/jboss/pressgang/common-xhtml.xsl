<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="d"
                version="1.0">

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

    <xsl:param name="html.googleAnalyticsId" select="''"/>
    <xsl:param name="html.googleTagManagerId" select="'GTM-NJWS5L'"/>
    <xsl:param name="html.googleTagManagerChannel" select="'UndefinedDocs'"/>

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
        Comes from xhtml/docbook.xsl
        Used to add google analytics script.
    -->
    <xsl:template name="user.footer.content">
        <script type="text/javascript" src="highlight.js/highlight.pack.js">
            <!-- Workaround to force outputting "</script>". The space is required. -->
            <xsl:text> </xsl:text>
        </script>
        <script type="text/javascript">
            <xsl:text>hljs.initHighlightingOnLoad();</xsl:text>
        </script>
        <xsl:if test="$html.googleAnalyticsId != ''">
            <xsl:element name="script" namespace="http://www.w3.org/1999/xhtml">
                <xsl:attribute name="type">
                    <xsl:text>text/javascript</xsl:text>
                </xsl:attribute>
                <xsl:text>
dataLayer = [{'channel' : '</xsl:text>
                <xsl:value-of select="$html.googleTagManagerChannel"/>
                <xsl:text>', 'additional_tracking_code' : '</xsl:text>
                <xsl:value-of select="$html.googleAnalyticsId"/>
                <xsl:text disable-output-escaping="yes">'}];
(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&amp;l='+l:'';j.async=true;j.src=
'//www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','</xsl:text>
                <xsl:value-of select="$html.googleTagManagerId"/>
                <xsl:text>');</xsl:text>
            </xsl:element>
            <!-- TODO this <noscript> element should be immediately under the body tag according to GTM guidelines -->
            <xsl:element name="noscript" namespace="http://www.w3.org/1999/xhtml">
                <xsl:element name="iframe" namespace="http://www.w3.org/1999/xhtml">
                    <xsl:attribute name="src">
                        <xsl:text>//www.googletagmanager.com/ns.html?id=</xsl:text><xsl:value-of select="$html.googleTagManagerId"/>
                    </xsl:attribute>
                    <xsl:attribute name="height"><xsl:text>0</xsl:text></xsl:attribute>
                    <xsl:attribute name="width"><xsl:text>0</xsl:text></xsl:attribute>
                    <xsl:attribute name="style"><xsl:text>display:none;visibility:hidden</xsl:text></xsl:attribute>
                    <!-- Workaround to force outputting "</iframe>". The space is required. -->
                    <xsl:text> </xsl:text>
                </xsl:element>
            </xsl:element>
        </xsl:if>
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
        <programlisting/> highlighting using highlight.js (allows decent copy-pasting by end-users)
    -->
    <xsl:template match="d:programlisting">
        <xsl:variable name="language">
            <xsl:value-of select="s:toLowerCase(string(@language))" xmlns:s="java:java.lang.String"/>
        </xsl:variable>
        <pre>
            <xsl:choose>
                <xsl:when test="$language != ''">
                    <code class="language-{$language}">
                        <xsl:apply-templates/>
                    </code>
                </xsl:when>
                <xsl:otherwise>
                    <code class="no-highlight">
                        <xsl:apply-templates/>
                    </code>
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
