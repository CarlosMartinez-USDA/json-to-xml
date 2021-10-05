<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE transform [
          <!ENTITY % predefined PUBLIC
         "-//W3C//ENTITIES Predefined XML//EN///XML"
         "C:/Users/carlos.martinez/Desktop/json-to-xml/ent/predefined.ent"
       >
       %predefined;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0"
    xmlns:mods="http://www.loc.gov/mods/v3" xmlns:f="http://functions"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" xmlns:saxon="http://saxon.sf.net/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:usfs="http://usfsreseaerch"
    exclude-result-prefixes="f fn math mods saxon usfs xd xs xsi">

    <xsl:output method="json" indent="yes" encoding="UTF-8" name="archive"/>
    <xsl:output method="xml" indent="yes" encoding="UTF-8" name="original"/>
    <!--saxon:next-in-chain="fix_characters.xsl"/>-->

    <xsl:include href="commons/common.xsl"/>
    <xsl:include href="commons/functions.xsl"/>
    <xsl:include href="commons/params.xsl"/>

    <xsl:strip-space elements="*"/>

    <xd:doc>
        <xd:desc/>
        <xd:param name="acronym"/>
        <xd:param name="unitNum"/>
    </xd:doc>
    <!-- <xsl:template match="data">
        <xsl:result-document omit-xml-declaration="yes" indent="yes" encoding="UTF-8"
            href="file:///{$workingDir}A-{replace($originalFilename, '(.*/)(.*)(\.json)','$2')}_{position()}.json" format="archive">
            <xsl:copy-of select="."/>
        </xsl:result-document>
        <xsl:result-document method="xml" indent="yes" encoding="UTF-8" media-type="text/xml"
            href="file:///{$workingDir}N-{replace($originalFilename, '(.*/)(.*)(\.json)','$2')}_{position()}.xml" format="original">
            <mods version="3.7">
                <xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>
                <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
                <xsl:attribute name="xsi:schemaLocation" select="normalize-space('http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd')"/>
                <xsl:attribute name="version">3.7</xsl:attribute>
                <xsl:apply-templates select="json-to-xml(.)"/>
            </mods>
        </xsl:result-document>
    </xsl:template>-->


    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="data">
        <xsl:result-document omit-xml-declaration="yes" indent="yes" encoding="UTF-8"
            href="{$workingDir}{replace($originalFilename, '(.*/)(.*)(\.json)', '$2')}_{position()}.json"
            format="archive">
            <xsl:copy-of select="."/>
        </xsl:result-document>
        <xsl:result-document method="xml" indent="yes" encoding="UTF-8" media-type="text/xml"
            href="{$workingDir}N-{replace($originalFilename, '(.*/)(.*)(\.json)', '$2')}_{position()}.xml"
            format="original">
            <mods>
                <xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>
                <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
                <xsl:attribute name="xsi:schemaLocation"
                    select="normalize-space('http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd')"/>
                <xsl:attribute name="version">3.7</xsl:attribute>
                <xsl:apply-templates select="json-to-xml(.)"/>
            </mods>
        </xsl:result-document>
    </xsl:template>


    <xd:doc>
        <xd:desc>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:template match="map" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <!-- titleInfo/title and author tags  -->
        <xsl:apply-templates select="./string[@key = 'title']"/>
        <xsl:apply-templates select="./array[@key = 'pub_authors']"/>

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
            <xsl:apply-templates select="./string[@key = 'pub_type_desc']" mode="relatedItem"/>
            <xsl:apply-templates select="./string[@key = 'pub_type_desc']" mode="titleInfo"/>
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
<!--end of main template-->

        <xsl:param name="series_pubs">
            <xsl:sequence select="
                tokenize(
                concat(
                'Forest Insect &amp; Disease Leaflet',
                'General Technical Report (GTR)',
                'General Technical Report - Proceedings',
                'Information Forestry',
                'Proceeding (Rocky Mountain Research Station Publications)',
                'Resource Bulletin (RB)',
                'Research Map (RMAP)',
                'Research Note (RN)',
                'Research Paper (RP)',
                'Resource Update (RU)'), 
                ',')"/> 
        </xsl:param>
            
            

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
    <xsl:template match="map/array[@key = 'pub_authors']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:choose>
            <xsl:when test="map/string[@key = 'primary_station']">
                <name type="corporate">
                    <namePart>
                        <xsl:text>United States Department of Agriculture, Forest Service, </xsl:text>
                        <xsl:value-of select="f:acronymToName(.)"/>
                        <xsl:value-of select="f:acronymToAddress(.)"/>
                    </namePart>
                </name>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select=".">
                    <name type="personal">
                        <xsl:if
                            test="position() = 1 and count(map/preceding-sibling::string[@key = 'name']) = 0">
                            <xsl:attribute name="usage">primary</xsl:attribute>
                        </xsl:if>
                        <xsl:call-template name="name-info"/>
                    </name>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xd:doc>
        <xd:desc>
            <xd:p>A for-each loop positions the context node within the pub_author array (i.e.,
                directly after the root/map tag).</xd:p>
            <xd:p>The first if test designates the first author as primary, </xd:p>
            <xd:p>Matching on station_id acronym and unit_id number, the template builds affiliation
                address from xml lookup table.</xd:p>
        </xd:desc>
        <xd:param name="acronym"/>
        <xd:param name="unitNum"/>
        <xd:param name="unitAcronym"/>
    </xd:doc>
    <xsl:template name="name-info" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="acronym" select="map[position()]/string[@key = 'station_id']"/>
        <xsl:param name="unitNum"  as="xs:string" select="map[position()]/string[@key = 'unit_id']"/>
        <xsl:param name="unitAcronym"  as="xs:string" select="map[position()]/string[@key = 'unit_id']"/>
        
        <!--        <xsl:for-each-group select="map/array[@key='pub_authors']" group-by="map/string[2][">-->
        <xsl:for-each select="map[position()]">
            <xsl:if test="./string[(@key = 'name')]">
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
            <!--affiliation-->
            <xsl:if test="(./string[@key = 'station_id']) != ''">
                <affiliation>
                    <xsl:text>United States Department of Agriculture, Forest Service, </xsl:text>
                    <xsl:value-of select="f:acronymToName(./string[@key = 'station_id'])"/>
                    <xsl:text>, </xsl:text>
                    <xsl:choose>
                        <xsl:when test="contains($unitNum, string($unitNum))">
                        <xsl:value-of select="f:unitNumToName(./string[@key = 'unit_id'])"/>
                        <xsl:text>, </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="f:unitAcronymToName(./string[@key = 'unit_id'])"/>
                            <xsl:text>, </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:value-of select="f:acronymToAddress(./string[@key = 'station_id'])"/>
                </affiliation>
            </xsl:if>
            <role>
                <roleTerm type="text">author</roleTerm>
            </role>
        </xsl:for-each>
    </xsl:template>


    <xd:doc>
        <xd:desc/>
        <xd:param name="input"/>
    </xd:doc>
    <xsl:template match="map/string[@key = ('modified_on', 'created_on')]"
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
        <xd:desc>Matches on string key value 'abstract' and maps to mods:abstract</xd:desc>
    </xd:doc>
    <xsl:template match="map/string[@key = 'abstract']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <abstract>
            <xsl:value-of select="normalize-space(.)"/>
        </abstract>
    </xsl:template>


    <xd:doc>
        <xd:desc>
            <xd:p>main template calls "keywords" template.</xd:p>
            <xd:p>conditionally selects in order of preference:</xd:p>
            <xd:ul>
                <xd:li>(1) controlled vocabulary - "National Research Taxonomy Elements'or,</xd:li>
                <xd:li></xd:li>
            </xd:ul>
        </xd:desc>
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
        <xd:desc/>
        <xd:param name="relatedItem"/>
    </xd:doc>
   <!-- <xsl:template match="./sting[@key = 'pub_type_desc']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" mode="relatedItem">
        <xsl:param name="relatedItem" select="map/string[@key = 'pub_type_desc']"/>
        <xsl:variable name="series_pubs">
            <xsl:value-of select="f:acronymToName(./string{@key = 'pub_type_desc'])"/>
        </xsl:variable>
            </xsl:template>
                <xd:doc>
        <xd:desc>relatedItem/title</xd:desc>
        <xd:param name="relatedItem"/>
    </xd:doc>
    <!-\-mode="related"-\->-->
    <xsl:template match="map/string[@key = 'pub_type_desc']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" mode="relatedItem">
        <xsl:param name="relatedItem" select="map/string[@key = 'pub_type_desc']"/>
            
    <!--    <xsl:choose>
            <xsl:when test="matches(./string[@key ='pub_type_desc'], $series_pubs)">-->
                <xsl:analyze-string select="f:pub_type_desc(.)" regex="^[a-z]+(,[a-z]+)*$">
            <xsl:matching-substring>
                <relatedItem type="host">
                    <titleInfo>
                        <title>
                            <xsl:value-of select="regex-group(1)"/>
                        </title>
                    </titleInfo>
                    <detail type="volume">
                        <number>
                            <xsl:number value="regex-group(2)" format="001"/>
                        </number>
                        <caption>v.</caption>
                    </detail>
                    <detail type="issue">
                        <number>
                            <xsl:number value="regex-group(3)" format="001"/>
                        </number>
                        <caption>no.</caption>
                    </detail>
                    <extent type="pages">
                        <start>
                            <xsl:number value="substring-before(regex-group(4), '-')" format="01"/>
                        </start>
                        <end>
                            <xsl:number value="substring-after(regex-group(4), '-')" format="01"/>
                        </end>
                        <total>
                            <xsl:value-of select="
                                    f:calculateTotalPgs(substring-before(regex-group(4), '-'),
                                    substring-after(regex-group(4), '-'))"
                            />
                        </total>
                    </extent>
                </relatedItem>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <!--                  <xsl:if test="contains($relatedItem, $series_pubs)">-->
                <relatedItem type="series">
                    <titleInfo>
                        <title>
                            <xsl:value-of select="$relatedItem"/>
                        </title>
                    </titleInfo>
                    <titleInfo type="abbreviated">
                        <title>
                            <xsl:value-of select="f:seriesToAbbrv($relatedItem)"/>
                        </title>
                    </titleInfo>
                    <detail type="volume">
                        <number> </number>
                    </detail>
                    <detail type="issue">
                        <number>
                            <xsl:value-of select="regex-group(3)"/>
                        </number>
                    </detail>
                    <extent type="pages">
                        <start>
                            <xsl:number value="substring-before(regex-group(4), '-')"/>
                        </start>
                        <end>
                            <xsl:number value="substring-after(regex-group(4), '-')"/>
                        </end>
                        <total>
                            <xsl:value-of
                                select="f:calculateTotalPgs(substring-before(regex-group(4), '-'), substring-after(regex-group(4), '-'))"
                            />
                        </total>
                    </extent>
                </relatedItem>
                <!--</xsl:if>-->
            </xsl:non-matching-substring>
        </xsl:analyze-string>
            <!--</xsl:when>
        </xsl:choose>-->
     
        
    </xsl:template>
   
    <!--<xd:doc>
        <xd:desc/>
        <xd:param name="pub_type_desc"/>
    </xd:doc>
    <xsl:template match="map/string[@key = 'pub_type_desc']" mode="relatedItemTitle">  
        <xsl:param name="pub_type_desc"/>
         <xsl:variable name="analyzed">
                 <xsl:analyze-string select="tokenize(concat('Forest Insect &amp; Disease Leaflet',
                    'General Technical Report (GTR)',
                    'General Technical Report - Proceedings',
                    'Information Forestry',
                    'Proceeding (Rocky Mountain Research Station Publications)',
                    'Resource Bulletin (RB)',
                    'Research Map (RMAP)',
                    'Research Note (RN)',
                    'Research Paper (RP)',
                    'Resource Update (RU)'), 
                    ',')" regex="'(((.)*,)*)(.)*"/>
         </xsl:variable>
                    <xsl:matching-substring>
                        <relateItem> 
                            <xsl:attribute name="type">series</xsl:attribute>
            <titleInfo>
                <xsl:if test="matches(./string[@key='pub_type_desc'), regex-group(1))">
                    <xsl:attribute name="type">abbreviated</xsl:attribute>
                </xsl:if>
             <title>
                 <xsl:value-of select="matches(./string[@key='pub_type_desc'),regex-group(1)"/>
             </title>
            </titleInfo>
                        </relateItem> 
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                       <related-item type="host">
                        <titleInfo>
                        <title>
                        <xsl:value-of select="."/>
                        </title>
                       </titleInfo>
                       </related-item>
                    </xsl:non-matching-substring>
               
             <xsl:variable name="series_title"> 
                 <xsl:value-of select="matches($pub_type_desc, $analyzed)"/>
             </xsl:variable>
        <titleInfo>
            <title>
                
                <xsl:value-of select="self::node()"/>
                
            </title>
            <xsl:if test="$series_title">
                <xsl:attribute name="type">series</xsl:attribute>
            </xsl:if>
        </titleInfo>
        
    </xsl:template>-->
        
        
    <xd:doc>
        <xd:desc/>
        <xd:param name="relatedItem"/>
    </xd:doc>
    <xsl:template match="map/string[@key = ('pub_type_desc', 'pub_publication')]"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions" mode="titleInfo">
        <xsl:param name="relatedItem" select="map/string[@key = 'pub_type_desc']"/>
        <xsl:variable name="series_pubs">
            <xsl:sequence
                select="concat('Forest Insect &amp; Disease Leaflet', 'General Technical Report (GTR)', 'General Technical Report - Proceedings', 'Information Forestry', 'Proceeding Rocky Mountain Research Station Publications', 'Resource Bulletin', 'Research Map', 'Research Note', 'Research Paper', 'Resource Update')"
            />
        </xsl:variable>
        <xsl:variable name="publication" select="tokenize($series_pubs, ',')"/>
        <xsl:variable name="nodes">
            <xsl:copy-of select="document('commons/USFS_Research.xml')"/>
        </xsl:variable>
        <xsl:variable name="pub_host"
            select="$nodes/usfs:research/usfs:seriesPublications/usfs:seriesPub[@type = 'host']"/>
        <xsl:variable name="pub_series"
            select="$nodes/usfs:research/usfs:seriesPublications/usfs:seriesPub[@type = 'series']"/>
        <titleInfo>
            <xsl:choose>
                <xsl:when test="matches($relatedItem, $publication)">
                    <xsl:attribute name="type">abbreviated</xsl:attribute>
                    <title>
                        <xsl:value-of select="f:seriesToAbbrv($relatedItem)"/>
                    </title>
                </xsl:when>
                <xsl:when test="not(matches($relatedItem, $publication))">
                    <xsl:variable name="pub_publication"
                        select="map/string[@key = 'pub_publication']"/>
                    <title>
                        <xsl:value-of
                            select="(substring-before(tokenize($pub_publication), '[.,:]\s+'), following-sibling::node())"
                        />
                    </title>
                </xsl:when>
                <xsl:otherwise>
                    <title>
                        <xsl:copy-of
                            select="(substring-before(tokenize($publication), '[.,:]\s+'), following-sibling::node())"
                        />
                    </title>
                </xsl:otherwise>
            </xsl:choose>
        </titleInfo>
    </xsl:template>



    <xd:doc>
        <xd:desc/>
        <xd:param name="publication"/>
        <xd:param name="pub_type"/>
    </xd:doc>
    <xsl:template match="map/string[@key = 'pub_type_desc']"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <xsl:param name="pub_type" select="map/string[@key = 'pub_type_desc']"/>
        <xsl:param name="publication" select="map/string[@key = 'pub_publication']"/>
        
        <xsl:if test="contains(f:seriesToAbbrv(.), $publication)">
            <titleInfo>
                <xsl:attribute name="type">abbreviated</xsl:attribute>
                <title>
                    <xsl:value-of select="f:seriesToAbbrv(.)"/>
                </title>
            </titleInfo>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="contains($pub_type, $publication)">
                <titleInfo>
                    <title>
                        <xsl:value-of select="substring-before($publication, '[.,;:]')"/>
                    </title>
                </titleInfo>
            </xsl:when>
            <xsl:otherwise>
                <titleInfo>
                    <xsl:attribute name="type">alternative</xsl:attribute>
                    <title>
                        <xsl:copy-of
                            select="(substring-before(tokenize($publication), '[.,:]\s+'), following-sibling::node())"
                        />
                    </title>
                </titleInfo>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="map/string[@key = 'issn_id']" xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
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
                <xsl:call-template name="pages"/>
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
        <xsl:choose>
            <xsl:when test="($start_page != ' ') and ($end_page != ' ')">
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
         
            <xsl:when test="./string[@key='pub_publication'] != ''">
                <xsl:variable name="pub_pages" select="tokenize(./string[@key='pub_publication'],'.')[last()]"/>
              <extend type="pages">
                  <start>
                      <xsl:value-of select="substring-before(tokenize(./string[@key='pub_publication'], '.')[last()], '-')"/>
                  </start>
                  <end>
                      <xsl:value-of select="substring-after(tokenize(./string[@key='pub_publication'], '.')[last()], '-')"/>
                  </end>
                  <total>
                      <xsl:value-of select="substring-before(tokenize(./string[@key='pub_publication'], '.')[last()], '-'), substring-after(tokenize(./string[@key='pub_publication'], '.')[last()], '-')"/>
                  </total>
              </extend>
                
            </xsl:when>
            <xsl:when test="substring-before(tokenize(map/string[@key = 'pub_publication'], '.')[last()], '.')"
      />
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
    <xsl:template name="usfs_identifiers"
        xpath-default-namespace="http://www.w3.org/2005/xpath-functions">
        <identifier>
            <xsl:for-each select="map/string[@key = 'url_binary_file', 'url_landing_page']">
                <xsl:choose>
                    <xsl:when test="map/string[@key = 'url_binary_file']">
                        <xsl:attribute name="type">
                            <xsl:value-of select="translate(text(), '_', ' ')"/>
                        </xsl:attribute>
                        <xsl:value-of select="."/>
                        <!--                        select="translate(upper-case(substring-before(tokenize(., '/')[last()], '.')), '_', ' ')"/>-->
                        <location>
                            <url access="raw object">
                                <xsl:attribute name="note" select="translate(@key, '_', ' ')"/>
                                <xsl:value-of
                                    select="normalize-space(string[@key = ('url_landing_page')])"/>
                            </url>
                        </location>
                    </xsl:when>
                    <xsl:when test="map/string[@key = 'url_binary_file']">
                        <xsl:attribute name="type">
                            <xsl:value-of select="translate(@key, '_', ' ')"/>
                        </xsl:attribute>
                        <xsl:value-of
                            select="translate(upper-case(substring-before(tokenize(., '/')[last()], '.')), '_', ' ')"/>
                        <location>
                            <url access="raw object">
                                <xsl:attribute name="note" select="translate(@key, '_', ' ')"/>
                                <xsl:value-of
                                    select="normalize-space(string[@key = ('url_binary_file')])"/>
                            </url>
                        </location>
                    </xsl:when>
                    <xsl:when test="map/string[@key = 'url_landing_page']">
                        <identifier> </identifier>
                        <location>
                            <url access="object in context">
                                <xsl:attribute name="note" select="translate(@key, '_', ' ')"/>
                                <xsl:value-of
                                    select="normalize-space(string[@key = ('url_landing_page')])"/>
                            </url>
                        </location>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
        </identifier>
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
</xsl:stylesheet>
