<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:f="http://functions"
    exclude-result-prefixes="xs math f " version="3.0">
    <xsl:output indent="yes" method="xml"/>
    
    <xsl:include href="../commons/functions.xsl"/>
   
    <xsl:template match="root">
        <!-- create a new root tag -->
        <mods version="3.7">
            <!-- apply the xml structure generated from JSON -->
            <xsl:apply-templates select="json-to-xml(.)"/>
        </mods>
    </xsl:template>

    <!-- template for the first tag -->
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">

        <!-- select a sub-node structure  -->
        <xsl:apply-templates select="//map/string[@key = 'title']"/>
        <xsl:apply-templates select="/map/array[@key='pub_authors']/map/string[@key = 'name']"/>
    </xsl:template>

    <!-- template to output a number value -->
    <xsl:template match="//string[@key = 'title']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <titleInfo>
            <title>
                <xsl:value-of select="."/>
            </title>
        </titleInfo>
    </xsl:template>


    


    <xsl:template match="map/array[@key='pub_authors']/map/string[@key='name'] | map/array[@key='pub_authors']/map/string[@key='station_id']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:for-each select=".">
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
                <xsl:variable name="nodes" select="//map/array[@key='pub_authors']"/>
                <affiliation>
                    <xsl:value-of select="$nodes/map/string[@key='station_id']"/>
                </affiliation>
                <role>
                    <roleTerm type="text">author</roleTerm>
                </role>
            </name>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="*/map/string[@key='station_id']">
        <xsl:value-of select="."/>
</xsl:template>

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
