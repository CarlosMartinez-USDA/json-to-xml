<?xml version="1.0" encoding="UTF-8"?>
<!--This stylesheet contains naming functions for The United States Forest Service's research stations and publications cited and mentioned within the Treesearch database-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.loc.gov/mods/v3"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:usfs="http://usfs_treesearch"
    exclude-result-prefixes="xs xd usfs"
    version="2.0">    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> September 21, 2021</xd:p>
            <xd:p><xd:b>Author:</xd:b>Carlos Martinez</xd:p>
            <xd:p><xd:b>Edited by:</xd:b>Carlos Martinez </xd:p>  
            <xd:p><xd:b>Last Edited on:</xd:b>November 8, 2021</xd:p> 
            <xd:p><xd:b>Purpose:</xd:b>This stylesheet matches a research station's abbreviation and supplies it with the proper name.</xd:p>
            <xd:p>The purpose is to provide more meaningful search results to researchers.</xd:p>     
        </xd:desc>
    </xd:doc>    
    
    <!--Global Variables-->
    <xsl:variable name="seriesTitle" select="('Forest Insect &amp; Disease Leaflet', 'General Technical Report (GTR)',
        'General Technical Report - Proceedings', 'Information Forestry', 'Prsoceeding (Rocky Mountain Research Station Publications)',
        'Resource Bulletin (RB)', 'Research Map (RMAP)', 'Research Note (RN)', 'Research Paper (RP)', 'Resource Update (RU)')"/>
    
    <xsl:variable name="tree_nodes">
        <xsl:copy-of select="document('./usfs_treesearch.xml')"/>
    </xsl:variable>  
    
    
    
    <!--Stations-->     
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:acronymToName</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:acronymToName(string[@key = 'station_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>function to match a three-letter acronym to a full research station name.</xd:p>            
        </xd:desc>
        <xd:param name="acronym">three-letter</xd:param>
    </xd:doc>      
    <xsl:function name="usfs:acronymToName"  as="xs:string?" xmlns:usfs="http://usfs_treesearch">
        <xsl:param name="acronym"/>
        <xsl:if test="$acronym != ''"/>
        <xsl:sequence select="$tree_nodes/usfs:treesearch/usfs:researchStations/usfs:station[usfs:acronym = $acronym]/usfs:name"/>
    </xsl:function>
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>usfs:acronymToAddress</xd:p>
            <xd:p><xd:b>Usage: </xd:b>usfs:acronyToAddress(string[@key = 'station_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>The acronym identifies the research station by matching </xd:p>            
        </xd:desc>
        <xd:param name="acronym">three-letter language code to match against</xd:param>
    </xd:doc>      
    <xsl:function name="usfs:acronymToAddress" as="xs:string?" xmlns:usfs="http://usfs_treesearch">
        <xsl:param name="acronym"/>
        <xsl:if test="$acronym != ''"/>
        <xsl:sequence select="$tree_nodes/usfs:treesearch/usfs:researchStations/usfs:station[usfs:acronym = $acronym]/usfs:address"/>
    </xsl:function>
    
    <!--Research Units-->
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>usfs:unitNumberToName</xd:p>
            <xd:p><xd:b>Usage: </xd:b>usfs:unitNumberoName(string[@key = 'unit_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Convert ISO 639-2b three-letter codes into ISO 639-1 two-letter codes.</xd:p>            
        </xd:desc>
        <xd:param name="unitNumber">four-digit number code to match against</xd:param>    
    </xd:doc>      
    <xsl:function name="usfs:unitNumberToName" as="xs:string?" xmlns:usfs="http://usfs_treesearch">
        <xsl:param name="unitNumber"/>    
        <xsl:if test="$unitNumber != ''"/>
        <xsl:value-of select="$tree_nodes/usfs:treesearch/usfs:researchStations/usfs:station/usfs:researchUnits/usfs:researchUnit[usfs:unitNumber=$unitNumber]/usfs:unitName"/> 
    </xsl:function>
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>usfs:unitNumToName</xd:p>
            <xd:p><xd:b>Usage: </xd:b>usfs:unitNumToName(string[@key = 'unit_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Convert ISO 639-2b three-letter codes into ISO 639-1 two-letter codes.</xd:p>            
        </xd:desc>
        <xd:param name="unitAcronym">four-digit number code to match against</xd:param>    
    </xd:doc>      
    <xsl:function name="usfs:unitAcronymToAddress" as="xs:string?" xmlns:usfs="http://usfs_treesearch">
        <xsl:param name="unitAcronym"/>    
        <xsl:if test="$unitAcronym != ''">
            <xsl:value-of select="$tree_nodes/usfs:treesearch/usfs:researchStations/usfs:station/usfs:researchUnits/usfs:researchUnit[usfs:unitAcronym=$unitAcronym]/usfs:unitAddress"/>
        </xsl:if>
    </xsl:function>
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>usfs:unitNumToName</xd:p>
            <xd:p><xd:b>Usage: </xd:b>usfs:unitNumToName(string[@key = 'unit_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Convert ISO 639-2b three-letter codes into ISO 639-1 two-letter codes.</xd:p>            
        </xd:desc>
        <xd:param name="unitNumber">four-digit number code to match against</xd:param>    
        
    </xd:doc>      
    <xsl:function name="usfs:unitNumberToAddress" as="xs:string?" xmlns:usfs="http://usfs_treesearch">
        <xsl:param name="unitNumber"/>    
        <xsl:if test="$unitNumber != ''"/>
        <xsl:value-of select="$tree_nodes/usfs:treesearch/usfs:researchStations/usfs:station/usfs:researchUnits/usfs:researchUnit[usfs:unitNumber=$unitNumber]/usfs:unitAddress"/> 
    </xsl:function>
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:unitAcronymToName</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:acronymToName(string[@key = 'station_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>function to match a three-letter acronym to a full research station name.</xd:p>            
        </xd:desc>
        <xd:param name="unitAcronym"/>
    </xd:doc>      
    <xsl:function name="usfs:unitAcronymToName" as="xs:string?" xmlns:usfs="http://usfs_treesearch">
        <xsl:param name="unitAcronym"/>
        <xsl:if test="$unitAcronym != ''"/>
        <xsl:sequence select="$tree_nodes/usfs:treesearch/usfs:researchStations/usfs:station/usfs:researchUnits/usfs:researchUnit[usfs:unitAcronym = $unitAcronym]/usfs:unitName"/>
    </xsl:function>
    
    <!-- Series &amp; Scholarly Publications -->
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:seriesToAbbrv</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:unitNumToName(string[@key = 'unit_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Convert ISO 639-2b three-letter codes into ISO 639-1 two-letter codes.</xd:p>            
        </xd:desc>
        <xd:param name="typeOfTitle"/>
    </xd:doc>
    <xsl:function name="usfs:seriesToAbbrv" as="xs:string?" xmlns:usfs="http://usfs_treesearch">
        <xsl:param name="typeOfTitle"/>
        <xsl:if test="$typeOfTitle != ''"/>
        <xsl:sequence select="$tree_nodes/usfs:treesearch/usfs:treesearchPublications/usfs:treePub[usfs:pubTitle = $typeOfTitle]/usfs:abbrv"/>
    </xsl:function>
    
    <xd:doc scope="component">
        
        
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:seriesToAbbrv</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:seriesToAbbrv(:unitNumToName(string[@key = 'unit_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Convert ISO 639-2b three-letter codes into ISO 639-1 two-letter codes.</xd:p>            
        </xd:desc>
        <xd:param name="pub_title"/>
    </xd:doc>      
    <xsl:function name="usfs:pub_type_desc" as="xs:string" xmlns:usfs="http://usfs_treesearch">
        <xsl:param name="pub_title"/>
        <xsl:if test="$pub_title != ''"/>
        <xsl:choose>
            <xsl:when test="matches($pub_title,$tree_nodes/usfs:treesearch/usfs:treeSeries/usfs:seriesPub[@type='series'])">
                <xsl:sequence select="$tree_nodes/usfs:treesearch/usfs:treeSeries/usfs:seriesPub[usfs:treePub = $pub_title]/usfs:abbrv"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="$tree_nodes/usfs:treesearch/usfs:treeSeries/usfs:seriesPub[usfs:treePub= $pub_title]"/> 
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>