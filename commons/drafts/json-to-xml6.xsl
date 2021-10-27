<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:f="http://functions" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="f fn math xd xs">
    <xsl:output indent="yes" method="xml"/>

    <xsl:include href="../commons/functions.xsl"/>
    <xsl:include href="../commons/params.xsl"/>

    <xsl:strip-space elements="*"/>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="root">
        <mods version="3.7">
            <xsl:apply-templates select="json-to-xml(.)"/>
        </mods>
    </xsl:template>


    <xd:doc>
        <xd:desc> template for the first tag </xd:desc>
    </xd:doc>
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <!-- select a sub-node structure  -->
        <xsl:apply-templates select="./string[@key = 'title']"/>
        <xsl:apply-templates select="."/>/ <!--default values-->
        <typeOfResource>text</typeOfResource>
        <genre>article</genre>
    </xsl:template>


    <xd:doc>
        <xd:desc> template to output a string value </xd:desc>
    </xd:doc>
    <xsl:template match="map/string[@key = 'title']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <titleInfo>
            <title>
                <xsl:value-of select="."/>
            </title>
        </titleInfo>
    </xsl:template>

    <xd:doc scope="component" id="contrib">
        <xd:desc>If the contributor is a collaborator rather than an individual, format output
            accordingly. If processing the first author in the group, assign an attribute of
                <xd:b>usage</xd:b> with a value of "primary."</xd:desc>
    </xd:doc>
    <!-- <xsl:template name="name-id" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:choose>
            <xsl:when test="map/array[@key = 'pub_authors']">
                <name type="personal">
                    <xsl:if test="map/string[@key = 'name'][position() = 1]">
                        <xsl:attribute name="usage">primary</xsl:attribute>
                    </xsl:if>
                    <xsl:apply-templates select="map/string[@key = 'name']"/>
                    <!-\-<xsl:call-template name="name-info"/>-\->
                </name>
            </xsl:when>
            <xsl:otherwise>
                <name type="corporate">
                    <namePart>
                        <xsl:value-of select="map/string[@key = 'primary_station']"/>
                    </namePart>
                </name>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="name-info" xpath-default-namespace="http://www.w3.org/2005/xpath-functions"> </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="abbrv"/>
    </xd:doc>
    <xsl:template match="map/array[@key = 'pub_authors']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="abbrv" tunnel="yes"
            select="/fn:map/fn:array/fn:map/fn:string[@key = 'station_id']"/>
        <xsl:if test="string[@key = 'name']">
            <namePart type="given">
                <xsl:value-of select="substring-after(., ', ')"/>
            </namePart>
            <namePart type="family">
                <xsl:value-of select="substring-before(., ', ')"/>
            </namePart>
            <displayName>
                <xsl:value-of select="."/>
            </displayName>
            <xsl:if test="contains($abbrv, text())">
                <affiliation>
                    <xsl:value-of select="f:abbrvToName(string[@key = 'station_id'])"/>
                </affiliation>
            </xsl:if>
            <role>
                <roleTerm type="text">author</roleTerm>
            </role>
        </xsl:if>
        <!-- Get author's ORCID -->
    </xsl:template>



    <xd:doc>
        <xd:desc/>
        <xd:param name="stationCode"/>
    </xd:doc>
    <xsl:template match="string[@key = 'primary_station']">
        <xsl:param name="stationCode"/>

        <name type="corporate">
            <namePart>United States</namePart>
            <namePart>Forest Service</namePart>
            <namePart>
                <xsl:value-of select="f:abbrvToName(.)"/>
            </namePart>
        </name>
    </xsl:template>
    <!--<!-\-Xpath uses the id aattribute and the current() function to the appropriate author (xref/@rid) -\->
       <xsl:for-each select="/article/front/article-meta/contrib-group/aff[@id = current()/xref/@rid]">
           <xsl:variable name="this">
               <xsl:apply-templates mode="affiliation"/>
           </xsl:variable>
           <affiliation>
               <xsl:value-of select="normalize-space($this)"/>
           </affiliation>
       </xsl:for-each>-->


</xsl:stylesheet>
