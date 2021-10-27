<?xml version="1.0"?>
<xsl:stylesheet
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:math="http://www.w3.org/2005/xpath-functions/math"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:saxon="http://saxon.sf.net/"
	xmlns:map="http://www.w3.org/2005/xpath-functions/map"
	xmlns:array="http://www.w3.org/2005/xpath-functions/array"
	exclude-result-prefixes="xs math saxon map array" version="3.0">
	<xsl:output method="xml" encoding="UTF-8"  version="1.0" indent="yes" omit-xml-declaration="yes" />
<xsl:include href="commons/new_params.xsl"/>
	<xsl:import href="../json-to-xsl/json/maps_and_arrays.xsl"/>
	
	<xsl:template match="data">
<!--	    <xsl:copy-of select="json-to-xml(.)"/>-->
		<xsl:apply-templates select="//title"/>
	</xsl:template>
	
	

<xsl:template match="//title">
	<xsl:source-document streamable="no" href="{$originalFilename}">
				<xsl:result-document href="file:///{$workingDir}N-{$archiveFile}_{position()}.xml">
					<titleInfo>
						<title>
							<xsl:value-of select="json-to-xml(//title)"/>
						</title>				
					</titleInfo>
				</xsl:result-document>
	</xsl:source-document>
	
</xsl:template>
	
</xsl:stylesheet>