<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    exclude-result-prefixes="xs xd"
    version="2.0">
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Jul 21, 2021</xd:p>
            <xd:p><xd:b>Author:</xd:b> Carlos.Martinez</xd:p>
            <xd:p>Purpose: to define global parameters that will be used in every transformation</xd:p>
        </xd:desc>
    </xd:doc>

<xd:doc>
    <xd:desc>
        <xd:p>Global parameters defined</xd:p>
        <xd:p>Assigns value to the filename and working directory, creating the ability to construct a fully qualified filepath for transformation</xd:p>
    </xd:desc>
    <xd:param>
        <xd:p>archiveFile: tokenizes the base-uri (i.e., the full file path) to be segmented by each forward slash. The last function chooses the filename at the end of the filepath.  
        As we will be relying on the position() function for the filename, the replace function allows the file extension to be removed. Leaving only the filename without extension</xd:p>
    </xd:param>
    <xd:param>
        <xd:p>workingDir: Arg one uses the originalFilename parameter to get the full filepath. The archiveFile tells the XSLT processesor to stop before the filename is encountered. We are left with the working directory the source document is in </xd:p>
    </xd:param>
    <xd:return>
        <xd:p>file:\Drive:\workingDirectory\archiveFile
        (e.g., C:\app\ISD-App-PubData\..\filename)</xd:p>
    </xd:return>
    <xd:p>In the main transformation template the result-document href can be constructed dynamically using these parameters to name and transform each file
        (e.g.  href="{$workingDir}A-{$archiveFile}_{position()}.xml"). The final differentiating naming value beign position, and finally adding .xml to the 
         end creates C:\$workingDir\$archiveFile_position.xml</xd:p>
</xd:doc>
    <xsl:param name="vendorName"/>
    <xsl:param name="archiveFile" select="replace(tokenize(base-uri(), '/')[last()],'(.*)(\.xml)', '$1')"/>
    <xsl:param name="originalFilename" select="base-uri()"/>
    <xsl:param name="original_filename" select="tokenize(base-uri(), '/')[last()]"/>
    <xsl:param name="workingDirectory"/>
    <xsl:param name="workingDir" select="substring-before($originalFilename, $archiveFile)"/>
</xsl:stylesheet>