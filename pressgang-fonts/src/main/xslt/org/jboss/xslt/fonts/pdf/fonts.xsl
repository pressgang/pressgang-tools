<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0"
                xmlns="http://www.w3.org/TR/xhtml1/transitional"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                exclude-result-prefixes="#default">

<!-- 
	Stylesheet for handling non-latin fonts in generating PDF documents.  Copied
	from http://svn.fedorahosted.org/svn/publican/trunk/publican/xsl/pdf.xsl
-->

	<xsl:template name="pickfont">
		<xsl:variable name="font">
			<xsl:choose>
				<xsl:when test="$l10n.gentext.language = 'ja-JP' or l10n.gentext.language = 'ja'">
					<xsl:text>Sazanami Gothic,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'ko-KR' or $l10n.gentext.language = 'ko'">
					<xsl:text>Baekmuk Batang,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'zh-CN'">
					<xsl:text>ZYSong18030,AR PL UMing CN,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'as-IN' or $l10n.gentext.language = 'as'">
					<xsl:text>Lohit Bengali,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'bn-IN' or $l10n.gentext.language = 'bn'">
					<xsl:text>Lohit Bengali,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'ta-IN' or $l10n.gentext.language = 'ta'">
					<xsl:text>Lohit Tamil,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'pa-IN' or l10n.gentext.language = 'pa'">
					<xsl:text>Lohit Punjabi,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'hi-IN' or $l10n.gentext.language = 'hi'">
					<xsl:text>Lohit Hindi,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'mr-IN' or $l10n.gentext.language = 'mr'">
					<xsl:text>Lohit Hindi,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'gu-IN' or $l10n.gentext.language = 'gu'">
					<xsl:text>Lohit Gujarati,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'zh-TW'">
					<xsl:text>AR PL ShanHeiSun Uni,AR PL UMing TW,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'kn-IN' or $l10n.gentext.language = 'kn'">
					<xsl:text>Lohit Kannada,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'ml-IN' or $l10n.gentext.language = 'ml-IN'">
					<xsl:text>Lohit Malayalam,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'or-IN' or $l10n.gentext.language = 'or'">
					<xsl:text>Lohit Oriya,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'te-IN' or $l10n.gentext.language = 'te'">
					<xsl:text>Lohit Telugu,</xsl:text>
				</xsl:when>
				<xsl:when test="$l10n.gentext.language = 'si-LK' or $l10n.gentext.language = 'si'">
					<xsl:text>LKLUG,</xsl:text>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

        <xsl:message>
            <xsl:text>pickfont selection [lang=</xsl:text><xsl:value-of select="$l10n.gentext.language"/><xsl:text>] : </xsl:text><xsl:copy-of select="$font"/>
        </xsl:message>

		<xsl:copy-of select="$font"/>
	</xsl:template>

	<xsl:template name="pickfont-sans">
		<xsl:variable name="font">
			<xsl:call-template name="pickfont"/>
		</xsl:variable>
			
		<xsl:copy-of select="$font"/><xsl:text>Liberation Sans,sans-serif</xsl:text>

	</xsl:template>

	<xsl:template name="pickfont-mono">
		<xsl:variable name="font">
			<xsl:call-template name="pickfont"/>
		</xsl:variable>

		<xsl:copy-of select="$font"/><xsl:text>Liberation Mono,monospace</xsl:text>

	</xsl:template>

	<xsl:param name="title.font.family">
		<xsl:call-template name="pickfont-sans"/>
	</xsl:param>

	<xsl:param name="body.font.family">
		<xsl:call-template name="pickfont-sans"/>
	</xsl:param>

	<xsl:param name="monospace.font.family">
		<xsl:call-template name="pickfont-mono"/>
	</xsl:param>

	<xsl:param name="sans.font.family">
		<xsl:call-template name="pickfont-sans"/>
	</xsl:param>

</xsl:stylesheet>


