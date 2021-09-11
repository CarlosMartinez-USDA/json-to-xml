<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:f="http://functions" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
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
        <xsl:apply-templates select="./array[@key='pub_authors'] | fn:map/fn:array[@key='primary_station']"/>
            

        <!--default values-->
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
    <xsl:template match="fn:map/fn:array[@key='pub_authors'] | fn:map/fn:array[@key='primary_station']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:choose>
            <xsl:when test="map/string[@key = 'primary_station']">
                <name type="corporate">
                    <namePart>
                        <xsl:value-of select="map/string[@key = 'primary_station']"/>
                    </namePart>
                </name>
            </xsl:when>
            <xsl:otherwise>
                <name type="personal">
                    <xsl:if test="position() = 1 and count(map/preceding-sibling::string[@key = 'name']) = 0">
                        <xsl:attribute name="usage">primary</xsl:attribute>
                    </xsl:if>
                   <xsl:call-template name="name-info"/>
                </name>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xd:doc>
        <xd:desc/>
       <xd:param name="abbrv"/>
    </xd:doc>
    <xsl:template name="name-info" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="abbrv" as="xs:string">
            <xsl:sequence select="subsequence(map/string[@key = 'station_id'],1,position())"/>
        </xsl:param> 
          <xsl:for-each select="map/string[@key='name']">
            <namePart type="given">
                <xsl:value-of select="substring-after(normalize-space(.), ', ')"/>
            </namePart>
            <namePart type="family">
                <xsl:value-of select="substring-before(normalize-space(.), ', ')"/>
            </namePart>
            <displayName>
                <xsl:value-of select="."/>
            </displayName>
            <affiliation>
                <xsl:if test="string-length($abbrv) >= 3 and position()">
                    <xsl:value-of select="f:abbrvToName($abbrv)"/>
                </xsl:if>
            </affiliation>
            <role>
                <roleTerm type="text">author</roleTerm>
            </role>
        </xsl:for-each>
    </xsl:template>
    <!-- Get author's ORCID -->



    <xd:doc>
        <xd:desc/>

    </xd:doc>
    <xsl:template match="map/string[@key = 'primary_station']">
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
