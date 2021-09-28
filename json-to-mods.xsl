<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE transform [
         <!ENTITY % htmlmathml-f PUBLIC
         "-//W3C//ENTITIES Predefined XM/EN///XML"
         "http://www.w3.org/2003/entities/2007/predefined.ent"
       >
       %predefined;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:f="http://functions" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:saxon="http://saxon.sf.net/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:usfs="http://usfsreseaerch" exclude-result-prefixes="f fn math mods saxon usfs xd xs">

    <xsl:output method="json" indent="yes" encoding="UTF-8" name="archive"/>
    <xsl:output method="xml" indent="yes" encoding="UTF-8" name="original" saxon:next-in-chain="fix_characters.xsl"/>

    <xsl:include href="commons/common.xsl"/>
    <xsl:include href="commons/functions.xsl"/>
    <xsl:include href="commons/params.xsl"/>

    <xsl:strip-space elements="*"/>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="data">
        <xsl:result-document omit-xml-declaration="yes" indent="yes" encoding="UTF-8"
            href="{$workingDir}A-{$originalFilename}_{position()}.json" format="archive">
            <xsl:copy-of select="."/>
        </xsl:result-document>
        <xsl:result-document method="xml" indent="yes" encoding="UTF-8" media-type="text/xml"
            href="{$workingDir}N-{$originalFilename}_{position()}.xml" format="original">
            <mods version="3.7">
                <xsl:apply-templates select="json-to-xml(.)"/>
            </mods>
        </xsl:result-document>
    </xsl:template>


    <xd:doc> </xd:doc>
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <!-- select a sub-node structure  -->
        <xsl:apply-templates select="./string[@key = 'title']"/>
        <xsl:apply-templates
            select="./array[@key = 'pub_authors'] | ./array[@key = 'primary_station']"/>

        <!--default values-->
        <typeOfResource>text</typeOfResource>
        <genre>article</genre>

        <!--originInfo/dateIssued-->
        <xsl:apply-templates select="./string[@key = 'modified_on']" mode="origin"/>

        <!-- Default language -->
        <language>
            <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
            <languageTerm type="text">English</languageTerm>
        </language>

        <!--abstract, subject/topic-->
        <xsl:apply-templates select="./string[@key = 'abstract']"/>
        <xsl:call-template name="keywords"/>

        <!--relatedItem-->
        <relatedItem type="host">
            <xsl:apply-templates select="./string[@key = 'pub_type_desc']"/>
            <xsl:apply-templates select="./string[@key = 'pub_publication']"/>
            <xsl:apply-templates select="./string[@key = 'issn_id']"/>
            <xsl:call-template name="part"/>
        </relatedItem>

        <!--identifiers-->
        <xsl:apply-templates select="./string[@key = 'doi']"/>
        <xsl:call-template name="usfs_identifiers"/>

        <!--extension-->
        <xsl:call-template name="extension"/>
    </xsl:template>


    <xd:doc scope="component" id="main_title">
        <xd:desc>
            <xd:p><xd:b>JSON to MODS title/titleInfo transformation</xd:b></xd:p>
            <xd:p><xd:b>output:</xd:b>A string value containing the main title of an article.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="map/string[@key = 'title']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <title>
            <titleInfo>
                <xsl:value-of select="."/>
            </titleInfo>
        </title>
    </xsl:template>

    <xd:doc scope="component" id="author-name-info">
        <xd:desc>
            <xd:p>If the contributor is a collaborator rather than an individual, format output
                accordingly. If processing the first author in the group, assign an attribute
                of</xd:p>
            <xd:p><xd:b>usage</xd:b> with a value of "primary."</xd:p>
        </xd:desc>
    </xd:doc>
    <!--   <xsl:template match="map/array[@key = 'pub_authors'] | map/string[@key = 'primary_station']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:choose>
            <xsl:when test="map/array[@key = 'pub_authors'] = ''">
                <name type="corporate">
                    <namePart>
                        <xsl:value-of select="map/string[@key = 'primary_station']"/>
                    </namePart>
                </name>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="name-info"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->

    
    <xd:doc scope="component" id="contrib">
        <xd:desc>If the contributor is a collaborator rather than an individual, format output
            accordingly. If processing the first author in the group, assign an attribute of
            <xd:b>usage</xd:b> with a value of "primary."</xd:desc>
    </xd:doc>
    <xsl:template match="map/array[@key = 'pub_authors'] | map/array[@key = 'primary_station']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
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
        <xd:param name="acronym"/>
        <xd:param name="unitNum"/>
    </xd:doc>
    <xsl:template name="name-info" xpath-default-namespace="http://www.w3.org/2005/xpath-functions"
        xmlns:usfs="http://usfsreseaerch">
        <xsl:param name="acronym" select="map[position()]/string[@key = 'station_id']"/>
        <xsl:param name="unitNum" select="map[position()]/string[@key = 'unit_id']"/>
<!--        <xsl:for-each select="map[position()]">-->
        <xsl:for-each select="map[position()]">
                 <xsl:if test="./string[@key = 'name']">
                        <namePart type="given">
                            <xsl:value-of
                        select="substring-after(normalize-space(./string[@key = 'name']), ', ')"
                    />
                        </namePart>
                        <namePart type="family">
                            <xsl:value-of
                        select="substring-before(normalize-space(./string[@key = 'name']), ', ')"
                    />
                </namePart>
                <displayName>
                    <xsl:value-of select="./string[@key = 'name']"/>
                </displayName>
            </xsl:if>
            <xsl:choose>
                <xsl:when
                    test="(./string[@key = 'station_id'] != '') and (./string[@key = 'unit_id'] != '')">
                    <affiliation>
                        <xsl:text>United States Department of Agriculture,&#xA;</xsl:text>
                        <xsl:text>Forest Service,&#xA;</xsl:text>
                        <xsl:value-of select="f:acronymToName($acronym)"/>
                        <xsl:text>&#xA;,</xsl:text>
                        <xsl:value-of select="f:unitNumToName($unitNum)"/>
                        <xsl:text>&#xA;,</xsl:text>
                        <xsl:value-of select="f:acronymToAddress($acronym)"/>
                    </affiliation>
                </xsl:when>
                <xsl:when
                    test="(./string[@key = 'station_id'] != '') and (./string[@key = 'unit_id'] = '')">
                    <affiliation>
                        <xsl:text>United States Department of Agriculture,</xsl:text>
                        <xsl:text>Forest Service,</xsl:text>
                        <xsl:value-of
                            select="f:acronymToName(./string[@key = 'station_id'])"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of
                            select="f:acronymToAddress(./string[@key = 'station_id'])"/>
                    </affiliation>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if
                        test="(././string[@key = 'station_id'] = '') and (././string[@key = 'unit_id'] = '')"
                    />
                </xsl:otherwise>
            </xsl:choose>
            <role>
                <roleTerm type="text">author</roleTerm>
            </role>
        </xsl:for-each>
    </xsl:template>
    <!--
    <xd:doc>
        <xd:desc/>
        
    </xd:doc>
    <xsl:template name="name-info" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:for-each select="map[position()]">
            <xsl:if test="./string[@key = 'name']">
                <namePart type="given">
                    <xsl:value-of
                        select="substring-after(normalize-space(./string[@key = 'name']), ', ')"/>
                </namePart>
                <namePart type="family">
                    <xsl:value-of
                        select="substring-before(normalize-space(./string[@key = 'name']), ', ')"/>
                </namePart>
                <displayName>
                    <xsl:value-of select="./string[@key = 'name']"/>
                </displayName>
            </xsl:if>
            <xsl:if test="./string[@key = 'station_id'] != ''">
                <affiliation>
                    <xsl:value-of select="f:acronymToName(string[@key = 'station_id'])"/>
                    <xsl:if test="./string[@key='unit_id']!=''">
                    <xsl:value-of select="f:unitNumToName(string[@key='unit_id'])"/>
                </xsl:if>
                </affiliation>
            </xsl:if>
            <role>
                <roleTerm type="text">author</roleTerm>
            </role>
        </xsl:for-each>
    </xsl:template>
    <!-\- Get author's ORCID -\->
    
    <!-\- <xsl:template name="acronym" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:for-each select="fn:array[@key='pub_authors']/map/string[2]">
            <xsl:value-of select="f:acronymToName(.)"/>
        </xsl:for-each>
    </xsl:template>-\->
    -->
    <xd:doc>
        <xd:desc/>

    </xd:doc>
    <xsl:template match="map/string[@key = 'primary_station']">
        <name type="corporate">
            <namePart>United States Department of Agriculture,</namePart>
            <namePart>Forest Service,</namePart>
            <namePart>
                <xsl:value-of select="f:acronymToName(.)"/>
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

    <!--<xd:doc>
        <xd:desc></xd:desc>
    </xd:doc>
    <xsl:template name="name-info" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:for-each select="map[position()]">
            <xsl:if test="./string[@key = 'name']">
                <namePart type="given">
                    <xsl:value-of
                        select="substring-after(normalize-space(./string[@key = 'name']), ', ')"/>
                </namePart>
                <namePart type="family">
                    <xsl:value-of
                        select="substring-before(normalize-space(./string[@key = 'name']), ', ')"/>
                </namePart>
                <displayName>
                    <xsl:value-of select="./string[@key = 'name']"/>
                </displayName>
            </xsl:if>
            <xsl:if test="./string[@key = 'station_id'] != ''">
                <affiliation>
                    <xsl:value-of select="f:acronymToName(string[@key = 'station_id'])"/>
                    <xsl:if test="./string[@key = 'unit_id'] != ''">
                        <xsl:value-of select="./string[@key = 'unit_id']"/>
                    </xsl:if>
                </affiliation>
            </xsl:if>
            <role>
                <roleTerm type="text">author</roleTerm>
            </role>
        </xsl:for-each>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    
     </xd:doc>
   -->


    <!-- <xsl:template name="author-name-info" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:for-each select="map[position()]">
        <name type="personal">
            <xsl:if test="position() = 1 and count(map/preceding-sibling::string[@key = 'name']) = 0">
                <xsl:attribute name="usage">primary</xsl:attribute>
            </xsl:if>
            <xsl:if test="string[@key = 'name']">
                <namePart type="given">
                    <xsl:value-of select="substring-after(normalize-space(string[@key = 'name']), ', ')"/>
                </namePart>
                <namePart type="family">
                    <xsl:value-of select="substring-before(normalize-space(string[@key = 'name']), ', ')"/>
                </namePart>
                <displayName>
                    <xsl:value-of select="string[@key = 'name']"/>
                </displayName>
            </xsl:if>
            <!-\-affiliaton-\->
<!-\-            <xsl:choose>-\->
<!-\-                <xsl:when test="(string[@key = 'station_id'] != ' ') and (string[@key = 'unit_id'] != ' ')">-\->
                <affiliation>  
                <xsl:value-of select="f:acronymToAddress((string[@key = 'station_id']))"/>
                </affiliation>
                <!-\-</xsl:when>-\->  
<!-\-                <xsl:when test="(string[@key = 'station_id'] != '') and (string[@key = 'unit_id'] = '')">-\->
                    <affiliation>
                        <xsl:value-of select="f:unitNumToName((string[@key = 'unit_id']))"/>
                    </affiliation>
                <!-\-</xsl:when>-\->
<!-\-                <xsl:otherwise>-\->
            <affiliation> 
                    <xsl:if test="(string[@key = 'station_id'] = '') and (string[@key = 'unit_id'] = '')"/>
            </affiliation>
                <!-\-</xsl:otherwise>-\->
            
            <!-\-</xsl:choose>-\->
            <role>
                <roleTerm type="text">author</roleTerm>
            </role>
        </name>
        </xsl:for-each>


    </xsl:template>-->



    <!-- Get author's ORCID -->

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="map/string[@key = 'primary_station']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <name type="corporate">
            <namePart>United States</namePart>
            <namePart>Forest Service</namePart>
            <namePart>
                <xsl:value-of select="f:acronymToName(.)"/>
            </namePart>
        </name>
    </xsl:template>

    <xd:doc>
        <xd:desc>Transforms, in order of preference, the publication-related date metadata</xd:desc>
    </xd:doc>
    <xsl:template name="dateIssued" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:choose>
            <xsl:when test="map/string[@key = 'modified_on']">
                <xsl:apply-templates select="map/string[@key = 'modified_on']"/>
            </xsl:when>
            <xsl:when test="map/string[@key = 'created_on']">
                <xsl:apply-templates select="map/string[@key = 'created_on']"/>
            </xsl:when>
            <xsl:otherwise>
                <originInfo>
                    <dateIssued encoding="w3cdtf" keyDate="yes">
                        <xsl:value-of select="map/string[@key = 'product_year']"/>
                    </dateIssued>
                </originInfo>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="input"/>
    </xd:doc>
    <xsl:template match="map/string[@key = 'created_on']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" mode="origin">
        <xsl:param name="input" select="."/>
        <originInfo>
            <dateIssued encoding="w3cdtf" keyDate="yes">
                <!-- Define array of months -->
                <xsl:variable name="months"
                    select="('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC')"/>
                <!-- Define regex to match input date format -->
                <xsl:analyze-string regex="^([0-9]{{1,2}})\-([A-Z]{{3}})\-([0-9]{{4}})(.*)$"
                    select="$input">
                    <xsl:matching-substring>
                        <xsl:number value="regex-group(3)" format="0001"/>
                        <xsl:text>-</xsl:text>
                        <xsl:number value="index-of($months, regex-group(2))" format="01"/>
                        <xsl:text>-</xsl:text>
                        <xsl:number value="regex-group(1)" format="01"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </dateIssued>
        </originInfo>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="input"/>
    </xd:doc>
    <xsl:template match="map/string[@key = 'modified_on']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" mode="origin">
        <xsl:param name="input" select="."/>
        <originInfo>
            <dateIssued encoding="w3cdtf" keyDate="yes">
                <!-- Define array of months -->
                <xsl:variable name="months"
                    select="('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC')"/>
                <!-- Define regex to match input date format -->
                <xsl:analyze-string regex="^([0-9]{{1,2}})\-([A-Z]{{3}})\-([0-9]{{4}})(.*)$"
                    select="$input">
                    <xsl:matching-substring>
                        <xsl:number value="regex-group(3)" format="0001"/>
                        <xsl:text>-</xsl:text>
                        <xsl:number value="index-of($months, regex-group(2))" format="01"/>
                        <xsl:text>-</xsl:text>
                        <xsl:number value="regex-group(1)" format="01"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </dateIssued>
        </originInfo>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="map/string[@key = 'abstract']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <abstract>
            <xsl:value-of select="normalize-space(.)"/>
        </abstract>
    </xsl:template>


    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="keywords" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:choose>
            <xsl:when test="./array[@key = 'national_research_taxonomy_elements']">
                <xsl:apply-templates select="./array[@key = 'national_research_taxonomy_elements']"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="./string[@key = 'keywords']"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>The national research taxonomy elements are the preferred controlled vocabulary
            chosen for inclusion in subject/topic MODS metadata. </xd:desc>
    </xd:doc>
    <xsl:template match="map/array[@key = 'national_research_taxonomy_elements']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:for-each select="map[position()]">
            <xsl:if test="./string[@key = 'nrt_title']">
                <subject>
                    <topic>
                        <xsl:value-of select="./string[@key = 'nrt_title']"/>
                    </topic>
                </subject>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    <xd:doc>
        <xd:desc>When the array for national research taxonomy elements is not present, the keywords
            listed are used for the subject/topic</xd:desc>
    </xd:doc>
    <xsl:template match="map/string[@key = 'keywords']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:for-each select="tokenize(., ',\s+')">
            <subject>
                <topic>
                    <xsl:value-of select="subsequence(tokenize(., ',\s+'), 1, last())"/>
                </topic>
            </subject>
        </xsl:for-each>
    </xsl:template>
    <!--add host and conditonal here-->
    <xd:doc>
        <xd:desc>Journal Title</xd:desc>
    </xd:doc>
    <xsl:template match="map/string[@key = 'pub_type_desc']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:variable name="primary_station" select="map/array[@key = 'primary_station']"/>
        <title>
            <titleInfo type="series">
                <xsl:value-of select="."/>
                <xsl:value-of select="$primary_station"/>
            </titleInfo>
        </title>
    </xsl:template>

   
    <xd:doc>
        <xd:desc/>

        <xd:param name="publication"/>
    </xd:doc>
    <xsl:template match="map/string[@key = 'pub_publication']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="publication" as="xs:string" select="."/>
        <xsl:analyze-string select="map/string[@key = 'pub_publication']"
            regex="('Forest Insect &amp; Disease Leaflet')|('General Technical Report')|('General Technical Report - Proceedings')|('Information Forestry')|('Proceeding \(Rocky Mountain Research Station Publications\)')|('Resource Bulletin')|('Research Map')|('Research Note')|('Research Paper') | ('Miscellaneous Publication')">

            <xsl:matching-substring>
                <titleInfo>
                    <xsl:choose>
                        <xsl:when test="regex-group(1)">

                            <title>
                                <xsl:attribute name="type">abbreviated</xsl:attribute>
                                <xsl:value-of select="'FIDL'"/>
                            </title>

                        </xsl:when>
                        <xsl:when test="regex-group(2)">

                            <title>
                                <xsl:attribute name="type">abbreviated</xsl:attribute>
                                <xsl:value-of select="'Gen. Tech. Rep.'"/>
                            </title>
                        </xsl:when>
                        <xsl:when test="regex-group(3)">

                            <title>
                                <xsl:attribute name="type">abbreviated</xsl:attribute>
                                <xsl:value-of select="'Gen. Tech. Rep. - Proceedings'"/>
                            </title>
                        </xsl:when>
                        <xsl:when test="regex-group(4)">
                            <title>
                                <xsl:attribute name="type">abbreviated</xsl:attribute>
                                <xsl:value-of select="'Info. Forestry'"/>
                            </title>
                        </xsl:when>
                        <xsl:when test="regex-group(5)">
                            <title>
                                <xsl:attribute name="type">abbreviated</xsl:attribute>
                                <xsl:value-of select="'Proceeding (RMRS)'"/>
                            </title>
                        </xsl:when>
                        <xsl:when test="regex-group(6)">
                            <title>
                                <xsl:attribute name="type">abbreviated</xsl:attribute>
                                <xsl:value-of select="'Res. Bull.'"/>
                            </title>
                        </xsl:when>
                        <xsl:when test="regex-group(7)">
                            <title>
                                <xsl:attribute name="type">abbreviated</xsl:attribute>
                                <xsl:value-of select="'Res. Map'"/>
                            </title>
                        </xsl:when>
                        <xsl:when test="regex-group(8)">
                            <title>
                                <xsl:attribute name="type">abbreviated</xsl:attribute>
                                <xsl:value-of select="'Res. Note'"/>
                            </title>
                        </xsl:when>
                        <xsl:when test="regex-group(9)">
                            <title>
                                <xsl:attribute name="type">abbreviated</xsl:attribute>
                                <xsl:value-of select="'Res. Paper'"/>
                            </title>

                        </xsl:when>
                        <xsl:when test="regex-group(11)">
                            <title>
                                <xsl:attribute name="type">abbreviated</xsl:attribute>
                                <xsl:value-of select="'Misc. Pub.'"/>
                            </title>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </titleInfo>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <title>
                    <titleInfo>
                        <xsl:attribute name="type">alternative</xsl:attribute>
                        <xsl:value-of select="."/>
                    </titleInfo>
                </title>
            </xsl:non-matching-substring>

        </xsl:analyze-string>
        <xsl:choose>
            <xsl:when test="contains(., $publication)">
                <title>
                    <titleInfo>
                        <xsl:attribute name="type">alternative</xsl:attribute>
                        <xsl:value-of select="substring-before(., $publication)"/>
                    </titleInfo>
                </title>
            </xsl:when>
            <xsl:otherwise>
                <title>
                    <titleInfo>
                        <xsl:attribute name="type">alternative</xsl:attribute>
                        <xsl:value-of select="."/>
                    </titleInfo>
                </title>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

   
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="map/string[@key = 'issn_id']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <identifier type="issn-e">
            <xsl:value-of select="."/>
        </identifier>
        <identifier type="issn">
            <xsl:value-of select="."/>
        </identifier>
    </xsl:template>


    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="part" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <part>
            <xsl:if test="(/fn:map/fn:string[@key = 'pub_volume'] != ' ')">
                <detail type="volume">
                    <number>
                        <xsl:value-of select="/fn:map/fn:string[@key = 'pub_volume']"/>
                    </number>
                    <caption>v.</caption>
                </detail>
            </xsl:if>

            <xsl:if test="(/fn:map/fn:string[@key = 'pub_issue'] != ' ')">
                <detail type="issue">
                    <number>
                        <xsl:value-of select="/fn:map/fn:string[@key = 'pub_issue']"/>
                    </number>
                    <caption>no.</caption>
                </detail>
            </xsl:if>

            <xsl:if test="(/fn:map/fn:string[@key = 'modified_on'] != ' ')">
                <xsl:apply-templates select="/fn:map/fn:string[@key = 'modified_on']" mode="part"/>
            </xsl:if>
            <extent unit="pages">
                <xsl:sequence>
                <xsl:call-template name="pages">
                    <xsl:with-param name="start_page"/>
                </xsl:call-template>
                <xsl:call-template name="pages">
                    <xsl:with-param name="end_page"/>
                </xsl:call-template>
                <xsl:call-template name="pages">
                    <xsl:with-param name="total_pages"/>
                </xsl:call-template>
                </xsl:sequence>
            </extent>
        </part>

    </xsl:template>


    <xd:doc>
        <xd:desc/>
        <xd:param name="start_page"/>
        <xd:param name="end_page"/>
        <xd:param name="total_pages"/>
    </xd:doc>
    <xsl:template name="pages" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="start_page" select="/fn:map/fn:string[@key = 'pub_page_start']"/>
        <xsl:param name="end_page" select="/fn:map/fn:string[@key = 'pub_page_end']"/>
        <xsl:param name="total_pages" select="f:calculateTotalPgs($start_page, $end_page)"/>
      
            <start>
                <xsl:value-of select="$start_page"/>
            </start>
            <end>
                <xsl:value-of select="$end_page"/>
            </end>
            <total>
                <xsl:value-of select="$total_pages"/>
            </total>
        
    </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="input"/>
    </xd:doc>
    <xsl:template match="map/string[@key = 'modified_on']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" mode="part">
        <xsl:param name="input" select="."/>
        <!-- Define array of months -->
        <xsl:variable name="months"
            select="('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC')"/>
        <!-- Define regex to match input date format -->
        <xsl:analyze-string regex="^([0-9]{{1,2}})\-([A-Z]{{3}})\-([0-9]{{4}})(.*)$" select="$input">
            <xsl:matching-substring>
                <text type="year">
                    <xsl:number value="regex-group(3)" format="0001"/>
                </text>
                <xsl:text>&#13;</xsl:text>
                <text type="month">
                    <xsl:number value="index-of($months, regex-group(2))" format="01"/>
                </text>
                <xsl:text>&#13;</xsl:text>
                <text type="day">
                    <xsl:number value="regex-group(1)" format="01"/>
                </text>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="usfs_identifiers"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <identifier>
            <xsl:choose>
                <xsl:when test="map/string[@key = 'url_binary_file']">
                    <xsl:attribute name="type">
                        <xsl:value-of select="@key"/>
                    </xsl:attribute>
                    <xsl:value-of
                        select="translate(upper-case(substring-before(tokenize(., '/')[last()], '.')), '_', ' ')"/>
                    <location>
                        <url>
                            <xsl:attribute name="access" select="translate(@key, '_', ' ')"/>
                            <xsl:value-of
                                select="normalize-space(string[@key = ('url_binary-file')])"/>
                        </url>
                    </location>
                </xsl:when>
                <xsl:when test="map/string[@key = 'url_landing_page']">
                    <identifier> </identifier>
                    <location>
                        <url>
                            <xsl:attribute name="access" select="translate(@key, '_', ' ')"/>
                            <xsl:value-of
                                select="normalize-space(string[@key = ('url_landing_page')])"/>
                        </url>
                    </location>
                </xsl:when>
            </xsl:choose>
        </identifier>
    </xsl:template>



    <xd:doc>
        <xd:desc> &lt;xsl:otherwise&gt; &lt;!-\- &lt;xsl:when test="local-name() =
            'ELocationID'"&gt;-\-&gt; &lt;xsl:attribute name="type"&gt; &lt;xsl:value-of
            select="@EIdType"/&gt; &lt;/xsl:attribute&gt; &lt;!-\-&lt;/xsl:when&gt;-\-&gt;
            &lt;/xsl:otherwise&gt; &lt;/xsl:choose&gt; &lt;xsl:value-of select="."/&gt;
            &lt;/identifier&gt;</xd:desc>
    </xd:doc>
    <xsl:template match="map/string[@key = 'doi']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:if test="@key = 'doi'">
            <identifier type="doi">
                <xsl:value-of select="."/>
            </identifier>
            <location>
                <url>
                    <xsl:text>http://dx.doi.org/</xsl:text>
                    <xsl:value-of select="normalize-space(.)"/>
                </url>
            </location>
        </xsl:if>
        <xsl:value-of select="."/>
    </xsl:template>

    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>vendorName</xd:b>Metadata supplier name (e.g., Brill, Springer,
                Elsevier)</xd:p>
            <xd:p><xd:b>filename_ext</xd:b>Filename from source metadata (eg. filename.xml,
                filename.json or filename.zip)</xd:p>
            <xd:p><xd:b>filename</xd:b>filename w/o the extension (i.e., xml, json or zip)</xd:p>
            <xd:p><xd:b>workingDirectory</xd:b>Directory the source file is transformed</xd:p>
            <xd:p><xd:b>filePath</xd:b>The full file path of the source file to assist with
                debugging</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="extension" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <extension>
            <vendorName>
                <xsl:value-of select="$vendorName"/>
            </vendorName>
            <archiveFile>
                <xsl:value-of select="$archiveFile"/>
            </archiveFile>
            <originalFile>
                <xsl:value-of select="$originalFilename"/>
            </originalFile>
            <workingDirectory>
                <xsl:value-of select="$workingDir"/>
            </workingDirectory>
        </extension>
    </xsl:template>


    <!-- <identifier type="issn-p">0005-7959</identifier>
        <identifier type="vendor">BEH</identifier>
        <part>
            <detail type="volume">
                <number>158</number>
                <caption>v.</caption>
            </detail>
            <detail type="issue">
                <number>11</number>
                <caption>no.</caption>
            </detail>
            <text type="year">2021</text>
            <text type="month">06</text>
            <text type="day">16</text>
            <extent unit="pages">
                <start>945</start>
                <end>969</end>
                <total>25</total>
            </extent>
        </part>-->

</xsl:stylesheet>
