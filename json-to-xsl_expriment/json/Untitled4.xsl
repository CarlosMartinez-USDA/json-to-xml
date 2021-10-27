<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:emp="http://www.semanticalllc.com/ns/employees#"
    xmlns:h="http://www.w3.org/1999/xhtml"
    xmlns:fn="http://www.w3.org/2005/xpath-functions"
    xmlns:j="http://www.w3.org/2005/xpath-functions"
    exclude-result-prefixes="xs math xd h emp"
    version="3.0"
    expand-text="yes"
    >
<xsl:variable name="employees-a" select="json-to-xml(.)"/>
</xsl:stylesheet>