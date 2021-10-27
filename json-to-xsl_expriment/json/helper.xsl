<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:jlib="http://saxonica.com/ns/jsonlib"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    version="3.0">
    <xsl:param name="input"/>
    <xsl:output method="json"/>
    <xsl:import href="maps_and_arrays.xsl"/>
    <xsl:mode on-no-match="deep-copy"/>
    
   <!-- Transforming JSON using XSLT 3.0-->
    
    <xsl:template name="xsl:initial-template">
        <xsl:apply-templates select="json-doc($input)"/>
    </xsl:template>
    <xsl:template match=".[. instance of map(*)][?tags = 'ice']">
        <xsl:map>
            <xsl:sequence select="map:for-each(.,
                function($k, $v){ map{$k : if ($k = 'price') then $v*1.1 ►
                else $v }})"/>
        </xsl:map>
    </xsl:template>
</xsl:stylesheet>