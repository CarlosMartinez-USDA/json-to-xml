<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:xlink="http://www.w3.org/2001/xlink"
 xmlns:math="http://www.w3.org/2005/xpath-functions/math"
 xmlns:array="http://www.w3.org/2005/xpath-functions/array"
 xmlns:saxon="http://saxon.sf.net/"
 xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
<xsl:include href="../commons/new_params.xsl"/>
 <xsl:mode on-no-match="shallow-copy"/>

 <xsl:param name="input"/>

 <xsl:output method="text"/>

 <xsl:template name="xsl:initial-template">
  <xsl:variable name="input-as-xml" select="json-to-xml(unparsed-text($input))"/>
  <xsl:variable name="transformed-xml" as="document-node()">
   <xsl:apply-templates select="$input-as-xml"/>
  </xsl:variable>
  <xsl:value-of select="$transformed-xml"/>
 </xsl:template>

 <xsl:template match="map[array[@key = 'tags']/string = 'ice']/number[@key = 'price']/text()">
  <xsl:value-of select="xs:decimal(.) * 1.1"/>
 </xsl:template>
</xsl:stylesheet>
