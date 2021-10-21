<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE transform [
          <!ENTITY % predefined PUBLIC
         "-//W3C//ENTITIES Predefined XML//EN///XML"
         "C:/Users/carlos.martinez/Desktop/json-to-xml/ent/predefined.ent"
       >
       %predefined;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns="http://www.loc.gov/mods/v3" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:f="http://functions" xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:saxon="http://saxon.sf.net/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:usfs="http://usfsreseaerch"
    exclude-result-prefixes="f fn math mods saxon usfs xd xs xsi">

    <xsl:output method="json" indent="no" encoding="UTF-8" name="archive"/>
    <xsl:output method="xml" indent="yes" encoding="UTF-8" name="original"/>  <!--saxon:next-in-chain="fix_characters.xsl"/>-->

    <xsl:include href="commons/common.xsl"/>
    <xsl:include href="commons/functions.xsl"/>
    <xsl:include href="commons/params.xsl"/>

    <xsl:strip-space elements="*"/>
    <xsl:key name="series_publications" match="string[@key = ('pub_type_desc', 'pub_publication')]" use="document('../USFS_Research.xml')/usfs:research/../usfs:seriesPub[@type='series']"/>
    <xd:doc>
        <xd:desc/>
    </xd:doc>


    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="/data">      
        <xsl:result-document omit-xml-declaration="yes" indent="yes" encoding="UTF-8"
            href="file:///{$workingDir}A-{replace($originalFilename, '(.*/)(.*)(\.json)','$2')}_{position()}.json"
            format="archive">
            <xsl:copy-of select="."/>
        </xsl:result-document>
        <xsl:result-document method="xml" indent="yes" encoding="UTF-8" media-type="text/xml"
            href="file:///{$workingDir}N-{replace($originalFilename, '(.*/)(.*)(\.json)','$2')}_{position()}.xml"
            format="original">
            <mods xmlns="http://www.loc.gov/mods/v3" version="3.7">
                <xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>
                <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
                <xsl:attribute name="xsi:schemaLocation"
                    select="normalize-space('http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd')"/>
                <xsl:attribute name="version">3.7</xsl:attribute>
                <xsl:apply-templates select="json-to-xml(.)"/>
            </mods>
        </xsl:result-document>
        
    </xsl:template>




    <!--    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="/data">
        <xsl:result-document omit-xml-declaration="yes" indent="no" method="json"
            href="{$workingDir}{$archiveFile}_{position()}.json"
            format="archive">
            <xsl:copy-of select="unparsed-text(resolve-uri($originalFilename))"/>
        </xsl:result-document>
        <xsl:result-document method="xml" indent="yes" encoding="UTF-8" media-type="text/xml"
            href="{$workingDir}N-{$archiveFile}.xml"
            format="original">
            <mods>
                <xsl:namespace name="mods">http://www.loc.gov/mods/v3</xsl:namespace>
                <xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>
                <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
                <xsl:attribute name="xsi:schemaLocation" select="normalize-space('http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd')"/>
                <xsl:attribute name="version">3.7</xsl:attribute>
                <xsl:apply-templates select="json-to-xml(.)"/>
            </mods>
        </xsl:result-document>
    </xsl:template>
    -->

    <xd:doc>
        <xd:desc>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <!-- titleInfo/title and author tags  -->
        <xsl:apply-templates select="./string[@key = 'title']"/>
        <xsl:apply-templates select="./array[@key = 'pub_authors'] |./string[@key = 'primary_station']"/>

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
        <relatedItem>
            <xsl:apply-templates select="./string[@key = 'pub_type_desc']" mode="pub_type_desc"/>
            <xsl:apply-templates select="./string[@key = 'pub_publication']" mode="pub_type_desc"/>
            <xsl:apply-templates select="./string[@key = 'issn_id']"/>
            <xsl:call-template name="part"/>
        </relatedItem>

        <!--identifiers-->
        <xsl:apply-templates select="./string[@key = 'doi']"/>
        <xsl:apply-templates
            select="./string[@key = 'url_landing_page'] | ./string[@key = 'url_binary_file']"/>

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

    
    
    <xd:doc scope="component" id="pub_authors">
        <xd:desc><xd:p>If the pub_author is a a corporate body rather than an individual, first condition is chosen and formats the output accordingly.</xd:p>
            <xd:p>If processing the first author in the group, assign an attribute of <xd:i>"usage"</xd:i> with a value of "primary."</xd:p></xd:desc>
    </xd:doc>
    <xsl:template match="map/array[@key = 'pub_authors'] | map/array[@key = 'primary_station']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:choose>
            <xsl:when test="count(map/string[@key = 'name']) = 0">
                <name type="corporate">
                    <namePart>
                        <xsl:text>United States Department of Agriculture, Forest Service, </xsl:text>
                        <xsl:value-of select="f:acronymToName(./array[@key = 'primary_station'])"/>
                        <xsl:value-of select="f:acronymToAddress(./array[@key = 'primary_station'])"/>
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
    </xd:doc>
    <xsl:template name="name-info" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:for-each select="map[position()]">
            <xsl:if test="./string[@key = 'name']">
                <namePart type="given">
                    <xsl:value-of select="substring-after(normalize-space(./string[@key = 'name']), ', ')"/>
                </namePart>
                <namePart type="family">
                    <xsl:value-of
                        select="substring-before(normalize-space(./string[@key = 'name']), ', ')"
                    />
                </namePart>
                <displayName>
                    <xsl:value-of select="./string[@key = 'name']"/>
                </displayName>
       
            <xsl:choose>
                <xsl:when test="(./string[@key = 'station_id'] != '')">
                    <affiliation>
                        <xsl:text>United States Department of Agriculture, Forest Service, </xsl:text>
                        <xsl:value-of select="f:acronymToName(./string[@key = 'station_id'])"/>
                        <xsl:text>, </xsl:text>
                        <xsl:choose>
                            <xsl:when test="./string[@key = 'unit_id'] != ''">
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="f:unitNumToName(./string[@key = 'unit_id'])"/>
                            </xsl:when>
                            <xsl:otherwise>   
                            <xsl:text>, </xsl:text>
                                <xsl:value-of select="f:unitAcronymToName(./string[@key = 'unit_id'])"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="f:acronymToAddress(./string[@key = 'station_id'])"/>
                    </affiliation>
                </xsl:when>                
                <xsl:when test="(./string[@key = 'station_id'] != '') and (./string[@key = 'unit_id'] = '')"> 
                    <affiliation>
                        <xsl:text>United States Department of Agriculture,</xsl:text>
                        <xsl:text>Forest Service,</xsl:text>
                        <xsl:value-of select="f:acronymToName(./string[@key = 'station_id'])"/>
                        <xsl:text>,</xsl:text>
                        <xsl:value-of select="f:acronymToAddress(./string[@key = 'station_id'])"/>
                    </affiliation>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:if test="(./string[@key = 'station_id'] = '') and (./string[@key = 'unit_id'] = '')"/>
                </xsl:otherwise>
            </xsl:choose>
            <role>
                <roleTerm type="text">author</roleTerm>
            </role>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
    

    <xd:doc>
        <xd:des>to match and creaete apply-templates for corporate body</xd:des>
    </xd:doc>
    <xsl:template name="corporate" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <name type="corporate">
            <namePart>
                <xsl:text>United States Department of Agriculture, Forest Service, </xsl:text>
                <xsl:value-of select="f:acronymToName(map/string[@key = 'primary_station'])"/>
                <xsl:value-of select="f:acronymToAddress(map/string[@key = 'primary_station'])"/>
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
        <xd:desc>
            <xd:p>Publication info as a string to be parsed</xd:p>
            <xd:p>Journal host info: base doi, origin, agency, sub-agency, research station,
                research unit, page numbers</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="map/string[@key = 'pub_type_desc']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" mode="relatedItem_title">
        <xsl:value-of select="map/string[@key = 'pub_type_desc']"/>
    </xsl:template>
    <xd:doc>
        <xd:desc>
            <xd:p>pub_type_desc as a string to be parsed</xd:p>
            <xd:p>Journal host info: base doi, origin, agency, sub-agency, research station,
                research unit, page numbers</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:template match="map/string[@key = 'pub_publication']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" mode="relatedItem_title">
        <xsl:value-of select="map/string[@key = 'pub_publication']"/>
    </xsl:template>

    <xd:doc>
        <xd:desc/>

        <xd:param name="p_series"/>
    </xd:doc>
    <xsl:template match="map/string[@key = ('pub_type_desc', 'pub_publication')]"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" mode="pub_type_desc">

        <xsl:param name="p_series" as="xs:string">
            <xsl:value-of select="normalize-space(string-join('Forest Insect &amp; Disease Leaflet,
                General Technical Report (GTR),
                General Technical Report - Proceedings,
                Information Forestry,
                Proceeding (Rocky Mountain Research Station Publications),
                Resource Bulletin (RB),
                Research Map (RMAP),
                Research Note (RN),
                Research Paper (RP),
                Resource Update (RU)', ','))"/>
        </xsl:param>
        <xsl:variable name="pub_type" select="string[@key = 'pub_type_desc']"/>
        <xsl:variable name="pub_publication" select="string[@key = 'pub_publication']"/>        
        <xsl:variable name="pub_publication" select="string[@key = 'citation']"/>
        <xsl:for-each select="*">
            <xsl:choose>
                <xsl:when test="contains($pub_type, string[@key = 'pub_type_desc'])">
                    <relatedItem type="series">
                        <titleInfo type="abbreviated">
                            <title>
                                <xsl:value-of select="key('series_publications', $pub_type)"/>
<!--                                <xsl:apply-templates select="./text()" mode="relatedItem_title"/>-->
                            </title>
                        </titleInfo>
                    </relatedItem>
                </xsl:when>
                <xsl:when test="not(matches($p_series, text()) and contains($pub_publication, text()))">      
                   <relatedItem type="series">
                     <xsl:apply-templates select="substring-before(./text(), '.')" mode="relatedItem_title"/>
                    </relatedItem>                        
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="host"/>
                    <relatedItem>
                            <xsl:apply-templates select="./text()" mode="relatedItem_title"/>
                    </relatedItem>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>


    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="map/string[@key = 'pub_desc_type']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" mode="get_value">
        <titleInfo type="abbreviated">
            <title>
                <xsl:value-of select="f:seriesToAbbrv(.)"/>
            </title>
        </titleInfo>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="map/string[@key = 'pub_publication']"
        xpath-default-namespace="http://www.w3.org/2005/xpah-functions" mode="get_value">
        
        <titleInfo>
            <title>
                <xsl:value-of select="."/>
            </title>
        </titleInfo>
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
            <!---->
            <xsl:if test="(./string[@key = 'modified_on'] != ' ')">
                <xsl:apply-templates select="./string[@key = 'modified_on']" mode="part"/>
            </xsl:if>
            <!--extent/pages-->
            <extent unit="pages">
                <xsl:call-template name="pages"/>
            </extent>
        </part>

    </xsl:template>



    <xd:doc>
        <xd:desc/>
        <xd:param name="start_page"/>
        <xd:param name="end_page"/>
        <xd:param name="pub_publication"/>
        <xd:param name="pages"/>
    </xd:doc>
    <xsl:template name="pages" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="start_page" select="/fn:map/fn:string[@key = 'pub_page_start']"/>
        <xsl:param name="end_page" select="/fn:map/fn:string[@key = 'pub_page_end']"/>
        <xsl:param name="pub_publication" select="/fn:map/fn:string[@key = 'pub_publication']"/>
        <xsl:param name="pages" select="tokenize($pub_publication, '-'[last()])"/>
        <xsl:choose>
            <xsl:when test="string[@key = 'pub_page'] except *[($start_page) or ($end_page)]">
                    <start>
                        <xsl:value-of select="substring-before(string[@key = 'pub_page'], '-')"/>
                    </start>
                    <end>
                        <xsl:value-of select="substring-after(string[@key = 'pub_page'], '-')"/>
                    </end>
                    <xsl:if test="contains(string[@key = 'pub_page'], '\s')"/>
                    <xsl:variable name="translated_total" select="translate(string[@key = 'pub_page'], '\s', '')"/>
                    <total>
                        <xsl:value-of select="f:calculateTotalPgs(substring-before($translated_total, '-'), substring-after($translated_total, '-'))"/>
                    </total>
                    <xsl:message>test 1</xsl:message>
                
            </xsl:when>
            <xsl:when test="$start_page and $end_page">
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
                    <xsl:message>test 2</xsl:message>
                </xsl:sequence>
            </xsl:when>
            <xsl:when test="tokenize($pub_publication, '-')[last()]">
                <xsl:variable name="first_page"
                    select="normalize-space(substring-after(substring-before($pub_publication, '-'), 'Pages'))"/>
                <xsl:variable name="last_page"
                    select="normalize-space(substring-before(substring-after($pub_publication, '-'), '.'[last()]))"/>
                <start>
                    <xsl:value-of select="$first_page"/>
                </start>
                <end>
                    <xsl:value-of select="$last_page"/>
                </end>
                <total>
                    <xsl:value-of select="f:calculateTotalPgs($first_page, $last_page)"/>
                </total>
                <xsl:message>test 3</xsl:message>
            </xsl:when>
            <xsl:when test="$pages">
                <xsl:variable name="first_page" select="normalize-space(substring-after(substring-before($pub_publication, '-'), 'pages'))"/>
                <xsl:variable name="last_page" select="normalize-space(substring-before(substring-after($pub_publication, '-'), '.'[last()]))"/>
                <start>
                    <xsl:value-of select="$first_page"/>
                </start>
                <end>
                    <xsl:value-of select="$last_page"/>
                </end>
                <total>
                    <xsl:value-of select="f:calculateTotalPgs($first_page, $last_page)"/>
                </total>
                <xsl:message>test 4</xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="$pages">
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
                        <xsl:message>test 5</xsl:message>
                    </xsl:for-each>
                </xsl:if>
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
        <xd:desc/>
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
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template
        match="map/string[@key = 'url_landing_page'] | map/string[@key = 'url_binary_file']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:if test="./string[@key = 'url_landing_page']">
            <identifier>
                <xsl:attribute name="type">
                    <xsl:value-of select="translate(@key, '_', ' ')"/>
                </xsl:attribute>
                <xsl:value-of select="."/>
            </identifier>
            <location>
                <url access="object in context">
                    <xsl:attribute name="note" select="translate(@key, '_', ' ')"/>
                    <xsl:value-of select="normalize-space(string[@key = 'url_landing_page'])"/>
                </url>
            </location>
            <xsl:if test="map/string[@key = 'url_binary_file']">
                <identifier>
                    <xsl:attribute name="type">
                        <xsl:value-of select="translate(@key, '_', ' ')"/>
                    </xsl:attribute>
                    <xsl:value-of
                        select="tokenize(map/string[@key = 'url_binary_file'], '/')[last()]"/>
                </identifier>
            </xsl:if>
            <location>
                <url access="raw object">
                    <xsl:value-of select="map/string[@key = 'url_binary_file']"/>
                </url>
            </location>
        </xsl:if>
    </xsl:template>

    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>vendorName:</xd:b>Metadata supplier name (e.g., Brill, Springer,
                Elsevier)</xd:p>
            <xd:p><xd:b>filename_ext:</xd:b>Filename from source metadata (eg. filename.xml,
                filename.json or filename.zip)</xd:p>
            <xd:p><xd:b>filename:</xd:b>filename w/o the extension (i.e., xml, json or zip)</xd:p>
            <xd:p><xd:b>workingDirectory:</xd:b>directory the source file is transformed
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



</xsl:stylesheet>