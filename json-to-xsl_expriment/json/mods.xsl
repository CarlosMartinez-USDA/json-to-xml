<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="3.0"
    xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:param name="input"/>
    <xsl:variable name="json-input" select="node()"/>
    <xsl:output method="xml" indent="yes"/>
   
    <xsl:template match="node()">     <!--
        <xsl:copy-of select="json-to-xml($json-input)"/>-->
        <xsl:call-template name="xsl:initial-template"/>
    </xsl:template>    
   
    <xsl:template name="xsl:initial-template">
        <xsl:variable name="input-as-xml" select="unparsed-text($input)"/>
        <xsl:variable name="transformed-xml" as="document-node()">
            <xsl:apply-templates select="$input-as-xml"/>
        </xsl:variable>
        <xsl:value-of select="$transformed-xml/[@key='title']"/>
        
    </xsl:template>

    <xsl:template match="map[array[@key='tags']/string='ice']/number[@key='price']/text()">
        <xsl:value-of select="xs:decimal(.)*1.1"/>
    </xsl:template>
</xsl:transform>
