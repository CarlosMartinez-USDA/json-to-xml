<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:saxon="http://saxon.sf.net/" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:mods="http://www.loc.gov/mods/v3"
    exclude-result-prefixes="xs xsi xlink math map array saxon fn mods" xpath-default-namespace="http://www.w3c.org/2005/xpath-functions">
    <xsl:include href="../commons/new_params.xsl"/>
    <xsl:mode on-no-match="shallow-copy"/>
    <xsl:output method="xml" indent="yes"/>
    <xsl:param name="input" select="$originalFilename"/>
    <xsl:variable name="input-as-xml">
        <xsl:copy-of select="json-to-xml($input)"/>
    </xsl:variable>


    <xsl:template match="/">
        <xsl:result-document method="xml" encoding="UTF-8" indent="yes"
            href="file:///{$workingDir}N-{$archiveFile}_{position()}.xml">
         <xsl:apply-templates select="$input-as-xml//map/string[@key]"/>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="doc($input-as-xml)//map/string[@key]">
     <titleInfo>
        <title>
            <xsl:value-of select="doc($input-as-xml)//map/string[@key='title']"/>
        </title>
    </titleInfo>
    </xsl:template> 
</xsl:stylesheet>