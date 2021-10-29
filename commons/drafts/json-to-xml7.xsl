<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:f="http://functions" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="f fn math xd xs">
    <xsl:output indent="yes" method="xml"/>

    <xsl:include href="../commons/functions.xsl"/>
    <xsl:include href="../commons/params.xsl"/>

    <xsl:strip-space elements="*"/>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="root">
        <xsl:copy-of select="json-to-xml(.)"/>
    </xsl:template>
</xsl:stylesheet>