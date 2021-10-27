<?xml version="1.0" encoding="UTF-8"?>
<xsl:transform version="3.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema" 
 xmlns="http://www.loc.gov/mods/v3" 
 xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xmlns:f="http://functions"
 xmlns:map="http://www.w3.org/2005/xpath-functions/map"
 xmlns:array="http://www.w3.org/2005/xpath-functions/array"
 xmlns:jlib="http://saxonica.com/ns/jlib"
 xmlns:saxon="http://saxon.sf.net/"
 xpath-default-namespace="http://www.w3.org/2005/xpath-functions"
 exclude-result-prefixes="xs xd xsi f #default map array jlib">
 <xsl:mode on-no-match="deep-copy"/>
 
 <xsl:include href="../commons/new_params.xsl"/>
 <xsl:mode on-no-match="shallow-copy"/>
 <xsl:output method="xml" indent="yes" name="json-to-xml"/>
 <xsl:param name="input-as-xml" select="json-to-xml(.)"/> 
<xsl:variable name="transformed-xml" as="document-node()">
 <xsl:copy-of select="map:for-each($input-as-xml)"/>
</xsl:variable> 
 <xsl:template match="/">
 
 
  
  <!-- Transforming JSON using XSLT 3.0-->
  
  <xsl:template name="xsl:initial-template">
   <xsl:apply-templates select="json-doc($input)"/>
  </xsl:template>
  <xsl:result-document method="xml" indent="yes" encoding="UTF-8" format="json-to-xml" href="file:///{$workingDir}A-{$archiveFile}_{position()}.xml">
  
  <xsl:apply-templates select="/array/map[string[@key='title']]"/>
  </xsl:result-document>
 </xsl:template>
<!--
 <xsl:template name="xsl:initial-template">
  <xsl:variable name="transformed-xml" as="document-node()">
   <xsl:apply-templates select="$input-as-xml"/>
  </xsl:variable>
  <xsl:value-of select="xml-to-json($transformed-xml)"/>
 </xsl:template>
-->
 <xsl:template match="/array/map/string[@key='title']">
  <xsl:value-of select="."/>
 </xsl:template>

</xsl:transform>
