<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.loc.gov/mods/v3"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:f="http://functions"
    xmlns:usfs="http:/usfsresearch"
    exclude-result-prefixes="xs xd f" version="2.0">

    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jun 28, 2017</xd:p>
            <xd:p><xd:b>Author:</xd:b> rdonahue</xd:p>
        </xd:desc>
    </xd:doc>
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:monthNumFromName</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:monthNumFtworomName(string)</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Pull the -digit equivalent of a month name for a given date
                string. e.g. "June 28, 2017" will return "06." The name of the month
                    <xd:i>must</xd:i> be at the start of the string. "28 June 2017" will return NaN.
                This function is not case sensitive.</xd:p>
            <xd:p>Originally from <xd:a>https://stackoverflow.com/a/37454157</xd:a></xd:p>
        </xd:desc>
        <xd:param name="month-name">string which starts with the month name</xd:param>
    </xd:doc>
   
    <xd:doc>
        <xd:desc/>
        <xd:param name="month-name"/>
    </xd:doc>
    <xsl:function name="f:monthNumFromName" as="xs:string" xmlns:functx="http://functions">
        <xsl:param name="month-name" as="xs:string"/>
        <xsl:variable name="months" as="xs:string*"
            select="'jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'"/>
        <xsl:sequence
            select="format-number(index-of($months, lower-case(substring($month-name, 1, 3))), '00')"
        />
    </xsl:function>

    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:calculateTotalPages</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:calculateTotalPages([xpath/value for first page],
                [xpath/value for last page])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Calculate the total page count if the first and last pages
                are present and are integers</xd:p>
        </xd:desc>
        <xd:param name="fpage">value or XPath for the first page</xd:param>
        <xd:param name="lpage">value or XPath for the last page</xd:param>
    </xd:doc>
    <xsl:function name="f:calculateTotalPgs">
        <xsl:param name="fpage"/>
        <xsl:param name="lpage"/>
        <xsl:if test="(string(number($fpage)) != 'NaN' and string(number($lpage)) != 'NaN')">
            <total>
                <xsl:value-of select="($lpage - $fpage)"/>
            </total>
        </xsl:if>
    </xsl:function>

    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:checkMonthType</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:checkMonthType(XPath)</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>If no month provided, return nothing. If month provided,
                check if represented as an integer or string. If integer, pad with zeroes to 2
                digits; if string, run <xd:i>f:monthNumFromName</xd:i></xd:p>
        </xd:desc>
        <xd:param name="testValue"/>
    </xd:doc>
    <xsl:function name="f:checkMonthType">
        <xsl:param name="testValue"/>
        <xsl:choose>
            <xsl:when test="(string($testValue)) and (not(string-length($testValue) > 2))">
                <xsl:value-of select="format-number($testValue, '00')"/>
            </xsl:when>
            <xsl:when test="string-length($testValue) > 2">
                <xsl:value-of select="f:monthNumFromName($testValue)"/>
            </xsl:when>
        </xsl:choose>
    </xsl:function>

    <!--new functions added 8/15/2018-->
    <xd:doc>
    <xd:desc>
        <xd:p><xd:b>Created on:</xd:b>August 15, 2018</xd:p>
        <xd:p><xd:b>Author:</xd:b>cmartinez</xd:p>
    </xd:desc>
    </xd:doc>

    <!--f:capitalize-first-->
    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:capitalize-first</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:capitalize-first(XPath)</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>The f:capitalize-first function capitalizes the first
                character of $arg. If the first character is not a lowercase letter, $arg is left
                unchanged. It capitalizes only the first character of the entire string, not the
                first letter of every word<xd:i>f:capitalize-first</xd:i></xd:p>
        </xd:desc>
        <xd:param name="arg"/>
    </xd:doc>
    <xsl:function name="f:capitalize-first" as="xs:string?">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence
            select="
                concat(upper-case(substring($arg, 1, 1)),
                substring($arg, 2))
                   "
         />
    </xsl:function>
    <!--f:format-case-->
    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:format-case</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:format-case(XPath)</xd:p>
            <xd:p><xd:b>Purpose:</xd:b>The f:format-case function capitalizes treats a string like
                two parts; the first character of $arg is capitalized, the rest of the string is
                lowercase. (e.g. STRING ---> String). Thus, even if the second letter of $arg is not
                a lowercase letter, the rest of the string is still lowercase. </xd:p>
        </xd:desc>
        <xd:param name="arg"/>
    </xd:doc>
    <xsl:function name="f:format-case" as="xs:string?">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence
            select="
                concat(upper-case(substring($arg, 1, 1)),
                lower-case(substring($arg, 2)))
                "
        />
    </xsl:function>
    <!--f:format-names-->
    <xd:doc>
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:format-names</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:formatNames(XPath)</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>The f:formatNames function performs a "choose when" test
                first determining if a string contains two substrings, when it does, it capitalizes
                the first character of each substring. when it does not, it capitalizes the first
                character of the substring, and the rest of the string is lowercase, making use of
                    <xd:i>f:format-case</xd:i>function in both instances</xd:p>
        </xd:desc>
        <xd:param name="arg"/>
    </xd:doc>
    <xd:doc>
        <xd:desc/>
        <xd:param name="arg"/>

    </xd:doc>
    <xsl:function name="f:formatNames">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:variable name="regex" select="' '"/>
        <!--choose when-->
        <xsl:choose>
            <xsl:when test="(matches($arg, $regex))">
                <xsl:variable name="substring1" select="substring-before($arg, $regex)"/>
                <xsl:variable name="substring2" select="substring-after($arg, $regex)"/>

                <xsl:sequence
                    select="
                    if (matches($arg, $regex))
                        then
                            concat(f:format-case($substring1), ($regex), (f:format-case($substring2)))
                        else
                            $arg"
                />
            </xsl:when>
            <xsl:otherwise>

                <xsl:value-of select="f:format-case($arg)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xd:doc>
        <xd:desc/>
        <xd:param name="arg"/>
        <xd:param name="regex"/>
    </xd:doc>
    <xsl:function name="f:substring-before-match" as="xs:string">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="regex" as="xs:string"/>
        <xsl:sequence select="tokenize($arg, $regex)[1]"/>
    </xsl:function>

    <xd:doc>
        <xd:desc/>
        <xd:param name="titles"/>
    </xd:doc>
    <xsl:function name="f:format-as-title-en" as="xs:string*">
        <xsl:param name="titles" as="xs:string*"/>
        <xsl:variable name="wordsToMoveToEnd" select="('A', 'An', 'The')"/>
        <xsl:for-each select="$titles">
            <xsl:variable name="title" select="."/>
            <xsl:variable name="firstWord" select="f:substring-before-match($title, '\W')"/>
            <xsl:sequence
                select="
                    if ($firstWord = $wordsToMoveToEnd)
                    then
                        replace($title, '(.*?)\W(.*)', '$2, $1')
                    else
                        $title"
            />
        </xsl:for-each>
    </xsl:function>



    <xd:doc>
        <xd:desc>f:escape-for-regex</xd:desc>
        <xd:param name="arg"/>
    </xd:doc>
    <xsl:function name="f:escape-for-regex" as="xs:string">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:sequence select="
            replace($arg,
            '(\.|\[|\]|\\|\||\-|\^|\$|\?|\*|\+|\{|\}|\(|\))','\\$1')
            "/>
    </xsl:function>

    <xd:doc>
        <xd:desc>f:contains-word</xd:desc>
        <xd:param name="arg"/>
        <xd:param name="word"/>
    </xd:doc>
    <xsl:function name="f:contains-word" as="xs:boolean">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="word" as="xs:string"/>

           <xsl:sequence
               select="
                matches(upper-case($arg),
                concat('^(.*\W)?',
                upper-case(
                f:escape-for-regex($word)),
                '(\W.*)?$'))"/>
    </xsl:function>
    
    <!--Forest Service research station naming functions-->
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:acronymToName</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:acronymToName(string[@key = 'station_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>function to match a three-letter acronym to a full research station name.</xd:p>            
        </xd:desc>
        <xd:param name="acronym">three-letter</xd:param>
    </xd:doc>      
    <xsl:function name="f:acronymToName" as="xs:string" xmlns:f="http://functions">
        <xsl:param name="acronym"/>
        <xsl:if test="$acronym != ''"/>
        <xsl:variable name="nodes">
            <xsl:copy-of select="document('./xml/USFS_Research.xml')"/>
        </xsl:variable>
        <xsl:value-of select="$nodes/usfs:research/usfs:stations/usfs:station[usfs:acronym = $acronym]/usfs:name"/>
    </xsl:function>
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>usfs:acronymToAddress</xd:p>
            <xd:p><xd:b>Usage: </xd:b>usfs:acronyToAddress(string[@key = 'station_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Convert ISO 639-2b three-letter codes into ISO 639-1 two-letter codes.</xd:p>            
        </xd:desc>
        <xd:param name="acronym">three-letter language code to match against</xd:param>
    </xd:doc>      
    <xsl:function name="f:acronymToAddress" as="xs:string" xmlns:f="http://functions">
        <xsl:param name="acronym"/>
        <xsl:variable name="nodes">
            <xsl:copy-of select="document('./xml/USFS_Research.xml')"/>
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
    <xsl:function name="f:unitNumToName" as="xs:string" xmlns:f="http://functions">
        <xsl:param name="unitNum"/>
        <xsl:if test="$unitNum != ''"/>
        <xsl:variable name="nodes">
            <xsl:copy-of select="document('./xml/USFS_Research.xml')"/>
        </xsl:variable>
            <xsl:value-of select="$nodes/usfs:research/usfs:stations/usfs:station/usfs:researchUnits/usfs:researchUnit[usfs:unitNumber = $unitNum]/usfs:unitName"/>
    </xsl:function>
    
    <xd:doc scope="component">
        <xd:desc>
            <xd:p><xd:b>Function: </xd:b>f:seriesToAbbrv</xd:p>
            <xd:p><xd:b>Usage: </xd:b>f:seriesToAbbrv(:unitNumToName(string[@key = 'unit_id'])</xd:p>
            <xd:p><xd:b>Purpose: </xd:b>Convert ISO 639-2b three-letter codes into ISO 639-1 two-letter codes.</xd:p>            
        </xd:desc>
        <xd:param name="seriesTitle"/>
    </xd:doc>      
    <xsl:function name="f:seriesToAbbrv" as="xs:string" xmlns:f="http://functions">
        <xsl:param name="seriesTitle"/>
        <xsl:if test="$seriesTitle != ''"/>
        <xsl:variable name="nodes">
            <xsl:copy-of select="document('./USFS_research.xml')"/>
        </xsl:variable>
        <xsl:sequence> 
            <xsl:copy-of select="$nodes/usfs:research/usfs:treeSeries/usfs:seriesPub[usfs:treePub = $seriesTitle]/usfs:abbrv"/> 
        </xsl:sequence>
    </xsl:function>
</xsl:stylesheet>
