<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:f="http://functions"
    exclude-result-prefixes="fn xs math f" version="3.0">
    <xsl:output indent="yes" method="xml"/>
    <xsl:include href="../commons/params.xsl"/>
    <xsl:include href="../commons/functions.xsl"/>

    <xsl:template match="root">
        <mods version="3.7">
            <!-- apply the xml structure generated from JSON -->
            <xsl:apply-templates select="json-to-xml(.)"/>
        </mods>
    </xsl:template>

    <!-- template for the first tag -->
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <!-- select a sub-node structure  -->
        <xsl:apply-templates select="string[@key = 'title']"/>
        <xsl:apply-templates select="array[@key = 'pub_authors']"/>
    </xsl:template>

    <!-- template to output a number value -->
    <xsl:template match="map/string[@key = 'title']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <titleInfo>
            <title>
                <xsl:value-of select="."/>
            </title>
        </titleInfo>
    </xsl:template>

    <xsl:template match="map/array[@key = 'pub_authors']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="affilations" select="map/string{@kay='station_id']"/>
        <xsl:for-each select="map/string[@key = 'name']">
            <name>
                <namePart type="given">
                    <xsl:value-of select="substring-after(., ', ')"/>
                </namePart>
                <namePart type="family">
                    <xsl:value-of select="substring-before(., ', ')"/>
                </namePart>
                <displayName>
                    <xsl:value-of select="."/>
                </displayName>
                <affiliation>
                    <xsl:value-of select="$affilations"/>
                </affiliation>
                <role>
                    <roleTerm type="text">author</roleTerm>
                </role>
            </name>
        </xsl:for-each>

    </xsl:template>

    <xsl:template match="map/array[@key = 'current_orgnanizational_memberships']">
        <xsl:variable name="nodes" select="map/array[@key = current()/map/array]"/>
        <xsl:value-of select="$nodes/map/string[@key = 'station_id']"/>
    </xsl:template>


</xsl:stylesheet>