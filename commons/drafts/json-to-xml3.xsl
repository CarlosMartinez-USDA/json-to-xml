<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:f="http://functions"
    exclude-result-prefixes="xs math f " version="3.0">
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
        <xsl:apply-templates select="./string[@key = 'title']"/>
        <xsl:apply-templates select="./array[@key = 'pub_authors']"/>
        <!--        <xsl:apply-templates select="/map/array[@key='pub_authors']/map/string[@key='station_id']"/>-->

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
        <xsl:for-each select=".">
            <namePart type="given">
                <xsl:value-of select="replace(.,'(\w+)(\,\s)(\w+)|(\s\w\.)'"/>
            </namePart>
            <namePart type="family">
                <xsl:value-of select="substring-before(., ', ')"/>
            </namePart>
            <displayName>
                <xsl:value-of select="$author_name"/>
            </displayName>
            <affiliation>
                <xsl:value-of select="$station_id"/>
            </affiliation>
            <role>
                <roleTerm type="text">author</roleTerm>
            </role>
        </xsl:for-each>
    </xsl:template>

    <!--    <xsl:template match="//array[@key='pub_authors']/map/string[@key='station_id']">
         <xsl:value-of select="."/>
    </xsl:template>-->



    <!--     <xsl:template match="/map/array[@key='pub_authors']/map/string[@key="name]
                <xsl:param name="stationCode" select="."/>
           
                  <name>
                      <namePart type="given">
                          
                      </namePart>
                      
                  </name>
                    <name type="corporate">
                        <namePart>United States</namePart>
                        <namePart>Forest Service</namePart>
                        <namePart><xsl:value-of select="station:abbrvToName(.)"/></namePart>
                    </name>
    </xsl:template>
       <xsl:template name=""
       <namePart type="given">
           <xsl:value-of select="normalize-space((string-name | name)/given-names)"/>
       </namePart>
       <namePart type="family">
           <xsl:value-of select="(string-name | name)/surname"/>
       </namePart>
       <displayForm>
           <xsl:value-of select="(string-name | name)/surname"/>
           <xsl:text>, </xsl:text>
           <xsl:value-of select="normalize-space((string-name | name)/given-names)"/>
       </displayForm>
       <!-\- Get author's ORCID -\->
       <xsl:apply-templates select="contrib-id[@contrib-id-type = 'orcid']"/>
       <!-\-Xpath uses the id aattribute and the current() function to the appropriate author (xref/@rid) -\->
       <xsl:for-each select="/article/front/article-meta/contrib-group/aff[@id = current()/xref/@rid]">
           <xsl:variable name="this">
               <xsl:apply-templates mode="affiliation"/>
           </xsl:variable>
           <affiliation>
               <xsl:value-of select="normalize-space($this)"/>
           </affiliation>
       </xsl:for-each>
       <role>
           <roleTerm type="text">author</roleTerm>
       </role>
       </xsl:template>
       
  -->
</xsl:stylesheet>