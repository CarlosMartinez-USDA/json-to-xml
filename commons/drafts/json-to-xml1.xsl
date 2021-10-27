<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:f="http://functions"
    exclude-result-prefixes="xs f">
    <xsl:output indent="yes" method="xml"/>

    <xsl:strip-space elements="*"/>
    <xsl:include href="../commons/functions.xsl"/>

    <xsl:template match="root">
        <!-- create a new root tag -->
        <!--        <mods version="3.7">-->
        <!-- apply the xml structure generated from JSON -->
        <xsl:apply-templates select="json-to-xml(.)"/>
        <!--</mods>-->
    </xsl:template>

    <!-- template for the first tag -->
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <!-- select a sub-node structure  -->
        <xsl:apply-templates select="string[@key = 'title']"/>
        <xsl:apply-templates select="array[@key = 'pub_authors']"/>
    </xsl:template>

    <!-- template to output a number value -->
    <xsl:template match="string[@key = 'title']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <titleInfo>
            <title>
                <xsl:value-of select="."/>
            </title>
        </titleInfo>
    </xsl:template>



    <xsl:template match="array[@key = 'pub_authors']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" mode="pub_authors">
        <xsl:param name="affiliations">
            <xsl:sequence select="map/string[@key = 'station_id']"/>
        </xsl:param>
        <xsl:for-each select="map/string[@key = 'name']">
            <name>
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
                    <xsl:value-of select="$affiliations"/>
                </affiliation>
                <role>
                    <roleTerm>author</roleTerm>
                </role>
            </name>
        </xsl:for-each>
    </xsl:template>


    <!--   xpath-default-namespace="http://www.w3.org/2005/xpath-functions/map">
        <xsl:for-each select="map/string[@key = 'station_id']">
       <affilation>
        <xsl:value-of select="."/>
       </affilation>
        <role>
            <roleTerm>author</roleTerm>
        </role>
        </xsl:for-each>
    </xsl:param>-->

</xsl:stylesheet>
