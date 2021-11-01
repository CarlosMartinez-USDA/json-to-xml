<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:f="http://functions"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
     exclude-result-prefixes="f fn math xs">
    <xsl:output indent="yes" method="xml"/>

    <xsl:include href="../commons/functions.xsl"/>
    <xsl:include href="../commons/params.xsl"/>


    <xsl:template match="root">
        <mods version="3.7">
            <xsl:apply-templates select="json-to-xml(.)"/>
        </mods>
    </xsl:template>

    <!-- template for the first tag -->
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">

        <!-- select a sub-node structure  -->
        <xsl:apply-templates select="string[@key = 'title']"/>
        <xsl:apply-templates select="array[@key = 'pub_authors']"/>
        <typeOfResource>text</typeOfResource>
        <genre>article</genre>

    </xsl:template>

    <!-- template to output a number value -->
    <xsl:template match="map/string[@key = 'title']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <titleInfo>
            <title>
                <xsl:value-of select="."/>
            </title>
        </titleInfo>
    </xsl:template>

 <!--   <xsl:template name="name-info" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:choose>
           <xsl:when test="not(map/array[@key = 'pub_authors'])">
                <xsl:apply-templates select="map/array[@key = 'pub_authors']/map/string[@key = 'name']"/>
           </xsl:when>
            <xsl:when
                test="not(map/array[@key = 'pub_authors']) and (map/string[@key = 'primary_station'])">
                <xsl:apply-templates select="map/string[@key = 'primary_station']"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
-->
    
    <xsl:template match="map/array[@key = 'pub_authors']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="abbrv" tunnel="yes">
           <xsl:sequence select="map/string[@key = 'station_id']"/>
        </xsl:param> 
        <xsl:for-each select="map/string[@key = 'name']">
        <namePart type="given">
            <xsl:value-of select="substring-after(normalize-space(.), ', ')"/>
        </namePart>
        <namePart type="family">
            <xsl:value-of select="substring-before(normalize-space(.), ', ')"/>
        </namePart>
        <displayName>
            <xsl:value-of select="."/>
        </displayName>
        <xsl:if test="$abbrv">
            <affiliation>
                <xsl:value-of select="f:abbrvToName($abbrv)"/>
            </affiliation>
        </xsl:if>
        <role>
            <roleTerm type="text">author</roleTerm>
        </role>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="string[@key = 'primary_station']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="stationCode" select="."/>
        <name type="corporate">
            <namePart>United States</namePart>
            <namePart>Forest Service</namePart>
            <namePart><xsl:value-of select="f:abbrvToName(.) </namePart>
        </name>
        <!-- Get author's ORCID -->
        <xsl:apply-templates select="contrib-id[@contrib-id-type = 'orcid']"/>
        <!--Xpath uses the id aattribute and the current() function to the appropriate author (xref/@rid) -->

    </xsl:template>


</xsl:stylesheet>
