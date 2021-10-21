
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