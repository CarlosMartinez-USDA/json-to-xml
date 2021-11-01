<?xml version="1.0" encoding="UTF-8"?>
<xsl:template match="EDataType[@type='enum']" mode="enum-decl">
    <xsl:variable name="className"><xsl:apply-templates select=".." mode="localName"
        /></xsl:variable>
    <xsl:if test="count(enum)=0">
        <xsl:message terminate="yes">No item defined in enumeration</xsl:message>
    </xsl:if> /** enumeration for <xsl:value-of select="$className"/> */ enum E_<xsl:value-of
        select="$className"/> { <xsl:for-each select="enum">
        <xsl:if test="position()&gt;1">,</xsl:if>
        <xsl:choose>
            <xsl:when test="@value">
                <xsl:value-of select="@value"/>() { @Override public String toString() { return
                    &quot;<xsl:value-of select="."/>&quot;; } } </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:for-each>; } </xsl:template>
