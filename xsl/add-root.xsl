<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns="http://www.loc.gov/mods/v3" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:f="http://functions" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:saxon="http://saxon.sf.net/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:unzip="java:java.lang.Runtime" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="f fn math mods saxon xd xs">

    <xsl:output indent="yes" method="xml" encoding="UTF-8" name="original" saxon:next-in-chain="json-to-mods.xsl"/>
<xsl:variable name="add-root-tag" select="document('./add-root.sh')"/>
  
    <xsl:template match="/">
    <xsl:result-document href="{$add-root-tag}" method="json">
        <xsl:message>Executing <xsl:value-of select="unzip:exec(unzip:getRuntime(),concat('bash:',$add-root-tag))"/></xsl:message>
    </xsl:result-document> 
    </xsl:template>
</xsl:stylesheet>