<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs math" version="3.0">
    <xsl:output indent="yes" omit-xml-declaration="yes" name="archive" />
   
    <xsl:include href="../commons/params.xsl"/>
    
   
    <xsl:template match="data">
        <xsl:result-document indent="yes" encoding="UTF-8"
            href="{$workingDir}{replace($originalFilename, '(.*/)(.*)(\.json)', '$2')}_{position()}.xml"
            format="archive">
            <xsl:copy-of select="json-to-xml(.)"/>
    </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>