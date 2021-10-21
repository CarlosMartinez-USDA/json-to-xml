<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema" 
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:zs="http://www.loc.gov/zing/srw/"     
    xmlns:mods="http://www.loc.gov/mods/v3"
    xsi:schemaLocation="http://www.loc.gov/mods/v3 
    <!--MODS Split-->                    
    <mods version="3.7">
        <xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>
        <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>                        <xsl:attribute name="version">3.7</xsl:attribute>                        <xsl:attribute name="xsi:schemaLocation">http://www.loc.gov/mods/v3                            http://www.loc.gov/standards/mods/v3/mods-3-7.xsd</xsl:attribute>                        <xsl:if test="VernacularTitle">                            <xsl:apply-templates select="VernacularTitle"/>                            <!-- VernacularTitle is the translated title and article title is the main title -->                        </xsl:if>                        <xsl:apply-templates select="ArticleTitle"/>                        <xsl:apply-templates select="AuthorList/Author"/>                        <typeOfResource>text</typeOfResource>                        <genre>article</genre>                        <xsl:apply-templates select="Journal/PubDate" mode="originInfo"/>                        <xsl:apply-templates select="Language"/>                        <xsl:apply-templates                            select="Abstract | Abstract/AbstractText | Abstractode()[@*]"/>                        <xsl:apply-templates select="PublicationType"/>                        <xsl:apply-templates select="Journal"/>c                        <xsl:apply-templates                            select="ArticleId[@IdType = 'doi' or 'pii'] | ELocationID[@EIdType = 'doi' or 'pii' or 'url']"/>                        <xsl:call-template name="extension"/>                    </mods>                </xsl:result-document>            </xsl:for-each>        </modsCollection>    </xsl:template>dfc











































vv
ccccc