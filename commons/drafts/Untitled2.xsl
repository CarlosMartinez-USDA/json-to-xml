<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs math" version="3.0">
    <xsl:output indent="yes" omit-xml-declaration="yes"/>

    <xsl:template match="root">
        <!-- create a new root tag -->
        <mods version="3.7">
            <!-- apply the xml structure generated from JSON -->
            <xsl:apply-templates select="json-to-xml(.)"/>
        </mods>
    </xsl:template>

    <!-- template for the first tag -->
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <titleInfo>
            <title>
                <!-- select a sub-node structure  -->
                <xsl:apply-templates select="map/string[@key = 'title']"/>
            </title>
        </titleInfo>

    </xsl:template>

    <!-- template to output a number value -->
    <xsl:template match="//string/[@key = 'title']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <num>
            <xsl:value-of select="."/>
        </num>
    </xsl:template>

</xsl:stylesheet>