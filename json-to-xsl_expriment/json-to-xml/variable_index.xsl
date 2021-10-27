<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs math" version="3.0"
    xpath-default-namespace="http://www.w3c.org/2005/xpath-functions">
    <xsl:include href="../commons/new_params.xsl"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="input"/>
        
<xsl:variable name="index" as="map(xs:string, element(doi))">
    <xsl:map>
        <xsl:for-each select="//string[@key='doi']">
            <xsl:map-entry key="@doi" select="."/>
        </xsl:for-each>
    </xsl:map>
</xsl:variable>
    
<xsl:template match="/">
    <xsl:copy-of select="json-doc($index)"/>
</xsl:template>
    
</xsl:transform>