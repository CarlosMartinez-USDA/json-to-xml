<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:saxon="http://saxon.sf.net/"
 xmlns:jlib="http://saxonica.com/ns/jlib"
 xmlns:map="http://www.w3.org/2005/xpath-functions/map"
 xmlns:array="http://www.w3.org/20005/xpath-functions/array"
 version="3.0"
 xpath-default-namespace="http://www.w3.org/2005/xpath-functions">

 <xsl:mode on-no-match="shallow-copy"/>


 <xsl:output method="xml" indent="yes"/>

<xsl:template match="/">
 <xsl:copy-of select="json-to-xml(.)"/>
</xsl:template>

</xsl:stylesheet>