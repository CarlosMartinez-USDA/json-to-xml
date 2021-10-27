<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:saxon="http://saxon.sf.net/"
	xmlns:map="http://www..org/2005/xpath-functions/map" xmlns:array="http://www.w3.org/2005/xpath-functions/array" exclude-result-prefixes="xs math"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/mods/v3 https://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="yes" name="archiveFile"/>
	<xsl:include href="commons/new_params.xsl"/>

	<xsl:template match="data">
		<!--	    <xsl:copy-of select="json-to-xml(.)"/>-->
		<xsl:apply-templates select="//title"/>
		
		
	</xsl:template>



	<xsl:template match="map(function{$k,$v}, ), ">
		<xsl:source-document streamable="no" href="{$originalFilename}">
			<xsl:result-document encoding="UTF-8" format="archiveFile"
				href="file:///{$workingDir}A-{$archiveFile}_{position()}.xml">
				<titleInfo>
					<title>
						<xsl:value-of select="//title"/>
					</title>
				</titleInfo>
			</xsl:result-document>
		</xsl:source-document>

	</xsl:template>

</xsl:stylesheet>
