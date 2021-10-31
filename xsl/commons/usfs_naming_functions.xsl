<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE transform [
          <!ENTITY % predefined PUBLIC
         "-//W3C//ENTITIES Predefined XML//EN///XML"
         "C:/Users/carlos.martinez/Desktop/json-to-xml/ent/predefined.ent"
       >
       %predefined;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.loc.gov/mods/v3"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:local="http://functions"
    xmlns:usfs="http://usfsresearch"
    exclude-result-prefixes="xs xd local usfs"
    version="2.0">
    <!--United States Forest Service Research Naming Functions (UFSF RNF) -->
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jun 28, 2017</xd:p>
            <xd:p><xd:b>Author:</xd:b>Rachel Donahoe</xd:p>
            <xd:p><xd:b>Edited by:</xd:b>Carlos Martinez </xd:p>  
            <xd:p><xd:b>Last Edited on:</xd:b>Sept 21, 2021</xd:p>       
        </xd:desc>
    </xd:doc>    
    
    <!--Global Variables-->
    <xsl:variable name="seriesTitle" select="text()=('Forest Insect &amp; Disease Leaflet', 'General Technical Report (GTR)', 'General Technical Report - Proceedings', 'Information Forestry', 'Prsoceeding (Rocky Mountain Research Station Publications)',
        'Resource Bulletin (RB)', 'Research Map (RMAP)', 'Research Note (RN)', 'Research Paper (RP)', 'Resource Update (RU)')"/>
    <xsl:variable name="nodes" as="node()*">
        <xsl:copy-of select="document('./usfs_treesearch.xml')"/>
    </xsl:variable>  
    
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:acronymToName</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:acronymToName(string[@key = 'station_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>function to match a three-letter acronym to a full research station name.</xd:p>            
        </xd:desc>
        <xd:param name="acronym">three-letter</xd:param>
    </xd:doc>      
    <xsl:function name="local:acronymToName">
        <xsl:param name="acronym"/>
        <xsl:if test="$acronym != ''"/>
        <xsl:variable name="nodes">
            <xsl:copy-of select="document('./USFS_treesearch.xml')"/>
        </xsl:variable>
        <xsl:copy-of select="$nodes/usfs:research/usfs:stations/usfs:station[usfs:acronym = $acronym]/usfs:name"/>
    </xsl:function>
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>usfs:acronymToAddress</xd:p>
            <xd:p><xd:b>Usage: </xd:b>usfs:acronyToAddress(string[@key = 'station_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Convert ISO 639-2b three-letter codes into ISO 639-1 two-letter codes.</xd:p>            
        </xd:desc>
        <xd:param name="acronym">three-letter language code to match against</xd:param>
    </xd:doc>      
    <xsl:function name="local:acronymToAddress" as="xs:string" xmlns:f="http://functions">
        <xsl:param name="acronym"/>
        <xsl:if test="$acronym != ''"/>
        <xsl:variable name="nodes">
            <xsl:copy-of select="document('./usfs_treesearch.xml')"/>
        </xsl:variable>
        <xsl:value-of select="$nodes/usfs:research/usfs:stations/usfs:station[usfs:acronym = $acronym]/usfs:address"/>
    </xsl:function>
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>usfs:unitNumToName</xd:p>
            <xd:p><xd:b>Usage: </xd:b>usfs:unitNumToName(string[@key = 'unit_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Convert ISO 639-2b three-letter codes into ISO 639-1 two-letter codes.</xd:p>            
        </xd:desc>
        <xd:param name="unitNum">four-digit number code to match against</xd:param>
    </xd:doc>      
    <xsl:function name="local:unitNumToName" as="xs:string" xmlns:f="http://functions">
        <xsl:param name="unitNum"/>
        <xsl:if test="$unitNum != ''"/>
        <xsl:variable name="nodes">
            <xsl:copy-of select="document('./usfs_treesearch.xml')"/>
        </xsl:variable>
        <xsl:copy-of select="$nodes/usfs:research/usfs:stations/usfs:station/usfs:researchUnits/usfs:researchUnit[usfs:unitNumber=$unitNum]/usfs:unitName"/>
    </xsl:function>
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:unitAcronymToName</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:acronymToName(string[@key = 'station_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>function to match a three-letter acronym to a full research station name.</xd:p>            
        </xd:desc>
        <xd:param name="unitAcronym"/>
    </xd:doc>      
    <xsl:function name="local:unitAcronymToName" as="xs:string" xmlns:f="http://functions">
        <xsl:param name="unitAcronym"/>
        <xsl:if test="$unitAcronym != ''"/>
        <xsl:variable name="nodes">
            <xsl:copy-of select="document('./usfs_treesearch.xml')"/>
        </xsl:variable>
        <xsl:copy-of select="$nodes/usfs:research/usfs:stations/usfs:station/usfs:researchUnits/usfs:researchUnit[usfs:unitAcronym= $unitAcronym]/usfs:unitName"/>
    </xsl:function>
    
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:seriesToAbbrv</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:unitNumToName(string[@key = 'unit_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Convert ISO 639-2b three-letter codes into ISO 639-1 two-letter codes.</xd:p>            
        </xd:desc>
        <xd:param name="typeOfTitle"/>
    </xd:doc>
    <xsl:function name="local:seriesToAbbrv" as="xs:string" xmlns:f="http://functions">
        <xsl:param name="typeOfTitle"/>
        <xsl:if test="$typeOfTitle != ''"/>
        <xsl:value-of select="if ($nodes/usfs:research/../usfs:seriesPub/usfs:treePub[@series])  
            then ($nodes/usfs:treesearch/usfs:treesearchPublications/usfs:treePub[usfs:pubTitle = $typeOfTitle]/usfs:abbrv)    
            else ($typeOfTitle)"/>
    </xsl:function>
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:seriesToAbbrv</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:seriesToAbbrv(:unitNumToName(string[@key = 'unit_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Convert ISO 639-2b three-letter codes into ISO 639-1 two-letter codes.</xd:p>            
        </xd:desc>
        <xd:param name="pub_title"/>
    </xd:doc>      
    <xsl:function name="local:pub_type_desc" as="xs:string" xmlns:f="http://functions">
        <xsl:param name="pub_title"/>
        <xsl:if test="$pub_title != ''"/>
        <xsl:choose>
            <xsl:when test="matches($pub_title,$nodes/usfs:research/usfs:treeSeries/usfs:seriesPub[@type='series'])">
                <xsl:sequence select="$nodes/usfs:research/usfs:treeSeries/usfs:seriesPub[usfs:treePub = $pub_title]/usfs:abbrv"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$nodes/usfs:research/usfs:treeSeries/usfs:seriesPub[usfs:treePub= $pub_title]"/> 
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
