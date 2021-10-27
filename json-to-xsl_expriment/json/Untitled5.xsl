<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:saxon="http://saxon.sf.net/"
    version="3.0"
    xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
    <xsl:param name="input" as="xs:anyURI" select="saxon:system-id()"/>
    
    <xsl:template match="/">
        <xsl:call-template name="xsl:initial-template"/>
    </xsl:template>
<xsl:template name="xsl:initial-template">
    <xsl:variable name="input-as-xml" select="json-to-xml(unparsed-text(resolve-uri($input)))"/>
    <xsl:variable name="transformed-xml" as="item()*">
        <xsl:apply-templates select="$input-as-xml"/>
    </xsl:variable>
    <xsl:value-of select="$transformed-xml"/>
            <xsl:value-of select="xml-to-json($transformed-xml)"/>
</xsl:template>
</xsl:stylesheet>