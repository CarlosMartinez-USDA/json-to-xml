<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:saxon="http://saxon.sf.net"
    xmlns:jlib="http://saxonica.com/ns/jsonlib"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array"
    version="3.0"
    xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
    <xsl:include href="../commons/new_params.xsl"/>
    <xsl:import href="maps-and-arrays.xsl"/>
    <xsl:mode on-no-match="deep-copy"/>
    <xsl:param name="input" select="unparsed-text($originalFilename)"/>
    
    <xsl:template name="xsl:initial-template">
        <xsl:apply-templates select="json-doc($input)"/>
    </xsl:template>
    
    <xsl:template match=".[. instance of map(*)][?tags = 'ice']">
        <xsl:map>
            <xsl:sequence select="map:for-each(.,
                function($k, $v){ map{$k : if ($k = 'price') then $v*1.1 else $v }})"/>
        </xsl:map>
    </xsl:template>
    
    <!--add to function.xsl-->
    <xsl:function name="jlib:is-map-entry" as="xs:boolean">
        <xsl:param name="map" as="item()"/>
        <xsl:param name="key" as="xs:anyAtomicType"/>
        <xsl:sequence select=". instance of map(*) and map:size(*) eq 1 and map:contains($key)"/>
    </xsl:function>
    
</xsl:stylesheet>