<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:array="http://www.w3.org/2005/xpath-functions/array" xmlns:f="http://functions"
    xmlns:map="http://www.w3.org/2005/xpath-functions/map" xmlns:saxon="http://saxon.sf.net/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="array f map xs">
    <xsl:output indent="yes" method="xml" name="archive"/>
    <xsl:output indent="yes" method="xml" encoding="UTF-8" media-type="text/xml"
        json-node-output-method="xml" saxon:next-in-chain="../fix-characters.xsl" name="original"/>
    <xsl:include href="../commons/functions.xsl"/>
    <xsl:include href="../commons/params.xsl"/>


    <xsl:template match="/">
        <xsl:for-each select="root">
            <xsl:result-document method="xml" indent="yes" encoding="UTF-8" media-type="text/xml"
                href="{$workingDir}A-{$archiveFile}_{position()}.xml" format="archive">
                <xsl:apply-templates select="json-to-xml(.)"/>
            </xsl:result-document>
            <xsl:result-document method="xml" indent="yes" encoding="UTF-8" media-type="text/xml"
                href="{$workingDir}N-{$archiveFile}_{position()}.xml" format="original">
                <mods version="3.7">
                    <xsl:apply-templates select="json-to-xml(.)"/>
                </mods>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>

    <!-- template for the first tag -->
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">

        <!-- select a sub-node structure  -->
        <xsl:apply-templates select="./string[@key = 'title']"/>
        <xsl:apply-templates select="./array/map/string[@key = 'name']"/>

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
        <name>
            <xsl:for-each select="/map/string[@key = 'name']">
                <namePart type="given">
                    <xsl:value-of select="substring-after(., ', ')"/>
                </namePart>
                <namePart type="family">
                    <xsl:value-of select="substring-before(., ', ')"/>
                </namePart>
                <displayName>
                    <xsl:value-of select="."/>
                </displayName>
                <xsl:variable name="affiliation"
                    xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
                    <xsl:value-of
                        select="normalize-space(map/array[@key = 'current_organizational_memberships']/map/string[@key = 'station_id'])"
                    />
                </xsl:variable>
                <affiliation>
                    <xsl:value-of select="$affiliation"/>
                </affiliation>
                <role>
                    <roleTerm type="text">author</roleTerm>
                </role>
            </xsl:for-each>
        </name>
    </xsl:template>


</xsl:stylesheet>
