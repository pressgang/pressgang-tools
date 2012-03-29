<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- IMPORTS -->
    <xsl:import href="common-callout.xsl"/>

    <!--
        This is needed to generate the correct xhtml-strict DOCTYPE on the front page.  We can't use
        indentation as the algorithm inserts linebreaks into the markup created for callouts. This means
        that callouts appear on different lines than the code they are supposed to refer to.
    -->
    <xsl:output method="xml"
                encoding="UTF-8"
                indent="no"
                doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
                doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"/>

    <!--
        We must turn off indenting as the algorithm inserts linebreaks into the callout markup that is
        added by the code highlighting routine. This causes the callouts to appear on different lines
        from the code they relate to.
    -->
    <xsl:param name="chunker.output.indent" select="'no'"/>

    <!--
        Place callout marks at this column in annotated areas. The algorithm using this number doesn't
        know about highlighted code with extra span elements so we need to pad each line at the start
        with an XML comment and a line break. The callout marks must then be placed immediately afterwards.
        This ensures that the callouts appear on the same line as the code it relates to and we can position
        them using CSS so that they all appear in a column on the right.
    -->
    <xsl:param name="callout.defaultcolumn">15</xsl:param>
    <xsl:param name="callout.icon.size">17px</xsl:param>


    <xsl:template name="callout-bug">
        <xsl:param name="conum" select="1"/>

        <xsl:choose>
            <xsl:when test="$callout.graphics != 0 and $conum &lt;= $callout.graphics.number.limit">
                <img src="{$callout.graphics.path}{$conum}{$callout.graphics.extension}" alt="{$conum}" border="0"
                     height="{$callout.icon.size}" width="{$callout.icon.size}"/>
            </xsl:when>
            <xsl:when test="$callout.unicode != 0 and $conum &lt;= $callout.unicode.number.limit">
                <xsl:choose>
                    <xsl:when test="$callout.unicode.start.character = 10102">
                        <xsl:choose>
                            <xsl:when test="$conum = 1">&#10102;</xsl:when>
                            <xsl:when test="$conum = 2">&#10103;</xsl:when>
                            <xsl:when test="$conum = 3">&#10104;</xsl:when>
                            <xsl:when test="$conum = 4">&#10105;</xsl:when>
                            <xsl:when test="$conum = 5">&#10106;</xsl:when>
                            <xsl:when test="$conum = 6">&#10107;</xsl:when>
                            <xsl:when test="$conum = 7">&#10108;</xsl:when>
                            <xsl:when test="$conum = 8">&#10109;</xsl:when>
                            <xsl:when test="$conum = 9">&#10110;</xsl:when>
                            <xsl:when test="$conum = 10">&#10111;</xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>Don't know how to generate Unicode callouts </xsl:text>
                            <xsl:text>when $callout.unicode.start.character is </xsl:text>
                            <xsl:value-of select="$callout.unicode.start.character"/>
                        </xsl:message>
                        <xsl:text>(</xsl:text>
                        <xsl:value-of select="$conum"/>
                        <xsl:text>)</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>(</xsl:text>
                <xsl:value-of select="$conum"/>
                <xsl:text>)</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
