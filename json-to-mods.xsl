<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE transform [
          <!ENTITY % predefined PUBLIC
         "-//W3C//ENTITIES Predefined XML//EN///XML"
         "https://www.w3.org/2003/entities/2007/predefined.ent"
       >
       %predefined;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:f="http://functions" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:local="http://local_functions" xmlns:saxon="http://saxon.sf.net/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:usfs="http://usfsreseaerch" 
    exclude-result-prefixes="f fn math mods saxon local usfs xd xs xsi">
 
    <xsl:output method="json" indent="yes" encoding="UTF-8" name="archive"/>
    <xsl:output method="xml" indent="yes" encoding="UTF-8" name="original" saxon:next-in-chain="fix_characters.xsl"/>
    
    <xsl:include href="commons/common.xsl"/>
    <xsl:include href="coamons/usfs_naming_functions.xsl"/>
    <xsl:include href="commons/params-cm.xsl"/>

    <xsl:strip-space elements="*"/>
 
   <!--Root template for local testing-->
    <xd:doc>
        <xd:ddsesc>
            <xd:p><xd:b>Root template for local testing</xd:b></xd:p>
            <xd:ul>
                <xd:p>This stylesheet may be run without presetting any parameters.</xd:p>
                <xd:li>
                    <xd:p><xd:b>Step 1:</xd:b>Choose the JSON file you wish to transform.</xd:p>
                </xd:li>
                <xd:li>
                    <xd:p><xd:b>Step 2:</xd:b> Apply the transformation scenario or select a
                        debugging button to begin.</xd:p>
                </xd:li>                                
                <xd:li>
                    <xd:p><xd:b>Step 3:</xd:b>Comment out this template or remove entirely before
                        putting into production.</xd:p>
                </xd:li>
            </xd:ul>
        </xd:ddsesc>
    </xd:doc>
     <xsl:template match="data">
        <xsl:result-document method="json" omit-xml-declaration="yes"
            href="{$working_dir}{$original_filename}_{position()}.json" format="archive">
            <xsl:copy>
                <data>
                <xsl:value-of select="."/>
                </data>
            </xsl:copy>
        </xsl:result-document>
        <xsl:result-document method="xml" indent="yes" encoding="UTF-8" media-type="text/xml"
            href="{$working_dir}N-{$original_filename}_{position()}.xml" format="original">
            <mods version="3.7">
                <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
                <xsl:attribute name="xsi:schemaLocation">http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd</xsl:attribute>
                <xsl:apply-templates select="json-to-xml(.)"/>
            </mods>
        </xsl:result-document>
  </xsl:template>

     <xd:doc>
        <xd:desc>
            <xd:p><xd:b>For Development and Production</xd:b>uncommment this template when testing on the server or putting into production</xd:p>            
        </xd:desc>
    </xd:doc>
<!--    <xsl:template match="data">
        <xsl:result-document omit-xml-declaration="yes" indent="yes" encoding="UTF-8"
            href="file:///{$workingDir}{replace($originalFilename, '(.*/)(.*)(\.json)','$2')}_{position()}.json" format="archive">
            <xsl:copy-of select="."/>
        </xsl:result-document>
        <xsl:result-document method="xml" indent="yes" encoding="UTF-8" media-type="text/xml"
            href="file:///{$workingDir}N-{replace($originalFilename, '(.*/)(.*)(\.json)','$2')}_{position()}.xml">
        <mods version="3.7">
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
            <xsl:attribute name="xsi:schemaLocation">http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd</xsl:attribute>
                <xsl:apply-templates select="json-to-xml(.)"/>
            </mods>
        </xsl:result-document>
    </xsl:template>-->




    


    <xd:doc>
        <xd:desc>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <!-- titleInfo/title and author tags  -->
        <xsl:apply-templates select="./string[@key = 'title']"/>
        <xsl:apply-templates select="./array[@key = 'pub_authors'] | ./array[@key = 'primary_station']"/>

        <!--default values-->
        <typeOfResource>text</typeOfResource>
        <genre>article</genre>

        <!--originInfo/dateIssued-->
        <xsl:apply-templates select="./string[@key = 'modified_on']" mode="origin"/>

        <!-- note-->
        <xsl:apply-templates select="./string[@key = 'status_name']"/>

        <!-- Default language -->
        <language>
            <languageTerm type="code" authority="iso639-2b">eng</languageTerm>
            <languageTerm type="text">English</languageTerm>
        </language>


        <!--abstract-->
        <xsl:apply-templates select="./string[@key = 'abstract']"/>
        
        <!--subject/topic-->
        <xsl:call-template name="keywords"/>

        <!--relatedItem-->
        <xsl:call-template name="relatedItem"/>
        
        <!--identifiers-->              
        <xsl:call-template name="identifiers"/>
        
        <!--extension-->
        <xsl:call-template name="extension"/>
        
    </xsl:template>



    <xd:doc scope="component" id="main_title">
        <xd:desc>
            <xd:p>
                <xd:b>JSON to MODS title/titleInfo transformation</xd:b>
            </xd:p>
            <xd:p><xd:b>output:</xd:b>A string value containing the main title of an article.</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="map/string[@key = 'title']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <titleInfo>
            <title>
                <xsl:value-of select="."/>
            </title>
        </titleInfo>
    </xsl:template>

    <xd:doc scope="component" id="name-info">
        <xd:desc>
            <xd:p>If the contributor is a collaborator rather than an individual, format output
                accordingly. If processing the first author in the group, assign an attribute
                of</xd:p>
            <xd:p><xd:b>usage</xd:b> with a value of "primary."</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="map/array[@key = 'pub_authors'] | map/array[@key = 'primary_station']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:choose>
            <xsl:when test="map/string[@key = 'primary_station']">
                <name type="corporate">
                    <namePart>
                        <xsl:text>United States Department of Agriculture, Forest Service, </xsl:text>
                        <xsl:value-of select="local:acronymToName(.)"/>
                        <xsl:value-of select="local:acronymToAddress(.)"/>
                    </namePart>
                </name>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="map[position()]">
                <name type="personal">
                    <xsl:if test="position() = 1 and count(map/preceding-sibling::string[@key = 'name']) = 0">
                        <xsl:attribute name="usage">primary</xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="name-info"/>
                </name>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc>Match primary_station aconym, and uses two extermal stylesheets to provide a whole name as the corporate body</xd:desc>
    </xd:doc>
    <xsl:template name="corporate" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <name type="corporate">
            <namePart>
                <xsl:text>United States Department of Agriculture, Forest Service, </xsl:text>
                <xsl:value-of select="local:acronymToName(map/string[@key = 'primary_station'])"/>                
            </namePart>
        </name>
    </xsl:template>

    <xd:doc>
        <xd:desc>
            <xd:p>An author's given and family name are parsed from the JSON map/array/map/string[@key='name'] string key value</xd:p>
            <xd:p>displayName matches on the 'name' string key value.</xd:p>
            <xd:p>affiliation uses two external stylesheets to match abbreviated station and unit
                numbers and names with their respective whole name and address</xd:p>
            <xd:p>roleTerm is hardcoded to "author"</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template name="name-info" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <!--author given and family names-->
            <xsl:if test="./string[@key = 'name']">
                <namePart type="given">
                    <xsl:value-of
                        select="substring-after(normalize-space(./string[@key = 'name']), ', ')"/>
                </namePart>
                <namePart type="family">
                    <xsl:value-of
                        select="substring-before(normalize-space(./string[@key = 'name']), ', ')"/>
                </namePart>
                <displayForm>
                    <xsl:value-of select="./string[@key = 'name']"/>
                </displayForm>
            </xsl:if>
        <!--    <!-\-affiliation-\->
            <xsl:if test="./string[@key = 'station_id'] != ''">
                <affiliation>
                    <xsl:text>United States Department of Agriculture, </xsl:text>
                    <xsl:text>Forest Service, </xsl:text>
                    <xsl:value-of select="local:acronymToName(./string[@key = 'station_id'])"/>
                   <xsl:text>, </xsl:text>
                    <xsl:choose>
                    <xsl:when test="./string[@key='unit_id']!=''">
                        <xsl:value-of select="local:unitNumberToName(./string[@key = 'unit_id'])"/>
                        <xsl:text>, </xsl:text>                        
                    </xsl:when>
                        <xsl:otherwise>
                    <!-\-<xsl:when test="./string[@key='unit_id']!=''">-\->
                        <xsl:value-of select="local:unitAcronymToName(./string[@key = 'unit_id'])"/>
                        <xsl:text>, </xsl:text>
                        </xsl:otherwise>
                    <!-\-</xsl:when>-\->
                    </xsl:choose>
                    
                    <xsl:value-of select="local:acronymToAddress(./string[@key = 'station_id'])"/>
                 </affiliation>
            </xsl:if>-->
        <!--affiliation-->
        <xsl:if test="./string[@key = 'station_id'] != ''">
            <affiliation>
                <xsl:text>United States Department of Agriculture, Forest Service, </xsl:text>
                <xsl:value-of select="local:acronymToName(./string[@key = 'station_id'])"/>
                <xsl:text>, </xsl:text>
                <xsl:choose>
                    <xsl:when test="number(./string[@key = 'unit_id']) > 0">
                        <xsl:value-of select="local:unitNumberToName(./string[@key = 'unit_id'])"/>
                        <xsl:text>, </xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="string(./string[@key = 'unit_id'] !='')">
                            <xsl:value-of select="local:unitAcronymToName(./string[@key = 'unit_id'])"/>
                            <xsl:text>, </xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                    
                </xsl:choose>
                                    <xsl:choose>
                <xsl:when test="number(./string[@key = 'unit_id']) > 0">
                            <xsl:value-of select="local:unitNumberToAddress(./string[@key = 'unit_id'])"/>
                        </xsl:when>
                       <xsl:otherwise>
                <xsl:value-of select="local:acronymToAddress(./string[@key = 'station_id'])"/>
                </xsl:otherwise>
                </xsl:choose>
            </affiliation>
        </xsl:if>
            <role>
                <roleTerm type="text">author</roleTerm>
            </role>
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
    <xsl:template match="map/string[@key = 'modified_on'] | map/string[@key = 'created_on']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" mode="origin">
        <xsl:param name="input" select="."/>
        <originInfo>
            <dateIssued encoding="w3cdtf" keyDate="yes">
                <!-- Define array of months -->
                <xsl:variable name="months"
                    select="('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC')"/>
                <!-- Define regex to match input date format -->
                <xsl:analyze-string select="$input"
                    regex="^([0-9]{{1,2}})\-([A-Z]{{3}})\-([0-9]{{4}})(.*)$">
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
        <xd:desc>
            <xd:p>note type="treesearch-status"</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="map/string[@key = 'status_name']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <note type="treesearch-status">
            <xsl:value-of select="."/>
        </note>
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



    <xd:doc>
        <xd:desc/>
        <xd:param name="p_series"/>
    </xd:doc>
    <xsl:template name="relatedItem"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="p_series">
            <xsl:value-of select="('Forest Insect &amp; Disease Leaflet',
                'General Technical Report (GTR)',
                'General Technical Report - Proceedings',
                'Information Forestry',
                'Proceeding (Rocky Mountain Research Station Publications)',
                'Resource Bulletin (RB)',
                'Research Map (RMAP)',
                'Research Note (RN)',
                'Research Paper (RP)',
                'Resource Update (RU)')"/>
        </xsl:param>
        <xsl:variable name="pub_desc_type" select="./string[@key = 'pub_type_desc']"/>
        <xsl:variable name="pub_publication" select="./string[@key = 'pub_publication']"/>
        <xsl:variable name="citation" select="./string[@key = 'citation']"/>
        <xsl:choose>
            <xsl:when test="contains($p_series, $pub_desc_type)">
                <relatedItem type="series">
                    <titleInfo>
                        <title>
                            <xsl:value-of select="$pub_desc_type"/>
                        </title>
                    </titleInfo>
                    <xsl:call-template name="part"/>
                </relatedItem>
            </xsl:when>
            <xsl:otherwise>
                <relatedItem type="host">
                    <titleInfo>
                        <title>
                            <xsl:value-of select="substring-before($pub_publication, '.')"/>
                        </title>
                    </titleInfo>
                    <xsl:call-template name="part"/>
                </relatedItem>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>Publication info as a string to be parsed</xd:p>
            <xd:p>Journal host info: base doi, origin, agency, sub-agency, research station,
                research unit, page numbers</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="map/string[@key = 'pub_publication']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <relatedItem type="host">
            <titleInfo>
                <title>
                    <xsl:value-of select="map/string[@key = 'pub_publication']"/>
                </title>
            </titleInfo>
        </relatedItem>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>Publication info as a string to be parsed</xd:p>
            <xd:p>Journal host info: base doi, origin, agency, sub-agency, research station,
                research unit, page numbers</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="map/string[@key = 'pub_type_desc']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <relatedItem type="host">
            <titleInfo>
                <title>
                    <xsl:value-of select="local:seriesToAbbrv(.)"/>
                </title>
            </titleInfo>
        </relatedItem>
    </xsl:template>


    <xd:doc>
        <xd:desc>issn</xd:desc>
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
            <!--volume-->
            <xsl:if test="(./string[@key = 'pub_volume'] != ' ')">
                <detail type="volume">
                    <number>
                        <xsl:value-of select="./string[@key = 'pub_volume']"/>
                    </number>
                    <caption>v.</caption>
                </detail>
            </xsl:if>
            <!--issue-->
            <xsl:if test="(./string[@key = 'pub_issue'] != ' ')">
                <detail type="issue">
                    <number>
                        <xsl:value-of select="./string[@key = 'pub_issue']"/>
                    </number>
                    <caption>no.</caption>
                </detail>
            </xsl:if>
            <!--extent/pages-->
            <xsl:if test="(./string[@key = 'modified_on'] != ' ')">
                <xsl:apply-templates select="./string[@key = 'modified_on']" mode="part"/>
            </xsl:if>
          <xsl:call-template name="pages"/>           
        </part>

    </xsl:template>


    <xd:doc>
        <xd:desc>
            <xd:p>Matches "pub_page_start" and "pub_page_end" stiing key values</xd:p>
            <xd:p>If not, looks for a hyphenated value within the "pub_page" field, and performs the math</xd:p>
            <xd:p>When none of these fields used, no page numbers appear within the output</xd:p>
            <xd:p>Below a commmented out template runs through six conditions in an attempt to capture fields</xd:p>
            <xd:p>If all page numbers are desired, the citation field or th e</xd:p>
        </xd:desc>
        <xd:param name="start_page"/>
        <xd:param name="end_page"/>
    </xd:doc>
    <xsl:template name="pages" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
    <xsl:param name="start_page" select="/fn:map/fn:string[@key = 'pub_page_start']"/>
    <xsl:param name="end_page" select="/fn:map/fn:string[@key = 'pub_page_end']"/>
      
        <xsl:choose>
        <xsl:when test="$start_page and $end_page">
    <xsl:sequence>
        <extent unit="pages">
        <start>
            <xsl:value-of select="$start_page"/>
        </start>
        <end>
            <xsl:value-of select="$end_page"/>
        </end>
        <total>
            <xsl:value-of select="f:calculateTotalPgs($start_page, $end_page)"/>
        </total>
        </extent>
    </xsl:sequence>          
        </xsl:when>            
            <xsl:when test="contains(/map/string[@key = 'pub_page'], '-')">
                <extent unit="pages">
                <xsl:analyze-string select="/map/string[@key = 'pub_page']" regex="(\d+)(\-)(\d+)">
                    <xsl:matching-substring>
                        <start>
                        <xsl:number value="regex-group(1)"/>
                        </start>
                        <end>
                        <xsl:number value="regex-group(3)"/>
                        </end>
                        <total>
                        <xsl:value-of select="f:calculateTotalPgs(regex-group(1),regex-group(3))"/>
                        </total>   
                    </xsl:matching-substring>                       
                    <xsl:non-matching-substring>]                       
                    </xsl:non-matching-substring>                  
                </xsl:analyze-string>
                </extent>
            </xsl:when>
        </xsl:choose>
        
</xsl:template>
    
   <!-- 
       Metadata withing Treesearch rarely uses the page numbering fields:
       "pub_page_start, pub_page_end, or pub_page". 
       If further development for this XSLT is allowed the following template is where to start-->
   <xd:doc>
        <xd:desc/>
        <xd:param name="start_page"/>
        <xd:param name="end_page"/>
        <xd:param name="total_pages"/>
        <xd:param name="pub_publication"/>
        <xd:param name="Pages"/>
        <xd:param name="pages"/>
    </xd:doc>
    <xsl:template name="pages" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="start_page" select="/fn:map/fn:string[@key = 'pub_page_start']"/>
        <xsl:param name="end_page" select="/fn:map/fn:string[@key = 'pub_page_end']"/>
        <xsl:param name="total_pages" select="f:calculateTotalPgs($start_page, $end_page)"/>
        <xsl:param name="pub_publication" select="/fn:map/fn:string[@key = 'pub_publication']"/>
        <xsl:param name="pages" as="xs:string"
           select="tokenize($pub_publication, '[\d{{2}.]')[last()]"/>
        <xsl:param name="Pages"
            select="substring-before(substring-after(./string[@key = 'pub_publication'], '\:'), '\.&#x22;,')"/>
        <xsl:choose>
            <xsl:when test="$start_page and $end_page">
                <xsl:text>test 1</xsl:text>
                <xsl:sequence>
                    <start>
                        <xsl:value-of select="$start_page"/>
                    </start>
                    <end>
                        <xsl:value-of select="$end_page"/>
                    </end>
                    <total>
                        <xsl:value-of select="$total_pages"/>
                    </total>
                </xsl:sequence>
            </xsl:when>
            <xsl:when test="string[@key = 'pub_page'] except *[($start_page) or ($end_page)]">
                <xsl:text>test 2 </xsl:text>
                <xsl:if test="contains(string[@key = 'pub_page'], '-')">
                    <start>
                        <xsl:value-of select="substring-before(string[@key = 'pub_page'], '-')"/>
                    </start>
                    <end>
                        <xsl:value-of select="substring-after(string[@key = 'pub_page'], '-')"/>
                    </end>
                    <xsl:if test="contains(string[@key = 'pub_page'], 's')"/>
                    <xsl:variable name="translated_total"
                        select="translate(string[@key = 'pub_page'], '[s]', '')"/>
                    <total>
                        <xsl:value-of
                            select="f:calculateTotalPgs(substring-before($translated_total, '-'), substring-after($translated_total, '-'))"
                        />
                    </total>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$start_page and $end_page">
                <xsl:text>test 3</xsl:text>
                <xsl:sequence>
                    <start>
                        <xsl:value-of select="$start_page"/>
                    </start>
                    <end>
                        <xsl:value-of select="$end_page"/>
                    </end>
                    <total>
                        <xsl:value-of select="f:calculateTotalPgs($start_page, $end_page)"/>
                    </total>
                </xsl:sequence>
            </xsl:when>
           <xsl:when test="contains($Pages, text())">
                <xsl:text>test 4</xsl:text>
                <start>
                    <xsl:value-of select="replace(., '.*[^.\d](\d*\.?\d+)$', '$1')"/>
                </start>
                <end>
                    <xsl:value-of select="replace(., '.*[^.\d](\d*\.?\d+)$', '$1')"/>
                </end>
                <total>
                    
                </total>
            </xsl:when>
            <xsl:when test="$pages">
           <xsl:text>test 5a</xsl:text>
                <xsl:analyze-string select="$pages"
                    regex="(\d{{1,4}})(\s\w{{1,4}})|(\S{{1,4}})\-\S{{1,4}}">
                    <xsl:matching-substring>
                        <xsl:if test="contains(string(), '-')">
                            <start>
                                <xsl:value-of select="substring-before($pages, '-')"/>
                            </start>
                            <end>
                                <xsl:value-of select="substring-after($pages, '-')"/>
                            </end>
                            <total>
                                <xsl:value-of
                                    select="f:calculateTotalPgs(substring-before($pages, '-'), substring-after($pages, '-'))"
                                />
                            </total>
                        </xsl:if>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:text>test 5b</xsl:text>
                        <start>
                            <xsl:value-of
                                select="substring-after(substring-before($pub_publication, '.'[last()]), '\d{{2}}')"
                            />
                        </start>
                        <end>
                            <xsl:value-of select="substring-after($pub_publication, '.'[last()])"/>
                        </end>
                        <total>
                            <xsl:value-of
                                select="f:calculateTotalPgs(substring-before($pub_publication, '-'[last()]), substring-after($pub_publication, '-'[last()]))"
                            />
                        </total>

                        <xsl:text>test4b</xsl:text>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:text>test 6 </xsl:text>
            <xsl:when test="$pages">
                <xsl:for-each select="$pages">
                    <start>
                        <xsl:value-of select="substring-before($pub_publication, '-'[last()])"/>
                    </start>
                    <end>
                        <xsl:copy-of select="substring-after($pub_publication, '-'[last()])"/>
                    </end>
                    <total>
                        <xsl:value-of
                            select="f:calculateTotalPgs(substring-before($pub_publication, '-'[last()]), substring-before($pub_publication, '-'[last()]))"
                        />
                    </total>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <start>
                    <xsl:value-of
                        select="substring-before(tokenize(./string[@key = 'pub_publication'], '\-')[last()], '\-')"/>
                    replace($pub_publication,'(.)','(?&lt;!\d):[^\s\r\n]*$')"/>
                </start>
                <end>
                    <xsl:value-of
                        select="substring-after(tokenize(./string[@key = 'pub_publication'], '\-')[last()], '\-')"
                    />
                </end>
                <total>
                    <xsl:value-of select="
                            f:calculateTotalPgs(substring-before(tokenize(./string[@key = 'pub_publication'], '\-')[last()], '\-'),
                            substring-after(tokenize(./string[@key = 'pub_publication'], '\-')[last()], '\-'))"
                    />
                </total>
                <xsl:text>test7</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
     </xsl:template>

    <xd:doc>
        <xd:desc/>
        <xd:param name="input"/>
    </xd:doc>
    <xsl:template match="map/string[@key = 'modified_on'] | map/string[@key = 'created_on']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" mode="part">
        <xsl:param name="input" select="."/>
        <!-- Define array of months -->
        <xsl:variable name="months"
            select="('JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC')"/>
        <!-- Define regex to match input date format -->
        <xsl:analyze-string select="$input" regex="^([0-9]{{1,2}})\-([A-Z]{{3}})\-([0-9]{{4}})(.*)$">
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
        <xd:desc>
            <xd:ul>
                <xd:p>The following identifiers are matched and mappped to MODS:</xd:p>
                <xd:li>
                    <xd:p>DOI (digital object identifier) - ubiquitous usage of this identifer makes
                        it useful to researchers because it provides direct access to an
                        article</xd:p>
                </xd:li>
                <xd:li>
                    <xd:p>product_id</xd:p>
                </xd:li>
                <xd:li>
                    <xd:p>treesearch_pub_id - while only functional locally, this identifer also
                        provides direct access to the surrogate respresntion of the article</xd:p>
                </xd:li>
            </xd:ul>
        </xd:desc>
    </xd:doc>
    <xsl:template name="identifiers" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <!--doi-->
        <xsl:if test="/map/string[@key = 'doi']">
            <identifier type="doi">
                <xsl:value-of select="/map/string[@key = 'doi']"/>
            </identifier>
            <location>
                <url>
                    <xsl:text>http://dx.doi.org/</xsl:text>
                    <xsl:value-of select="normalize-space(/map/string[@key = 'doi'])"/>
                </url>
            </location>
        </xsl:if>

        <!--product-id-->
        <xsl:if test="/map/string[@key = 'product_id']">
            <identifier type="treesearch">
                <xsl:value-of select="/map/string[@key = 'product_id']"/>
            </identifier>
        </xsl:if>

        <!--treesearch_pub_id -->
        <xsl:if test="/map/string[@key = 'treesearch_pub_id']">
            <identifier type="treesearch-pub">
                <xsl:value-of select="/map/string[@key = 'treesearch_pub_id']"/>
            </identifier>
            <location>
                <url access="object in context">
                    <xsl:text>https://www.fs.usda.gov/treesearch/pubs/</xsl:text>
                    <xsl:value-of select="normalize-space(/map/string[@key = 'treesearch_pub_id'])"
                    />
                </url>
            </location>
            <location>
                <url access="raw object">                    
                    <xsl:value-of select="normalize-space(/map/string[@key = 'url_binary_file'])"
                    />
                </url>
            </location>
        </xsl:if>
    </xsl:template>


  

    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>vendorName</xd:b>Metadata supplier name (e.g., Brill, Springer,
                Elsevier)</xd:p>
            <xd:p><xd:b>filename_ext</xd:b>Filename from source metadata (eg. filename.xml,
                filename.json or filename.zip)</xd:p>
            <xd:p><xd:b>filename</xd:b>filename w/o the extension (i.e., xml, json or zip)</xd:p>
            <xd:p><xd:b>workingDir</xd:b>Directory the source file is transformed</xd:p>
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
            <xsl:comment>values of new global variables</xsl:comment>
            <original_file>
                <xsl:value-of select="$original_filename"/>
            </original_file>
            <working_directory>  
                <xsl:value-of select="$working_dir"/>
            </working_directory>
        </extension>
    </xsl:template>
</xsl:stylesheet>
