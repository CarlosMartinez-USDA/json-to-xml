<?xml version="1.0"?>
<xsl:transform xm-lns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:math="http://www.w3.org/2005/xpath-functions/math"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs math" version="3.0"
	xpath-default-namespace="http://www.w3c.org/2005/xpath-functions">
	<xsl:include href="commons/new_params.xsl"/>
	<xsl:mode on-no-match="shallow-copy"/>
	<xsl:output method="xml" indent="yes"/>
	<xsl:param name="input"/>
	<xsl:variable name="input-as-xml">
		
		<xsl:copy-of select="json-to-xml(.)"/>
		
	</xsl:variable>
		

	<xsl:template match="/">
		<xsl:result-document method="xml" encoding="UTF-8" indent="yes" href="file:///{$workingDir}N-{$archiveFile}_{position()}.xml">
		<xsl:copy-of select="$input-as-xml"/>
		</xsl:result-document>
		<xsl:apply-templates select="/array/map/string[@key='title']/text()"/>
<!--		<xsl:call-template name="xsl:initial-template"/>-->
	</xsl:template>


<!--	<xsl:template name="xsl:initial-template">
		
		<xsl:variable name="transformed-xml" as="document-node()">
			<xsl:apply-templates select="$input-as-xml"/>
		</xsl:variable>
		<xsl:value-of select="$input-as-xml"/>
<!-\-		<xsl:value-of select="xml-to-json($transformed-xml)"/>-\->
	</xsl:template>

-->	<xsl:template match="array/map/string[@key='title']/text()">
		<titleInfo>
			<title>
				<xsl:value-of select="."/>
			</title>
		</titleInfo>
	</xsl:template>


	<!--<xsl:template match="map[array[@key='title']/string]/number[@key]/text()">
		<titleInfo>
			<title>
				<xsl:value-of select="map[array[@key='title']/string]"/>
			</title>
		</titleInfo>
	</xsl:template>-->
</xsl:transform>
